import streams, sequtils, strutils, tables, times, os, sets, math, std/sha1, std/oids
doAssert(($genOid()).len == 24)

import resman, util, compressedbuf, exo

# bif and key version NEEDS to match
type KeyBifVersion* {.pure.} = enum
  V1,
  E1

type
  ResId = int32

  VariableResource* = ref object
    # N.B.: Full ID (with bif idx)
    id: ResId

    # Where in the bif can we find our data?
    ioOffset: int
    ioSize: int

    # This is a bit of a hack: We are storing the resref in the bif structure,
    # because our key_unpack utility needs to know that in order to write out
    # the data on a per-bif basis; and this is a bit faster than a global lookup
    # table on the keyfile itself.
    resref: ResRef

    # Only E1
    compressionType: ExoResFileCompressionType
    uncompressedSize: int
    sha1: SecureHash

  Bif* = ref object
    keyTable: KeyTable
    filename: string
    mtime: Time
    io: Stream
    fileType: string
    fileVersion: KeyBifVersion

    variableResources: OrderedTable[ResId, VariableResource]

    # E1
    oid: Oid

  KeyTable* = ref object of ResContainer
    version: KeyBifVersion
    io: Stream
    ioStart: int
    label: string

    buildYear: int
    buildDay: int

    bifs: seq[Bif]
    resrefIdLookup: OrderedTable[ResRef, ResId]

    # E1
    oid: Oid

# Accessors for VariableResource: Don't allow modifications from outside.
proc id*(self: VariableResource): ResId = self.id
  ## The id of this VA. Note: This is already stripped of the bif idx component.
proc ioOffset*(self: VariableResource): int = self.ioOffset
  ## The offset where this VA starts inside a bif.
proc ioSize*(self: VariableResource): int = self.ioSize
  ## The data size of this VA inside the owning bif.
proc resref*(self: VariableResource): ResRef = self.resref
  ## The resref of this VA.
proc `$`*(self: VariableResource): string = $self.resref

proc readBif(expectVersion: KeyBifVersion, expectOid: Oid, io: Stream, owner: KeyTable, filename: string, expectIdx: int): Bif =
  ## Read a bif file from a stream. Used internally; as reading bif files from
  ## the outside isn't very useful (you can't get resrefs).

  new(result)

  result.variableResources = initOrderedTable[ResId, VariableResource]()
  result.io = io
  result.keyTable = owner
  result.filename = filename
  result.mtime = getTime() # getLastModificationTime(filename)

  result.fileType = io.readStrOrErr(4)
  expect(result.fileType == "BIFF")
  let fileVersion = io.readStrOrErr(4)
  case expectVersion:
  of KeyBifVersion.V1: expect(fileVersion == "V1  ")
  of KeyBifVersion.E1: expect(fileVersion == "E1  ")
  result.fileVersion = expectVersion

  let varResCount = io.readInt32()
  let fixedResCount = io.readInt32()
  let variableTableOffset = io.readInt32()

  if expectVersion == KeyBifVersion.E1:
    let tmp = io.readStrOrErr(24)
    result.oid = parseOid tmp.cstring
    expect(result.oid == expectOid, "bif oid (" & $result.oid & ") mismatches key oid (" & $expectOid & ")")

  expect(fixedResCount == 0, "fixed resources in bif not supported")

  io.setPosition(variableTableOffset)
  for i in 0..<varResCount:
    let fullId = io.readInt32()
    let offset = io.readInt32()
    let fileSize = io.readInt32()
    let resType = io.readInt32()

    let compressionType =
      if result.fileVersion == KeyBifVersion.E1: io.readInt32().ExoResFileCompressionType
      else: ExoResFileCompressionType.None

    let uncompressedSize =
      if result.fileVersion == KeyBifVersion.E1: io.readInt32()
      else: fileSize

    discard resType # This is unused because we later on map the actual
                    # resref to this VA

    let r = VariableResource(
      id: fullId.ResId,
      ioOffset: offset,
      ioSize: fileSize,
      compressionType: compressionType,
      uncompressedSize: uncompressedSize
    )

    result.variableResources[r.id and 0xfffff] = r

