import std/[os, streams, tables, terminal]
from std/terminal import isatty

import shared
import neverwinter/nwscript/[nwasm, ndb as ndblib, langspec]

import nancy, termstyle

let args = DOC """
Disassemble ncs.

This utility is basically a stub to exercise the nwscript disasm lib.
No API stability guarantees.

Usage:
  $0 [options] -d <script>
  $USAGE

Options:
  -d                          Disassemble ncs file to stdout.
  -g                          Require .ndb loading.
  -G                          Do not attempt to load .ndb.
  -S                          Do not attempt to read/load source code for interweaving (ndb only).

  -F                          Omit per-function IP offsets (ndb only).

  --internal-names            Do not print shorthand opcodes, use internal constants instead.

  -L                          Do not look up language spec
  --langspec NSS              Language spec to load [default: nwscript]

  -n LEN                      Max string length printed [default: 15]

  --no-color                  Do not emit colors to terminal.
  --term-width N              Override terminal width for cell wrapping (0: Don't wrap)
  --cell-padding N            Cell padding between output columns [default: 2]
$OPTRESMAN
"""

let script = ($args["<script>"]).splitFile()
let weaveCode = not args["-S"]
let maxStringLength = parseInt $args["-n"]

setTermStyleColorsEnabled isatty(stdout) and not args["--no-color"]

let termWidth =
  if args["--term-width"]:
    let v = parseInt($args["--term-width"])
    if v == 0: int.high else: v
  elif not isatty(stdout):
    int.high
  else:
    terminalWidth()

let padding = Natural parseInt $args["--cell-padding"]
let indent = 2

let rm = newBasicResMan()

rm.add newResFile(script.dir / script.name & ".nss")
rm.add newResFile(script.dir / script.name & ".ncs")
rm.add newResFile(script.dir / script.name & ".ndb")

var spec: LanguageSpec
if not args["-L"]:
  spec = parseLanguageSpec rm.demand(newResolvedResRef($args["--langspec"] & ".nss")).readAll

var ndb: Ndb

# Attempt to load ndb.
if not args["-G"] and rm.contains(newResolvedResRef script.name & ".ndb"):
  ndb = parseNdb(newStringStream rm.demand(newResolvedResRef script.name & ".ndb").readAll)
  # Pre-sort functions by occurence in binary.
  ndb.functions.sort do (a, b: NdbFunction) -> int:
    system.cmp(a.bStart, b.bStart)
elif args["-g"]: raise newException(ValueError, "-g: .ndb required, but not found")

proc getLineOfFile(fileNum, lineNum: int): string =
  var fileLinesCache {.global.}: Table[ResolvedResRef, seq[string]]
  let rr = newResolvedResRef(ndb.files[fileNum] & ".nss")
  if not fileLinesCache.contains(rr):
    if rm.contains(rr):
      fileLinesCache[rr] = rm.demand(rr).readAll.splitLines()
    else:
      return ""
  if lineNum - 1 < fileLinesCache[rr].len:
    fileLinesCache[rr][lineNum - 1].strip
  else:
    warn "Debug info for ", rr, " out of sync"
    ""

proc instrStr(i: Instr): string =
  i.canonicalName(args["--internal-names"])

var jumps: Table[int, seq[(Opcode, int)]]

proc addInstr(table: var TerminalTable, i: Instr, globalOffset, localOffset: int) =
  ## Returns relative change to IP after this execution would have been executed.

  # Weaving code into output means putting it in the comment field
  let sourceLine =
    if weaveCode:
      var currentLine {.global.}: NdbLine
      let lines = ndb.lines.filterIt(globalOffset.uint32 in (it.bStart - 13)..<(it.bEnd-13))
      if lines.len == 1 and lines[0] != currentLine:
        currentLine = lines[0]
        # Only print source on first appearance of line
        getLineOfFile(currentLine.fileNum, currentLine.lineNum) #.substr(0, maxStringLength)
      else: ""
    else: ""

  let extraStr = case i.op
    of EXECUTE_COMMAND:
      let cmdId = unpackExtra[int16](i)
      if cmdId in 0..spec.funcs.high: red spec.funcs[cmdId].name else: ""
    of JMP, JZ, JNZ:
      let rel = unpackExtra[int32](i)
      $rel & green " => " & $(rel + int32 globalOffset)
    of JSR:
      let rel = unpackExtra[int32](i)
      # Find the function this instruction is in
      let funcs = ndb.functions.filterIt(globalOffset + rel in (it.bStart.int-13)..<(it.bEnd.int-13))
      $rel & green " => " & bold cyan(if funcs.len == 1: funcs[0].label else: $(globalOffset + rel))
    else:
      i.extraStr(maxStringLength)

  var row: seq[string]
  row.add style($globalOffset, if jumps.hasKey(globalOffset): termGreen else: "")
  if not args["-F"] and localOffset >= 0:
    row.add yellow $localOffset
  row.add i.instrStr
  row.add extraStr
  row.add blue sourceLine
  table.add row

# ================

let ii = disAsm newStringStream rm.demand(newResolvedResRef script.name & ".ncs").readAll

type OutputFunctionLabel = tuple
  label: string
  file: string
  offset: string
var outputTables: OrderedTable[OutputFunctionLabel, TerminalTable]

var currentFunction: NdbFunction
var currentFunctionFile: string
var globalOffset = 0
var localOffset = -1

# first pass: build a map of jumps
for idx, i in ii:
  case i.op
  of JMP, JSR, JZ, JNZ:
    jumps.mgetOrPut(globalOffset + unpackExtra[int32](i), @[]).add (i.op, globalOffset)
  else: discard
  inc globalOffset, i.len
globalOffset = 0

# second pass: render all tables
for idx, i in ii:
  for fn in ndb.functions:
    if globalOffset in (fn.bStart.int - 13)..<(fn.bEnd.int - 13):
      if currentFunction != fn:
        currentFunction = fn
        currentFunctionFile = ""
        for line in ndb.lines:
          if line.bStart == fn.bStart:
            currentFunctionFile = format("$#.$#:$#", ndb.files[line.fileNum], "nss", line.lineNum - 1)
            break
        localOffset = 0
      break

  var label: OutputFunctionLabel
  if currentFunction.label != "":
    label.label = format("$# $#($#):", currentFunction.retType, currentFunction.label,
                                       currentFunction.args.mapIt($it).join(", "))
    label.file = currentFunctionFile
    label.offset = format("[$#:$#]", currentFunction.bStart - 13, currentFunction.bEnd - 13)

  addInstr outputTables.mgetOrPut(label, TerminalTable()),
           i, globalOffset, localOffset

  inc globalOffset, i.len
  if currentFunction.label != "":
    inc localOffset, i.len

var outputSizes: seq[int]
for label, table in outputTables:
  getColumnSizes(table, outputSizes, maxSize = termWidth - indent, padding = padding)

var first = true
for label, table in outputTables:
  if label.label != "":
    if not first: echo ""
    first = false
    echo bold underline cyan label.label, " ", cyan label.file, " ", magenta label.offset

  table.echoTable(outputSizes, maxSize = termWidth, indent = indent, padding = padding)
