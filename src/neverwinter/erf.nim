when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, sequtils, tables, times, algorithm

import resman, util

type
  Erf* = ref object of ResContainer
    mtime*: Time

    fileType*: string

    buildYear*: int
    buildDay*: int

    strRef*: int
    locStrings: TableRef[int, string]
    contents: TableRef[ResRef, Res]

proc contents*(self: Erf): TableRef[ResRef, Res] =
  self.contents

proc locStrings*(self: Erf): TableRef[int, string] =
  self.locStrings

proc readErf*(io: Stream): Erf =
  new(result)
  result.locStrings = newTable[int, string]()
  result.contents = newTable[ResRef, Res]()
  result.mtime = getTime()

  result.fileType = io.readStrOrErr(4)
  expect(["MOD ", "ERF ", "HAK "].find(result.fileType) != -1, "unsupported erf type")
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
    expect(not result.contents.hasKey(rr), "duplicate resref in erf: " & $rr)

    let resData = resList[i]
    var erfObj = newRes(rr, result.mtime, io, size = resData.size, offset = resData.offset)
    result.contents[rr] = erfObj

proc write*(io: Stream, self: Erf) =
  let ioStart = io.getPosition

  var locStrSize = 0
  for id, str in self.locStrings: locStrSize += 8 + str.toNwnEncoding.len

  let offsetToLocStr = 160
  let offsetToKeyList = offsetToLocStr + locStrSize
  let keyListSize = self.contents.len * 24
  let offsetToResourceList = offsetToKeyList + keyListSize

  expect(self.fileType.len == 4)
  io.write(self.fileType)
  io.write("V1.0")
  io.write(self.locStrings.len.int32)
  io.write(locStrSize.int32)
  io.write(self.contents.len.int32)
  io.write(offsetToLocStr.int32)
  io.write(offsetToKeyList.int32)
  io.write(offsetToResourceList.int32)
  io.write(self.buildYear.int32)
  io.write(self.buildDay.int32)
  io.write(self.strRef.int32)
  io.write(repeat("\x0", 116))
  assert(io.getPosition == ioStart + 160)

  var keysToWrite = newSeq[ResRef]()
  for k in self.contents.keys: keysToWrite.add(k)

  # we save out entries sorted alphabetically for now.
  keysToWrite.sort() do (x, y: auto) -> int:
    if x.resRef > y.resRef: 1 else: -1

  # locstr list
  for id, str in self.locStrings:
    io.write(id.int32)
    io.write(str.toNwnEncoding.len.int32)
    io.write(str.toNwnEncoding)

  # key list
  var id = 0
  for rr in keysToWrite:
    let cc = self.contents[rr]
    # resref, id, restype, 0, 0
    io.write(rr.resRef & repeat("\x0", 16 - rr.resRef.len))
    io.write(id.int32)
    io.write(rr.resType.int16)
    io.write("\x0\x0")
    id += 1

  # res list
  var currentOffset = 0
  for rr in keysToWrite:
    let cc = self.contents[rr]
    io.write(currentOffset.int32)
    io.write(cc.len.int32)
    currentOffset += cc.len

  # res data
  for rr in keysToWrite:
    let cc = self.contents[rr]
    io.write(cc.read())

method contains*(self: Erf, rr: ResRef): bool =
  self.contents.hasKey(rr)

method demand*(self: Erf, rr: ResRef): Res =
  self.contents[rr]

method count*(self: Erf): int =
  self.contents.len
