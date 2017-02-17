import tables, strutils, options
from hashes import hash, Hash, `!&`

import restype, util

const
  ResRefMaxLength = 16

type
  ResRef* = ref object of RootObj
    resRef: string
    resType: ResType

  ResolvedResRef* = ref object of ResRef
    resExt: string

proc hash*(self: ResRef): Hash =
  0 !& hash(self.resRef) !& hash(self.resType)

proc `==`*(a, b: ResRef): bool =
  a.resRef == b.resRef and a.resType == b.resType

proc isValidResRefPart1(s: string): bool = s.len > 0 and s.len <= ResRefMaxLength

proc newResRef*(resRef: string, resType: ResType): ResRef =
  expect(resRef.isValidResRefPart1, "'" & resRef & "' is not a valid resref")
  new(result)
  result.resRef = resRef.toLowerAscii
  result.resType = resType

proc resolve*(rr: ResRef): Option[ResolvedResRef] =
  let ext = lookupResExt(rr.resType)
  if ext.isSome:
    let r = new(ResolvedResRef)
    r.resRef = rr.resRef
    r.resType = rr.resType
    r.resExt = ext.get()
    result = some(r)

proc tryNewResolvedResRef*(filename: string): Option[ResolvedResRef] =
  let sp = filename.toLowerAscii.split(".", 2)
  if sp.len == 2 and isValidResRefPart1(sp[0]):
    let ext = lookupResType(sp[1])
    if ext.isSome:
      result = newResRef(sp[0], ext.get()).resolve()

proc newResolvedResRef*(filename: string): ResolvedResRef =
  let r = tryNewResolvedResRef(filename)
  expect(r.isSome, "'" & filename & "' is not a resolvable resref")
  result = r.get()

converter stringToResolvedResRef*(filename: string): ResolvedResRef =
  newResolvedResRef(filename)

proc `$`*(rr: ResRef): string = rr.resRef & "._" & $rr.resType
proc toFile*(rr: ResolvedResRef): string = rr.resRef & "." & rr.resExt
proc `$`*(rr: ResolvedResRef): string = rr.toFile

proc resRef*(rr: ResRef): string = rr.resRef
proc resType*(rr: ResRef): ResType = rr.resType
proc resExt*(rr: ResolvedResRef): string = rr.resExt