proc hasResId*(self: Bif, id: ResId): bool =
  ## Returns true if this bif has a id of ResId.
  self.variableResources.hasKey(id and 0xfffff)

proc getVariableResource*(self: Bif, id: ResId): VariableResource =
  ## Returns a variable resource by ID.

  self.variableResources[id and 0xfffff]

proc getVariableResources*(self: Bif): seq[VariableResource] =
  ## Returns a seq of all VariableResouces contained in this bif.

  result = newSeq[VariableResource]()
  for k, v in self.variableResources: result.add(v)

proc getStreamForVariableResource*(self: Bif, id: ResId): Stream =
  ## Gets the stream data for a ID. The offset is already correct; but you
  ## will have to know the VA length to read data correctly (see getVariableResource).
  ## You also need to know the compression and decompress it yourself (for now).

  result = self.io
  expect(self.variableResources.hasKey(id and 0xfffff), "attempted to look up id " & $id &
    " in bif, but not found")

  result.setPosition(self.variableResources[id and 0xfffff].ioOffset)

proc readAll*(self: Bif, id: ResId): string =
  ## Reads and decompresses (if needed) the full payload for the given VR.
  let vr = getVariableResource(self, id)
  let stream = getStreamForVariableResource(self, id)
  let rawData = stream.readStrOrErr(vr.ioSize)
  result = case vr.compressionType
  of ExoResFileCompressionType.None: rawData
  of ExoResFileCompressionType.CompressedBuf: decompress(rawData, ExoResFileCompressedBufMagic)

proc filename*(self: Bif): string =
  ## Returns the filename with which this bif was referenced in the key table.
  self.filename

