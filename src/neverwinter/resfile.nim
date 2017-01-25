when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, os

import resman, util

type
  ResFile* = ref object of ResContainer
    filename: string

proc newResFile*(filename: string): ResFile =
  new(result)
  result.filename = filename

proc resRefToFullPath(self: ResFile, rr: ResolvedResRef): string = rr.toFile

method contains*(self: ResFile, rr: ResRef): bool =
  let r = rr.resolve()
  result = r.isSome and fileExists(self.resRefToFullPath(r.get()))

method demand*(self: ResFile, rr: ResRef): Res =
  let fp = self.resRefToFullPath(rr.resolve().get())
  let mtime = getLastModificationTime(fp)
  result = newRes(rr, mtime, newFileStream(fp))

method count*(self: ResFile): int = 1 # TODO: check for access/existence
