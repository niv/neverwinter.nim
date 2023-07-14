# A laissez-faire, incomplete reimplementation of the game script VM.
# This impl is meant as a test runner.

import std/[streams, strutils, sequtils]
import neverwinter/[nwscript/nwasm, util]

type
  ObjectId* = distinct uint32

const
  ObjectInvalid* = ObjectId 0x7fffffff

# Stack
# ===============

type
  StackKind* = enum
    skInt
    skFloat
    skObject
    skString

  StackElem* = object
    case kind*: StackKind
    of skInt:    intVal*: int32
    of skFloat:  floatVal*: float32
    of skObject: objectVal*: ObjectId
    of skString: stringVal*: string

proc `$`*(e: StackElem): string =
  case e.kind
  of skInt:    format("i=$#", e.intVal)
  of skFloat:  format("f=$#", $e.floatVal)
  of skObject: format("o=0x$#", toHex(e.objectVal.uint32))
  of skString: format("s='$#'", $e.stringVal)

proc `==`*(a, b: StackElem): bool =
  a.kind == b.kind and (
    case a.kind
    of skInt: a.intVal == b.intVal
    of skFloat: a.floatVal == b.floatVal
    of skObject: a.objectVal.uint32 == b.objectVal.uint32
    of skString: a.stringVal == b.stringVal
  )

proc `<=`*(a, b: StackElem): bool =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  case a.kind
  of skInt: a.intVal <= b.intVal
  of skFloat: a.floatVal <= b.floatVal
  of skString: a.stringVal <= b.stringVal
  of skObject: raise newException(ValueError, "Cannot do this on objects")

proc `<`*(a, b: StackElem): bool =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  case a.kind
  of skInt: a.intVal < b.intVal
  of skFloat: a.floatVal < b.floatVal
  of skString: a.stringVal < b.stringVal
  of skObject: raise newException(ValueError, "Cannot do this on objects")

proc `+`*(a, b: StackElem): StackElem =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  result = StackElem(kind: a.kind)
  if a.kind == skInt and b.kind == skInt: result.intVal = a.intVal + b.intVal
  elif a.kind == skString and b.kind == skString: result.stringVal = a.stringVal & b.stringVal
  elif a.kind == skFloat and b.kind == skFloat: result.floatVal = a.floatVal + b.floatVal
  else: doAssert(false, $a & " + " & $b)

proc `-`*(a, b: StackElem): StackElem =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  result = StackElem(kind: a.kind)
  if a.kind == skInt and b.kind == skInt: result.intVal = a.intVal - b.intVal
  else: doAssert(false, $a & " - " & $b)

proc `*`*(a, b: StackElem): StackElem =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  result = StackElem(kind: a.kind)
  if a.kind == skInt and b.kind == skInt: result.intVal = a.intVal * b.intVal
  else: doAssert(false, $a & " * " & $b)

proc `/`*(a, b: StackElem): StackElem =
  if a.kind != b.kind: raise newException(ValueError, "Stack type mismatch: " & $a.kind & "<>" & $b.kind)
  result = StackElem(kind: a.kind)
  if a.kind == skInt and b.kind == skInt: result.intVal = a.intVal div b.intVal
  elif a.kind == skFloat and b.kind == skFloat: result.floatVal = a.floatVal / b.floatVal
  else: doAssert(false, $a & " / " & $b)

# boolean/bitwise ops are implemented inline in VM handlers

# VM
# ===============

type
  CodeAddress*  = Natural
  StackAddress* = Natural
  Cmd*          = Natural
  CmdHandler*   = proc(cmd: Cmd, argc: int)

  VM* = ref object
    ip: CodeAddress
    sp: StackAddress     # 1 = array elem 0; 0 = invalid/none
    bp: StackAddress
    ret: seq[CodeAddress]
    stack: seq[StackElem]
    cmd: seq[CmdHandler]
    # STORE_STATE
    saveIp: CodeAddress
    saveBp, saveSp: StackAddress

func ip*(vm: VM): CodeAddress = vm.ip
func sp*(vm: VM): StackAddress = vm.sp
func bp*(vm: VM): StackAddress = vm.bp

proc push*(vm: VM, e: StackElem) =
  vm.stack.add e
  inc vm.sp

proc pop*(vm: VM): StackElem =
  doAssert vm.sp > 0
  dec vm.sp
  vm.stack.pop

proc pushInt*(vm: VM, v: int32) = vm.push StackElem(kind: skInt, intVal: v)
proc pushIntBool(vm: VM, v: bool) = pushInt(vm, if v: 1 else: 0)
proc pushFloat*(vm: VM, v: float32) = vm.push StackElem(kind: skFloat, floatVal: v)
proc pushString*(vm: VM, v: string) = vm.push StackElem(kind: skString, stringVal: v)
proc pushObject*(vm: VM, v: ObjectId) = vm.push StackElem(kind: skObject, objectVal: v)

