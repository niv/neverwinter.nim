import streams, strutils, sequtils

import res, resref, util

const
  CellPadding = 2
  MaxColumns = 1024 # im a hack

type
  Row*   = seq[string]
  TwoDA* = ref object
    headers*: Row
    rows*: seq[Row]
    # If you edit headers, make sure this matches. This is headers transformed
    # to lowercase to speed up column lookups.
    headersForLookup*: Row

proc `[]`*(self: TwoDA, row: int): Row =
  ## Looks up a row value on this twoda. Will return empty rows for missing entries.
  if row >= 0 and row < self.rows.len: self.rows[row] else: newSeq[string]()

proc `[]`*(self: TwoDA, row: int, column: string): string =
  ## Looks up a value on this twoda. Will return a empty string for missing entries.
  result = ""
  if row >= 0 and row < self.rows.len:
    let colId = self.headersForLookup.find(column.toLowerAscii)
    if colId != -1:
      result = self.rows[row][colId]

proc `$`*(self: TwoDA): string =
  let tp = (headers: self.headers, rows: self.rows)
  result = $tp

proc readFields(line: string, count: int): Row =
  result = newSeq[string]()
  var currentField = ""
  var quotes = false

  proc addField(r: var seq[string]): bool =
    if currentField == "****": r.add("") else: r.add(currentField)
    currentField = ""
    if r.len >= count: return true

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

proc readTwoDA*(io: Stream): TwoDA =
  proc line(): string =
    var tn = TaintedString""
    if io.readLine(tn): result = tn.strip else: raise newException(IOError,
      "EOF while reading 2da from Res")

  proc skipEmptyLines() =
    while true:
      let p = io.getPosition
      if line() != "":
        io.setPosition(p)
        break

  new(result)
  result.rows = newSeq[Row]()

  skipEmptyLines()
  # header
  expect(line() == "2DA V2.0")
  # skip post-header whitespace
  skipEmptyLines()

  result.headers = line().readFields(MaxColumns)
  result.headersForLookup = result.headers.
    map() do (x: auto) -> auto: x.toLowerAscii

  while true:
    try:
      skipEmptyLines()

      let ln = line().readFields(result.headers.len + 1)

      # let rowId = ln[0] # just ignore the row altogether
      var row = ln[1..<ln.len]

      # fill in missing columns
      while row.len < result.headers.len: row.add("")

      result.rows.add(row)
    except IOError:
      break

proc writeField(field: string): string =
  if field == "": "****"
  elif field.find(" ") != -1: '"' & field & '"' else: field

proc write*(io: Stream, self: TwoDA) =
  ## Writes a twoda to the stream. Attempts to format the twoda to look pretty.

  let prows = self.rows.map() do (row: auto) -> auto:
    row.map() do (r: auto) -> auto: r.writeField

  let maxColWidth: seq[int] = self.headers.
    mapWithIndex() do (idx: int, hdr: string) -> int:
      max(hdr.len, self.rows.map() do (row: auto) -> int: row[idx].len)

  let idWidth = max(3, len($self.rows.len))

  io.write("2DA V1.0\n\n")
  io.write(repeat(" ", idWidth + CellPadding))
  for idx, h in self.headers:
    io.write(h)
    io.write(repeat(" ", maxColWidth[idx] - h.len + 3 + CellPadding))
  io.write("\n")

  for rowidx, row in prows:
    let thisId = $rowIdx
    io.write(thisId & repeat(" ", idWidth + CellPadding - thisId.len))
    for cellidx, cell in row:
      # let fmt = cell.writeField
      io.write(cell)
      io.write(repeat(" ", maxColWidth[cellidx] - cell.len + 3 + CellPadding))
    io.write("\n")

proc as2DA*(self: Res): TwoDA =
  ## Attempts to parse the given res as a 2da.
  let st = newStringStream(self.readAll())
  st.readTwoDA
