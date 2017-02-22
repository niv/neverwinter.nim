when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, os, times

import resman, util

type
  ResMemFile* = ref object of ResContainer
    resRef: ResRef
    io: StringStream
    mtime: Time
    label: string

proc newResMemFile*(io: StringStream, rr: ResRef, label = "anon"): ResMemFile =
  new(result)
  result.io = io
  result.resRef = rr
  result.mtime = getTime()
  result.label = ""

method contains*(self: ResMemFile, rr: ResRef): bool =
  self.resRef == rr

method demand*(self: ResMemFile, rr: ResRef): Res =
  newRes(newResOrigin(self), rr, self.mtime, self.io)

method count*(self: ResMemFile): int = 1

method contents*(self: ResMemFile): HashSet[ResRef] =
  result = initSet[ResRef]()
  result.incl(self.resRef)

method `$`*(self: ResMemFile): string =
  "ResMemFile:(" & self.label & ")"