proc popInt*(vm: VM): int32 = vm.pop.intVal
proc popIntBool*(vm: VM): bool = vm.popInt.bool
proc popFloat*(vm: VM): float32 = vm.pop.floatVal
proc popString*(vm: VM): string = vm.pop.stringVal
proc popObject*(vm: VM): ObjectId = vm.pop.objectVal

proc printInternals*(vm: VM, prefix = "VM") =
  echo format("$# [size=$#,bp=$#,sp=$#]:", prefix, vm.stack.len, vm.bp, vm.sp)
  for idx, se in vm.stack:
    echo format("   $# [$#] $#", (if idx+1 == vm.sp.int: "=> " else: "   "), idx, se)

proc defineCommand*(vm: VM, cmd: Cmd, cb: CmdHandler) =
  vm.cmd.setLen(max(vm.cmd.len, cmd + 1))
  assert isNil vm.cmd[cmd.int]
  vm.cmd[cmd.int] = cb

proc defineCommand*(vm: VM, cmd: Cmd, cb: proc()) =
  defineCommand vm, cmd, proc (cmd: Cmd, argc: int) = cb()

proc setStackPointer(vm: VM, p: StackAddress) =
  vm.sp = p
  vm.stack.delete(vm.sp.int..<vm.stack.len)

proc clear(vm: VM) =
  vm.stack = @[]
  vm.ret = @[]
  vm.sp = 0
  vm.ip = 0
  vm.bp = 0
  vm.saveIp = 0
  vm.saveBp = 0
  vm.saveSp = 0

proc assign(vm: VM, src, dst: StackAddress) =
  assert src >= 0
  assert dst >= 0
  if dst >= vm.stack.len:
    vm.stack.add vm.stack[src]
    inc vm.sp
  else:
    vm.stack[dst] = vm.stack[src]