proc readKeyTable*(io: Stream, label: string, resolveBif: proc (fn: string): Stream): KeyTable =
  ## Read a key table from a stream.
  ## The optional label contains debug info that describes where the table came from;
  ## you usually want to set this to the path/filename.
  ##
  ## resolveBif is expected to look up a bif (by the stored filename) and return
  ## a open, readable stream to it.  This stream will be kept open until the key
  ## table itself is closed.

  new(result)
  result.label = label
  result.io = io
  result.ioStart = io.getPosition
  result.bifs = newSeq[Bif]()

  result.resrefIdLookup = initOrderedTable[Resref, ResId]()

  let ioStart = result.ioStart

  let ft = io.readStrOrErr(4)
  expect(ft == "KEY ")
  let fv = io.readStrOrErr(4)
  expect(fv == "V1  " or fv == "E1  ")
  case fv
  of "V1  ": result.version = KeyBifVersion.V1
  of "E1  ": result.version = KeyBifVersion.E1

  let bifCount = io.readInt32()
  let keyCount = io.readInt32()
  let offsetToFileTable = io.readInt32()
  let offsetToKeyTable = io.readInt32()
  result.buildYear = io.readInt32()
  result.buildDay = io.readInt32()
  if result.version == KeyBifVersion.E1:
    let tmp = io.readStrOrErr(24)
    result.oid = parseOid tmp.cstring
    io.setPosition(io.getPosition + 8) # reserved bytes
  else:
    io.setPosition(io.getPosition + 32) # reserved bytes

  const HeaderSize = 64
  assert(io.getPosition == ioStart + HeaderSize)

  # expect(offsetToFileTable > HeaderSize and offsetToFileTable < offsetToKeyTable)

  proc stripTrailing0(s: var string) {.inline.} =
    s.removeSuffix('\0')

  var fileTable = newSeq[tuple[fSize: int32, fnOffset: int32,
                               fnSize: int16, drives: int16]]()

  io.setPosition(offsetToFileTable)

  for i in 0..<bifCount:
    let fSize = io.readInt32()
    let fnOffset = io.readInt32()
    let fnSize = io.readInt16()
    let drives = io.readInt16()
    let e = (fSize, fnOffset, fnSize, drives)
    # expect(drives == 1, "only drives = 1 supported, but got: " & $drives)
    fileTable.add(e)

  let filenameTable = fileTable.map(proc (entry: auto): string =
    io.setPosition(ioStart + entry.fnOffset)
    expect(entry.fnSize >= 1, "bif filename in filenametable empty")

    result = io.readStrOrErr(entry.fnSize)
    result.stripTrailing0()

    when defined(posix):
      result = result.replace("\\", "/")
  )

  for fnidx, fn in filenameTable:
    let fnio = resolveBif(fn)
    expect(fnio != nil, "key file referenced file " & fn & " but cannot open")
    let bf = readBif(result.version, result.oid, fnio, result, fn, fnidx)
    result.bifs.add(bf)

  io.setPosition(offsetToKeyTable)
  for i in 0..<keyCount:
    var resref = io.readStrOrErr(16)
    resref.stripTrailing0()
    let restype = io.readInt16().ResType
    let resId = io.readInt32()
    let bifIdx = resId shr 20

    var sha1: SecureHash
    if result.version == KeyBifVersion.E1:
      let str = io.readStrOrErr(20)
      for i in 0..<20: Sha1Digest(sha1)[i] = uint8(str[i])

    expect(bifIdx >= 0 and bifIdx < result.bifs.len,
      "while reading res " & $resId & "=" & $resref & "." & $restype & ", bifidx not indiced by keyfile: " &
      $bifIdx)

    let rr = newResRef(resref, restype)

    expect(result.bifs[bifIdx].hasResId(resId),
      "keytable references non-existent id: " & $resId & ", resref: " & $rr &
      " in bif " & filenameTable[bifIdx])

    result.resrefIdLookup[rr] = resId

    # We're reading VAs from the bif files above (in readBif); and here we
    # re-assign the ID we just read to a resref, so the bif has the proper
    # data entry for it.
    let vra = result.bifs[bifIdx].getVariableResource(resId)
    expect(vra != nil, "key table references unknown variable resource (bug?): " &
      $bifIdx & " doesn't have " & $resId)

    # We also have to backfill the resref and the sha1, as they are stored
    # in the keyfile, not the bif.
    vra.resref = rr
    vra.sha1 = sha1

proc readKeyTable*(io: Stream, resolveBif: proc (fn: string): Stream): KeyTable =
  ## Alias for readKeyTable, just without a label.
  readKeyTable(io, label = "(anon-io)", resolveBif)

method contains*(self: KeyTable, rr: ResRef): bool =
  result = self.resrefIdLookup.hasKey(rr)

method demand*(self: KeyTable, rr: ResRef): Res =
  let resId = self.resrefIdLookup[rr]
  let bifIdx = resId shr 20

  expect(bifIdx >= 0 and bifIdx < self.bifs.len)

  let b = self.bifs[bifIdx]
  let va = b.getVariableResource(resId)
  let st = b.getStreamForVariableResource(resId)

  result = newRes(newResOrigin(self, "id=" & $resId & " in " & b.filename),
    resref = rr, mtime = b.mtime, io = st, ioOffset = va.ioOffset, ioSize = va.ioSize)

method count*(self: KeyTable): int = self.resrefIdLookup.len

method contents*(self: KeyTable): OrderedSet[ResRef] =
  result = initOrderedSet[ResRef]()
  for k in keys(self.resrefIdLookup):
    result.incl(k)

method `$`*(self: KeyTable): string =
  "KeyTable:" & self.label

proc bifs*(self: KeyTable): seq[Bif] =
  ## Returns the bifs this key table references.
  self.bifs


# -----------------
#  Key/Bif Writing
# -----------------

type KeyBifEntry* = tuple
  directory: string
  name: string
  entries: seq[ResRef]

type BifEntryWriter* = proc(r: ResRef, io: Stream): tuple[bytes: int, sha1: SecureHash]

type WriteBifResult = tuple
  bytes: int
  entries: seq[tuple[resref: ResRef, sha1: SecureHash]]

