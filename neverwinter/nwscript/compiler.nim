{.passL: "-lstdc++".}
const cppFlags = "-std=c++14"
when defined(mingw):
  {.passL: "-static".}
{.compile("native/exostring.cpp", cppFlags).}
{.compile("native/scriptcompcore.cpp", cppFlags).}
{.compile("native/scriptcomplexical.cpp", cppFlags).}
{.compile("native/scriptcompparsetree.cpp", cppFlags).}
{.compile("native/scriptcompidentspec.cpp", cppFlags).}
{.compile("native/scriptcompfinalcode.cpp", cppFlags).}
{.compile("compilerapi.cpp", cppFlags).}

import std/[tables, strutils, logging, enumutils, setutils]

import neverwinter/[resman, restype]

type
  CScriptCompiler = distinct pointer

  # Must be threadsafe; you must throw if resolving fails.
  Resolver* = proc(fn: string, ty: ResType): string {.gcsafe.}

  ScriptCompiler* = ref object of RootObj
    lang: LangSpec
    compiler: CScriptCompiler
    resman: ResMan     # Can be nil for compilers that have external resolver funcs.
    resolver: Resolver # Can be nil if data will be sourced from resman.

  LangSpec* = tuple
    lang: string
    src, bin, dbg: ResType

  ResManWriteToFile = proc (fn: cstring, resType: uint16, pData: ptr uint8, size: csize_t, bin: bool): int32 {.cdecl.}
  ResManLoadScriptSourceFile = proc (fn: cstring, resType: uint16): bool {.cdecl.}

  CompileResult* = tuple
    code: int32
    str: string
    bytecode: string  # "" if none written
    debugcode: string # "" if none written

type
  # Needs to match scriptcomp.h
  OptimizationFlag* {.pure.} = enum
    RemoveDeadCode       = 0x1
    FoldConstants        = 0x2
    MeldInstructions     = 0x4
    RemoveDeadBranches   = 0x8

const
  OptimizationFlagsO0* = {}
  OptimizationFlagsO2* = fullSet(OptimizationFlag)

proc scriptCompApiNewCompiler(
  src, bin, dbt: cint,
  writer: ResManWriteToFile,
  resolver: ResManLoadScriptSourceFile
): CScriptCompiler {.importc.}

proc scriptCompApiInitCompiler(
  instance: CScriptCompiler,
  lang: cstring,
  writeDebug: bool,
  maxIncludeDepth: cint,
  graphvizOut: cstring,
  outputAlias: cstring
) {.importc.}

proc scriptCompApiCompileFile(instance: CScriptCompiler, fn: cstring): tuple[code: int32, str: cstring] {.importc.}

proc scriptCompApiDeliverFile(instance: CScriptCompiler, data: cstring, size: csize_t) {.importc.}

# Since the C level API calls back for each invocation, we need to cache the
# currently-calling compiler instance here. This makes all procs threadsafe, as long
# as they're using separate compiler instances.
var currentCompilerInstance {.threadvar.}: ScriptCompiler
var currentCompileResults {.threadvar.}: CompileResult

proc writeFileInMem(fn: cstring, resType: uint16, pData: ptr uint8, size: csize_t, bin: bool): int32 {.cdecl.} =
  # Builtin callback that will fill in currentCompileResults. Not meant to be exposed to user code.
  assert not isNil currentCompilerInstance
  var data = newString(size)
  copyMem(data[0].addr, pData, size)
  if resType == currentCompilerInstance.lang.bin.uint16:
    currentCompileResults.bytecode = data
  elif resType == currentCompilerInstance.lang.dbg.uint16:
    currentCompileResults.debugcode = data
  else:
    error "Failed to map writeFileInMem restype to actual payload: ", resType
    return 1
  return 0

proc resolveFileResMan(fn: cstring, ty: uint16): bool {.cdecl.} =
  # Builtin callback that will invoke the provided resman instance in a thread and exception safe manner.
  # Not meant to be exposed to user code.
  assert not isNil currentCompilerInstance
  try:
    let r = newResRef($fn, ResType ty)
    let d = currentCompilerInstance.resman.demand(r)
    doAssert not isNil d, $r & " failed to resolve"
    let resolveFileBuf = d.readAll
    if resolveFileBuf == "": return false
    scriptCompApiDeliverFile(currentCompilerInstance.compiler,
      resolveFileBuf.cstring, resolveFileBuf.len.csize_t)
    return true
  except:
    # Must not throw back to C
    error "Failed to resolve ", $fn, ".", $ty, ":", getCurrentExceptionMsg()
    return false

