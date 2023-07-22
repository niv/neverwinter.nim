import sequtils, ansiparse, terminal, algorithm
import unicode except repeat
from strutils import Whitespace, tokenize, split, repeat, join

type
  RowKind* = enum
    rkCells # Multiple cells
    rkSep   # printSeparator(center)

  Cell* = seq[AnsiData]

  RawCb = proc()

  Row* = object
    kind: RowKind
    cells: seq[Cell]
    rawCb: RawCb

  TerminalTable* = object
    parts: seq[Row]

func len(part: Row): int = part.cells.len
func high(part: Row): int = part.cells.high

proc addSep*(table: var TerminalTable) =
  table.parts.add Row(kind: rkSep, cells: @["*".parseAnsi])

proc add*(table: var TerminalTable, parts: varargs[string]) =
  ## Adds a new row to the table with the columns specified
  table.parts.add Row(kind: rkCells, cells: @[])
  for part in parts:
    table.parts[^1].cells.add part.parseAnsi

proc tabbed*(table: var TerminalTable, row: string) =
  ## Convenience procedure to split a string by tabs and add it as a row
  table.add row.split('\t')

proc clear*(table: var TerminalTable) =
  ## Clear out all table state.
  table.parts = @[]

proc pureLen(ansiSequence: seq[AnsiData]): int =
  for part in ansiSequence:
    if part.kind == String:
      result += part.str.len

proc ansiAlign(ansiSeq: seq[AnsiData], amount: int): string =
  let
    str = ansiSeq.toString()
    diff = str.len - ansiSeq.pureLen
  str.alignLeft(amount + diff)

proc olen(s: string): int =
  var i = 0
  result = 0
  while i < s.len:
    inc result
    let L = graphemeLen(s, i)
    inc i, L

func wrapWords*(s: seq[AnsiData], maxLineWidth = 80,
               splitLongWords = true,
               seps: set[char] = Whitespace): seq[seq[AnsiData]] =
  ## This function is copied from the word-wrapping procedure in the standard
  ## library. However it has been tweaked to not properly handle ANSI data so
  ## it doesn't wrap in the middle of a CSI sequence and it doesn't count CSI
  ## sequences as taking up space.
  const endElem =
    AnsiData(kind: CSI, parameters: "0", intermediate: "", final: 'm')
  var
    temp: seq[AnsiData]
    spaceLeft = maxLineWidth
    lastSep = ""
    csi: seq[AnsiData]
    passedCsi: seq[AnsiData]
  for element in s:
    case element.kind:
    of CSI:
      csi.add element
      temp.add element
    of String:
      for word, isSep in tokenize(element.str, seps):
        let wlen = olen(word)
        if isSep:
          lastSep = word
          spaceLeft = spaceLeft - wlen
        elif wlen > spaceLeft:
          if splitLongWords and wlen > maxLineWidth:
            var i = 0
            while i < word.len:
              if spaceLeft <= 0:
                spaceLeft = maxLineWidth
                result.add passedCsi & temp & endElem
                passedCsi.add csi
                reset csi
                reset temp
              dec spaceLeft
              let L = graphemeLen(word, i)
              for j in 0 ..< L: temp.add AnsiData(kind: String, str: $word[i+j])
              inc i, L
          else:
            spaceLeft = maxLineWidth - wlen
            result.add passedCsi & temp & endElem
            passedCsi.add csi
            reset csi
            reset temp
            temp.add AnsiData(kind: String, str: word)
        else:
          spaceLeft = spaceLeft - wlen
          temp.add AnsiData(kind: String, str: lastSep)
          temp.add AnsiData(kind: String, str: word)
          lastSep.setLen(0)
  result.add passedCsi & temp & endElem

proc rows*(table: TerminalTable): int =
  ## Returns how many rows are currently in the table
  table.parts.len

proc columns*(table: TerminalTable): int =
  ## Returns how many columns are currently in the table
  for part in table.parts:
    result = max(result, part.cells.len)

