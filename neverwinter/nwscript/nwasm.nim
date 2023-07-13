import std/[streams, strutils]

import neverwinter/util

const Header* = "NCS V1.0"

type Opcode* {.pure.} = enum
  ASSIGNMENT            = uint8 0x01
  RUNSTACK_ADD          = 0x02
  RUNSTACK_COPY         = 0x03
  CONSTANT              = 0x04
  EXECUTE_COMMAND       = 0x05
  LOGICAL_AND           = 0x06
  LOGICAL_OR            = 0x07
  INCLUSIVE_OR          = 0x08
  EXCLUSIVE_OR          = 0x09
  BOOLEAN_AND           = 0x0a
  EQUAL                 = 0x0b
  NOT_EQUAL             = 0x0c
  GEQ                   = 0x0d
  GT                    = 0x0e
  LT                    = 0x0f
  LEQ                   = 0x10
  SHIFT_LEFT            = 0x11
  SHIFT_RIGHT           = 0x12
  USHIFT_RIGHT          = 0x13
  ADD                   = 0x14
  SUB                   = 0x15
  MUL                   = 0x16
  DIV                   = 0x17
  MODULUS               = 0x18
  NEGATION              = 0x19
  ONES_COMPLEMENT       = 0x1a
  MODIFY_STACK_POINTER  = 0x1b
  STORE_IP              = 0x1c
  JMP                   = 0x1d
  JSR                   = 0x1e
  JZ                    = 0x1f
  RET                   = 0x20
  DE_STRUCT             = 0x21
  BOOLEAN_NOT           = 0x22
  DECREMENT             = 0x23
  INCREMENT             = 0x24
  JNZ                   = 0x25
  ASSIGNMENT_BASE       = 0x26
  RUNSTACK_COPY_BASE    = 0x27
  DECREMENT_BASE        = 0x28
  INCREMENT_BASE        = 0x29
  SAVE_BASE_POINTER     = 0x2A
  RESTORE_BASE_POINTER  = 0x2B
  STORE_STATE           = 0x2C
  NO_OPERATION          = 0x2D

type Auxcode* {.pure.} = enum
  NONE                      = uint8 0x00
  TYPE_VOID                 = 0x01
  TYPE_COMMAND              = 0x02
  TYPE_INTEGER              = 0x03
  TYPE_FLOAT                = 0x04
  TYPE_STRING               = 0x05
  TYPE_OBJECT               = 0x06
  TYPE_ENGST0               = 0x10
  TYPE_ENGST1               = 0x11
  TYPE_ENGST2               = 0x12
  TYPE_ENGST3               = 0x13
  TYPE_ENGST4               = 0x14
  TYPE_ENGST5               = 0x15
  TYPE_ENGST6               = 0x16
  TYPE_ENGST7               = 0x17
  TYPE_ENGST8               = 0x18
  TYPE_ENGST9               = 0x19
  TYPETYPE_INTEGER_INTEGER  = 0x20
  TYPETYPE_FLOAT_FLOAT      = 0x21
  TYPETYPE_OBJECT_OBJECT    = 0x22
  TYPETYPE_STRING_STRING    = 0x23
  TYPETYPE_STRUCT_STRUCT    = 0x24
  TYPETYPE_INTEGER_FLOAT    = 0x25
  TYPETYPE_FLOAT_INTEGER    = 0x26
  TYPETYPE_ENGST0_ENGST0    = 0x30
  TYPETYPE_ENGST1_ENGST1    = 0x31
  TYPETYPE_ENGST2_ENGST2    = 0x32
  TYPETYPE_ENGST3_ENGST3    = 0x33
  TYPETYPE_ENGST4_ENGST4    = 0x34
  TYPETYPE_ENGST5_ENGST5    = 0x35
  TYPETYPE_ENGST6_ENGST6    = 0x36
  TYPETYPE_ENGST7_ENGST7    = 0x37
  TYPETYPE_ENGST8_ENGST8    = 0x38
  TYPETYPE_ENGST9_ENGST9    = 0x39
  TYPETYPE_VECTOR_VECTOR    = 0x3a
  TYPETYPE_VECTOR_FLOAT     = 0x3b
  TYPETYPE_FLOAT_VECTOR     = 0x3c
  EVAL_INPLACE              = 0x70
  EVAL_POSTPLACE            = 0x71

type
  Instr* = tuple
    op: Opcode
    aux: Auxcode
    extra: string

proc unpackExtra*[T: int16](i: Instr, io: Stream, into: var T) =
  into = io.readInt16().swapEndian()
proc unpackExtra*[T: uint16](i: Instr, io: Stream, into: var T) =
  into = io.readUint16().swapEndian()
proc unpackExtra*[T: int32](i: Instr, io: Stream, into: var T) =
  into = io.readInt32().swapEndian()
proc unpackExtra*[T: uint32](i: Instr, io: Stream, into: var T) =
  into = io.readUint32().swapEndian()

proc unpackExtra*[T](i: Instr, offset = 0): T =
  var io = newStringStream(i.extra)
  io.setPosition(offset)
  unpackExtra(i, io, result)

