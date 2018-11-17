import streams, strutils, sequtils, tables, times, algorithm, os, logging

import resman, util

# This is advisory only. We will emit a warning on mismatch (so library users
# get more debug hints), but still attempt to load the file.
const ValidErfTypes = ["NWM ", "MOD ", "ERF ", "HAK "]

type
  Erf* = ref object of ResContainer
    mtime*: Time

    fileType*: string

    filename: string

    buildYear*: int
    buildDay*: int

    strRef*: int
    locStrings: Table[int, string]
    entries: OrderedTableRef[ResRef, Res]

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
  if  modv != "V1.0":
    warn "unsupported erf version: ", modv, "; erf might fail to load"

  let locStrCount = io.readInt32()
  let locStringSz = io.readInt32()
  let entryCount = io.readInt32()
  let offsetToLocStr = io.readInt32()
  let offsetToKeyList = io.readInt32()
  let offsetToResourceList = io.readInt32()
  result.buildYear = io.readInt32()
  result.buildDay = io.readInt32()
  result.strRef = io.readInt32()
  io.setPosition(io.getPosition + 116) # reserved

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

  var resList = newSeq[tuple[offset: int, size: int]]()
  io.setPosition(offsetToResourceList)
  for i in 0..<entryCount:
    resList.add((offset: io.readInt32().int, size: io.readInt32().int))

  # key list
  io.setPosition(offsetToKeyList)
  for i in 0..<entryCount:
    let resref = io.readStrOrErr(16).strip(true, true, {'\0'})
    io.setPosition(io.getPosition + 4) # id - we're not using it
    let restype = io.readInt16()
    io.setPosition(io.getPosition + 2) # unused NULLs

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
         result.entries[rr].len == resList[i].size:
        warn "Duplicate resref entry in erf pointing to same data, skipping: ", rr
        continue


      else:
        let newrr = newResRef("__erfdup__" & $i, restype.ResType)

        warn(("Duplicate resref entry in erf, but differing offset/size: " &
              "resref=$# offset=$# size=$# (idx=$#) would collide with " &
              "offset=$# size=$#; renamed to $#"
              ).format(
                rr, resList[i].offset, resList[i].size, i,
                result.entries[rr].ioOffset,
                result.entries[rr].len,
                newrr))

        rr = newrr

    let resData = resList[i]
    var erfObj = newRes(newResOrigin(result), rr, result.mtime, io,
      size = resData.size, offset = resData.offset)
    result.entries[rr] = erfObj

proc writeErf*(io: Stream,
               fileType: string,
               locStrings: Table[int, string] = initTable[int, string](),
               strRef = 0,
               entries: seq[ResRef],
               # This is called when we want you to write the binary data
               # of r:ResRef to io.
               writer: proc(r: ResRef, io: Stream): void) =

  ## Writes a new ERF.
  ## `entries` maps resrefs to filenames on the local system.

  let ioStart = io.getPosition

  var locStrSize = 0
  for id, str in locStrings: locStrSize += 8 + str.toNwnEncoding.len

  let offsetToLocStr = 160
  let offsetToKeyList = offsetToLocStr + locStrSize
  let keyListSize = entries.len * 24
  let offsetToResourceList = offsetToKeyList + keyListSize

  let myFileType = fileType[0..min(fileType.high, 3)] &
                   strutils.repeat(" ", clamp(3 - fileType.high, 0,  4))
  assert(myFileType.len == 4)
  io.write(myFileType.toUpperAscii)
  io.write("V1.0")
  io.write(locStrings.len.int32)
  io.write(locStrSize.int32)
  io.write(entries.len.int32)
  io.write(offsetToLocStr.int32)
  io.write(offsetToKeyList.int32)
  io.write(offsetToResourceList.int32)
  io.write(int32 getTime().utc.year - 1900) # self.buildYear.int32)
  io.write(int32 getTime().utc.yearday) # self.buildDay.int32)
  io.write(int32 strRef)
  io.write(repeat("\x00", 116))
  assert(io.getPosition == ioStart + 160)

  # We save out entries sorted alphabetically for now. This ensures a reproducible
  # build.
  let keysToWrite = entries.sorted() do (a, b: ResRef) -> int:
    system.cmp(a.resRef.toUpperAscii, b.resRef.toUpperAscii)

  # locstr list
  for id, str in locStrings:
    io.write(id.int32)
    io.write(str.toNwnEncoding.len.int32)
    io.write(str.toNwnEncoding)

  # key list
  var id = 0
  for rr in keysToWrite:
    io.write(rr.resRef & repeat("\x00", 16 - rr.resRef.len))
    io.write(id.int32)
    io.write(rr.resType.int16)
    io.write("\x00\x00")
    id += 1

  var sizes = initTable[ResRef, BiggestInt]()
  let resListOffset = io.getPosition

  # res list: pad out first and revisit when data was written and we
  # have the sizes
  io.write(repeat("\x00", 8 * keysToWrite.len))

  let resDataOffset = io.getPosition

  # res data: write data and keep track of sizes written
  for rr in keysToWrite:
    let pos = io.getPosition
    writer(rr, io)
    sizes[rr] = io.getPosition - pos

  let eofOffset = io.getPosition

  io.setPosition(resListOffset)
  var currentOffset: BiggestInt = resDataOffset
  for rr in keysToWrite:
    io.write(uint32 currentOffset)
    io.write(uint32 sizes[rr])
    currentOffset += sizes[rr]

  io.setPosition(eofOffset)

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
