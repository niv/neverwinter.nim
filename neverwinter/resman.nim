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


import options, streams, sets, times, strutils, checksums/sha1
export options, streams, sets

import resref, restype, util, lru, exo, compressedbuf
export resref, restype

const MemoryCacheThreshold* = 1024 * 1024 # 1MB
  ## Loaded Res (with readAll()) smaller than this are cached on the res to prevent
  ## repeated seeks/reads.  This works in conjunction with the Resman LRU cache.

type
  ResOrigin* = tuple[container: ResContainer, label: string]
    ## Used for debug printing and origin tracing (see Res.origin)

  ResIoSpawner* = proc(res: Res): Stream {.gcsafe.}
    ## Individual io handles need to be created on a per-demand level when a file
    ## is read. For the builtin readAll(), the file handle will be closed immediately after.

  Res* = ref object of RootObj
    ## A "pointer" to resource data, held inside a ResContainer, identified by
    ## a resref.
    mtime: Time

    ioStream: Stream   # Only valid if this Res is backed by a persistent (non-owned) IO.
    ioOffset: int      # offset into stream where the raw data is
    ioSize: int        # size of raw data (before decompression)

    ioSpawner: ResIoSpawner

    resref: ResRef

    sha1: SecureHash   # hash of object (can be zeroed out if no hash was provided)

    compression: ExoResFileCompressionType
    uncompressedSize: int

    cached: bool       # is the decompressed object cached in memory?
    cache: string

    origin: ResOrigin

  ResContainer* = ref object of RootObj

  ResMan* = ref object
    containers: seq[ResContainer]
    cache: WeightedLRU[ResRef, Res]



# --------------
#  ResContainer
# --------------

method `$`*(self: ResContainer): string {.base,gcsafe.} = "ResContainer:?"
  ## Implement this in a ResContainer. See the proc on ResMan for a description.
  ##
  ## This should output a short description of this ResContainer; it should at
  ## the very least include any backing storage info.

method contains*(self: ResContainer, rr: ResRef): bool {.base,gcsafe.} =
  ## Implement this in a ResContainer. See the proc on ResMan for a description.
  ##
  ## It needs to return true if the ResContainer has knowledge of the given ResRef.
  ## It must never error.
  raise newException(ValueError, "Implement me!")

method demand*(self: ResContainer, rr: ResRef): Res {.base,gcsafe.} =
  ## Implement this in any ResContainer. See the proc on ResMan for a description.
  ##
  ## This needs to return a Res. It must be safe to call even if contains() was
  ## not checked beforehand; a missing entry must raise.
  raise newException(ValueError, "Implement me!")

method count*(self: ResContainer): int {.base,gcsafe.} =
  ## Implement this in any ResContainer. See the proc on ResMan for a description.
  ##
  ## This needs to return the total count of *available/readable* resrefs in this
  ## container.
  raise newException(ValueError, "Implement me!")

method contents*(self: ResContainer): OrderedSet[ResRef] {.base,gcsafe.} =
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

const EmptySecureHash = [0u8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0].SecureHash
proc newRes*(
    origin: ResOrigin, resref: ResRef,
    mtime: Time,
    io: Stream, ioSize: int, ioOffset = 0,
    compression = ExoResFileCompressionType.None, uncompressedSize = 0,
    sha1: SecureHash = EmptySecureHash): Res =
  ## Create a new Res instance that is backed by a pre-existing IO instance (such as an ERF file).
  new(result)
  result.ioStream = io
  result.resref = resref
  result.ioOffset = ioOffset
  result.ioSize = ioSize
  result.mtime = mtime
  result.origin = origin

  result.compression = compression
  result.uncompressedSize =
    if compression == ExoResFileCompressionType.None and uncompressedSize == 0: ioSize
    else: uncompressedSize
  result.sha1 = sha1

proc newRes*(
    origin: ResOrigin, resref: ResRef,
    mtime: Time,
    ioSpawner: ResIoSpawner, ioSize: int, ioOffset = 0,
    compression = ExoResFileCompressionType.None, uncompressedSize = 0,
    sha1: SecureHash = EmptySecureHash): Res =
  ## Create a new Res instance that is backed by a dynamic IO spawner.
  new(result)

  result.resref = resref
  result.ioSpawner = ioSpawner
  result.ioOffset = ioOffset
  result.ioSize = ioSize
  result.mtime = mtime
  result.origin = origin

  result.compression = compression
  result.uncompressedSize =
    if compression == ExoResFileCompressionType.None and uncompressedSize == 0: ioSize
    else: uncompressedSize
  result.sha1 = sha1

