import streams, strutils, sequtils, tables, times, algorithm, logging, std/sha1, std/oids

import resman, util, resref, exo, compressedbuf

# This is advisory only. We will emit a warning on mismatch (so library users
# get more debug hints), but still attempt to load the file.
const ValidErfTypes = ["NWM ", "MOD ", "ERF ", "HAK "]

type ErfVersion* {.pure.} = enum
  V1,
  # V11: rim/encrypted premiums. No longer supported.
  E1

type
  Erf* = ref object of ResContainer
    mtime*: Time

    fileType*: string
    fileVersion*: ErfVersion

    filename: string

    buildYear*: int
    buildDay*: int

    strRef*: int
    locStrings: Table[int, string]
    entries: OrderedTableRef[ResRef, Res]

    # E1:
    oid: Oid

proc filename*(self: Erf): string =
  self.filename

proc locStrings*(self: Erf): var Table[int, string] =
  self.locStrings

proc readErf*(io: Stream, filename = "(anon-io)"): Erf =
  new(result)
  result.locStrings = initTable[int, string]()
  result.entries = newOrderedTable[ResRef, Res]()
  result.mtime = getTime()
  result.filename = filename

  result.fileType = io.readStrOrErr(4)
  if ValidErfTypes.find(result.fileType) == -1:
    warn("Unknown erf file type: '" & repr(result.fileType) &
         "', possibly invalid erf?")

  let modv = io.readStrOrErr(4)
  case modv
  of "V1.0": result.fileVersion = ErfVersion.V1
  of "E1.0": result.fileVersion = ErfVersion.E1
  else: warn("unsupported erf version: ", modv, "; erf might fail to load")

  let locStrCount = io.readInt32()
  let locStringSz = io.readInt32()
  let entryCount = io.readInt32()
  let offsetToLocStr = io.readInt32()
  let offsetToKeyList = io.readInt32()
  let offsetToResourceList = io.readInt32()
  result.buildYear = io.readInt32()
  result.buildDay = io.readInt32()
  result.strRef = io.readInt32()
  case result.fileVersion
  of ErfVersion.V1:
    io.setPosition(io.getPosition + 16) # reserved cipher mp5 for RIM, unused these days.
    io.setPosition(io.getPosition + 100) # reserved
  of ErfVersion.E1:
    let tmp = io.readStrOrErr(24)
    result.oid = parseOid tmp.cstring
    io.setPosition(io.getPosition + 92) #reserved

  # locstrlist
  io.setPosition(offsetToLocStr)
  for i in 0..<locStrCount:
    let id = io.readInt32()
    expect(id >= 0)
    let str = io.readStrOrErr(io.readInt32()).fromNwnEncoding
    result.locStrings[id] = str

  # the locStringSz data field isn't needed to parse, and some distro erfs
  # have broken headers
  if io.getPosition != offsetToLocStr + locStringSz:
    warn "erf header field locStringSize has invalid value (safe to ignore)"

  var resList = newSeq[tuple[offset, diskSize, uncompressedSize: int, exocomp: ExoResFileCompressionType, sha1: SecureHash]]()
  io.setPosition(offsetToResourceList)
  for i in 0..<entryCount:
    let offset = io.readUint32()
    let diskSize = io.readUint32()
    var uncompressedSize = diskSize
    var exocomp = ExoResFileCompressionType.None
    if result.fileVersion == ErfVersion.E1:
      exocomp = io.readUint32().ExoResFileCompressionType
      uncompressedSize = io.readUint32()

    var sha1: SecureHash # filled in in keylist
    resList.add((int offset, int diskSize, int uncompressedSize, exocomp, sha1))

  # key list
  io.setPosition(offsetToKeyList)
  for i in 0..<entryCount:
    let resref = io.readStrOrErr(16).strip(true, true, {'\0'})
    io.setPosition(io.getPosition + 4) # id - we're not using it
    let restype = io.readInt16()
    io.setPosition(io.getPosition + 2) # unused NULLs

    # Invalid restype is OK
    if restype == 65535:
      continue

    if result.fileVersion == ErfVersion.E1:
      let str = io.readStrOrErr(20)
      for i in 0..<20: Sha1Digest(resList[i].sha1)[i] = uint8(str[i])

    var rr =
      try:
        newResRef(resref, restype.ResType)
      except:
        warn "erf file contains entry with invalid resref at index ", i, ": ",
          getCurrentExceptionMsg(), "; rewritten to 'invalid_", i, ".", restype.ResType, "'"
        newResRef("invalid_" & $i, restype.ResType)

    # Some distro erfs have duplicate resref entries. We skip them if they
    # point to the same resource.
    if result.entries.hasKey(rr):
      if result.entries[rr].ioOffset == resList[i].offset and
         result.entries[rr].ioSize == resList[i].diskSize:
        warn "Duplicate resref entry in erf pointing to same data, skipping: ", rr
        continue


      else:
        let newrr = newResRef("__erfdup__" & $i, restype.ResType)

        warn(("Duplicate resref entry in erf, but differing offset/size: " &
              "resref=$# offset=$# disksize=$# (idx=$#) would collide with " &
              "offset=$# size=$#; renamed to $#"
              ).format(
                rr, resList[i].offset, resList[i].diskSize, i,
                result.entries[rr].ioOffset,
                result.entries[rr].ioSize,
                newrr))

        rr = newrr

    let resData = resList[i]
    var erfObj = newRes(newResOrigin(result, filename & ": " & $rr), rr, result.mtime, io,
      ioSize = resData.diskSize, ioOffset = resData.offset,
      compression = resData.exocomp, uncompressedSize = resData.uncompressedSize, sha1 = resData.sha1)
    result.entries[rr] = erfObj

