import std/[strutils, streams, options]
include neverwinter/twoda

const SampleFile = TwodaHeader & "\n" & "\n" &
    "   A B      \n" &
    "0  a b      \n" &
    "1  a ****   \n" &
    "2"

# handles missing newline at EOF
discard newStringStream(TwodaHeader & "\nA B").readTwoDA()

# fails reading invalid header version
doAssertRaises(ValueError):
  discard newStringStream("2DA V2.x\n").readTwoDA()

# handles no row data but newlines
discard newStringStream(TwodaHeader & "\nA B\n\n\n").readTwoDA()

# will not skip empty lines at start of file
doAssertRaises(ValueError):
  discard newStringStream("\n" & TwodaHeader & "\nA B\n").readTwoDA()

# skips empty lines between header and body
block:
  let tda = newStringStream(TwodaHeader & "\n\n\n\nA B\n0 a b\n").readTwoDA()
  doAssert tda.columns == @["A", "B"]
  doAssert tda.rows.len == 1

# reads a empty DEFAULT value properly
doAssert newStringStream(TwodaHeader & "\nDEFAULT\nA B\n").readTwoDA().default == none string

# reads a malformed DEFAULT value properly
doAssert newStringStream(TwodaHeader & "\nDEFAULT   \nA B\n").readTwoDA().default == none string
doAssert newStringStream(TwodaHeader & "\nDEFAULT \"k\nA B\n").readTwoDA().default == none string
doAssert newStringStream(TwodaHeader & "\nDEFAULT:\"k\nA B\n").readTwoDA().default == some "k"
doAssert newStringStream(TwodaHeader & "\nDEFAULT: \"k\nA B\n").readTwoDA().default == some "k"
doAssert newStringStream(TwodaHeader & "\nDEFAULT: \"k \nA B\n").readTwoDA().default == some "k"

# reads a DEFAULT: value properly
block:
  let tda = newStringStream(TwodaHeader & "\nDEFAULT:\"test value\"\nA B\n").readTwoDA()
  doAssert tda.default == some "test value"
  let tda2 = newStringStream(TwodaHeader & "\nDEFAULT: \"test value\"\nA B\n").readTwoDA()
  doAssert tda2.default == some "test value"

# handles crlf files properly
block:
  let tda = newStringStream(TwodaHeader & "\r\n\r\nA B\n0 a b").readTwoDA()
  doAssert tda.columns == @["A", "B"]
  doAssert tda.rows.len == 1

# reads malformed quotes properly
doAssert readFields("test \"hello", 2) == @[some "test", some "hello"]

# skips extraneous columns while reading rows
doAssert readFields("a b c", 2) == @[some("a"), some("b")]

# fails on invalid headers
doAssertRaises(ValueError):
  discard newStringStream(TwodaHeader & "\r\n\r\nA ****\n0 a b").readTwoDA()

# does not assume that row label is the row id
block:
  let tda = newStringStream(TwodaHeader & "\r\n\r\nA B\n3 a b").readTwoDA()
  doAssert tda.len == 1
