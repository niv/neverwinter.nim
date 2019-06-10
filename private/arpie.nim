# A static/template-based network streams serializer/deserializer for tuples.
# Can be used, for example, to map network packets to data structures.
# Or file data.

import streams, typetraits
export streams

type
  ArpieType* = (tuple | object)

  SerializableTypes* =
    uint8 | int8 |
    uint16 | int16 |
    uint32 | int32 |
    uint64 | int64 |
    SizePrefixedSeq |
    SizePrefixedString |
    StaticValue

  # Makes no sense to have negative size prefixes, right?
  ValidSizePrefixes* = uint32 | uint16 | uint8

  # A seq prefixed with a size-able type, reading n elements.
  SizePrefixedSeq*[PrefixType: ValidSizePrefixes, Elem] = seq[Elem]

  # A static, fixed-size byte buffer.
  StaticValue*[T: static[string]] = distinct string

  # A string prefixed with a size value
  SizePrefixedString*[PrefixType: ValidSizePrefixes] = string

  # A set[] type thing.
  SizePrefixedSet*[Size] = set[Size]

  # A value that is silently dropped when reading.
  DiscardValue*[T] = distinct T

  # EnumValue*[Size, T] = concept c
  #   c.type is enum

  # A boolean, converted from a int of the given width.
  # BoolValue*[T: Natural] = bool

  # Width bits serialized to nearest-byte.
  # Bitfield[Width] = TODO

proc `==`*[T](a, b: StaticValue[T]): bool = true # im a hack
# proc `$`*[T](t: StaticValue[T]): string = T.string
# proc `$`*[T](t: SizePrefixedString[T]): string = t.string

# converter staticValue2String*[T](s: StaticValue[T]): string = T.string
# converter sizedString2String*[T](s: SizePrefixedString[T]): string = s.string
# converter string2SizedString*[T](s: string): SizePrefixedString[T] = s.SizePrefixedString
# converter discardValue2String*[T](s: DiscardValue[T]): string = ""

template writeVal*[T: (float32|float64)](io: Stream, val: T) =
  io.write(val)

template writeVal*[T: (int8|uint8|int16|uint16|int32|uint32)](io: Stream, val: T) =
  io.write(val)

template writeVal*[T](io: Stream, val: SizePrefixedSet[T]) =
  io.write(card(val).int32)
  for i in items(val): io.write(i)

template writeVal*[T: static[string]](io: Stream, val: StaticValue[T]) =
  io.write(T)

template writeVal*[SzPrefix, Elem](io: Stream, val: SizePrefixedSeq[SzPrefix, Elem]) =
  write(io, SzPrefix val.len)
  for i in 0..<val.len: io.writeVal(val[i])

template writeVal*[SzPrefix](io: Stream, val: SizePrefixedString[SzPrefix]) =
  write(io, SzPrefix val.len)
  io.write(val)

template writeVal*[T: tuple](io: Stream, val: T) =
  for k, v in fieldPairs(val):
    # TODO: generic nil value support?
    when compiles(v != nil): assert(v != nil,
      name(type(val)) & "." & k & " (" & name(type(v)) & ") is nil, but nil values " &
        "aren't supported yet")
    io.writeVal(v)

template readVal*[T](io: Stream; t: var DiscardValue[T]) =
  io.setPosition(io.getPosition() + sizeof(t))

template readVal*[T: float32](io: Stream, t: var T) = t = io.readFloat32()
template readVal*[T: float64](io: Stream, t: var T) = t = io.readFloat64()
template readVal*[T: (int8|uint8)](io: Stream, t: var T) = t = cast[T](io.readInt8())
template readVal*[T: (int16|uint16)](io: Stream, t: var T) = t = cast[T](io.readInt16())
template readVal*[T: (int32|uint32)](io: Stream, t: var T) = t = cast[T](io.readInt32())

# template readVal*[Size, Enum](io: Stream, t: var EnumValue[Size, Enum]) =
#   echo "reading enum size=", Size, " enum=", Enum

