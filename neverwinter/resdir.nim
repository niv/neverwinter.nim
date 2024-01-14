## A Resdir is the contents of a single directory mapped into resman. The contents
## are cached on creation and additions to the local filesystem are not reflected.

import std/[streams, os, tables, logging]

import resman

type
  ResDir* = ref object of ResContainer
    directory: string
    contentMap: Table[ResRef, string]
    contentSet: OrderedSet[ResRef]

proc rebuild(self: ResDir) =
  assert(self.directory != "")
  self.contentMap.clear()
  self.contentSet.clear()
  for pc in walkDir(self.directory, relative = true):
    if pc.kind in {pcFile, pcLinkToFile}:
      let rr = tryNewResolvedResRef(pc.path)
      if rr.isSome:
        self.contentMap[rr.unsafeGet] = pc.path
        self.contentSet.incl(rr.unsafeGet)

proc newResDir*(directory: string): ResDir =
  new(result)
  result.directory = directory
  result.rebuild()

proc directory*(self: ResDir): string =
  self.directory

proc checkExists(self: ResDir, rr: ResRef): bool =
  if not self.contentSet.contains(rr):
    return false

  if not fileExists(self.directory / self.contentMap[rr]):
    debug self, ": ", rr, " disappeared since ResDir creation"
    self.contentMap.del(rr)
    self.contentSet.excl(rr)
    return false

  return true

method contains*(self: ResDir, rr: ResRef): bool =
  self.checkExists(rr)

method demand*(self: ResDir, rr: ResRef): Res =
  if not self.checkExists(rr):
    return nil

  let fp = self.directory / self.contentMap[rr]
  let mtime = getLastModificationTime(fp)
  let sz = getFileSize(fp).int

  let spawner = proc(self: Res): Stream = openFileStream(fp)

  result = newRes(newResOrigin(self, self.directory), rr, mtime,
    ioSpawner = spawner, ioSize = sz)

method count*(self: ResDir): int =
  self.contents.card

method contents*(self: ResDir): OrderedSet[ResRef] =
  self.contentSet

method `$`*(self: ResDir): string =
  "ResDir:" & self.directory
