# Tests scriptcomp on all nss files in corpus dir

import std/os

import neverwinter/[resman, resdir, resfile, restype, nwscript/compiler]

const
  LangSpecNWScript* = ("nwscript", ResType 2009, ResType 2010, ResType 2064).LangSpec
  DebugSymbols = true

let cwd = currentSourcePath().splitFile().dir

let rm = newResMan()
rm.add newResFile(cwd / "nwscript.nss")
rm.add newResDir(cwd / "corpus")

var resolveFileBuf: string
proc resolveFile(fn: cstring, ty: uint16): cstring {.cdecl.} =
  let r = newResRef($fn, ResType ty)
  let d = rm.demand(r)
  doAssert not isNil d, $r & " failed to resolve"
  resolveFileBuf = d.readAll
  if resolveFileBuf == "": return nil
  return resolveFileBuf.cstring

var wroteBytecode = false
var wroteDebug    = false

proc writeFile(fn: cstring, resType: uint16, pData: ptr uint8, size: csize_t, bin: bool): int32 {.cdecl.} =
  doAssert not isNil pData
  case resType
  of 2010:
    var check = "NCS V1.0B"
    doAssert cmpMem(pData, check[0].addr, check.len) == 0, "does not start with NCS header"
    wroteBytecode = true
  of 2064:
    var check = "NDB V1.0"
    doAssert cmpMem(pData, check[0].addr, check.len) == 0, "does not start with NDB header"
    wroteDebug = true
  else: raise newException(ValueError, "wrote unexpected file " & $fn & "." & $resType)

let cNSS = newCompiler(LangSpecNWScript, DebugSymbols, writeFile, resolveFile)

var anyRan = false
for file in walkFiles(cwd / "corpus" / "*.nss"):
  wroteBytecode = false
  wroteDebug = false
  let ret = cNSS.compileFile(splitFile(file).name)
  doAssert ret == CompileResult (code: 0i32, str: ""), file & " failed to compile: " & ret.str
  doAssert wroteBytecode
  doAssert wroteDebug
  anyRan = true

doAssert anyRan
