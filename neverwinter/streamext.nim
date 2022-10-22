import streams, sequtils

type SizePrefix* = uint8 | uint16 | uint32 | uint64

template readVal[T: float32](io: Stream, t: var T) = t = io.readFloat32()
template readVal[T: float64](io: Stream, t: var T) = t = io.readFloat64()
template readVal[T: uint8](io: Stream, t: var T)   = t = io.readUInt8()
template readVal[T: uint16](io: Stream, t: var T)  = t = io.readUInt16()
template readVal[T: uint32](io: Stream, t: var T)  = t = io.readUInt32()
template readVal[T: uint64](io: Stream, t: var T)  = t = io.readUInt64()

proc readSizePrefixedString*[P: SizePrefix](io: Stream, expectFixedSize = -1): string =
  var prefix: P
  readVal(io, prefix)
  if expectFixedSize != -1 and prefix != P(expectFixedSize):
    raise newException(IOError, "expected a size of " & $expectFixedSize &
      ", but got " & $prefix)
  result = readStr(io, int prefix)
  if result.len.int != prefix.int:
    raise newException(IOError, "wanted to read T of length " &
                                $prefix & ", but got " & $result.len)

proc readString*(io: Stream, size: int): string =
  result = readStr(io, int size)
  if result.len.int != size.int:
    raise newException(IOError, "wanted to read T of length " &
                                $size & ", but got " & $result.len)

proc readFixedValue*(io: Stream, value: string): void =
  let data = readString(io, value.len)
  if data != value:
    raise newException(IOError, "wanted to read fixed value " & repr(value) &
                                ", but got " & repr(data))

proc readFixedCountSeq*[T](io: Stream, count: int): seq[T] =
  result = newSeq[T](count)
  result = result.mapIt(reader(io))

proc readSizePrefixedSeq*[P: SizePrefix, T](io: Stream, reader: proc(): T): seq[T] =
  var prefix: P
  readVal(io, prefix)
  result = newSeq[T](prefix)
  result = result.mapIt(reader())

proc writeSizePrefixedString*[P: SizePrefix](io: Stream, value: string) =
  io.write(P value.len)
  io.write(value)

proc writeSizePrefixedSeq*[P: SizePrefix, T](io: Stream, elements: seq[T],
    writer: proc(elem: T): void = nil): void =
  write(io, P elements.len)
  for elem in elements:
    if writer != nil: writer(elem)
    else: write(io, elem)

proc readArray*[Length: static[int], T](io: Stream, reader: proc(): T): array[0..Length-1, T] =
  for i in 0..<Length:
    result[i] = reader()

when isMainModule or defined(test):
  import unittest

  suite "streamext":
    suite "readSizePrefixedString":
      let io = newStringStream("\x05abcde")
      test "works":
        check(readSizePrefixedString[uint8](io) == "abcde")

    suite "sizePrefixedSeq":
      let io = newStringStream("\x02\x01a\x04abcd")

      test "read":
        let s = readSizePrefixedSeq[uint8, string](io) do () -> string:
          readSizePrefixedString[uint8](io)
        check(s == @["a", "abcd"])

      test "write":
        var io2 = newStringStream()
        writeSizePrefixedSeq[uint8, string](io2, @["a", "abcd"]) do (elem: string):
          writeSizePrefixedString[uint8](io2, elem)

        io2.setPosition(0)
        io.setPosition(0)
        let data = io2.readAll()
        check(data == io.readAll())