template readVal*[T: enum](io: Stream, t: var T) =
  when sizeof(T) == 1: t = cast[T](io.readInt8())
  else: {.fatal: "enums of size " & $sizeof(T) & " are not supported." }

template readVal*[T](io: Stream, t: var SizePrefixedSet[T]) =
  let card = io.readInt32()
  for i in 0..<card:
    var x: T
    io.readVal(x)
    t.incl(x)

# SizePrefixedSeq
template readVal*[SzPrefix, Elem](io: Stream, t: var SizePrefixedSeq[SzPrefix, Elem]) =
  var sz: SzPrefix = 0
  io.readVal(sz)
  t = newSeq[Elem](sz)
  for i in 0..<sz.int: io.readVal(t[i])

template readVal*[T](io: Stream, t: var StaticValue[T]) =
  let str = io.readStr(T.len)
  if T.len > 0 and str != T:
    raise newException(IOError, "mismatch on reading a StaticValue, got: " &
      str & ", expected: " & T)
  t = StaticValue[T](str)

# SizePrefixedString
template readVal*[SzPrefix](io: Stream, t: var SizePrefixedString[SzPrefix]) =
  var sz: SzPrefix = 0
  io.readVal(sz)
  if sz.int > 0:
    let val = io.readStr(sz.int)
    if val.len < sz.int: raise newException(IOError,
      "not enough data to read string of length " & $sz & ", read only " & $val.len)
    t = val #.SizePrefixedString
  else:
    t = "" #.SizePrefixedString

# tuple iterator
template readVal*[T: ArpieType](io: Stream, t: var T) =
  when compiles(preReadVal(t)): preReadVal(t)

  for k, v in fieldPairs(t):
    when compiles(preReadVal(t)): preReadVal(t)

    # when compiling in debug mode, output some more descriptive exceptions
    when compileOption("assertions"):
      try: readVal(io, v)
      except IOError: raise newException(IOError,
        "while reading " & name(type(t)) & "." & k & " (" & name(type(v)) & "): " &
          getCurrentExceptionMsg())

    else:
      io.readVal(v)

    when compiles(postReadVal(t)): postReadVal(t)

  when compiles(postReadVal(t)): post(t)

# alias for readVal
proc readArpie*[T: ArpieType](io: Stream): T =
  io.readVal(result)

proc parseArpie*[T: ArpieType](s: string): T =
  readArpie[T](newStringStream(s))

proc writeArpie*[T: ArpieType](io: Stream, binary: T) =
  for k, v in fieldPairs(binary):
    io.writeVal(v)

proc toString*[T: ArpieType](binary: T): string =
  let io = newStringStream()
  writeArpie(io, binary)
  io.setPosition(0)
  result = io.readAll()

when isMainModule:
  type
    Nested = tuple
      i: int8
      str: SizePrefixedString[uint8]

    Test = tuple
      i: int32
      a: SizePrefixedSeq[uint8, Nested]
      s: SizePrefixedString[uint8]
      k: Nested
      st: StaticValue["123"]
      bf: SizePrefixedSet[uint8]

  template pre*[T](t: var T) =
    echo "pre ", name(type t)

  template post*[T](t: var T) =
    echo "post ", name(type t)

  var mytest: Test
  mytest.i = 1
  mytest.k.i = 2
  # mytest.k.str = "hi"
  mytest.a = @[(i:15i8, str: "hellooooo").Nested]
  mytest.s = "hello"
  mytest.bf = {1u8, 2u8, 3u8}

  let outstr = newStringStream()
  outstr.write(mytest)
  outstr.setPosition(0)
  let outall = outstr.readAll()

  echo repr(outall)

  let mytest2 = readArpie[Test](newStringStream(outall))
  doAssert(mytest == mytest2, $mytest & " vs " & $mytest2)

  # let mytest3 = readArpie[tuple[s: SizePrefixedString[uint8]]](newStringStream("\x01"))

