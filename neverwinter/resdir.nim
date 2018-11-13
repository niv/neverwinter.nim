## A Resdir is the contents of a single directory mapped into resman. The contents
## are available live (meaning that adding files makes them available immediately).
## This may change in the future.

import streams, strutils, os, logging

import resman, util

type
  ResDir* = ref object of ResContainer
    directory: string

proc newResDir*(directory: string): ResDir =
  new(result)
  result.directory = directory

proc resRefToFullPath(self: ResDir, rr: ResolvedResRef): string =
  self.directory & DirSep & rr.toFile

method contains*(self: ResDir, rr: ResRef): bool =
  let r = rr.resolve()
  result = r.isSome and fileExists(self.resRefToFullPath(r.get()))

method demand*(self: ResDir, rr: ResRef): Res =
  let fp = self.resRefToFullPath(rr.resolve().get())
  let mtime = getLastModificationTime(fp)
  let sz = getFileSize(fp).int

  let fs = newFileStream(fp, fmRead)
  result = newRes(newResOrigin(self), rr, mtime, fs, size = sz, ioOwned = true)

method count*(self: ResDir): int =
  self.contents.card

method contents*(self: ResDir): OrderedSet[ResRef] =
  result = initOrderedSet[ResRef]()

  for pc in walkDir(self.directory, true):
    if (pc.kind == pcFile or pc.kind == pcLinkToFile):
      let rr = tryNewResolvedResRef(pc.path)
      if rr.isSome:
        # if pc.path != pc.path.toLowerAscii:
        #   warn self, ": '" & pc.path & "' is not lowercase. This will break on Linux."
        result.incl(rr.get())

method `$`*(self: ResDir): string =
  "ResDir:" & self.directory
