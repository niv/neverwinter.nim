import std/[streams, tables]

import shared
import neverwinter/nwscript/compiler
import neverwinter/resman

let args = DOC """
Compile each file in <spec> using the official compiler.

Target artifacts are written to the same directory each source file is in.

When given a directory, all scripts in directory will be compiled.

Usage:
  $0 [options] -c <spec>...
  $USAGE

  -g                          Generate debug symbols
  -y                          Continue processing input files even on error
  -R                          Recurse into subdirectories for each given directory
$OPTRESMAN
"""

type
  State = ref object
    successes, errors, skips: uint
    continueProcessing: bool
    currentOutDir: string
    recurse: bool
    rm: ResMan
    cNSS: CScriptCompiler

const
  LangSpecNWScript* = ("nwscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

var state: State
proc getState(): State

proc resolveFile(fn: cstring, ty: uint16): cstring {.cdecl.} =
  let r = newResRef($fn, ResType ty)
  let rr = r.resolve()
  if not rr.isSome:
    raise newException(IOError, "Not a resolvable resref: " & $r)
  if not getState().rm.contains(rr.unsafeGet):
    return nil

  let dm = getState().rm.demand(rr.unsafeGet)
  if not isNil dm:
    var buf {.global.}: string
    buf = dm.readAll()
    buf.cstring
  else:
    raise newException(IOError, "Failed to demand file: " & $r)

proc writeFile(fn: cstring, resType: uint16, pData: ptr uint8, size: csize_t, bin: bool): int32 {.cdecl.} =
  var resRef = $fn
  resRef.removePrefix("scriptout:")
  let outFile = newResolvedResRef(resRef, ResType resType)
  let str = newFileStream(getState().currentOutDir / $outFile, fmWrite)
  str.writeData(pData, size.int)

proc getState(): State =
  if isNil state:
    new(state)
    state.continueProcessing = args["-y"]
    state.recurse = args["-R"]
    state.rm = newBasicResMan()
    state.cNSS = newCompiler(LangSpecNWScript, args["-g"], writeFile, resolveFile)
  state

proc doCompile(p: string, ignoreUnknown: bool) =
  let parts = splitFile(absolutePath(p))

  doAssert(parts.dir != "")
  getState().currentOutDir = parts.dir

  case parts.ext
  of ".nss":
    # When compiling a file, we add it's contained directory to the search path.
    # This allows resolving includes.
    var d: ResContainer = newResDir(parts.dir)
    getState().rm.add(d)
    # When compiling a single file, we explicitly add it at the very top of the resolve stack.
    # This ensures the RM lookup yields the correct file.
    var c: ResContainer = newResFile(p)
    getState().rm.add(c)
    defer:
      getState().rm.del(d)
      getState().rm.del(c)

    let ret = compileFile(getState().cNSS, parts.name)
    case ret.code
    of 0:
      inc getState().successes
      debug p, ": Success"
    of 623:
      inc getState().skips
      debug p, ": no main (include?)"
    else:
      inc getState().errors
      error p, ": ", ret.str
      if not getState().continueProcessing: quit(1)
  else:
    if not ignoreUnknown:
      raise newException(ValueError, "Don't know how to compile: " & p)

proc doCompileDir(p: string) =

  debug "Walking directory: ", p
  for f in walkDir(p, relative=true, checkdir=true):
    if f.kind == pcDir:
      doCompileDir(p / f.path)
    elif f.kind == pcFile:
      doCompile(p / f.path, true)

for fn in args["<spec>"]:
  if dirExists(fn):
    doCompileDir(fn)
  elif fileExists(fn):
    doCompile(fn, false)
  else:
    raise newException(IOError, "Not found or uknown file: " & fn)

debug format("$# files compiled", getState().successes)
debug format("$# files skipped", getState().skips)
debug format("$# files errored", getState().errors)

if getState().errors > 0:
  quit(1)
