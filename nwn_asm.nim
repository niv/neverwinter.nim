import std/streams

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

$OPTS
"""

proc decompileFunction(ndb: Ndb, f: NdbFunction, ncs: Stream) =
  echo $f & ":"
  ncs.setPosition(f.bStart)
  let fun = newStringStream ncs.readStrOrErr(f.bEnd - f.bStart)
  echo asmToStr(disasm fun) do (i: Instr, streamOffset: int) -> string:
    case i.op
    of EXECUTE_COMMAND:
      $unpackExtra[int16](i)
    of JMP:
      " => " & $(unpackExtra[int32](i) + streamOffset)
    of JSR:
      let rel = unpackExtra[int32](i)
      let funcs = ndb.functions.filterIt(it.bStart == f.bStart + rel + streamOffset)
      if funcs.len == 1: $funcs[0] else: "?"
    else: ""

let script = ($args["<script>"]).splitFile()
let sncs = joinPath(script.dir, script.name) & ".ncs"
let sndb = joinPath(script.dir, script.name) & ".ndb"

doAssert fileExists(sncs), sncs
let sncsx = openFileStream(sncs, fmRead)

if fileExists(sndb):
  let ndbx = parseNdb(openFileStream(sndb, fmRead))
  for idx, f in ndbx.functions:
    ndbx.decompileFunction(f, sncsx)
else:
  echo "# no .ndb found: disassembly will not show functions or metadata"
  echo asmToStr disAsm(sncsx)
