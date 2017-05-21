import unittest, streams
include neverwinter.tlk

suite "SingleTlk":
  test "never writes out caret returns in strings":
    var outstr = newStringStream()
    var tlk = newSingleTlk()
    tlk[0] = "test\r\nstring"
    outstr.write(tlk)
    outstr.setPosition(0)
    let rd = outstr.readAll()
    let offset = rd.find("test")
    check(offset != -1)
    check(rd.substr(offset, offset + 10) == "test\nstring")
