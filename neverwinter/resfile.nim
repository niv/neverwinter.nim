## A ResFile is a single file mapped into resman: it needs to live in the
## file system and remain accessible.

import streams, strutils, os

import resman, util

type
  ResFile* = ref object of ResContainer
    filename: string
    resRef: ResolvedResRef

proc newResFile*(filename: string): ResFile =
  new(result)
  result.filename = filename
  result.resRef = newResolvedResRef(extractFilename(filename))

proc resRefToFullPath(self: ResFile, rr: ResolvedResRef): string =
  self.filename

method contains*(self: ResFile, rr: ResRef): bool =
  let r = rr.resolve()
  result = rr == self.resRef and r.isSome and
    fileExists(self.resRefToFullPath(r.get()))

method demand*(self: ResFile, rr: ResRef): Res =
  let fp = self.resRefToFullPath(rr.resolve().get())
  let mtime = getLastModificationTime(fp)
  let sz = getFileSize(fp).int

  result = newRes(newResOrigin(self), rr, mtime, io = newFileStream(fp), size = sz)

method count*(self: ResFile): int =
  if fileExists(self.resRefToFullPath(self.resRef)): 1 else: 0

method contents*(self: ResFile): OrderedSet[ResRef] =
  result = initOrderedSet[ResRef]()
  if fileExists(self.resRefToFullPath(self.resRef)):
    result.incl(self.resRef)

method `$`*(self: ResFile): string =
  "ResFile:" & self.filename
