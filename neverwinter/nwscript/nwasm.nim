import std/[streams, strutils, typetraits, enumutils, tables]

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

const
  OpAuxSep = "."

  OpcodeToCanonical = {
    ASSIGNMENT:                "CPDOWNSP",
    RUNSTACK_ADD:              "RSADD",
    RUNSTACK_COPY:             "CPTOPSP",
    CONSTANT:                  "CONST",
    EXECUTE_COMMAND:           "ACTION",
    LOGICAL_AND:               "LOGAND",
    LOGICAL_OR:                "LOGOR",
    INCLUSIVE_OR:              "INCOR",
    EXCLUSIVE_OR:              "EXCOR",
    BOOLEAN_AND:               "BOOLAND",
    EQUAL:                     "EQUAL",
    NOT_EQUAL:                 "NEQUAL",
    GEQ:                       "GEQ",
    GT:                        "GT",
    LT:                        "LT",
    LEQ:                       "LEQ",
    SHIFT_LEFT:                "SHLEFT",
    SHIFT_RIGHT:               "SHRIGHT",
    USHIFT_RIGHT:              "USHRIGHT",
    ADD:                       "ADD",
    SUB:                       "SUB",
    MUL:                       "MUL",
    DIV:                       "DIV",
    MODULUS:                   "MOD",
    NEGATION:                  "NEG",
    ONES_COMPLEMENT:           "COMP",
    MODIFY_STACK_POINTER:      "MOVSP",
    STORE_IP:                  "STOREIP",
    JMP:                       "JMP",
    JSR:                       "JSR",
    JZ:                        "JZ",
    RET:                       "RET",
    DE_STRUCT:                 "DESTRUCT",
    BOOLEAN_NOT:               "NOT",
    DECREMENT:                 "DECSP",
    INCREMENT:                 "INCSP",
    JNZ:                       "JNZ",
    ASSIGNMENT_BASE:           "CPDOWNBP",
    RUNSTACK_COPY_BASE:        "CPTOPBP",
    DECREMENT_BASE:            "DECBP",
    INCREMENT_BASE:            "INCBP",
    SAVE_BASE_POINTER:         "SAVEBP",
    RESTORE_BASE_POINTER:      "RESTOREBP",
    STORE_STATE:               "STORESTATE",
    NO_OPERATION:              "NOP",
  }.toOrderedTable

  AuxcodeToCanonical = {
    TYPE_INTEGER:              "I",
    TYPE_FLOAT:                "F",
    TYPE_STRING:               "S",
    TYPE_OBJECT:               "O",
    TYPE_ENGST0:               "E0",
    TYPE_ENGST1:               "E1",
    TYPE_ENGST2:               "E2",
    TYPE_ENGST3:               "E3",
    TYPE_ENGST4:               "E4",
    TYPE_ENGST5:               "E5",
    TYPE_ENGST6:               "E6",
    TYPE_ENGST7:               "E7",
    TYPE_ENGST8:               "E8",
    TYPE_ENGST9:               "E9",
    TYPETYPE_INTEGER_INTEGER:  "II",
    TYPETYPE_FLOAT_FLOAT:      "FF",
    TYPETYPE_OBJECT_OBJECT:    "OO",
    TYPETYPE_STRING_STRING:    "SS",
    TYPETYPE_STRUCT_STRUCT:    "TT",
    TYPETYPE_INTEGER_FLOAT:    "IF",
    TYPETYPE_FLOAT_INTEGER:    "FI",
    TYPETYPE_ENGST0_ENGST0:    "E0E0",
    TYPETYPE_ENGST1_ENGST1:    "E1E1",
    TYPETYPE_ENGST2_ENGST2:    "E2E2",
    TYPETYPE_ENGST3_ENGST3:    "E3E3",
    TYPETYPE_ENGST4_ENGST4:    "E4E4",
    TYPETYPE_ENGST5_ENGST5:    "E5E5",
    TYPETYPE_ENGST6_ENGST6:    "E6E6",
    TYPETYPE_ENGST7_ENGST7:    "E7E7",
    TYPETYPE_ENGST8_ENGST8:    "E8E8",
    TYPETYPE_ENGST9_ENGST9:    "E9E9",
    TYPETYPE_VECTOR_VECTOR:    "VV",
    TYPETYPE_VECTOR_FLOAT:     "VF",
    TYPETYPE_FLOAT_VECTOR:     "FV",
  }.toOrderedTable

