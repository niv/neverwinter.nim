import streams, strutils, sequtils, options

import resman, resref, util

const
  CellPadding = 2
  MaxColumns = 1024 # im a hack
  TwodaHeader = "2DA V2.0"

type
  Cell*  = Option[string]
  Row*   = seq[Cell]

  TwoDA* = ref object
    defaultValue: Cell
    headers: seq[string]
    headersForLookup: seq[string]
    # Be careful when hacking on this.
    rows*: seq[Row]

proc newTwoDA*(): TwoDA =
  new(result)
  result.defaultValue = none(string)
  result.headers = newSeq[string]()
  result.headersForLookup = newSeq[string]()
  result.rows = newSeq[Row]()

proc `[]`*(self: TwoDA, row: Natural): Option[Row] =
  ## Looks up a row value on this 2da.
  ## Will return a none if out of bounds.
  if row < self.rows.len: some self.rows[row]
  else: none Row # raise newException(IndexError, "Out of bounds")

proc `[]=`*(self: TwoDA, row: Natural, data: Row) =
  ## Assign a row. To clear row data, assign a empty seq. Adding a row
  ## beyond the current length will expand the backing data array to
  ## accomodate at least as many entries.
  ## Hint: To truncate row data, use raw access to `rows` instead.
  if row < self.rows.len:
    self.rows[row] = data
  else:
    while self.rows.len < row: self.rows.add(@[])
    self.rows.add(data)

proc `[]`*(self: TwoDA, row: Natural, column: string): Option[string] =
  ## Looks up a value on this twoda. Will return a none for missing entries.
  ## Will return the default value (none) if the row index is out of bounds or
  ##   the asked-for row does not contain a value in the given column.
  ## Hint: Values written out as **** are considered non-existant as per spec.
  result = self.defaultValue
  if row >= 0 and row < self.rows.len:
    let colId = self.headersForLookup.find(column.toLowerAscii)
    if colId != -1 and colId < self.rows[row].len:
      if self.rows[row][colId].isSome:
        result = self.rows[row][colId]

proc `[]`*(self: TwoDA, row: Natural, column: string, default: string): string =
  ## Looks up a value on this twoda. ill return the given default value for missing entries,
  ## overriding the global default value.
  let o = self[row, column]
  if o.isSome: o.get()
  else: default

proc low*(self: TwoDA): int = self.rows.low
  ## Returns the first ID (same as seq.low).
proc high*(self: TwoDA): int = self.rows.high
  ## Returns the highest ID (same as seq.high).
proc len*(self: TwoDA): int = self.rows.len
  ## Returns the row data length.

proc default*(self: TwoDA): Cell = self.defaultValue
  ## Gets the DEFAULT: value for this table (default: none).

proc `default=`*(self: TwoDA, v: Cell) = self.defaultValue = v
  ## Sets the DEFAULT: value for this table. This value is returned for
  ## all API calls that do not resolve to valid data (including none/**** cells
  ##  and invalid rows.)

proc columns*(self: TwoDA): seq[string] = self.headers
  ## Gets the current column names, case preserved.

proc `columns=`*(self: TwoDA, columns: seq[string]) =
  ## (Re-)sets columns, overwriting the current set. This does
  ## not modify the backing row data in any way.

  for c in columns:
    if strip(c) == "": raise newException(ValueError,
      "invalid column value: " & repr(c))
  self.headers = columns
  self.headersForLookup = self.headers.
    map() do (x: string) -> string: x.toLowerAscii

proc readFields(line: string, maxcount: Natural, minpad = 0): Row =
  ## Reads a string into separated fields/cells. Will only read up to
  ## maxcount, and optionally pad out with none up until minpad.
  result = newSeq[Cell]()
  var currentField = ""
  var quotes = false

  proc addField(r: var seq[Cell]): bool =
    if currentField == "****": r.add(none(string)) else: r.add(some(currentField.fromNwnEncoding))
    currentField = ""
    if r.len >= maxcount: return true

  for c in line:
    case c:
    of '"':
      quotes = not quotes
    of ' ':
      if not quotes and currentField != "":
        if addField(result): return
      elif quotes: currentField &= c
    else:
      currentField &= c

  discard addField(result)

  while result.len < minpad: result.add(none string)

