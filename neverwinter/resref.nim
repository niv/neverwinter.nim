import strutils, options
from hashes import hash, Hash, `!&`

import restype, util

const
  ResRefMaxLength = 16

type
  ResRef* = object
    ## A ResRef is a string/restype pair; the restype does not neccessarily need
    ## to be registered with resman.
    resRef: string
    resType: ResType

  ResolvedResRef* = object
    ## A ResolvedResRef is a ResRef that we have a human-readable extension for.
    ## You can only resolve resrefs where the restype is known to resman.
    base: ResRef
    resExt: string

proc isValidResRefPart1(s: string): bool = s.len > 0 and s.len <= ResRefMaxLength

proc newResRef*(resRef: string, resType: ResType): ResRef =
  ## Creates a new ResRef. Will raise a ValueError if the given data is invalid.
  expect(resRef.isValidResRefPart1, "'" & resRef & "." & $resType & "' is not a valid resref")
  result.resRef = resRef
  result.resType = resType

proc resolve*(rr: ResRef): Option[ResolvedResRef] =
  ## Attempts to resolve this resref. Will not raise any errors; instead, use
  ## the given optional to check for success.
  let ext = lookupResExt(rr.resType)
  if ext.isSome:
    var r: ResolvedResRef
    r.base = rr
    r.resExt = ext.get()
    result = some(r)

proc tryNewResolvedResRef*(filename: string): Option[ResolvedResRef] =
  ## Alias for newResRef().resolve()
  let sp = filename.toLowerAscii.rsplit(".", 1)
  if sp.len == 2 and isValidResRefPart1(sp[0]):
    let ext = lookupResType(sp[1])
    if ext.isSome:
      result = newResRef(sp[0], ext.get()).resolve()

proc newResolvedResRef*(resRef: string, resType: ResType): ResolvedResRef =
  ## Alias for newResRef().resolve()
  let r = newResRef(resRef, resType).resolve()
  expect(r.isSome, "'" & resRef & "." & $resType & "' is not a resolvable resref")
  r.unsafeGet

proc newResolvedResRef*(filename: string): ResolvedResRef =
  ## Alias for newResRef().resolve().get()
  let r = tryNewResolvedResRef(filename)
  expect(r.isSome, "'" & filename & "' is not a resolvable resref")
  result = r.get()

converter resolvedToBaseResRef*(rr: ResolvedResRef): ResRef = rr.base

proc toFile*(rr: ResolvedResRef): string = rr.base.resRef & "." & rr.resExt
proc `$`*(rr: ResolvedResRef): string = rr.toFile
proc `$`*(rr: ResRef): string = rr.resRef & "." & $rr.resType

proc resRef*(rr: ResRef): string = rr.resRef
proc resType*(rr: ResRef): ResType = rr.resType
proc resExt*(rr: ResolvedResRef): string = rr.resExt

proc hash*(self: ResRef): Hash =
  0 !& hash(self.resRef.toUpperAscii) !& hash(self.resType)

proc `==`*(a, b: ResRef): bool =
  a.resType == b.resType and cmpIgnoreCase(a.resRef, b.resRef) == 0

proc `cmp`*[T: ResRef](a, b: T): int {.procvar.} =
  # We compare uppercase resrefs, just like NWN does too.
  # This matters for sorting things like "_" versus "A".
  if a.resType != b.resType: return a.resType.int - b.resType.int
  else: return cmpIgnoreCase(a.resRef, b.resRef)

