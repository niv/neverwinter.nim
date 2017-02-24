import streams, tables, os, options, sequtils, times, logging, strutils, algorithm
import neverwinter.resref

addHandler newConsoleLogger()

type Bif = tuple
  fname: string
  sz: BiggestInt
  entries: seq[ResolvedResRef]

const HeaderStartOfFileData = 64

proc packKeyBif*(keyFilename: string, sourceDir: string, targetDir: string) =
  ## Packs a directory tree into a keyfile, with one bif file per
  ## subdirectory.

  # Internal references to bif files are prefixed with this.
  let bifPrefix = "data"

  proc indexBif(dir: string): Bif =
    var sz: BiggestInt = 0
    var entries = newSeq[ResolvedResRef]()
    for f in walkDir(sourceDir / dir, true):
      if f.kind == pcFile:
        # this will exception if the res doesnt have a good type
        entries.add(newResolvedResRef(f.path))
        let fullFn = sourceDir / dir / f.path
        sz += getFileSize(fullFn)

    # Make sure resrefs are stored in alphabetical order (per bif), to produce
    # reproducible builds.
    sort(entries) do (lhs, rhs: ResolvedResRef) -> int:
      system.cmp[string](lhs.toFile.toUpperAscii, rhs.toFile.toUpperAscii)

    result = (fname: dir, sz: sz, entries: entries)

  # First walk: resolve all resrefs, bail on error.
  info "bif: walking tree to resolve all resrefs"

  var bifs = newSeq[Bif]()
  for wd0 in walkDir(sourceDir, true):
    if wd0.kind == pcDir:
        var bif = indexBif(wd0.path)
        bifs.add(bif)

  # make sure bifs are ordered alphabetically too.
  sort(bifs) do (lhs, rhs: Bif) -> int:
    system.cmp[string](lhs.fname, rhs.fname)

  let totalcount = foldl(bifs, a + b.entries.len, 0)

  info "bif: found " & $totalcount & " resrefs for " & $bifs.len & " bifs"

  # first, write all bifs.
  for bifidx, bif in bifs:
    let bifFn = targetDir / bif.fname.toLowerAscii # & ".bif"
    let ioBif = newFileStream(bifFn, fmWrite)
    ioBif.write("BIFFV1  ")
    ioBif.write(uint32 bif.entries.len)
    ioBif.write(uint32 0) # fixed resources not supported as per spec
    ioBif.write(uint32 20) # varres table offset, always immediately after hdr

    doAssert(ioBif.getPosition == 20)
    var offset: BiggestInt = 20 + bif.entries.len * 16 + 0

    info "bif: " & bif.fname.toLowerAscii & "(idx=" & $bifidx & "), writing key table"
    for i, e in bif.entries:
      let id = (i shl 20) + i
      ioBif.write(uint32 id) # id: assigned in same order as entries
      ioBif.write(uint32 offset) # offset
      let fullFn = sourceDir / bif.fname / e.toFile
      let size = getFileSize(fullFn)
      ioBif.write(uint32 size) # size
      offset += size
      ioBif.write(uint32 e.resType) # restype

    info "bif: " & bif.fname & ", writing file data"
    for e in bif.entries:
      let fullFn = sourceDir / bif.fname / e.toFile
      let rr = newFileStream(fullFn, fmRead)
      ioBif.write(rr.readAll)
      rr.close

    ioBif.close
    info "bif: " & bif.fname & " written to " & bifFn & ", size: " & $bif.sz


  # beginning of key file to start of filenames raw data. we precalc it here
  # because we need it to reference in the filetable data, which comes before it
  let startOfFileNamesData = HeaderStartOfFileData + bifs.len * (12)

  let ioFileTable = newStringStream()
  let ioFilenames = newStringStream()
  for bifidx, bif in bifs:
    # debug "filetable data for bif ", bifidx
    ioFileTable.write(uint32 bif.sz) # bif file size

    let fn = bifPrefix / bif.fname.toLowerAscii
    let offset = startOfFileNamesData + ioFilenames.getPosition

    ioFileTable.write(uint32 offset) # byte pos of this bifs filename in table
    ioFileTable.write(uint16 fn.len) # sz of filename in this file
    ioFileTable.write(uint16 0) # drives

    info "key: " & fn & " at idx " & $bifidx
    #nb: the spec says we shouldnt terminate, but all core files are; so let's add
    #    one just to keep compatibility for readers that expect this.
    ioFilenames.write(fn & "\x00")

  let fileTableSz = ioFileTable.getPosition
  let filenamesSz = ioFilenames.getPosition
  ioFileTable.setPosition(0)
  ioFilenames.setPosition(0)

  let ioKey = newFileStream(targetDir / keyFilename, fmWrite)
  ioKey.write("KEY V1  ")
  ioKey.write(uint32 bifs.len)
  ioKey.write(uint32 totalcount)
  ioKey.write(uint32 HeaderStartOfFileData) # offset to file table
  ioKey.write(uint32 HeaderStartOfFileData + fileTableSz + filenamesSz) # offset to key table
  ioKey.write(uint32 getTime().getGMTime().year - 1900) # build year
  ioKey.write(uint32 getTime().getGMTime().yearday) # build day
  ioKey.write(repeat("\x00", 32)) # reserved

  # debug "Offset to fn table: ", HeaderStartOfFileData + fileTableSz
  # debug "Offset to key table: ", HeaderStartOfFileData + fileTableSz + filenamesSz

  doAssert(ioKey.getPosition == HeaderStartOfFileData)
  ioKey.write(ioFileTable.readAll)
  ioKey.write(ioFilenames.readAll)
  doAssert(ioKey.getPosition == HeaderStartOfFileData + fileTableSz + filenamesSz)

  # Write out all bifs, and each entry for each bif, all concatenated.
  var countWritten = 0
  for bifidx, bif in bifs:
    for eidx, e in bif.entries:
      ioKey.write(e.resRef & repeat("\x0", 16 - e.resRef.len))
      ioKey.write(uint16 e.resType)
      let id = (bifIdx shl 20) + eidx
      ioKey.write(uint32 id)
      countWritten += 1

  doAssert(ioKey.getPosition == HeaderStartOfFileData + fileTableSz + filenamesSz +
    countWritten * (16+2+4))

  doAssert(countWritten == totalcount)

  ioKey.close
  info "key: " & keyFilename & " written, all done"

if paramCount() != 3:
  echo "This application packs a set of directories into a key file; with one " &
    "bif file per directory. bif files are always parented to a data/ subdirectory."
  echo ""
  echo "Syntax: <keyname> <srcDir> <targetDir>"
  echo ""
  echo "Example: patch.key src/ out/"
  quit(1)

let keyName   = paramStr(1)
let sourceDir = paramStr(2)
let targetDir = paramStr(3)

# Make sure we have a target dir
if dirExists(targetDir):
  for k in walkDir(targetDir):
    quit("Target directory not empty; aborting for your own safety.")

createDir(targetDir)

packKeyBif(keyName, sourceDir, targetDir)
