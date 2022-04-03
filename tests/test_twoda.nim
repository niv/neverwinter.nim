import unittest, streams
include neverwinter/twoda

const SampleFile = TwodaHeader & "\n" & "\n" &
    "   A B      \n" &
    "0  a b      \n" &
    "1  a ****   \n" &
    "2"

suite "TwoDA api":
  let tda = newStringStream(SampleFile).readTwoDA()

  test "[row] returns row seq":
    check(tda[0].get() == @[some "a", some "b"])

  test "[row] with missing fields is none-padded seq":
    check(tda[2].get() == @[none string, none string])

  test "[row] for invalid id returns none":
    check(tda[3] == none Row)

  test "[row, column] for valid returns cell data":
    check(tda[0, "B"].get() == "b")

  test "[row, column, def] for valid returns cell data":
    check(tda[0, "B", "d"] == "b")

  test "[row, column] for invalid row is none":
    check(tda[2, "A"] == none string)

  test "[row, column] for invalid column is none":
    check(tda[0, "C"] == none string)

  test "[row, column] for invalid column is default value if given":
    tda.default = some "k"
    check(tda[0, "C"] == some "k")
    tda.default = none string

  test "[row, column] = value for valid columns and rows":
    tda[0, "A"] = some("b")
    check tda[0, "A"] == some("b")
    tda[0, "A"] = some("a")

  test "[row, column] = value for valid columns and invalid rows":
    expect IndexError: tda[3, "A"] = some("a")

  test "[row, column] = value for invalid columns":
    expect IndexError: tda[3, "Invalid"] = some("a")

  test "headers returns headers":
    check(tda.columns == @["A", "B"])

  test "column lookup is case-insensitive":
    check(tda[0, "a"].get() == "a")

  test "can add columns":
    tda.columns = tda.columns & @["C"]
    check(tda.columns.len == 3)
    check(tda.columns == @["A", "B", "C"])

  test "rejects invalid columns":
    expect(ValueError): tda.columns = @[""]
    expect(ValueError): tda.columns = @[" "]
    expect(ValueError): tda.columns = @["\n"]

  test "looking up added columns returns default value":
    tda.columns = tda.columns & @["C"]
    tda.default = some "X"
    check(tda[0, "C"] == some "X")
    tda.default = none string

  test "len returns row count":
    check(tda.len == 3)

  test "can replace row data":
    tda[0] = @[some "x"]
    check(tda[0].get()[0] == some "x")

  test "can add row data beyond end":
    tda[5] = @[some "end"]
    check(tda.len == 6)
    check(tda[3].isSome)
    check(tda[4].isSome)
    check(tda[5].isSome)
    check(tda[6].isNone)

  test "default value is observed for undefined (****) cells":
    tda.default = some "X"
    check tda[1, "B"] == some "X"
    tda.default = none string

  test "default value is observed for missing cells":
    tda.default = some "X"
    check tda[2, "A"] == some "X"
    tda.default = none string

  test "readFields reads at most n fields":
    check(readFields("a b c", 2) == @[some "a", some "b"])

  test "readFields pads out when requested":
    check(readFields("a", 1, 2) == @[some "a", none string])