proc run(vm: VM, i: Instr) =
  let str = newStringStream(i.extra)

  template NotImplemented() =
    raise newException(Defect, "not impl: " & $i)

  case i.op

  of NO_OPERATION: discard

  of JMP:
    inc vm.ip, unpackExtra[int32](i)
    return
  of JSR:
    vm.ret.add vm.ip + i.len.int32
    inc vm.ip, unpackExtra[int32](i)
    return
  of JZ:
    if vm.popInt == 0:
      inc vm.ip, unpackExtra[int32](i)
      return
  of JNZ:
    if vm.popInt != 0:
      inc vm.ip, unpackExtra[int32](i)
      return
  of RET:
    vm.ip = vm.ret.pop
    return

  of SAVE_BASE_POINTER:
    vm.pushInt vm.bp.int32
    vm.bp = vm.sp
  of RESTORE_BASE_POINTER:
    vm.bp = vm.popInt

  of RUNSTACK_ADD:
    case i.aux
    of TYPE_INTEGER: vm.pushInt(0)
    of TYPE_FLOAT:   vm.pushFloat(0)
    of TYPE_STRING:  vm.pushString("")
    of TYPE_OBJECT:  vm.pushObject(ObjectInvalid)
    else: NotImplemented

  of RUNSTACK_COPY, RUNSTACK_COPY_BASE:
    let stackLoc = (if i.op == RUNSTACK_COPY_BASE: vm.bp else: vm.sp) -
                   (-1 * unpackExtra[int32](i)) shr 2
    let copySize = unpackExtra[int16](i, 4) shr 2

    assert stackLoc >= 0

    for i in 0..<copySize:
      vm.assign(stackLoc + i, vm.sp + i)

  of ASSIGNMENT, ASSIGNMENT_BASE:
    let stackLoc = (if i.op == ASSIGNMENT_BASE: vm.bp else: vm.sp) -
                   (-1 * unpackExtra[int32](i)) shr 2
    let copySize = unpackExtra[int16](i, 4) shr 2

    for i in 0..<copySize:
      vm.assign(vm.sp - copySize + i, stackLoc + i)

  of CONSTANT:
    case i.aux
    of TYPE_INTEGER: vm.pushInt unpackExtra[int32](i)
    of TYPE_FLOAT:   vm.pushFloat unpackExtra[float32](i)
    of TYPE_STRING:  vm.pushString i.extra.substr(2)
    of TYPE_OBJECT:  vm.pushObject unpackExtra[uint32](i).ObjectId
    else: NotImplemented

  of MODIFY_STACK_POINTER:
    let stackLoc = -1 * unpackExtra[int32](i) shr 2
    vm.setStackPointer vm.sp - stackLoc

  of INCREMENT, DECREMENT,
     INCREMENT_BASE, DECREMENT_BASE:
    let stackLoc = (if i.op == INCREMENT_BASE or i.op == DECREMENT_BASE: vm.bp else: vm.sp) -
                   (-1 * unpackExtra[int32](i) shr 2)
    let delta = if i.op == INCREMENT or i.op == INCREMENT_BASE: 1 else: -1
    inc vm.stack[stackLoc].intVal, delta

  of NEGATION:
    case i.aux
    of TYPE_INTEGER: vm.pushInt -1 * vm.popInt
    of TYPE_FLOAT:   vm.pushFloat -1 * vm.popFloat
    else: NotImplemented

  of EQUAL, NOT_EQUAL, LT, GT, LEQ, GEQ:
    let b = vm.pop
    let a = vm.pop
    vm.pushIntBool case i.op
    of EQUAL: a == b
    of NOT_EQUAL: a != b
    of LT: a < b
    of GT: a > b
    of LEQ: a <= b
    of GEQ: a >= b
    else: NotImplemented

  of LOGICAL_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt != 0
    let a = vm.popInt != 0
    vm.pushIntBool a or b
  of LOGICAL_AND:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt != 0
    let a = vm.popInt != 0
    vm.pushIntBool a and b
  of INCLUSIVE_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a or b
  of BOOLEAN_AND:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a and b
  of EXCLUSIVE_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a xor b
  of BOOLEAN_NOT:
    vm.pushIntBool not vm.popIntBool
  of ONES_COMPLEMENT:
    vm.pushInt not vm.popInt
  of SHIFT_LEFT:
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a shl b
  of SHIFT_RIGHT:
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a shr b
  of USHIFT_RIGHT:
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt ashr(a, b)

  of ADD:
    let b = vm.pop
    let a = vm.pop
    vm.push a + b
  of SUB:
    let b = vm.pop
    let a = vm.pop
    vm.push a - b
  of MUL:
    let b = vm.pop
    let a = vm.pop
    vm.push a * b
  of DIV:
    let b = vm.pop
    let a = vm.pop
    vm.push a / b
  of MODULUS:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = vm.popInt
    let a = vm.popInt
    vm.pushInt a mod b

  of DE_STRUCT:
    let sizeOrig = unpackExtra[int16](i)    shr 2
    let start    = unpackExtra[int16](i, 2) shr 2
    let size     = unpackExtra[int16](i, 4) shr 2

    if size + start < sizeOrig:
      vm.sp -= sizeOrig
      vm.sp += size + start
      vm.setStackPointer vm.sp

    if start > 0:
      for i in (vm.sp - size - start)..<(vm.sp-start):
        vm.assign(i + start, i)

      vm.sp -= start
      vm.setStackPointer vm.sp

  of STORE_IP, STORE_STATE:
    vm.saveIp = vm.ip
    if i.op == STORE_STATE:
      vm.saveBp = unpackExtra[int32](i)
      vm.saveSp = unpackExtra[int32](i, 4)

  of EXECUTE_COMMAND:
    let cmd = int unpackExtra[uint16](i)
    let arg = int unpackExtra[uint8](i, 2)
    doAssert cmd < vm.cmd.len
    doAssert not isNil vm.cmd[cmd], "CMD Not implemented: " & $cmd
    vm.cmd[cmd](cmd, arg)

  inc vm.ip, i.len
  assert vm.ip >= 0
  assert vm.sp >= 0
  assert vm.sp <= vm.stack.len

proc run*(vm: VM, io: Stream) =
  ## Run a raw bytecode stream.
  defer: vm.clear()

  if io.peekStr(8) == Header:
    # Transparently support ignoring NCS header
    io.setPosition(io.getPosition() + 8 + 1 + 4)

  let start = io.getPosition()

  vm.ret.add CodeAddress.high

  while true:
    let i = io.readInstr()

    # echo ""
    # echo "Execute: ", i

    # echo format("  Before [size=$#,bp=$#,sp=$#]:", vm.stack.len, vm.bp, vm.sp)
    # for idx, se in vm.stack:
    #   echo format("   $# [$#] $#", (if idx+1 == vm.sp.int: "=> " else: "   "), idx, se)

    vm.run(i)
    if vm.ip == CodeAddress.high:
      # "loader" shim/fake: return, we're done
      break

    if io.getPosition() != start + vm.ip:
      # echo "  Jump: ", io.getPosition(), " -> ", start + vm.ip
      io.setPosition(start + vm.ip)

    # echo format("  After [size=$#,bp=$#,sp=$#]:", vm.stack.len, vm.bp, vm.sp)
    # for idx, se in vm.stack:
    #   echo format("   $# [$#] $#", (if idx+1 == vm.sp.int: "=> " else: "   "), idx, se)

  # StartingCond leaves something on the stack
  # assert vm.sp == 0
  # assert vm.stack.len == 0
