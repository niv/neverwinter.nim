import std/[streams, times]

import resman

type
  ResMemFile* = ref object of ResContainer
    resRef: ResRef
    io: StringStream
    size: int
    mtime: Time
    label: string

proc newResMemFile*(io: StringStream, rr: ResRef, size: int, label = "anon"): ResMemFile =
  new(result)
  result.io = io
  result.resRef = rr
  result.mtime = getTime()
  result.label = label
  result.size = size

proc newResMemFile*(data: string, rr: ResRef, label = "anon"): ResMemFile =
  newResMemFile(newStringStream(data), rr, data.len, label)

method contains*(self: ResMemFile, rr: ResRef): bool =
  self.resRef == rr

method demand*(self: ResMemFile, rr: ResRef): Res =
  newRes(origin = newResOrigin(self, self.label), resref = rr, mtime = self.mtime,
    io = self.io, ioSize = self.size)

method count*(self: ResMemFile): int = 1

method contents*(self: ResMemFile): OrderedSet[ResRef] =
  result = initOrderedSet[ResRef]()
  result.incl(self.resRef)

method `$`*(self: ResMemFile): string =
  "ResMemFile:(" & self.label & ")"
