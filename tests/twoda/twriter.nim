import std/[strutils, streams, options]
include neverwinter/twoda

const SampleFile = TwodaHeader & "\n" & "\n" &
    "   A B      \n" &
    "0  a b      \n" &
    "1  a ****   \n" &
    "2"

# writes empty fields as four stars
doAssert escapeField(none string) == "****"

# writes empty strings as empty strings
doAssert escapeField(some "") == "\"\""

# quotes fields with spaces
doAssert escapeField(some " ") == "\" \""

# errors with broken quotes
# because nwn doesn't know how to handle them in values.
doAssertRaises(ValueError):
  discard escapeField(some "\"")

# write pads out columns to max width of cells
# This is kinda hard to test, but we'll try:
block:
  var tda = newTwoDA()
  tda.columns = @["A", "B"]
  tda[0] = @[some "LongValue", some "B"]
  var io = newStringStream()
  io.writeTwoDA(tda)
  io.setPosition(0)
  let all = io.readAll
  doAssert -1 != all.find("LongValue     B")

# write minified does not pad out columns to max width of cells
block:
  var tda = newTwoDA()
  tda.columns = @["A", "B"]
  tda[0] = @[some "LongValue", some "B"]
  var io = newStringStream()
  io.writeTwoDA(tda, true)
  io.setPosition(0)
  let all = io.readAll
  doAssert -1 != all.find("LongValue B")

# writes out with CRLF
block:
  var tda = newStringStream(TwodaHeader & "\n\nA B\n0 a b").readTwoDA()
  var io = newStringStream()
  io.writeTwoDA(tda)
  io.setPosition(0)
  let str = io.readAll
  doAssert str.find("\c\L") != -1

# fails writing out with no columns configured
block:
  doAssertRaises(ValueError):
    newStringStream().writeTwoDA(newTwoDA())

# does not write out none default
block:
  var tda = newTwoDA()
  tda.default = none string
  tda.columns = @["A"]
  var io = newStringStream()
  io.writeTwoDA(tda)
  io.setPosition(0)
  let all = io.readAll
  doAssert all.startsWith TwodaHeader & "\c\L\c\L"

# writes out empty default
block:
  var tda = newTwoDA()
  tda.default = some ""
  tda.columns = @["A"]
  var io = newStringStream()
  io.writeTwoDA(tda)
  io.setPosition(0)
  let all = io.readAll
  doAssert all.startsWith TwodaHeader & "\c\LDEFAULT: \"\"\c\L"

# roundtrip
block:
  let tda = newStringStream(SampleFile).readTwoDA
  tda.default = some "wobblegobble"
  var io = newStringStream()
  io.writeTwoDA(tda)
  io.setPosition(0)
  let tda2 = io.readTwoDA()
  doAssert tda.columns == tda2.columns
  doAssert tda.len == tda2.len
  doAssert tda.default == tda2.default
  for r in 0..<tda.len:
    doAssert tda[r] == tda2[r]