static:
  # This makes sure that adding new op/auxcodes also introduces them on the name LUTs
  doAssert OpcodeToCanonical.len == Opcode.enumLen
  for k in Opcode: doAssert OpcodeToCanonical.contains(k)
  doAssert AuxcodeToCanonical.len == Auxcode.enumLen - 5
  for k in Auxcode:
    if not(k in [NONE, TYPE_VOID, TYPE_COMMAND, EVAL_INPLACE, EVAL_POSTPLACE]):
      doAssert AuxcodeToCanonical.contains(k)

proc canonicalName*(i: Instr, internal: bool = false): string =
  if internal:
    result &= $i.op & OpAuxSep & $i.aux

  else:
    result &= OpcodeToCanonical[i.op]
    if AuxcodeToCanonical.contains(i.aux):
      result &= OpAuxSep & AuxcodeToCanonical[i.aux]

proc `$`*(i: Instr): string =
  i.canonicalName

proc unpackExtra*[T: int8](i: Instr, io: Stream, into: var T) =
  into = io.readOnt8()
proc unpackExtra*[T: int16](i: Instr, io: Stream, into: var T) =
  into = io.readInt16().swapEndian()
proc unpackExtra*[T: uint8](i: Instr, io: Stream, into: var T) =
  into = io.readUint8()
proc unpackExtra*[T: uint16](i: Instr, io: Stream, into: var T) =
  into = io.readUint16().swapEndian()
proc unpackExtra*[T: int32](i: Instr, io: Stream, into: var T) =
  into = io.readInt32().swapEndian()
proc unpackExtra*[T: uint32](i: Instr, io: Stream, into: var T) =
  into = io.readUint32().swapEndian()
proc unpackExtra*[T: float32](i: Instr, io: Stream, into: var T) =
  into = io.readFloat32().swapEndian()

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

proc extraStr*(i: Instr, maxStringLength: Natural = 15): string =
  let str = newStringStream(i.extra)
  case i.op
  of CONSTANT:
    case i.aux
    of TYPE_STRING:           i.extra.substr(2, maxStringLength).escape() &
                              (if i.extra.len > maxStringLength + 2: ".." & $(i.extra.len - 2) else: "")
    of TYPE_INTEGER:          $str.readInt32().swapEndian()
    of TYPE_OBJECT:           "0x" & toHex str.readInt32().swapEndian()
    of TYPE_FLOAT:            formatFloat(str.readFloat32().swapEndian(), precision = -1)
    of TYPE_ENGST2:           $str.readUInt32().swapEndian() # loc preset
    of TYPE_ENGST7:           i.extra.substr(2).escape() # json
    else: raise newException(Defect, "implement me: " & $i.op & ":" & $i.aux)
  of JZ, JMP, JSR, JNZ:       $str.readInt32().swapEndian()
  of STORE_STATE: $str.readInt32().swapEndian() & ", " & $str.readInt32().swapEndian()
  of MODIFY_STACK_POINTER:    $str.readInt32().swapEndian()
  of EXECUTE_COMMAND:         $str.readUint16().swapEndian() & ", " & $str.readUint8()
  of RUNSTACK_COPY, RUNSTACK_COPY_BASE: $str.readInt32().swapEndian() & ", " & $str.readInt16().swapEndian()
  of ASSIGNMENT, ASSIGNMENT_BASE: $str.readInt32().swapEndian() & ", " & $str.readUint16().swapEndian()
  of INCREMENT, DECREMENT, INCREMENT_BASE, DECREMENT_BASE: $str.readInt32().swapEndian()
  of DE_STRUCT: $str.readUint16().swapEndian() & ", " & $str.readUint16().swapEndian() & ", " & $str.readUint16().swapEndian()
  else:
    if i.extra.len > 0:
      raise newException(Defect, "not implemented: " & i.extra.escape() & " for " & $i.op)
    ""

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
