# A laissez-faire, incomplete reimplementation of the game script VM.
# This impl is meant as a test runner.

# Add -d:tracetestvm to emit debug more verbose logs to logging framework.

import std/[streams, strutils, sequtils, logging]
import neverwinter/[nwscript/nwasm, util]

type
  ObjectId* = uint32

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
  of skInt:    format("$#", e.intVal)
  of skFloat:  format("$#", $e.floatVal)
  of skObject: format("0x$#", toHex(e.objectVal))
  of skString: format("'$#'", $e.stringVal.substr(0, 10))

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
  CmdHandler*   = proc(script: VMScript, cmd: Cmd, argc: int)

  VM* = ref object
    cmd: seq[CmdHandler]

  VMScript* = ref object
    vm*: VM
    label: string
    code: Stream
    ip: CodeAddress
    sp: StackAddress     # 1 = array elem 0; 0 = invalid/none
    bp: StackAddress
    ret: seq[CodeAddress]
    stack: seq[StackElem]

    # STORE_STATE
    saveIp: CodeAddress
    saveBp, saveSp: StackAddress

proc stackStr*(script: VMScript): string =
  for idx, elem in script.stack:
    if idx == script.bp - 1: result &= "^"
    if idx == script.sp - 1: result &= "*"
    result &= $elem
    if idx < script.stack.len: result &= " "
  # script.stack.mapIt($it).join(" ")

proc `$`*(script: VMScript): string =
  format("Script[$#@$#]", script.label, script.ip)

func ip*(script: VMScript): CodeAddress = script.ip
func sp*(script: VMScript): StackAddress = script.sp
func bp*(script: VMScript): StackAddress = script.bp

func saveIp*(script: VMScript): CodeAddress = script.saveIp
func saveSp*(script: VMScript): StackAddress = script.saveSp
func saveBp*(script: VMScript): StackAddress = script.saveBp

proc push*(script: VMScript, e: StackElem) =
  script.stack.add e
  inc script.sp

proc pop*(script: VMScript): StackElem =
  doAssert script.sp > 0
  dec script.sp
  script.stack.pop

proc pushInt*(script: VMScript, v: int32) = script.push StackElem(kind: skInt, intVal: v)
proc pushIntBool(script: VMScript, v: bool) = pushInt(script, if v: 1 else: 0)
proc pushFloat*(script: VMScript, v: float32) = script.push StackElem(kind: skFloat, floatVal: v)
proc pushString*(script: VMScript, v: string) = script.push StackElem(kind: skString, stringVal: v)
proc pushObject*(script: VMScript, v: ObjectId) = script.push StackElem(kind: skObject, objectVal: v)

proc popInt*(script: VMScript): int32 = script.pop.intVal
proc popIntBool*(script: VMScript): bool = script.popInt.bool
proc popFloat*(script: VMScript): float32 = script.pop.floatVal
proc popString*(script: VMScript): string = script.pop.stringVal
proc popObject*(script: VMScript): ObjectId = script.pop.objectVal

proc defineCommand*(vm: VM, cmd: Cmd, cb: CmdHandler) =
  vm.cmd.setLen(max(vm.cmd.len, cmd + 1))
  assert isNil vm.cmd[cmd.int]
  vm.cmd[cmd.int] = cb

proc defineCommand*(vm: VM, cmd: Cmd, cb: proc(script: VMScript)) =
  defineCommand vm, cmd, proc (script: VMScript, cmd: Cmd, argc: int) = cb(script)

proc setStackPointer*(script: VMScript, p: StackAddress) =
  script.sp = p
  script.stack.delete(script.sp.int..<script.stack.len)

proc assign(script: VMScript, src, dst: StackAddress) =
  assert src >= 0
  assert dst >= 0
  if dst >= script.stack.len:
    script.stack.add script.stack[src]
    inc script.sp
  else:
    script.stack[dst] = script.stack[src]

