import std/[streams, strutils]
import neverwinter/[nwscript/nwtestvm]

import std/[random, os]
import neverwinter/nwscript/compiler, neverwinter/restype, neverwinter/resdir, neverwinter/resman

randomize()

let rm = newResMan()
rm.add newResDir(".")
rm.add newResDir("tests/scriptcomp")
rm.add newResDir("tests/scriptcomp/corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec
const DebugSymbols = true

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
  doAssert boo, format("[ip=$#,sp=$#] $#", vm.ip, vm.sp, msg)

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

  echo "Running: ", ff
  vm.run newStringSTream(ret.bytecode)
  anyRan = true

doAssert anyRan
