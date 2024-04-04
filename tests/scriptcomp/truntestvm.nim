import std/[streams, strutils, random, os, logging, options, pegs]
import neverwinter/nwscript/[nwtestvm, compiler, ndb]
import neverwinter/[restype, resfile, resdir, resman]

randomize()

const SourcePath = currentSourcePath().splitFile().dir

let rm = newResMan()
rm.add newResFile(SourcePath / "nwtestvmscript.nss")
rm.add newResDir(SourcePath / "corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

const NCSHeaderSize = 13

var currentFile: string
var currentLines: seq[string]
var currentDebug: Option[NDB]

let cNSS = newCompiler(LangSpecNWTestScript, true, rm)

var vm: VM
new(vm)

type VMCommand = enum
  Assert = 0
  IntToString
  Random
  TakeInt
  TakeClosure
  PegMatch

vm.defineCommand(Assert.int) do (script: VMScript):
  let boo = script.popIntBool()
  var msg = script.popString()

  # attempt to find the failing line in ndb.
  var loc = ""

  if currentDebug.isSome:
    var debug = currentDebug.get()
    for l in debug.lines:
      if (NCSHeaderSize + script.ip.uint32) in l.bStart..l.bEnd:
        let ext = getResExt(LangSpecNWTestScript.src)
        loc = format("$#.$#:$#: ", debug.files[l.fileNum], ext, l.lineNum)
        if currentFile == debug.files[l.fileNum]:
          msg = msg & " (`" & currentLines[l.lineNum.int - 1].strip & "`)"
        break

  doAssert boo, format("[ip=$#,sp=$#] $#$#", script.ip, script.sp, loc, msg)

vm.defineCommand(IntToString.int) do (script: VMScript):
  script.pushString $script.popInt

vm.defineCommand(Random.int) do (script: VMScript):
  script.pushInt rand(script.popInt).int32

vm.defineCommand(TakeInt.int) do (script: VMScript):
  discard script.popInt

vm.defineCommand(TakeClosure.int) do (script: VMScript):
  discard

vm.defineCommand(PegMatch.int) do (script: VMScript):
  let test    = script.popString
  let pattern = peg script.popString
  script.pushInt if test.match(pattern): 1 else: 0

proc testFileSingle(file: string, debugSymbols: bool, optFlags: set[OptimizationFlag]) =
  let ff = splitFile(file).name

  currentLines = splitLines(readFile(file))
  currentFile  = ff
  currentDebug = none(NDB)

  let expectCode = block:
    var expectStr = readLines(file, 1)[0]
    if expectStr.startsWith("// EXPECT: "):
      expectStr.removePrefix("// EXPECT: ")
      expectStr.parseInt
    else:
      0

  info format("Compiling $# [debug: $#, opt: $#]", ff, debugSymbols, optFlags)
  setGenerateDebuggerOutput(cNSS, debugSymbols)
  setOptimizations(cNSS, optFlags)
  let ret = cNSS.compileFile(ff)

  doAssert ret.code == expectCode,
    file & " failed to compile: expected " & $expectCode & " got " & $ret.code & " (" & ret.str & ")"

  # If we expected the file not to compile, continue. The expectations are checked above.
  if expectCode != 0:
    info "Compile code ", expectCode, " - expected failure, next"
    return

  doAssert ret.bytecode != ""

  if debugSymbols:
    doAssert ret.debugcode != "", "expected debug output, but none was generated"

    # for Assert()
    currentDebug = some parseNdb(newStringStream ret.debugcode)

  var script = newVMScript(vm, ret.bytecode, ff)
  info "Running: ", ff
  run script

# =======

var scriptsRan = 0

for optFlags in [OptimizationFlagsO0, OptimizationFlagsO2]:
  for dbg in [true, false]:
    for file in walkFiles(SourcePath / "corpus" / "*.nss"):
      testFileSingle(file, dbg, optFlags)
      inc scriptsRan

doAssert scriptsRan > 0, "test didn't run any scripts?"
info scriptsRan, " tests completed OK"