proc readTwoDA*(io: Stream): TwoDA =
  ## Read a TwoDA from a stream.
  ## Will silently fix errors that can be fixed, or raise a ValueError if
  ## something is uncorrectable. Any errors corrected strive to be
  ## compatible to how the game engine sees it.

  result = newTwoDA()

  proc line(): string =
    var tn = TaintedString ""
    if io.readLine(tn): result = tn.strip
    else: raise newException(EOFError, "EOF while reading 2da")

  proc skipEmptyLines() =
    while true:
      let p = io.getPosition
      if line() != "":
        io.setPosition(p)
        break

  # header
  expect(line() == TwodaHeader)
  # skip post-header whitespace
  skipEmptyLines()

  let defaultOrHeaders = line()
  if defaultOrHeaders.startsWith("DEFAULT:"):
    result.defaultValue = defaultOrHeaders.substr(8).readFields(1)[0]
    skipEmptyLines()

    try: result.columns = line().readFields(MaxColumns).mapIt(it.get())
    except ValueError: raise newException(ValueError, "Could not parse columns")
  else:
    result.columns = defaultOrHeaders.readFields(MaxColumns).mapIt(it.get())

  try: skipEmptyLines()
  except EOFError: return # no row data

  while true:
    try:
      let ln = line().readFields(result.headers.len + 1)

      # discard the row label: It's not really used by the game.
      var row: seq[Cell] = if ln.len > 1: ln[1..<ln.len] else: @[]

      # fill in missing columns
      while row.len < result.headers.len: row.add(none string)

      result.rows.add(row)
    except IOError:
      break

proc escapeField*(field: Cell): string =
  ## Transforms a field for twoda writing.
  if field.isNone: "****"
  else:
    let fd = field.get()
    if fd.find("\"") != -1: raise newException(ValueError,
      "Cannot properly escape doublequotes")
    if fd == "" or fd.find(Whitespace) != -1:
      '"' & fd & '"'
    else:
      fd

proc writeTwoDA*(io: Stream, self: TwoDA) =
  ## Writes a twoda to the stream. Attempts to format the twoda to look pretty.

  if self.headers.len == 0:
    raise newException(ValueError, "no columns configured")

  let maxColWidth: seq[int] = self.headers.
    map() do (idx: int, hdr: string) -> int:
      let rowLens = self.rows.map() do (row: Row) -> int:
        if idx < row.len and row[idx].isSome: row[idx].get().len else: 0
      if rowLens.len > 0:
        max(hdr.len, max(rowLens))
      else:
        hdr.len

  let idWidth = max(3, len($self.rows.len))

  io.write(TwodaHeader)
  io.write("\c\L")

  if self.defaultValue.isSome: io.write("DEFAULT: " & self.defaultValue.escapeField)
  io.write("\c\L")

  io.write(repeat(" ", idWidth + CellPadding))
  for idx, h in self.headers:
    io.write(h)
    io.write(repeat(" ", maxColWidth[idx] - h.len + 3 + CellPadding))
  io.write("\c\L")

  for rowidx, row in self.rows:
    let thisId = $rowIdx
    io.write(thisId & repeat(" ", idWidth + CellPadding - thisId.len))

    for cellidx, cell in row:
      let fmt = cell.escapeField
      io.write(fmt.toNwnEncoding)
      io.write(repeat(" ", maxColWidth[cellidx] - fmt.len + 3 + CellPadding))
    io.write("\c\L")

proc as2DA*(self: Res): TwoDA =
  ## Attempts to parse the given res as a 2da.
  let st = newStringStream(self.readAll())
  st.readTwoDA
