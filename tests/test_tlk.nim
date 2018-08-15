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

  test "highest returns the latest-valid entry for dynamically added":
    var tlk = newSingleTlk()
    tlk[0] = "a"
    check(tlk.highest == 0)
    tlk[55] = "b"
    check(tlk.highest == 55)

  test "highest returns the latest-valid entry when loading statics":
    var tlk = newSingleTlk()
    tlk[0] = "a"
    tlk[55] = "b"
    var outstr = newStringStream()
    outstr.write(tlk)
    outstr.setPosition(0)
    let rd = readSingleTlk(outstr)
    check(rd.highest == 55)