proc run(vm: VM, script: VMScript, i: Instr) =
  template NotImplemented() =
    raise newException(Defect, "not impl: " & $i)

  case i.op

  of NO_OPERATION: discard

  of JMP:
    inc script.ip, unpackExtra[int32](i)
    return
  of JSR:
    script.ret.add script.ip + i.len.int32
    inc script.ip, unpackExtra[int32](i)
    return
  of JZ:
    if script.popInt == 0:
      inc script.ip, unpackExtra[int32](i)
      return
  of JNZ:
    if script.popInt != 0:
      inc script.ip, unpackExtra[int32](i)
      return
  of RET:
    script.ip = script.ret.pop
    return

  of SAVE_BASE_POINTER:
    script.pushInt script.bp.int32
    script.bp = script.sp
  of RESTORE_BASE_POINTER:
    script.bp = script.popInt

  of RUNSTACK_ADD:
    case i.aux
    of TYPE_INTEGER: script.pushInt(0)
    of TYPE_FLOAT:   script.pushFloat(0)
    of TYPE_STRING:  script.pushString("")
    of TYPE_OBJECT:  script.pushObject(0)
    else: NotImplemented

  of RUNSTACK_COPY, RUNSTACK_COPY_BASE:
    let stackLoc = (if i.op == RUNSTACK_COPY_BASE: script.bp else: script.sp) -
                   (-1 * unpackExtra[int32](i)) shr 2
    let copySize = unpackExtra[int16](i, 4) shr 2

    assert stackLoc >= 0

    for i in 0..<copySize:
      script.assign(stackLoc + i, script.sp + i)

  of ASSIGNMENT, ASSIGNMENT_BASE:
    let stackLoc = (if i.op == ASSIGNMENT_BASE: script.bp else: script.sp) -
                   (-1 * unpackExtra[int32](i)) shr 2
    let copySize = unpackExtra[int16](i, 4) shr 2

    for i in 0..<copySize:
      script.assign(script.sp - copySize + i, stackLoc + i)

  of CONSTANT:
    case i.aux
    of TYPE_INTEGER: script.pushInt unpackExtra[int32](i)
    of TYPE_FLOAT:   script.pushFloat unpackExtra[float32](i)
    of TYPE_STRING:  script.pushString i.extra.substr(2)
    of TYPE_OBJECT:  script.pushObject unpackExtra[uint32](i)
    else: NotImplemented

  of MODIFY_STACK_POINTER:
    let stackLoc = -1 * unpackExtra[int32](i) shr 2
    script.setStackPointer script.sp - stackLoc

  of INCREMENT, DECREMENT,
     INCREMENT_BASE, DECREMENT_BASE:
    let stackLoc = (if i.op == INCREMENT_BASE or i.op == DECREMENT_BASE: script.bp else: script.sp) -
                   (-1 * unpackExtra[int32](i) shr 2)
    let delta = if i.op == INCREMENT or i.op == INCREMENT_BASE: 1 else: -1
    inc script.stack[stackLoc].intVal, delta

  of NEGATION:
    case i.aux
    of TYPE_INTEGER: script.pushInt -1 * script.popInt
    of TYPE_FLOAT:   script.pushFloat -1 * script.popFloat
    else: NotImplemented

  of EQUAL, NOT_EQUAL, LT, GT, LEQ, GEQ:
    let b = script.pop
    let a = script.pop
    script.pushIntBool case i.op
    of EQUAL: a == b
    of NOT_EQUAL: a != b
    of LT: a < b
    of GT: a > b
    of LEQ: a <= b
    of GEQ: a >= b
    else: NotImplemented

  of LOGICAL_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt != 0
    let a = script.popInt != 0
    script.pushIntBool a or b
  of LOGICAL_AND:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt != 0
    let a = script.popInt != 0
    script.pushIntBool a and b
  of INCLUSIVE_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt
    let a = script.popInt
    script.pushInt a or b
  of BOOLEAN_AND:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt
    let a = script.popInt
    script.pushInt a and b
  of EXCLUSIVE_OR:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt
    let a = script.popInt
    script.pushInt a xor b
  of BOOLEAN_NOT:
    script.pushIntBool not script.popIntBool
  of ONES_COMPLEMENT:
    script.pushInt not script.popInt
  of SHIFT_LEFT:
    let b = script.popInt
    let a = script.popInt
    script.pushInt a shl b
  of SHIFT_RIGHT:
    let b = script.popInt
    let a = script.popInt
    script.pushInt a shr b
  of USHIFT_RIGHT:
    let b = script.popInt
    let a = script.popInt
    script.pushInt ashr(a, b)

  of ADD:
    let b = script.pop
    let a = script.pop
    script.push a + b
  of SUB:
    let b = script.pop
    let a = script.pop
    script.push a - b
  of MUL:
    let b = script.pop
    let a = script.pop
    script.push a * b
  of DIV:
    let b = script.pop
    let a = script.pop
    script.push a / b
  of MODULUS:
    doAssert(i.aux == TYPETYPE_INTEGER_INTEGER)
    let b = script.popInt
    let a = script.popInt
    script.pushInt a mod b

  of DE_STRUCT:
    let sizeOrig = unpackExtra[int16](i)    shr 2
    let start    = unpackExtra[int16](i, 2) shr 2
    let size     = unpackExtra[int16](i, 4) shr 2

    if size + start < sizeOrig:
      script.sp -= sizeOrig
      script.sp += size + start
      script.setStackPointer script.sp

    if start > 0:
      for i in (script.sp - size - start)..<(script.sp-start):
        script.assign(i + start, i)

      script.sp -= start
      script.setStackPointer script.sp

  of STORE_IP, STORE_STATE:
    script.saveIp = script.ip + i.aux.CodeAddress
    if i.op == STORE_STATE:
      script.saveBp = unpackExtra[int32](i)
      script.saveSp = unpackExtra[int32](i, 4)

  of EXECUTE_COMMAND:
    let cmd = int unpackExtra[uint16](i)
    let arg = int unpackExtra[uint8](i, 2)
    doAssert cmd < vm.cmd.len, "CMD not implemented: " & $cmd
    doAssert not isNil vm.cmd[cmd], "CMD Not implemented: " & $cmd
    vm.cmd[cmd](script, cmd, arg)

  inc script.ip, i.len
  assert script.ip >= 0
  assert script.sp >= 0
  assert script.sp <= script.stack.len

