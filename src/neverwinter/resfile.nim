when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, strutils, os

import resman, util

type
  ResFile* = ref object of ResContainer
    filename: string
    resRef: ResolvedResRef

proc newResFile*(filename: string): ResFile =
  new(result)
  result.filename = filename
  result.resRef = newResolvedResRef(filename)

proc resRefToFullPath(self: ResFile, rr: ResolvedResRef): string = rr.toFile

method contains*(self: ResFile, rr: ResRef): bool =
  let r = rr.resolve()
  result = r.isSome and fileExists(self.resRefToFullPath(r.get()))

method demand*(self: ResFile, rr: ResRef): Res =
  let fp = self.resRefToFullPath(rr.resolve().get())
  let mtime = getLastModificationTime(fp)

  result = newRes(newResOrigin(self), rr, mtime, newFileStream(fp))

method count*(self: ResFile): int = # TODO: check for access/existence
  if fileExists(self.resRefToFullPath(self.resRef)): 1 else: 0

method contents*(self: ResFile): HashSet[ResRef] =
  result = initSet[ResRef]()
  if fileExists(self.resRefToFullPath(self.resRef)):
    result.incl(self.resRef)

method `$`*(self: ResFile): string =
  "ResFile:" & self.filename
