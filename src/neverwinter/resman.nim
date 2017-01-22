import options, streams

import resref

import util

type
  ResContainer* = ref object of RootObj

  ResMan* = ref object
    containers: seq[ResContainer]

  Res* = ref object of RootObj
    io: Stream
    size: int
    data: string

proc newResMan*(): ResMan =
  new(result)
  result.containers = newSeq[ResContainer]()

method contains*(self: ResContainer, rr: ResRef): bool {.base.} =
  raise newException(ValueError, "Implement me!")

method demand*(self: ResContainer, rr: ResRef): Res {.base.} =
  raise newException(ValueError, "Implement me!")

proc contains*(self: ResMan, rr: ResRef): bool =
  ## Returns true if this ResMan knows about the res you gave it.

  for c in self.containers:
    if c.contains(rr): return true
  return false

proc demand*(self: ResMan, rr: ResRef): Res =
  ## Resolves the given resref. Will raise an error if things fail.
  for c in self.containers:
    if c.contains(rr): return c.demand(rr)

proc `[]`*(self: ResMan, rr: ResRef): Option[Res] =
  ## Alias for contains + demand.
  if self.contains(rr): result = some(self.demand(rr))

proc add*(self: ResMan, c: ResContainer) =
  self.containers.insert(c, 0)

proc newRes*(io: Stream, size: int): Res =
  new(result)
  result.io = io
  result.size = size

proc read*(self: Res): string =
  ## Reads the full data of this res. This is a one-shot op; this Res will be
  ## invalid after that.
  result = self.io.readStrOrErr(self.size)
  self.size = 0