suite "TwoDA reading":
  test "handles missing newline at EOF":
    discard newStringStream(TwodaHeader & "\nA B").readTwoDA()

  test "fails reading invalid header version":
    expect(ValueError):
      discard newStringStream("2DA V2.x\n").readTwoDA()

  test "handles no row data but newlines":
    discard newStringStream(TwodaHeader & "\nA B\n\n\n").readTwoDA()

  test "will not skip empty lines at start of file":
    expect(ValueError):
      discard newStringStream("\n" & TwodaHeader & "\nA B\n").readTwoDA()

  test "skips empty lines between header and body":
    let tda = newStringStream(TwodaHeader & "\n\n\n\nA B\n0 a b\n").readTwoDA()
    check(tda.columns == @["A", "B"])
    check(tda.rows.len == 1)

  test "reads a empty DEFAULT value properly":
    check newStringStream(TwodaHeader & "\nDEFAULT\nA B\n").readTwoDA().default == none string

  test "reads a malformed DEFAULT value properly":
    check newStringStream(TwodaHeader & "\nDEFAULT   \nA B\n").readTwoDA().default == none string
    check newStringStream(TwodaHeader & "\nDEFAULT \"k\nA B\n").readTwoDA().default == none string
    check newStringStream(TwodaHeader & "\nDEFAULT:\"k\nA B\n").readTwoDA().default == some "k"
    check newStringStream(TwodaHeader & "\nDEFAULT: \"k\nA B\n").readTwoDA().default == some "k"
    check newStringStream(TwodaHeader & "\nDEFAULT: \"k \nA B\n").readTwoDA().default == some "k"

  test "reads a DEFAULT: value properly":
    let tda = newStringStream(TwodaHeader & "\nDEFAULT:\"test value\"\nA B\n").readTwoDA()
    check(tda.default == some "test value")
    let tda2 = newStringStream(TwodaHeader & "\nDEFAULT: \"test value\"\nA B\n").readTwoDA()
    check(tda2.default == some "test value")

  test "handles crlf files properly":
    let tda = newStringStream(TwodaHeader & "\r\n\r\nA B\n0 a b").readTwoDA()
    check(tda.columns == @["A", "B"])
    check(tda.rows.len == 1)

  test "reads malformed quotes properly":
    check(readFields("test \"hello", 2) == @[some "test", some "hello"])

  test "skips extraneous columns while reading rows":
    check(readFields("a b c", 2) == @[some("a"), some("b")])

  test "fails on invalid headers":
    expect(ValueError):
      discard newStringStream(TwodaHeader & "\r\n\r\nA ****\n0 a b").readTwoDA()

  test "does not assume that row label is the row id":
    let tda = newStringStream(TwodaHeader & "\r\n\r\nA B\n3 a b").readTwoDA()
    check(tda.len == 1)

suite "TwoDA writing":
  test "writes empty fields as four stars":
    check(escapeField(none string) == "****")

  test "writes empty strings as empty strings":
    check(escapeField(some "") == "\"\"")

  test "quotes fields with spaces":
    check(escapeField(some " ") == "\" \"")

  test "errors with broken quotes":
    # because nwn doesn't know how to handle them in values.
    expect(ValueError):
      discard escapeField(some "\"")

  test "write pads out columns to max width of cells":
    # This is kinda hard to test, but we'll try:
    var tda = newTwoDA()
    tda.columns = @["A", "B"]
    tda[0] = @[some "LongValue", some "B"]
    var io = newStringStream()
    io.writeTwoDA(tda)
    io.setPosition(0)
    let all = io.readAll
    check(-1 != all.find("LongValue     B"))

  test "write minified does not pad out columns to max width of cells":
    var tda = newTwoDA()
    tda.columns = @["A", "B"]
    tda[0] = @[some "LongValue", some "B"]
    var io = newStringStream()
    io.writeTwoDA(tda, true)
    io.setPosition(0)
    let all = io.readAll
    check(-1 != all.find("LongValue B"))

  test "writes out with CRLF":
    var tda = newStringStream(TwodaHeader & "\n\nA B\n0 a b").readTwoDA()
    var io = newStringStream()
    io.writeTwoDA(tda)
    io.setPosition(0)
    let str = io.readAll
    check(str.find("\c\L") != -1)

  test "fails writing out with no columns configured":
    expect(ValueError):
      newStringStream().writeTwoDA(newTwoDA())

  test "does not write out none default":
    var tda = newTwoDA()
    tda.default = none string
    tda.columns = @["A"]
    var io = newStringStream()
    io.writeTwoDA(tda)
    io.setPosition(0)
    let all = io.readAll
    check(all.startsWith TwodaHeader & "\c\L\c\L")

  test "writes out empty default":
    var tda = newTwoDA()
    tda.default = some ""
    tda.columns = @["A"]
    var io = newStringStream()
    io.writeTwoDA(tda)
    io.setPosition(0)
    let all = io.readAll
    check(all.startsWith TwodaHeader & "\c\LDEFAULT: \"\"\c\L")

  test "roundtrip":
    let tda = newStringStream(SampleFile).readTwoDA
    tda.default = some "wobblegobble"
    var io = newStringStream()
    io.writeTwoDA(tda)
    io.setPosition(0)
    let tda2 = io.readTwoDA()
    check(tda.columns == tda2.columns)
    check(tda.len == tda2.len)
    check(tda.default == tda2.default)
    for r in 0..<tda.len:
      check(tda[r] == tda2[r])