proc writeBif(version: KeyBifVersion, exocomp: ExoResFileCompressionType, compalg: Algorithm,
    oid: Oid, # E1
    ioBif: Stream, entries: seq[ResRef], pleaseWrite: BifEntryWriter): WriteBifResult =
  result.entries = newSeq[tuple[resref: ResRef, sha1: SecureHash]]()

  case version
  of KeyBifVersion.V1: ioBif.write("BIFFV1  ")
  of KeyBifVersion.E1: ioBif.write("BIFFE1  ")

  let vartableOffset = case version
  of KeyBifVersion.V1: 20 # vartable offset, hardcoded value
  of KeyBifVersion.E1: 20 + 24 # + oid

  ioBif.write(uint32 entries.len) # entries
  ioBif.write(uint32 0) #fixedres
  ioBif.write(uint32 vartableOffset)

  if version == KeyBifVersion.E1:
    ioBif.write($oid)

  doAssert(ioBif.getPosition == vartableOffset)

  let entrySize = case version
  of KeyBifVersion.V1: 16 # id, offset, len, type
  of KeyBifVersion.E1: 16 + 8+20 # compression, sha1

  var resrefData = initTable[ResRef, tuple[uncompressed: int, compressed: int, sha1: SecureHash]]()
  let varTableStart = ioBif.getPosition

  # Pad out initial data which we back-fill later with collected size/offset data
  for i in 0..<entries.len:
    ioBif.write(repeat("\x00", entrySize))

  # Write out data. This fills in resrefDataSizes so we know
  # what we need to put into the varResTable
  for idx, resRef in entries:
    let pos = ioBif.getPosition

    var compressedSize: int
    var uncompressedSize: int
    var sha1: SecureHash

    case exocomp
    of ExoResFileCompressionType.CompressedBuf:
      let inmem = newStringStream()
      (uncompressedSize, sha1) = pleaseWrite(resRef, inmem)
      inmem.setPosition(0)
      # TODO: make this more efficient w/o a duplicate stream
      compressedbuf.compress(ioBif, inmem, compalg, ExoResFileCompressedBufMagic)
      compressedSize = ioBif.getPosition() - pos

    of ExoResFileCompressionType.None:
      (uncompressedSize, sha1) = pleaseWrite(resRef, ioBif)
      compressedSize = uncompressedSize

    resrefData[resRef] = (uncompressedSize, compressedSize, sha1)
    result.entries.add((resRef, sha1))

  # Backfill what we skipped before.
  var offset: BiggestInt = varTableStart + (entries.len * entrySize)
  ioBif.setPosition(varTableStart)
  for idx, resRef in entries:
    # let res = rm[resRef].get()
    # ID = (x << 20) + y
    #   where x = y for game CDs and x is 0 for patch bifs
    #   but really, the game does not care
    let id = (idx.uint32 shl 20u32) + idx.uint32
    ioBif.write(uint32 id)
    ioBif.write(uint32 offset)
    ioBif.write(uint32 resrefData[resRef].compressed)
    offset += resrefData[resRef].compressed
    ioBif.write(uint32 resRef.resType)

    if version == KeyBifVersion.E1:
      ioBif.write(uint32 exocomp)
      ioBif.write(uint32 resrefData[resRef].uncompressed)

  result.bytes = ioBif.getPosition
  ioBif.close