proc resolveFileInMem(fn: cstring, ty: uint16): bool {.cdecl.} =
  # Builtin callback that will invoke the provided resolver cb in a thread and exception safe manner.
  # Not meant to be exposed to user code.
  assert not isNil currentCompilerInstance
  try:
    let resolveFileBuf = currentCompilerInstance.resolver($fn, ResType ty)
    scriptCompApiDeliverFile(currentCompilerInstance.compiler,
      resolveFileBuf.cstring, resolveFileBuf.len.csize_t)
    return true
  except:
    # Must not throw back to C
    error "Failed to resolve ", $fn, ".", $ty, ":", getCurrentExceptionMsg()
    return false

proc newCompiler*(
    lang: LangSpec,
    writeDebug: bool,
    resolver: Resolver,
    maxIncludeDepth: int = 16,
    graphvizOut: string = ""
): ScriptCompiler =
  ## Instance a new compiler, which will read data by calling resolver.
  ## Any compilation results are returned by the respective functions.

  new(result)
  result.lang = lang
  result.resolver = resolver

  currentCompilerInstance = result
  defer: currentCompilerInstance = nil

  result.compiler = scriptCompApiNewCompiler(
    lang.src.cint, lang.bin.cint, lang.dbg.cint,
    writeFileInMem,
    resolveFileInMem,
  )

  scriptCompApiInitCompiler(
    result.compiler,
    lang.lang.cstring,
    writeDebug,
    maxIncludeDepth.cint,
    graphvizOut.cstring,
    "scriptout"
  )

proc newCompiler*(
    lang: LangSpec,
    writeDebug: bool,
    resman: ResMan,
    maxIncludeDepth: int = 16,
    graphvizOut: string = ""
): ScriptCompiler =
  ## Instance a new compiler, which will read data from the ResMan you give it.
  ## Any compilation results are returned by the respective functions.

  new(result)
  result.lang = lang
  result.resman = resman

  currentCompilerInstance = result
  defer: currentCompilerInstance = nil

  result.compiler = scriptCompApiNewCompiler(
    lang.src.cint, lang.bin.cint, lang.dbg.cint,
    writeFileInMem,
    resolveFileResMan
  )

  scriptCompApiInitCompiler(
    result.compiler,
    lang.lang.cstring,
    writeDebug,
    maxIncludeDepth.cint,
    graphvizOut.cstring,
    "scriptout"
  )

proc compileFile*(instance: ScriptCompiler, fn: string): CompileResult =
  ## Compile the given file (resref+ext), which will be queried from resman or the resolver respectively.
  ## Will return the result, and bytecode if ret==0. Will return debugcode only if requested, otherwise "".
  currentCompilerInstance = instance
  defer: currentCompilerInstance = nil

  assert fn != ""
  assert currentCompileResults.bytecode == ""
  assert currentCompileResults.debugcode == ""

  let q = scriptCompApiCompileFile(instance.compiler, fn.cstring)

  swap(result, currentCompileResults)
  result.code = q.code * -1
  result.str  = strip $(q.str)

proc scriptCompApiGetOptimizationFlags(instance: CScriptCompiler): uint32 {.importc.}
proc scriptCompApiSetOptimizationFlags(instance: CScriptCompiler, flags: uint32) {.importc.}

proc getOptimizations*(instance: ScriptCompiler): set[OptimizationFlag] =
  let val = scriptCompApiGetOptimizationFlags(instance.compiler)
  for check in OptimizationFlag:
    if (val and check.uint32) > 0:
      result.incl check

proc setOptimizations*(instance: ScriptCompiler, opt: set[OptimizationFlag]) =
  var optVal: uint32
  for v in opt: optVal = optval or v.uint32
  scriptCompApiSetOptimizationFlags(instance.compiler, optVal)

proc scriptCompApiSetGenerateDebuggerOutput(instance: CScriptCompiler, state: uint32) {.importc.}

proc setGenerateDebuggerOutput*(instance: ScriptCompiler, state: bool) =
  scriptCompApiSetGenerateDebuggerOutput(instance.compiler, if state: 1 else: 0)