proc getColumnSizes*(table: TerminalTable, sizes: var seq[int],
    maxSize = terminalWidth(), padding = 1) =
  ## Calculate the sizes of the columns, and returns a sequence of column
  ## widths. `maxSize` defines the maximum width of the table, the table will
  ## be smaller than this if possible, but will wrap the columns if it's
  ## bigger. `padding` determines how much room is in-between each column. The
  ## returned sizes does not include the padding. If you want to print a
  ## terminal with varying width padding then use `columns` to decide how many
  ## colums you have and subtract the combined padding from `maxSize` while
  ## setting padding to 0.
  for part in table.parts:
    for i, cell in part.cells:
      if i == sizes.len:
        sizes.add cell.pureLen
      else:
        sizes[i] = max(sizes[i], cell.pureLen)

  let totalSize = sizes.foldl(a + b) + padding * (sizes.len - 1)
  if totalSize > maxSize:
    var newSizes = newSeq[tuple[val, i: int]](sizes.len)
    for i, size in sizes:
      newSizes[i] = (val: size, i: i)
    newSizes.sort(SortOrder.Descending)
    var
      resized = 0
      newSize = totalSize
    for i in 0..<sizes.high:
      newSize -= newSizes[i].val * (i+1)
      newSize += newSizes[i+1].val * (i+1)
      resized += 1
      if newSize <= maxSize:
        break
    let extra = maxSize - newSize
    if extra >= 0:
      for i in 0..<resized:
        sizes[newSizes[i].i] = newSizes[resized].val + extra div resized
        newSize += extra div resized
    else:
      newSize = 0
      for i in 0..sizes.high:
        sizes[i] = (maxSize - sizes.high * padding) div sizes.len
        newSize += sizes[i]
        if i != sizes.high:
          newSize += padding
    while newSize < maxSize:
      for i in 0..<resized:
        sizes[newSizes[i].i] += 1
        newSize += 1
        if newSize == maxSize: break

iterator entries*(table: TerminalTable, padding: int, sizes: seq[int]): tuple[
    key: int,
    val: iterator(): tuple[
      key: int,
      kind: RowKind,
      val: iterator(): tuple[key: int, val: string]
    ]
  ] =
  ## Iterator to help build custom output formats. Each tuple will work with
  ## double argument `for` loops to provide an index and the actual value. The
  ## first iterator goes through each entry in the table, the second goes
  ## through all the lines to be printed for that entry, and the third goes
  ## through the columns for that entry. All columns will be padded to the size
  ## specified in the sizes sequence or wrapped over multiple lines if they
  ## are longer than the size.
  for k, part in table.parts:
    var
      wrapped = newSeq[seq[seq[AnsiData]]](part.len)
      longest = 0
    for i in 0..part.high:
      wrapped[i] = part.cells[i].wrapWords(sizes[i])
      longest = max(longest, wrapped[i].len)
    yield (k, iterator (): tuple[key: int, kind: RowKind, val: iterator(): tuple[key: int, val: string]] =
      for i in 0..<longest:
        yield (i, part.kind, iterator(): tuple[key: int, val: string] =
          for j, w in wrapped:
            if w.len > i:
              yield (j, w[i].ansiAlign(sizes[j]))
            else:
              yield (j, ' '.repeat sizes[j])
          for j in wrapped.len..sizes.high:
            yield (j, ' '.repeat sizes[j])
        )
    )

const
  defaultSeps* = (topLeft: "+", topRight: "+", topMiddle: "+", bottomLeft: "+",
    bottomMiddle: "+", bottomRight: "+", centerLeft: "+", centerMiddle: "+",
    centerRight: "+", vertical: "|", horizontal: "-")
  boxSeps* = (topLeft: "┌", topRight: "┐", topMiddle: "┬", bottomLeft: "└",
    bottomMiddle: "┴", bottomRight: "┘", centerLeft: "├", centerMiddle: "┼",
    centerRight: "┤", vertical: "│", horizontal: "─")

template printSeparator(indent: Natural, position: untyped): untyped =
  if indent > 0: stdout.write repeat(" ", indent)
  stdout.write seps.`position Left`
  for i, size in sizes:
    stdout.write seps.horizontal.repeat(size + 2)
    if i != sizes.high:
      stdout.write seps.`position Middle`
    else:
      stdout.write seps.`position Right` & "\n"