proc newVMScript*(vm: VM, bytecode: string, label = "(anon)"): VMScript =
  new(result)
  result.label = label
  result.vm = vm

  # We copy the input data, stripping off the initial bytes.
  result.code = newStringStream(
    if bytecode.startsWith(Header): bytecode.substr(13)
    else: bytecode)

template trace(args: varargs[string, `$`]) =
  when defined(tracetestvm):
    debug args

proc run*(script: VMScript) =
  ## Run the given script at the current position.
  ## We expect to RET at some point, so we push the ret code on the stack.

  doAssert script.ret.len == 0, "In the middle of some execution context??"
  script.ret.add CodeAddress.high

  script.code.setPosition(script.ip)

  while true:
    let i = script.code.readInstr()

    trace script, " executing: ", i
    trace script, "   stack: ", script.stackStr

    # VM executes single instruction
    script.vm.run(script, i)

    if script.ip == CodeAddress.high:
      # "loader" shim/fake: return, we're done
      break

    trace script, "   after: ", script.stackStr

    if script.code.getPosition() != script.ip:
      trace script, " jump: ", script.code.getPosition(), " -> ", script.ip
      script.code.setPosition(script.ip)

  # StartingCond leaves something on the stack
  # assert vm.sp == 0
  # assert vm.stack.len == 0
