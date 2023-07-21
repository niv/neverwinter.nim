import std/[os, streams, tables]

import shared
import neverwinter/nwscript/[nwasm, ndb]

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

  --internal-names            Do not print shorthand opcodes, use internal constants instead.
$OPTRESMAN
"""

let script = ($args["<script>"]).splitFile()

let weaveCode = not args["-S"]

let rm = newBasicResMan()
rm.add newResFile(script.dir / script.name & ".nss")

var fileLinesCache: Table[ResolvedResRef, seq[string]]

proc getLineOfFile(ndb: Ndb, fileNum, lineNum: int): string =
  let rr = newResolvedResRef(ndb.files[fileNum] & ".nss")
  if not fileLinesCache.contains(rr):
    if rm.contains(rr):
      fileLinesCache[rr] = rm.demand(rr).readAll.splitLines()
    else:
      return ""

  "// " & fileLinesCache[rr][lineNum - 1].strip

proc decompileFunction(ndb: Ndb, f: NdbFunction, ncs: Stream) =
  ncs.setPosition(int f.bStart)
  var currentLine: NdbLine
  let fun = newStringStream ncs.readStrOrErr(int f.bEnd - f.bStart)
  echo asmToStr(disasm fun, some(int f.bStart - 13), not args["--internal-names"]) do (i: Instr, streamOffset: int) -> tuple[prefix, comment, source: string]:
    if weaveCode:
      let lines = ndb.lines.filterIt(streamOffset.uint32 in (it.bStart - 13)..<(it.bEnd-13))
      if lines.len == 1 and lines[0] != currentLine:
        currentLine = lines[0]
        # Only print source on first appearance of line
        result.source = getLineOfFile(ndb, currentLine.fileNum, currentLine.lineNum)

    result.comment = (case i.op
    of EXECUTE_COMMAND:
      $unpackExtra[int16](i)
    of JMP:
      " => " & $(unpackExtra[int32](i) + streamOffset)
    of JSR:
      let rel = unpackExtra[int32](i)
      let funcs = ndb.functions.filterIt(it.bStart.int == f.bStart.int + rel + streamOffset)
      if funcs.len == 1: $funcs[0] else: "?"
    else: "")

let sncs = joinPath(script.dir, script.name) & ".ncs"
let sndb = joinPath(script.dir, script.name) & ".ndb"

doAssert fileExists(sncs), sncs
let sncsx = openFileStream(sncs, fmRead)

doAssert fileExists(sndb) or not args["-g"], "-g: .ndb required, but not found"

if not args["-G"] and fileExists(sndb):
  var ndbx = parseNdb(openFileStream(sndb, fmRead))
  ndbx.functions.sort do (a, b: NdbFunction) -> int:
    system.cmp(a.bStart, b.bStart)
  for idx, f in ndbx.functions:
    ndbx.decompileFunction(f, sncsx)
else:
  echo "# no .ndb found: disassembly will not show functions or metadata"
  echo asmToStr(disAsm(sncsx), some(0), not args["--internal-names"])
