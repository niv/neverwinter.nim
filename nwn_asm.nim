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
  -g                          Require .ndb loading.
  -G                          Do not attempt to load .ndb.
$OPT
"""

proc decompileFunction(ndb: Ndb, f: NdbFunction, ncs: Stream) =
  echo $f & ":"
  ncs.setPosition(int f.bStart)
  let fun = newStringStream ncs.readStrOrErr(int f.bEnd - f.bStart)
  echo asmToStr(disasm fun, some(int f.bStart - 13)) do (i: Instr, streamOffset: int) -> string:
    case i.op
    of EXECUTE_COMMAND:
      $unpackExtra[int16](i)
    of JMP:
      " => " & $(unpackExtra[int32](i) + streamOffset)
    of JSR:
      let rel = unpackExtra[int32](i)
      let funcs = ndb.functions.filterIt(it.bStart.int == f.bStart.int + rel + streamOffset)
      if funcs.len == 1: $funcs[0] else: "?"
    else: ""

let script = ($args["<script>"]).splitFile()
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
  echo asmToStr disAsm(sncsx)
