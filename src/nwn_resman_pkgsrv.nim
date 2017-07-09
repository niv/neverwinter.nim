import shared

let args = DOC """
Packages a resman view into a slimmed-down variant suitable for
docker deployment.

Usage:
  $0 [options]
  $USAGE

Options:
  -d DIRECTORY                Save files to DIRECTORY [default: .]
  $OPTRESMAN
"""

let rm = newBasicResMan()

let destination = ($args["-d"])
doAssert(dirExists(destination), "destination directory does not exist")

const whiteListExt = [
  # walkmeshes: needed to pathfind
  "wok", "pwk", "dwk",
  # scripts
  "ncs",
  # templates: potentially needed by scripts and other templates
  "uti", "utc", "utp", "ssf", "uts", "utt", "ute", "utm", "dlg", "utw", "utd",
  # palette data
  "itp",
  # config data
  "2da",
  # tileset data
  "ini", "set"
]

proc shouldBeIncluded(o: ResolvedResRef): bool =
  whiteListExt.find(($o.resType).toLowerAscii) > -1

# How many files to pack into a single bif at max.
const FilesPerBif = 5000

const HeaderStartOfKeyFileData = 64 # key

# find all the resRefs we want to include.
var allContent = newSeq[ResolvedResRef]()
for o in rm.contents.withProgressBar("filter"):
  let oo = o.resolve().get()
  if oo.shouldBeIncluded: allContent.add(oo)

# Sort entries so the build is reproducible
sort(allContent) do (lhs, rhs: ResolvedResRef) -> int:
  system.cmp[string](lhs.toFile.toUpperAscii, rhs.toFile.toUpperAscii)

let allBifsToWrite = allContent.distribute(1 + allContent.len div FilesPerBif)

info "Including ", allContent.len, " files in shrunk set, split into ", allBifsToWrite.len, " bifs"

let ioFileTable = newStringStream()
let ioFilenames = newStringStream()

proc writeBif(index: int, entries: seq[ResolvedResRef]) =
  let fn = destination / "srvpkg" & $index & ".bif"
  let ioBif = newFileStream(fn, fmWrite)
  ioBif.write("BIFFV1  ")
  ioBif.write(uint32 entries.len) # entries
  ioBif.write(uint32 0) #fixedres
  ioBif.write(uint32 20) #vartable offset, hardcoded value

  doAssert(ioBif.getPosition == 20)
  # Counting the total offset to each file data entry
  var offset: BiggestInt = ioBif.getPosition + (entries.len * 16)
  for idx, resRef in entries: #.withProgressBar("bifheader"):
    let res = rm[resRef].get()
    # ID = (x << 20) + y
    #   where x = y for game CDs and x is 0 for patch bifs
    #   but really, the game does not care
    let id = (idx.uint32 shl 20u32) + idx.uint32
    ioBif.write(uint32 id)
    ioBif.write(uint32 offset)
    doAssert(res.len == res.readAll.len)
    ioBif.write(uint32 res.len)
    offset += res.len
    ioBif.write(uint32 resRef.resType)

  # Write out data
  for idx, resRef in entries: #.withProgressBar("bifdata"):
    let res = rm[resRef].get()
    let st = ioBif.getPosition
    ioBif.write(res.readAll)
    doAssert(ioBif.getPosition == st + res.len)

    # if idx == 0 or idx == 2988 or resRef.toFile == "xptable.2da":
    #   echo "BIF: ", idx, "=", resRef.toFile, " sz=", res.len,
    #     " type=", resRef.resType

  let thisBifSize = ioBif.getPosition
  ioBif.close

  ioFileTable.write(uint32 thisBifSize - 20) # header not included
  let fnForBif = r"data\srvpkg" & $index & ".bif"
  ioFileTable.write(uint32 HeaderStartOfKeyFileData + (allBifsToWrite.len * 12) + ioFilenames.getPosition)
  ioFileTable.write(uint16 fnForBif.len)
  ioFileTable.write(uint16 0) #drives
  ioFilenames.write(fnForBif & "\x00")

  info fn, " written: ", thisBifSize.formatSize, " as ", fnForBif, " with ", entries.len, " entries"

for idx, bif in allBifsToWrite:
  writeBif(idx, bif)

let fileTableSz = ioFileTable.getPosition
let filenamesSz = ioFilenames.getPosition

let ioKey = newFileStream(destination / "nwn_base.key", fmWrite)

ioKey.write("KEY V1  ")
ioKey.write(uint32 allBifsToWrite.len) # bifs.len
ioKey.write(uint32 allContent.len)
ioKey.write(uint32 64) # offset to file table
ioKey.write(uint32 64 + fileTableSz + filenamesSz) # offset to key table
ioKey.write(uint32 getTime().getGMTime().year - 1900) # build year
ioKey.write(uint32 getTime().getGMTime().yearday) # build day
ioKey.write(repeat("\x00", 32)) # reserved

# file table+names offset
doAssert(ioKey.getPosition == HeaderStartOfKeyFileData)

ioFileTable.setPosition(0)
ioFilenames.setPosition(0)
ioKey.write(ioFileTable.readAll)
ioKey.write(ioFilenames.readAll)

# keyTable offset
doAssert(ioKey.getPosition == HeaderStartOfKeyFileData + fileTableSz + filenamesSz)

for bifIdx, bifEntries in allBifsToWrite:
  for resIdx, resRef in bifEntries:
    doAssert(resref.resRef.len > 0)
    doAssert(resRef.resRef.len <= 16, resRef.resRef)
    ioKey.write(resRef.resRef & repeat("\x0", 16 - resRef.resRef.len))
    ioKey.write(uint16 resRef.resType)
    # ID = (x << 20) + y
    # x = index into bif file table
    # y = index into variable table inside of bif
    let id: uint32 = (bifIdx.uint32 shl 20u32) + resIdx.uint32
    ioKey.write(uint32 id)

    # if resIdx == 2988 or resRef.toFile == "xptable.2da":
    #   echo "KEY: ", resRef.toFile, " bif=", bifIdx, " id=", resIdx, " offset=", ioKey.getPosition,
    #     " writtenId=", id, " type=", resRef.resType

doAssert(ioKey.getPosition == HeaderStartOfKeyFileData + fileTableSz + filenamesSz +
  allContent.len * (16+2+4))

ioKey.close

info "nwn_base.key written"
