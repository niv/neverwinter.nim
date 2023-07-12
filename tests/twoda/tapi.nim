import std/[strutils, streams, options]
include neverwinter/twoda

const SampleFile = TwodaHeader & "\n" & "\n" &
    "   A B      \n" &
    "0  a b      \n" &
    "1  a ****   \n" &
    "2"

let tda = newStringStream(SampleFile).readTwoDA()

# [row] returns row seq
doAssert tda[0].get() == @[some "a", some "b"]

# [row] with missing fields is none-padded seq
doAssert tda[1].get() == @[some "a", none string]

# [row] for invalid id returns none
doAssert tda[2] == none Row
doAssert tda[3] == none Row

# [row, column] for valid returns cell data
doAssert tda[0, "B"].get() == "b"

# [row, column, def] for valid returns cell data
doAssert tda[0, "B", "d"] == "b"

# [row, column] for invalid row is none
doAssert tda[2, "A"] == none string

# [row, column] for invalid column is none
doAssert tda[0, "C"] == none string

# [row, column] for invalid column is default value if given
tda.default = some "k"
doAssert tda[0, "C"] == some "k"
tda.default = none string

# [row, column] = value for valid columns and rows
tda[0, "A"] = some("b")
doAssert tda[0, "A"] == some("b")
tda[0, "A"] = some("a")

# # [row, column] = value for valid columns and invalid rows
doAssertRaises IndexError: tda[3, "A"] = some("a")

# # [row, column] = value for invalid columns
doAssertRaises IndexError: tda[3, "Invalid"] = some("a")

# headers returns headers
block:
  doAssert tda.columns == @["A", "B"]

# column lookup is case-insensitive
block:
  doAssert tda[0, "a"].get() == "a"

# can add columns
block:
  tda.columns = tda.columns & @["C"]
  doAssert tda.columns.len == 3
  doAssert tda.columns == @["A", "B", "C"]

# rejects invalid columns
block:
  doAssertRaises(ValueError): tda.columns = @[""]
  doAssertRaises(ValueError): tda.columns = @[" "]
  doAssertRaises(ValueError): tda.columns = @["\n"]

# looking up added columns returns default value
block:
  tda.columns = tda.columns & @["C"]
  tda.default = some "X"
  doAssert tda[0, "C"] == some "X"
  tda.default = none string

# len returns row count
doAssert tda.len == 2

# can replace row data
tda[0] = @[some "x"]
doAssert tda[0].get()[0] == some "x"

# can add row data beyond end
tda[5] = @[some "end"]
doAssert tda.len == 6
doAssert tda[3].isSome
doAssert tda[4].isSome
doAssert tda[5].isSome
doAssert tda[6].isNone

# default value is observed for undefined (****) cells
tda.default = some "X"
doAssert tda[1, "B"] == some "X"
tda.default = none string

# default value is observed for missing cells
tda.default = some "X"
doAssert tda[2, "A"] == some "X"
tda.default = none string

# readFields reads at most n fields
doAssert readFields("a b c", 2) == @[some "a", some "b"]

# readFields pads out when requested
doAssert readFields("a", 1, 2) == @[some "a", none string]