proc writeKeyAndBif*(
    version: KeyBifVersion,
    exocomp: ExoResFileCompressionType, compalg: Algorithm,
    destDir: string,
    keyName: string, bifPrefix: string, bifs: seq[KeyBifEntry],
    buildYear, buildDay: uint32,
    pleaseWrite: BifEntryWriter) =

  doAssert(exocomp == ExoResFileCompressionType.None or version == KeyBifVersion.E1, "Compression requires E1")

  let keyOid = genOid()

  const HeaderStartOfKeyFileData = 64 # key

  let ioFileTable = newStringStream()
  let ioFilenames = newStringStream()

  var bifResults = newSeq[WriteBifResult]()

  for bif in bifs:
    createDir(destDir / bif.directory)
    let fn = destDir / bif.directory / bif.name & ".bif"
    let ioBif = openFileStream(fn, fmWrite)
    let writtenBif = writeBif(version, exocomp, compalg, keyOid, ioBif, bif.entries, pleaseWrite)
    bifResults.add(writtenBif)

    ioFileTable.write(uint32 writtenBif.bytes - 20) # header not included
    let fnForBif = bifPrefix.strip(chars={'/', '\\'}) & "\\" & bif.name & ".bif"
    ioFileTable.write(uint32 HeaderStartOfKeyFileData + (bifs.len * 12) + ioFilenames.getPosition)
    ioFileTable.write(uint16 fnForBif.len)
    ioFileTable.write(uint16 0) #drives
    ioFilenames.write(fnForBif & "\x00")

  let ioKey = openFileStream(destDir / keyName & ".key", fmWrite)

  let fileTableSz = ioFileTable.getPosition
  let filenamesSz = ioFilenames.getPosition
  let totalResRefCount = sum(bifs.mapIt(it.entries.len))

  case version
  of KeyBifVersion.V1: ioKey.write("KEY V1  ")
  of KeyBifVersion.E1: ioKey.write("KEY E1  ")

  ioKey.write(uint32 bifs.len) # bifs.len
  ioKey.write(uint32 totalResRefCount)
  ioKey.write(uint32 64) # offset to file table
  ioKey.write(uint32 64 + fileTableSz + filenamesSz) # offset to key table
  ioKey.write(uint32 buildYear - 1900) # build year
  ioKey.write(uint32 buildDay) # build day
  case version
  of KeyBifVersion.V1:
    ioKey.write(repeat("\x00", 32)) # reserved
  of KeyBifVersion.E1:
    let oldPos = ioKey.getPosition()
    ioKey.write($keyOid)
    doAssert(ioKey.getPosition() == oldPos + 24)
    ioKey.write(repeat("\x00", 8)) # reserved

  # file table+names offset
  doAssert(ioKey.getPosition == HeaderStartOfKeyFileData)

  ioFileTable.setPosition(0)
  ioFilenames.setPosition(0)
  ioKey.write(ioFileTable.readAll)
  ioKey.write(ioFilenames.readAll)

  # keyTable offset
  doAssert(ioKey.getPosition == HeaderStartOfKeyFileData + fileTableSz + filenamesSz)

  for bifIdx, bif in bifs:
    for resIdx, resRef in bif.entries:
      doAssert(resref.resRef.len > 0)
      doAssert(resRef.resRef.len <= 16, resRef.resRef)
      ioKey.write(resRef.resRef & repeat("\x00", 16 - resRef.resRef.len))
      ioKey.write(uint16 resRef.resType)
      # ID = (x << 20) + y
      # x = index into bif file table
      # y = index into variable table inside of bif
      let id: uint32 = (bifIdx.uint32 shl 20u32) + resIdx.uint32
      ioKey.write(uint32 id)

      if version == KeyBifVersion.E1:
        ioKey.write(bifResults[bifIdx].entries[resIdx].sha1)

  let expectedEntrySize = case version
    of KeyBifVersion.V1: 16+2+4
    of KeyBifVersion.E1: 16+2+4 + 20
  doAssert(ioKey.getPosition == HeaderStartOfKeyFileData + fileTableSz + filenamesSz +
    totalResRefCount * expectedEntrySize)

  ioKey.close

proc writeKeyAndBif*(
    version: KeyBifVersion,
    exocomp: ExoResFileCompressionType, compalg: Algorithm,
    destDir: string,
    keyName: string, bifPrefix: string, bifs: seq[KeyBifEntry],
    pleaseWrite: BifEntryWriter) =
  writeKeyAndBif(version, exocomp, compalg, destDir, keyName, bifPrefix, bifs,
    uint32 getTime().utc.year,
    uint32 getTime().utc.yearday,
    pleaseWrite)
