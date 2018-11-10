## This is a very basic reimplementation of how ResMan works, logically, in
## NWN1.  You will create a ResMan, and assign ResContainers to it in the reverse
## order you want them evaluated (latest = highest).
##
## See ResContainer for details on how this works.
##
## This ResMan has a cache builtin that can be memory-limited: The default is
## 100 MB of rss.  Tweaking this to have a sane value is highly dependant on the
## usecase.

## There are a handful of default container implementations available (KeyTable,
## Erf, ResDir, ResFile, ResMemFile). Please see their individual types for
## implementation details and usage.
##
## You can implement your own ResContainer easily by creating a new type that
## inherits from ResConainer and then creating the required methods (see below).


import options, streams, sets, times, strutils
export options, streams, sets

import resref, restype, util, lru
export resref, restype

const MemoryCacheThreshold* = 1024 * 1024 # 1MB
  ## Loaded Res (with readAll()) smaller than this are cached on the res to prevent
  ## repeated seeks/reads.  This works in conjunction with the Resman LRU cache.

type
  ResOrigin* = tuple[container: ResContainer, label: string]
    ## Used for debug printing and origin tracing (see Res.origin)

  Res* = ref object of RootObj
    ## A "pointer" to resource data, held inside a ResContainer, identified by
    ## a resref.
    mtime: Time
    io: Stream
    ioOwned: bool
    resref: ResRef
    offset: int
    size: int
    cached: bool
    cache: string

    origin: ResOrigin

  ResContainer* = ref object of RootObj

  ResMan* = ref object
    containers: seq[ResContainer]
    cache: WeightedLRU[ResRef, Res]



# --------------
#  ResContainer
# --------------

method `$`*(self: ResContainer): string {.base.} = "ResContainer:?"
  ## Implement this in a ResContainer. See the proc on ResMan for a description.
  ##
  ## This should output a short description of this ResContainer; it should at
  ## the very least include any backing storage info.

method contains*(self: ResContainer, rr: ResRef): bool {.base.} =
  ## Implement this in a ResContainer. See the proc on ResMan for a description.
  ##
  ## It needs to return true if the ResContainer has knowledge of the given ResRef.
  ## It must never error.
  raise newException(ValueError, "Implement me!")

method demand*(self: ResContainer, rr: ResRef): Res {.base.} =
  ## Implement this in any ResContainer. See the proc on ResMan for a description.
  ##
  ## This needs to return a Res. It must be safe to call even if contains() was
  ## not checked beforehand; a missing entry should raise a ValueError.
  raise newException(ValueError, "Implement me!")

method count*(self: ResContainer): int {.base.} =
  ## Implement this in any ResContainer. See the proc on ResMan for a description.
  ##
  ## This needs to return the total count of *available/readable* resrefs in this
  ## container.
  raise newException(ValueError, "Implement me!")

method contents*(self: ResContainer): OrderedSet[ResRef] {.base.} =
  ## Implement this in any ResContainer. See the proc on ResMan for a description.
  ##
  ## Returns the contents of this container, as a set.
  ## This can be a potentially *expensive operation*.
  raise newException(ValueError, "Implement me!")

proc `[]`*(self: ResContainer, rr: ResolvedResRef): Option[Res] =
  ## Alias for contains + demand.
  if self.contains(rr): result = some(self.demand(rr))

proc `[]`*(self: ResContainer, rr: ResRef): Option[Res] =
  ## Alias for contains + demand.
  if self.contains(rr): result = some(self.demand(rr))



# -----------
#  ResOrigin
# -----------

proc newResOrigin*(c: ResContainer, label = ""): ResOrigin =
  # if label == "": label = "(no-label)" # todo
  (container: c, label: label).ResOrigin

proc `$`*(self: ResOrigin): string =
  if self.label == "":
    $self.container
  else:
    $self.container & "(" & self.label & ")"



# -----
#  Res
# -----