proc unpackExtra*[T: tuple|object](i: Instr, into: var T) =
  let io = newStringStream(i.extra)
  for k, v in into.fieldPairs:
    unpackExtra(i, io, v)

proc unpackExtra*[T: tuple|object](i: Instr): T =
  unpackExtra(i, result)

func len*(i: Instr): int = 2 + i.extra.len

proc `$`*(i: Instr): string =
  let str = newStringStream(i.extra)
  let extra = case i.op
  of CONSTANT:
    case i.aux
    of TYPE_STRING:           i.extra.substr(2).escape()
    of TYPE_INTEGER:          $str.readInt32().swapEndian()
    of TYPE_OBJECT:           "0x" & toHex str.readInt32().swapEndian()
    of TYPE_FLOAT:            $str.readFloat32().swapEndian()
    of TYPE_ENGST2:           $str.readUInt32().swapEndian() # loc preset
    of TYPE_ENGST7:           i.extra.substr(2).escape() # json
    else: raise newException(Defect, "implement me: " & $i.op & ":" & $i.aux)
  of JZ, JMP, JSR, JNZ:       $str.readInt32().swapEndian()
  of STORE_STATE: $str.readInt32().swapEndian() & ", " & $str.readInt32().swapEndian()
  of MODIFY_STACK_POINTER:    $str.readInt32().swapEndian()
  of EXECUTE_COMMAND:         $str.readUint16().swapEndian() & ", " & $str.readUint8()
  of RUNSTACK_COPY, RUNSTACK_COPY_BASE: $str.readInt32().swapEndian()
  of ASSIGNMENT, ASSIGNMENT_BASE: $str.readInt32().swapEndian() & ", " & $str.readUint16().swapEndian()
  of INCREMENT, DECREMENT, INCREMENT_BASE, DECREMENT_BASE: $str.readInt32().swapEndian()
  of DE_STRUCT: $str.readUint16().swapEndian() & ", " & $str.readUint16().swapEndian() & ", " & $str.readUint16().swapEndian()
  else:
    if i.extra.len > 0:
      raise newException(Defect, "not implemented: " & i.extra.escape() & " for " & $i.op)
    ""
  result = $i.op
  if i.aux != Auxcode.None: result &= ", " & $i.aux
  if extra.len > 0: result &= ", " & extra

func getExtraInstructionSize*(i: Instr, peekStringSize: int = 0): int =
  case i.op
  of CONSTANT:
    case i.aux
    of TYPE_INTEGER: 4  # int32 val
    of TYPE_FLOAT: 4    # float val
    of TYPE_OBJECT: 4   # object_id val
    of TYPE_STRING: 2 + peekStringSize # uint16 strlen, str
    of TYPE_ENGST2: 4   # location preset as a uint32 constant
    of TYPE_ENGST7: 2 + peekStringSize
    else: 0
  of JZ, JMP, JSR, JNZ: 4 # int32 stackLocation
  of STORE_STATE: 4 + 4 # int32 baseStackToSave, int32 stackToSave
  of MODIFY_STACK_POINTER: 4 # int32 stackLocation
  of EXECUTE_COMMAND: 2 + 1 # uint16 command, uint8 param
  of RUNSTACK_COPY, RUNSTACK_COPY_BASE: 4 + 2 # int32 stackLocation, int16 size
  of ASSIGNMENT, ASSIGNMENT_BASE: 4 + 2 # int32 stackLocation, int16 size
  of INCREMENT, DECREMENT, INCREMENT_BASE, DECREMENT_BASE: 4 # stackLocation
  of EQUAL, NOT_EQUAL:
    if i.aux == Auxcode.TYPETYPE_STRUCT_STRUCT: 2 else: 0
  of DE_STRUCT: 2 + 2 + 2 # int16 sizeOrg, sizeComp, size
  else: 0

proc readInstr*(io: Stream): Instr =
  result.op = io.readUint8().Opcode
  result.aux = io.readUint8().Auxcode
  let extraSz = getExtraInstructionSize(result, 0)
  if extraSz > 0:
    let peekStringSize = int io.peekUint16().swapEndian()
    let extraSz = getExtraInstructionSize(result, peekStringSize) # again but with strsz
    result.extra = io.readStrOrErr(extraSz)

proc disAsm*(io: Stream): seq[Instr] =
  result = newSeq[Instr]()

  try:
    if io.peekStr(8) == Header:
      # Transparently support ignoring NCS header
      io.setPosition(io.getPosition() + 8 + 1 + 4)
  except IOError: discard

  while not io.atEnd:
    result.add readInstr(io)

proc asmToStr*(ii: seq[Instr], commentCb: proc(i: Instr, offset: int): string = nil): string =
  var offset = 0
  for idx, c in ii:
    let comment = if not isNil commentCb: commentCb(c, offset) else: ""
    result &=
      align($(offset), 6) & "  " &
      alignLeft($c, 40) &
      (if comment.len > 0:("# " & comment) else: "") &
      "\n"

    inc offset, c.len
