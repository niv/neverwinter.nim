import std/[streams, strutils, random, os]
import neverwinter/nwscript/[nwtestvm, compiler, ndb]
import neverwinter/[restype, resdir, resman]

randomize()

let rm = newResMan()
rm.add newResDir(".")
rm.add newResDir("tests/scriptcomp")
rm.add newResDir("tests/scriptcomp/corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

# Note: This test also exercises the NDB parser.
const DebugSymbols = true

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

vm.defineCommand(Assert.int) do:
  let boo = vm.popIntBool()
  let msg = vm.popString()
  # attempt to find the failing line in ndb.
  var loc = ""
  var code = ""
  for l in currentDebug.lines:
    if vm.ip.uint32 in l.bStart..<l.bEnd:
      let ext = getResExt(LangSpecNWTestScript.src)
      loc = format("$#.$#:$#", currentDebug.files[l.fileNum], ext, l.lineNum)
      if currentFile == currentDebug.files[l.fileNum]:
        code = currentLines[l.lineNum.int]
      break

  # currentDebug.lines.bStart.bEnd
  doAssert boo, format("[ip=$#,sp=$#] $# (`$#`)", vm.ip, vm.sp, loc, code.strip)

vm.defineCommand(IntToString.int) do:
  vm.pushString $vm.popInt

vm.defineCommand(Random.int) do:
  vm.pushInt rand(vm.popInt).int32

vm.defineCommand(TakeInt.int) do:
  discard vm.popInt

vm.defineCommand(TakeClosure.int) do:
  discard
  # echo "*** CLOSURES NOT IMPLEMENTED: saved data: " &
  #      "ip=", vm.saveIp, " bp=", vm.saveBp, " sp=", vm.saveSp
  # vm.saveIp = 0
  # vm.saveBp = 0
  # vm.saveSp = 0

var anyRan = false

for file in walkFiles("tests/scriptcomp/corpus/*.nss"):
  let ff = splitFile(file).name

  echo "Compiling: ", ff
  let ret = cNSS.compileFile(ff)
  doAssert ret.code == 0, $ret
  doAssert ret.bytecode != ""
  doAssert ret.debugcode != ""

  # for Assert()
  currentLines = splitLines(readFile(file))
  currentDebug = parseNdb(newStringStream ret.debugcode)
  currentFile = ff

  echo "Running: ", ff
  vm.run newStringSTream(ret.bytecode)
  anyRan = true

doAssert anyRan
