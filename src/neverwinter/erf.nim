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
    locStrings: TableRef[int, string]
    entries: OrderedTableRef[ResRef, Res]

proc locStrings*(self: Erf): TableRef[int, string] =
  self.locStrings

proc readErf*(io: Stream, filename = "(anon-io)"): Erf =
  new(result)
  result.locStrings = newTable[int, string]()
  result.entries = newOrderedTable[ResRef, Res]()
  result.mtime = getTime()
  result.filename = filename

  result.fileType = io.readStrOrErr(4)
  if ValidErfTypes.find(result.fileType) == -1:
    warn("Unknown erf file type: '" & repr(result.fileType) &
         "', possibly invalid erf?")

  expect(io.readStrOrErr(4) == "V1.0", "unsupported erf version")

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

  expect(io.getPosition == offsetToLocStr + locStringSz,
    "read bytes for locstringtable did not match expected size from header")

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

    let rr = newResRef(resref, restype.ResType)
    expect(not result.entries.hasKey(rr), "duplicate resref in erf: " & $rr)

    let resData = resList[i]
    var erfObj = newRes(newResOrigin(result), rr, result.mtime, io,
      size = resData.size, offset = resData.offset)
    result.entries[rr] = erfObj

proc writeErf*(io: Stream,
               fileType: string,
               entries: Table[ResRef, string], # resref to local file.
               locStrings: Table[int, string] = initTable[int, string](),
               strRef = 0,
               progress: proc(r: ResRef): void = nil
               # not supported yet:
               # entries: seq[ResRef],
               # resolver: proc(r: ResRef): tuple[s: Stream, sz: int]) =
              ) =

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
  io.write(int32 getTime().getGMTime().year - 1900) # self.buildYear.int32)
  io.write(int32 getTime().getGMTime().yearday) # self.buildDay.int32)
  io.write(int32 strRef)
  io.write(repeat("\x0", 116))
  assert(io.getPosition == ioStart + 160)

  # We save out entries sorted alphabetically for now. This ensures a reproducible
  # build.
  let keysToWrite = toSeq(entries.keys).sorted() do (a, b: ResRef) -> int:
    system.cmp(a.resRef.toUpperAscii, b.resRef.toUpperAscii)

  # locstr list
  for id, str in locStrings:
    io.write(id.int32)
    io.write(str.toNwnEncoding.len.int32)
    io.write(str.toNwnEncoding)

  # key list
  var id = 0
  for rr in keysToWrite:
    io.write(rr.resRef & repeat("\x0", 16 - rr.resRef.len))
    io.write(id.int32)
    io.write(rr.resType.int16)
    io.write("\x0\x0")
    id += 1

  # res list
  var currentOffset = 0
  for rr in keysToWrite:
    let sz = getFileSize(entries[rr]).int32
    # let (rrio, sz) = resolver(rr) #  self.entries[rr]
    io.write(int32 currentOffset)
    io.write(int32 sz)
    currentOffset += sz

  # res data
  for rr in keysToWrite:
    let fn = entries[rr]
    if progress != nil: progress(rr)
    io.write(readFile(fn))

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