proc resRef*(self: Res): ResRef = self.resRef

proc mtime*(self: Res): Time =
  ## When this Res was last modified (This is highly experimental.)
  self.mtime

func ioOwned*(self: Res): bool =
  ## Returns true if this Res owns the IO (e.g. is not spawned dynamically)
  not isNil(self.ioStream) and isNil(self.ioSpawner)

proc io*(self: Res, cacheIO = true): Stream =
  ## The backing IO (a stream) for this Res.  This is NOT guaranteed to be
  ## safe for concurrent readers, nor are there any guarantees as to length,
  ## current positioning, or data availability.
  ## This is also the raw data stream, NOT decompressed data (if the Res is compressed).

  if not isNil(self.ioStream):
    return self.ioStream
  elif not isNil(self.ioSpawner) and cacheIO:
    self.ioStream = self.ioSpawner(self)
    return self.ioStream
  elif not isNil(self.ioSpawner):
    return self.ioSpawner(self)
  else:
    return nil

proc ioOffset*(self: Res): int =
  ## Return the offset into `getIO` on where the data for this Res starts.
  ## Only valid for Res that are backed by a IO.
  self.ioOffset

proc ioSize*(self: Res): int =
  self.ioSize

proc cached*(self: Res): bool =
  self.cached

proc uncompressedSize*(self: Res): int = self.uncompressedSize
proc compressionAlgorithm*(self: Res): ExoResFileCompressionType = self.compression

proc seek*(self: Res) =
  ## Convenience method to make the backing io for this Res seek to the proper
  ## position.
  self.io.setPosition(self.ioOffset)

proc origin*(self: Res): ResOrigin =
  ## Returns the origin of this res: The container it came from and the debug
  ## label the reader attached to it (if any).
  self.origin

method readAll*(self: Res, useCache: bool = true): string {.base,gcsafe.} =
  ## Reads the full data of this res. Transparently decompresses.
  ## If `useCache` is true, then the value is cached in memory (if fitting into MemoryCacheThreshold).
  ## This method has special handling for dynamically backed IO (e.g. reading single files) to
  ## make sure we don't exhaust the available fd.
  if useCache and self.cached:
    return self.cache

  var io = self.io(cacheIO = false)
  defer:
    # We need to be aggressive about closing the open IO handle we summoned,
    # otherwise we'll exhaust fdlimit before gc has a chance to collect.
    if not self.ioOwned:
      io.close()

  io.setPosition(self.ioOffset)

  let rawData = if self.ioSize == -1:
    io.readAll
  else:
    io.readStrOrErr(self.ioSize)

  self.ioSize = rawData.len

  result = case self.compression
    of ExoResFileCompressionType.None:
      rawData
    of ExoResFileCompressionType.CompressedBuf:
      decompress(rawData, ExoResFileCompressedBufMagic)

  if useCache and self.ioSize < MemoryCacheThreshold:
    self.cached = true
    self.cache = result

proc `$`*(self: Res): string =
  "$#@$#".format(self.resref, self.origin)

proc sha1*(self: Res): SecureHash =
  ## Returns the checksum for the contained data. Warning: may invoke a full read
  ## if the container doesn't have checksums embedded.
  if self.sha1 == EmptySecureHash:
    self.sha1 = secureHash(self.readAll)
  self.sha1

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
  ## Will not actually open a IO handle or read data; this is done in readAll(); or manually
  ## with the io accessors.
  if self.cache != nil and usecache:
    let cached = self.cache[rr]
    if cached.isSome:
      # echo "rr=", rr, " served from cache"
      return cached.get()

  for c in self.containers:
    if c.contains(rr):
      result = c.demand(rr)
      if self.cache != nil and usecache:
        self.cache[rr, result.ioSize] = result
      return result

  raise newException(ValueError, "not found: " & $rr)

proc contents*(self: ResMan): HashSet[ResRef] =
  ## Returns the contents of resman. This is a potentially *very expensive
  ## operation*, as it walks the lookup chain and collects the contents
  ## of each container.
  result = initHashSet[ResRef]()
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
