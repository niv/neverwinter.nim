when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import options, streams, times
import resref, util, rescontainer

const MemoryCacheThreshold* = 1024 * 1024 # 1MB
  ## loaded res (with readAll()) smaller than this are cached on the res to prevent
  ## repeated seeks/reads.  This works in conjunction with the Resman LRU cache.

type
  ResOrigin* = tuple[container: ResContainer, label: string]
  ## Used for debug printing and origin tracing (see Res.origin)

  Res* = ref object of RootObj
    mtime: Time
    io: Stream
    resref: ResRef
    offset: int
    size: int
    cached: bool
    cache: string

    origin: ResOrigin

proc newResOrigin*(c: ResContainer, label = ""): ResOrigin =
  # if label == "": label = "(no-label)" # todo
  (container: c, label: label).ResOrigin

proc `$`*(self: ResOrigin): string =
  if self.label == "":
    $self.container
  else:
    $self.container & "(" & self.label & ")"

proc newRes*(origin: ResOrigin, resref: ResRef, mtime: Time, io: Stream,
    offset = 0, size = -1): Res =

  new(result)
  result.io = io
  result.resref = resref
  result.offset = offset
  result.size = size
  result.mtime = mtime
  result.origin = origin

proc resRef*(self: Res): ResRef = self.resRef

proc len*(self: Res): int =
  self.size

proc mtime*(self: Res): Time =
  self.mtime

proc io*(self: Res): Stream =
  self.io

proc ioOffset*(self: Res): int =
  self.offset

proc cached*(self: Res): bool =
  self.cached

proc seek*(self: Res) =
  self.io.setPosition(self.offset)

proc origin*(self: Res): ResOrigin =
  ## Returns the origin of this res: The container it came from and the debug
  ## label the reader attached to it (if any).
  self.origin

method readAll*(self: Res): string {.base.} =
  ## Reads the full data of this res. The value is cached, as long as it
  ## fits inside MemoryCacheThreshold.
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