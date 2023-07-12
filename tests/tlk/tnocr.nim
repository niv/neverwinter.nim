import std/[strutils, streams]
import neverwinter/tlk as nwtlk

# never writes out caret returns in strings

var outstr = newStringStream()
var tlk = newSingleTlk()
tlk[0] = "test\r\nstring"
outstr.writeTlk(tlk)
outstr.setPosition(0)
let rd = outstr.readAll()
let offset = rd.find("test")
doAssert offset != -1
doAssert rd.substr(offset, offset + 10) == "test\nstring"
