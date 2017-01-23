when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import options, streams, times

import resref, util

const MemoryCacheThreshold = 1024 * 1024 # 1MB

type
  Res* = ref object of RootObj
    mtime: Time
    io: Stream
    resref: ResRef
    offset: int
    size: int
    cached: bool
    cache: string

proc newRes*(resref: ResRef, mtime: Time, io: Stream, offset = 0, size = -1): Res =
  new(result)
  result.io = io
  result.resref = resref
  result.offset = offset
  result.size = size
  result.mtime = mtime

proc resRef*(self: Res): ResRef = self.resRef

proc size*(self: Res): int =
  self.size

proc mtime*(self: Res): Time =
  self.mtime

method read*(self: Res): string {.base.} =
  ## Reads the full data of this res.
  if self.cached:
    result = self.cache

  else:
    self.io.setPosition(self.offset)

    if self.size == -1:
      result = self.io.readAll
      self.size = result.len
    else:
      result = self.io.readStrOrErr(self.size)

    if self.size < MemoryCacheThreshold:
      self.cached = true
      self.cache = result
      self.io = nil