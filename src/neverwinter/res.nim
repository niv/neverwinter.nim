import options, streams

import resref, util

const MemoryCacheThreshold = 1024 * 1024 # 1MB

type
  Res* = ref object of RootObj
    io: Stream
    resref: ResRef
    offset: int
    size: int
    cached: bool
    cache: string

proc newRes*(resref: ResRef, io: Stream, offset: int, size: int): Res =
  new(result)
  result.io = io
  result.resref = resref
  result.offset = offset
  result.size = size

proc resRef*(self: Res): ResRef = self.resRef

proc size*(self: Res): int = self.size

method read*(self: Res): string {.base.} =
  ## Reads the full data of this res.
  if self.cached:
    result = self.cache

  else:
    self.io.setPosition(self.offset)
    result = self.io.readStrOrErr(self.size)
    if self.size < MemoryCacheThreshold:
      self.cached = true
      self.cache = result
      self.io = nil