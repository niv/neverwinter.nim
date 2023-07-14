import std/[streams, strutils, sequtils]
import neverwinter/[nwscript/nwasm, nwscript/nwtestvm, util]

import std/[random, os]
import neverwinter/nwscript/compiler, neverwinter/restype, neverwinter/resdir, neverwinter/resman
randomize()

const
  LangSpecNWTestScript* = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

let rm = newResMan()
rm.add newResDir(".")
rm.add newResDir("tests/scriptcomp")
rm.add newResDir("tests/scriptcomp/corpus")

proc resolveFile(fn: cstring, ty: uint16): cstring {.cdecl.} =
  var buf {.global.}: cstring
  buf = rm.demand(newResolvedResRef $fn & ".nss").readAll
  return buf

var bytecode: string
var debugcode: string

proc writeFile(fn: cstring, resType: uint16, pData: ptr uint8, size: csize_t, bin: bool): int32 {.cdecl.} =
  var data = newString(size)
  copyMem(data[0].addr, pData, size)
  case resType
  of 2010: bytecode = data
  of 2064: debugcode = data
  else: raise newException(ValueError, $resType)

proc compile(file: string) =
  bytecode = ""
  debugcode = ""
  let c = newCompiler(LangSpecNWTestScript, true, writeFile, resolveFile)
  let r = c.compileFile(file)
  doAssert r.code == 0, $r
  doAssert bytecode.len > 0
  doAssert debugCode.len > 0

proc run(file: string)

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


proc run(file: string) =
  let ncs = newStringStream(bytecode)
  vm.run(ncs)

var anyRan = false

for file in walkFiles("tests/scriptcomp/corpus/*.nss"):
  let ff = splitFile(file).name
  echo "Compile: ", ff
  compile(ff)
  echo "Run: ", ff
  run(ff)
  anyRan = true

doAssert anyRan
