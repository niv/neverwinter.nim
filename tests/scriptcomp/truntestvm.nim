import std/[streams, strutils, random, os, logging]
import neverwinter/nwscript/[nwtestvm, compiler, ndb]
import neverwinter/[restype, resfile, resdir, resman]

randomize()

const SourcePath = currentSourcePath().splitFile().dir

let rm = newResMan()
rm.add newResFile(SourcePath / "nwtestvmscript.nss")
rm.add newResDir(SourcePath / "corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

# Note: This test also exercises the NDB parser.
const DebugSymbols = true

const NCSHeaderSize = 13

var currentFile: string
var currentLines: seq[string]
var currentDebug: NDB

let cNSS = newCompiler(LangSpecNWTestScript, DebugSymbols, rm)

var vm: VM
new(vm)

type VMCommand = enum
  Assert = 0
  IntToString
  Random
  TakeInt
  TakeClosure

vm.defineCommand(Assert.int) do (script: VMScript):
  let boo = script.popIntBool()
  var msg = script.popString()

  # attempt to find the failing line in ndb.
  var loc = ""

  for l in currentDebug.lines:
    if (NCSHeaderSize + script.ip.uint32) in l.bStart..l.bEnd:
      let ext = getResExt(LangSpecNWTestScript.src)
      loc = format("$#.$#:$#: ", currentDebug.files[l.fileNum], ext, l.lineNum)
      if currentFile == currentDebug.files[l.fileNum]:
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

var scriptsRan = 0

for file in walkFiles(SourcePath / "corpus" / "*.nss"):
  let ff = splitFile(file).name

  let expectCode = block:
    var expectStr = readLines(file, 1)[0]
    if expectStr.startsWith("// EXPECT: "):
      expectStr.removePrefix("// EXPECT: ")
      expectStr.parseInt
    else:
      0

  info "Compiling: ", ff
  let ret = cNSS.compileFile(ff)

  doAssert ret.code == expectCode,
    file & " failed to compile: expected " & $expectCode & " got " & $ret.code & " (" & ret.str & ")"

  # If we expected the file not to compile, continue. The expectations are checked above.
  if expectCode != 0:
    info "Compile code ", expectCode, " - expected failure, next"
    inc scriptsRan
    continue

  doAssert ret.bytecode != ""
  doAssert ret.debugcode != ""

  # for Assert()
  currentLines = splitLines(readFile(file))
  currentDebug = parseNdb(newStringStream ret.debugcode)
  currentFile = ff

  var script = newVMScript(vm, ret.bytecode, ff)
  info "Running: ", ff
  run script
  inc scriptsRan

doAssert scriptsRan > 0, "test didn't run any scripts?"
