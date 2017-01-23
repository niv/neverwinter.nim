when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, sequtils, tables

import resman, util

type
  ErfContent = tuple
    offset: int
    size: int

  LocString = tuple
    language: int
    text: string

  Erf* = ref object of ResContainer
    io: Stream
    ioStart: int

    fileType: string

    buildYear: int
    buildDay: int

    strRef: int
    locStrings: seq[LocString]
    contents: Table[ResRef, ErfContent]

    files: seq[ResRef]
    offsets: seq[tuple[offset: int, size: int]]
    offsetToResourceList: int

proc readFromStream*(io: Stream): Erf =
  new(result)
  result.io = io
  result.ioStart = io.getPosition
  result.files = newSeq[ResRef]()
  result.offsets = newSeq[tuple[offset: int, size: int]]()
  result.locStrings = newSeq[LocString]()

  result.fileType = io.readStrOrErr(4)
  expect(["MOD ", "ERF ", "HAK "].find(result.fileType) != -1, "unsupported erf type")
  expect(io.readStrOrErr(4) == "V1.0", "unsupported erf version")

  let locStrCount = io.readInt32()
  let locStringSz = io.readInt32()
  let entryCount = io.readInt32()
  let offsetToLocStr = io.readInt32()
  let offsetToKeyList = io.readInt32()
  result.offsetToResourceList = io.readInt32()
  result.buildYear = io.readInt32()
  result.buildDay = io.readInt32()
  result.strRef = io.readInt32()
  io.setPosition(io.getPosition + 116) # reserved

  # locstrlist
  io.setPosition(offsetToLocStr)
  for i in 0..<locStrCount:
    let id = io.readInt32()
    expect(id >= 0)
    let str = io.readStrOrErr(io.readInt32())
    result.locStrings.add((language: id.int, text: str))
  expect(io.getPosition == offsetToLocStr + locStringSz,
    "read bytes for locstringtable did not match expected size from header")

  # key list
  io.setPosition(offsetToKeyList)
  for i in 0..<entryCount:
    let resref = io.readStrOrErr(16).strip(true, true, {'\0'})
    io.setPosition(io.getPosition + 4) # id - we're not using it
    let restype = io.readInt16()
    io.setPosition(io.getPosition + 2) # unused NULLs
    result.files.add((resRef: resref, resType: restype.ResType).ResRef)

  # reslist
  for i in 0..<entryCount:
    let offset = io.readInt32().int
    let size = io.readInt32().int

    result.offsets.add((offset: offset, size: size))

method contains*(self: Erf, rr: ResRef): bool =
  self.files.find(rr) > -1

method demand*(self: Erf, rr: ResRef): Res =
  let index = self.files.find(rr)
  doAssert(index > -1)
  let offset = self.offsets[index]
  result = newRes(self.files[index], self.io, offset.offset, offset.size)

method count*(self: Erf): int = self.files.len
