import std/streams
import neverwinter/tlk as nwtlk

# returns the latest-valid entry for dynamically added
var tlk = newSingleTlk()
tlk[0] = "a"
doAssert tlk.highest == 0

tlk[55] = "b"
doAssert tlk.highest == 55

var outstr = newStringStream()
outstr.writeTlk(tlk)
outstr.setPosition(0)

# returns the latest-valid entry when loading statics
let rd = readSingleTlk(outstr)
doAssert rd.highest == 55