type ErfEntryWriter* = proc(r: ResRef, io: Stream): tuple[bytes: int, sha1: SecureHash]

proc writeErf*(io: Stream,
               fileType: string,
               fileVersion: ErfVersion,
               exocomp: ExoResFileCompressionType, compalg: Algorithm,
               locStrings: Table[int, string] = initTable[int, string](),
               strRef = 0,
               entries: seq[ResRef],
               # What OID to write out to the ERF. Defaults to no OID.
               erfOid: Oid = parseOid(repeat("\x00", 24)),
               # This is called when we want you to write the binary data
               # of r:ResRef to io.
               writer: ErfEntryWriter) =

  ## Writes a new ERF.
  ## `entries` maps resrefs to filenames on the local system.

  doAssert(exocomp == ExoResFileCompressionType.None or fileVersion == ErfVersion.E1, "Compression requires E1")

  let ioStart = io.getPosition

  var locStrSize = 0
  for id, str in locStrings: locStrSize += 8 + str.toNwnEncoding.len

  let offsetToLocStr = 160
  let offsetToKeyList = offsetToLocStr + locStrSize
  let keyListSize = entries.len * (
    case fileVersion
    of ErfVersion.V1: 24
    of ErfVersion.E1: 24 + 20 # sha1
  )
  let offsetToResourceList = offsetToKeyList + keyListSize
  let resourceListSize = entries.len * (
    case fileVersion
    of ErfVersion.V1: 8     # offset, (compressed/disk) size
    of ErfVersion.E1: 8 + 8 # exocomptype, uncomp size
  )

  let myFileType = fileType[0..min(fileType.high, 3)] &
                   strutils.repeat(" ", clamp(3 - fileType.high, 0,  4))
  assert(myFileType.len == 4)
  io.write(myFileType.toUpperAscii)
  case fileVersion
  of ErfVersion.V1: io.write("V1.0")
  of ErfVersion.E1: io.write("E1.0")
  io.write(locStrings.len.int32)
  io.write(locStrSize.int32)
  io.write(entries.len.int32)
  io.write(offsetToLocStr.int32)
  io.write(offsetToKeyList.int32)
  io.write(offsetToResourceList.int32)
  io.write(int32 getTime().utc.year - 1900) # self.buildYear.int32)
  io.write(int32 getTime().utc.yearday) # self.buildDay.int32)
  io.write(int32 strRef)

  case fileVersion
  of ErfVersion.V1:
    io.write(repeat("\x00", 116))
    assert(io.getPosition == ioStart + 160)
  of ErfVersion.E1:
    io.write($erfOid)
    io.write(repeat("\x00", 92))
    assert(io.getPosition == ioStart + 160)

  # We save out entries sorted alphabetically for now. This ensures a reproducible
  # build.
  let keysToWrite = entries.sorted(resref.cmp)

  # locstr list
  for id, str in locStrings:
    io.write(id.int32)
    io.write(str.toNwnEncoding.len.int32)
    io.write(str.toNwnEncoding)

  # key list: pad out first and revisit when data was written and we
  #           have sizes and sha1
  io.write(repeat("\x00", keyListSize))

  # res list: pad out first and revisit when data was written and we
  # have the sizes
  io.write(repeat("\x00", resourceListSize))

  var writtenEntries = newSeq[tuple[rr: ResRef, diskSize: int, uncompressedSize: int, sha1: SecureHash]]()
  let offsetToResourceData = io.getPosition
  doAssert(offsetToResourceList + resourceListSize == offsetToResourceData)

  # res data: write data and keep track of sizes and checksums written
  for rr in keysToWrite:
    let pos = io.getPosition

    var compressedSize: int
    var uncompressedSize: int
    var sha1: SecureHash

    case exocomp
    of ExoResFileCompressionType.CompressedBuf:
      let inmem = newStringStream()
      (uncompressedSize, sha1) = writer(rr, inmem)
      inmem.setPosition(0)
      # TODO: make this more efficient w/o a duplicate stream
      compressedbuf.compress(io, inmem, compalg, ExoResFileCompressedBufMagic)
      compressedSize = io.getPosition() - pos

    of ExoResFileCompressionType.None:
      (uncompressedSize, sha1) = writer(rr, io)
      compressedSize = uncompressedSize

    writtenEntries.add((rr, compressedSize, uncompressedSize, sha1))

  # keep around the offset to the EOF, so we can reset the stream pointer
  let offsetToEndOfFile = io.getPosition

  # backfill the keylist
  io.setPosition(offsetToKeyList)
  var id = 0
  for (rr, diskSize, uncompressedSize, sha1) in writtenEntries:
    io.write(rr.resRef & repeat("\x00", 16 - rr.resRef.len))
    io.write(id.int32)
    io.write(rr.resType.int16)
    io.write("\x00\x00")
    if fileVersion == ErfVersion.E1:
      io.write(sha1)
    id += 1

  # backfill the reslist
  io.setPosition(offsetToResourceList)
  var currentOffset: BiggestInt = offsetToResourceData
  for (rr, diskSize, uncompressedSize, sha1) in writtenEntries:
    io.write(uint32 currentOffset)
    io.write(uint32 diskSize)
    if fileVersion == ErfVersion.E1:
      io.write(uint32 exocomp)
      io.write(uint32 uncompressedSize)
    currentOffset += diskSize

  io.setPosition(offsetToEndOfFile)

method contains*(self: Erf, rr: ResRef): bool =
  self.entries.hasKey(rr)

method demand*(self: Erf, rr: ResRef): Res =
  self.entries[rr]

method count*(self: Erf): int =
  self.entries.len

method contents*(self: Erf): OrderedSet[ResRef] =
  result = initOrderedSet[ResRef]()
  for rr, re in self.entries:
    result.incl(rr)

method `$`*(self: Erf): string =
  "Erf:" & self.filename