proc echoTableSeps*(table: TerminalTable, sizes: seq[int] = @[],
    maxSize = terminalWidth(), seps = defaultSeps,
    indent: Natural = 0, mergeRows = false) =
  ## Writes out the table to the terminal with wrapping, styles, and
  ## separators. `maxSize` is the same as for `echoTable`, and `seps` is a
  ## tuple with strings to use as separators. All separators are expected to be
  ## 1 character wide when printed to the terminal, but are defined as strings
  ## so they can be UTF characters or use ANSI colours. The body of this
  ## procedure displays nicely how to implement your own table printing with
  ## the `entries` iterator.
  var sizes = sizes
  table.getColumnSizes(sizes, maxSize - 4 - indent, padding = 3)
  printSeparator(indent, top)
  for k, entry in table.entries(sizes = sizes, padding = 3):
    for _, kind, row in entry():
      if indent > 0: stdout.write repeat(" ", indent)
      case kind
      of rkCells:
        stdout.write seps.vertical & " "
        for i, cell in row():
          stdout.write cell & (if i != sizes.high: " " & seps.vertical & " " else: "")
        stdout.write " " & seps.vertical & "\n"
      of rkSep:
        printSeparator(indent, center)
    if k != table.rows - 1 and (not mergeRows and k == 0):
      printSeparator(indent, center)
  printSeparator(indent, bottom)

proc echoTable*(table: TerminalTable, sizes: seq[int] = @[],
    maxSize = terminalWidth(), padding = 1, indent = 0) =
  ## Writes out the table to the terminal with wrapping and styles. `maxSize`
  ## can be used to set the maximum width of the table, this defaults to the
  ## current width of the terminal. `padding` can be used to set how much space
  ## is inserted between each column. If you want to have a table with
  ## separators use `echoTableSeps` instead.
  var sizes = sizes
  table.getColumnSizes(sizes, maxSize - indent, padding = padding)
  for _, entry in table.entries(sizes = sizes, padding = padding):
    for _, kind, row in entry():
      if indent > 0: stdout.write repeat(" ", indent)
      case kind
      of rkCells:
        for i, cell in row():
          stdout.write cell & (if i != sizes.high: ' '.repeat(padding) else: "")
        stdout.write "\n"
      of rkSep:
        discard

# proc echoTable*(table: TerminalTable, maxSize = terminalWidth(), padding = 1, indent = 0) =
#   var sizes: seq[int]
#   echoTable(table, sizes, maxSize, padding, indent)

when isMainModule:
  import termstyle

  var table: TerminalTable
  table.add red "Lorem", blue "Lorem ipsum dolor sit amet," & bold(" consectetur adipiscing elit") & blue ", sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Ut enim ad minim veniam"
  table.add green "Ipsum"
  table.add italic red "Dolor sit", "", underline "Ut enum ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
  #table.add @[blue "Hello world", "this is aligned"]
  #table.add @["Tim", red "this is also aligned"]
  #table.add "Timothy", (yellow "This is a really long message that" & blue " should break the width of the terminal and cause a wrapping scenario, hopefully it works so I can test wrapping."), red "This is a really long message that should break the width of the terminal and cause a wrapping scenario, hopefully it works so I can test wrapping.", "Test"
  #table.add blue "Ronaldson", green "This is a shorter message", "So is this", red "Last field that now includes a message long enough for this to be truncated"
  #table.tabbed "This is a test\tTo see if tab delimited adding works\t\e[32mAlso supports colours!\e[0m"

  table.echoTable(80)
  echo ""
  table.echoTableSeps(80, boxSeps)
  echo ""
  table.echoTableSeps(80)
  echo ""
  table.echoTable(padding = 3)
  echo ""
  table.echoTableSeps(seps = boxSeps)
  echo ""
  table.echoTableSeps()
  #for i in 60..80:
  #  echo '-'.repeat i
  #  table.echoTableSeps(i, boxSeps)
