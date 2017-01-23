import options, streams

import resref, res, util, lru
export resref, res

type
  ResContainer* = ref object of RootObj

  ResMan* = ref object
    containers: seq[ResContainer]
    cache: WeightedLRU[ResRef, Res]

proc newResMan*(cacheSizeMB = 100): ResMan =
  new(result)
  result.containers = newSeq[ResContainer]()
  assert(cacheSizeMB >= 0)
  result.cache = newWeightedLRU[ResRef, Res](cacheSizeMB * 1024 * 1024)

method contains*(self: ResContainer, rr: ResRef): bool {.base.} =
  raise newException(ValueError, "Implement me!")

method demand*(self: ResContainer, rr: ResRef): Res {.base.} =
  raise newException(ValueError, "Implement me!")

method count*(self: ResContainer): int {.base.} =
  raise newException(ValueError, "Implement me!")

proc contains*(self: ResMan, rr: ResRef, usecache = true): bool =
  ## Returns true if this ResMan knows about the res you gave it.
  if usecache and self.cache.hasKey(rr): return true

  for c in self.containers:
    if c.contains(rr): return true
  return false

proc demand*(self: ResMan, rr: ResRef, usecache = true): Res =
  ## Resolves the given resref. Will raise an error if things fail.
  if usecache:
    let cached = self.cache[rr]
    if cached.isSome:
      # echo "rr=", rr, " served from cache"
      return cached.get()

  for c in self.containers:
    if c.contains(rr):
      result = c.demand(rr)
      if usecache:
        # echo "rr=", rr, " put in cache"
        self.cache[rr, result.size] = result
      break

proc count*(self: ResMan): int =
  result = 0
  for c in self.containers: result += c.count()

proc `[]`*(self: ResMan, rr: ResRef): Option[Res] =
  ## Alias for contains + demand.
  if self.contains(rr): result = some(self.demand(rr))

proc add*(self: ResMan, c: ResContainer) =
  ## Adds a container to be indiced by this ResMan. Containers are indiced in
  ## reverse order; so the one added last will be queried first for any res.
  self.containers.insert(c, 0)

proc containers*(self: ResMan): seq[ResContainer] =
  ## Returns a seq of all resman containers.
  self.containers

proc del*(self: ResMan, c: ResContainer) =
  let idx = self.containers.find(c)
  if idx > -1: self.containers.del(idx)

proc del*(self: ResMan, idx: int) = self.containers.del(idx)

proc cache*(self: ResMan): WeightedLRU[ResRef, Res] = self.cache
