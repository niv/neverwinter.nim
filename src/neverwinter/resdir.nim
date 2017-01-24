when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, os

import resman, util

type
  ResDir* = ref object of ResContainer
    directory: string

proc newResDir*(directory: string): ResDir =
  new(result)
  result.directory = directory

proc contents*(self: ResDir): seq[string] =
  result = newSeq[string]()
  for pc in walkDir(self.directory, true):
    if (pc.kind == pcFile or pc.kind == pcLinkToFile):
      let rr = tryNewResolvedResRef(pc.path)
      if rr.isSome:
        result.add(pc.path)

proc resRefToFullPath(self: ResDir, rr: ResolvedResRef): string =
  self.directory & DirSep & rr.toFile

method contains*(self: ResDir, rr: ResRef): bool =
  let r = rr.resolve()
  result = r.isSome and fileExists(self.resRefToFullPath(r.get()))

method demand*(self: ResDir, rr: ResRef): Res =
  let fp = self.resRefToFullPath(rr.resolve().get())
  let mtime = getLastModificationTime(fp)
  result = newRes(rr, mtime, newFileStream(fp))

method count*(self: ResDir): int =
  self.contents.len
