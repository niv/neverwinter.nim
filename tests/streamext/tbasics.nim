import std/streams
import neverwinter/streamext

block:
  let io = newStringStream("\x05abcde")
  doAssert readSizePrefixedString[uint8](io) == "abcde"

block:
  let io = newStringStream("\x02\x01a\x04abcd")
  let s = readSizePrefixedSeq[uint8, string](io) do () -> string:
    readSizePrefixedString[uint8](io)
  doAssert s == @["a", "abcd"]

block:
  let io = newStringStream("\x02\x01a\x04abcd")
  let s = readSizePrefixedSeq[uint8, string](io) do () -> string:
    readSizePrefixedString[uint8](io)
  doAssert s == @["a", "abcd"]

block:
  let io = newStringStream("\x02\x01a\x04abcd")
  let io2 = newStringStream()
  writeSizePrefixedSeq[uint8, string](io2, @["a", "abcd"]) do (elem: string):
    writeSizePrefixedString[uint8](io2, elem)

  io2.setPosition(0)
  io.setPosition(0)
  let data = io2.readAll()
  doAssert data == io.readAll()