proc newRes*(origin: ResOrigin, resref: ResRef, mtime: Time, io: Stream,
    size: int, offset = 0, ioOwned = false): Res =

  new(result)
  result.io = io
  result.resref = resref
  result.offset = offset
  result.size = size
  result.mtime = mtime
  result.origin = origin
  result.ioOwned = ioOwned

proc resRef*(self: Res): ResRef = self.resRef

proc len*(self: Res): int =
  self.size

proc mtime*(self: Res): Time =
  ## When this Res was last modified (This is highly experimental.)
  self.mtime

proc io*(self: Res): Stream =
  ## The backing IO (a stream) for this Res.  This is NOT guaranteed to be
  ## safe for concurrent readers, nor are there any guarantees as to length,
  ## current positioning, or data availability.
  self.io

proc ioOffset*(self: Res): int =
  self.offset

proc cached*(self: Res): bool =
  self.cached

proc seek*(self: Res) =
  ## Convenience method to make the backing io for this Res seek to the proper
  ## position.
  self.io.setPosition(self.offset)

proc origin*(self: Res): ResOrigin =
  ## Returns the origin of this res: The container it came from and the debug
  ## label the reader attached to it (if any).
  self.origin

method readAll*(self: Res, useCache: bool = true): string {.base.} =
  ## Reads the full data of this res. The value is cached, as long as it
  ## fits inside MemoryCacheThreshold.
  if useCache and self.cached:
    result = self.cache

  else:
    self.io.setPosition(self.offset)

    if self.size == -1:
      result = self.io.readAll
      self.size = result.len
    else:
      result = self.io.readStrOrErr(self.size)

    if useCache and self.size < MemoryCacheThreshold:
      self.cached = true
      self.cache = result
      if self.ioOwned: self.io.close()
      self.io = nil

proc `$`*(self: Res): string =
  "$#@$#".format(self.resref, self.origin)



# --------
#  ResMan
# --------

proc newResMan*(cacheSizeMB = 100): ResMan =
  ## Creates a new resman, with the given cache size.

  new(result)
  result.containers = newSeq[ResContainer]()
  if cacheSizeMB > 0:
    result.cache = newWeightedLRU[ResRef, Res](cacheSizeMB * 1024 * 1024)

proc contains*(self: ResMan, rr: ResRef, usecache = true): bool =
  ## Returns true if this ResMan knows about the res you gave it.
  if self.cache != nil and usecache and self.cache.hasKey(rr): return true

  for c in self.containers:
    if c.contains(rr): return true
  return false

proc demand*(self: ResMan, rr: ResRef, usecache = true): Res =
  ## Resolves the given resref. Will raise an error if things fail.
  if self.cache != nil and usecache:
    let cached = self.cache[rr]
    if cached.isSome:
      # echo "rr=", rr, " served from cache"
      return cached.get()

  for c in self.containers:
    if c.contains(rr):
      result = c.demand(rr)
      if self.cache != nil and usecache:
        # echo "rr=", rr, " put in cache"
        self.cache[rr, result.len] = result
      break

proc count*(self: ResMan): int =
  ## Returns the number of resrefs known to this resman.
  result = 0
  for c in self.containers: result += c.count()

proc contents*(self: ResMan): HashSet[ResRef] =
  ## Returns the contents of resman. This is a potentially *very expensive
  ## operation*, as it walks the lookup chain and collects the contents
  ## of each container.
  result = initSet[ResRef]()
  for c in self.containers:
    result.incl(c.contents())

proc `[]`*(self: ResMan, rr: ResolvedResRef): Option[Res] =
  ## Alias for contains + demand.
  if self.contains(rr): result = some(self.demand(rr))

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
  ## Remove a container from this ResMan.
  let idx = self.containers.find(c)
  if idx > -1: self.containers.del(idx)

proc del*(self: ResMan, idx: int) = self.containers.del(idx)
  ## Remove a container from this ResMan (by id).

proc cache*(self: ResMan): WeightedLRU[ResRef, Res] = self.cache
  ## Returns the LRU cache used by this ResMan. nil if disabled.
