import std/[strutils, sequtils, streams, enumutils]

import neverwinter/util

type
  NdbType* {.pure.} = enum
    `float`         = "f"
    `int`           = "i"
    `void`          = "v"
    `object`        = "o"
    `string`        = "s"
    `effect`        = "e"
    `struct`        = "t"
    `unknown`       = "?"

  NdbFunction* = tuple
    label: string
    bStart, bEnd: uint32
    retType: NdbType
    args: seq[NdbType]

  NdbStruct* = tuple
    label: string
    fields: seq[tuple[label: string, `type`: NdbType]]

  NdbVariable* = tuple
    label: string
    `type`: NdbType
    bStart, bEnd, stackLoc: uint32

  NdbLine* = tuple
    fileNum: int
    lineNum: int
    bStart, bEnd: uint32

  Ndb* = tuple
    files: seq[string]
    structs: seq[NdbStruct]
    functions: seq[NdbFunction]
    variables: seq[NdbVariable]
    lines: seq[NdbLine]

func `$`*(t: NdbType): string =
  symbolName t

func `$`*(f: NdbFunction): string =
  format("$1 $2($3) [$4:$5]", f.retType, f.label, f.args.mapIt($it).join(", "),
    f.bStart - 13, f.bEnd - 13)

func parseType(s: string): NdbType =
  # Some types are longer than 1 char, e.g. structs: t001, t002 etc.
  # This is not possible to encode in a compile time enum, so NdbType
  # wull have to change to represent that.
  assert s.len >= 1
  parseEnum[NdbType](s.substr(0, 0))

proc parseNdb*(io: Stream): Ndb =
  expect io.readLine() == "NDB V1.0"
  let counters = io.readLine().split(" ").mapIt(parseInt(it))
  expect counters.len == 5
  while not io.atEnd:
    let ln = io.readLine().strip()
    if ln.len == 0 or ln[0] == '#': continue
    let s = ln.split(" ")
    expect s.len > 0
    if s[0][0] == 'N' or s[0][0] == 'n':
      expect s[0].substr(1).parseInt() == result.files.len
      result.files.add(s[1])
    elif s[0] == "s":
      expect s.len == 3
      result.structs.add(NdbStruct (
        label: s[2],
        fields: @[]
      ))
    elif s[0] == "sf":
      expect s.len == 3
      expect result.structs.len > 0
      result.structs[result.structs.len - 1].fields.add((
        label: s[2],
        `type`: parseType(s[1])
      ))
    elif s[0] == "f":
      expect s.len == 6
      result.functions.add(NdbFunction (
        label: s[5],
        bStart: uint32 parseHexInt(s[1]),
        bEnd: uint32 parseHexInt(s[2]),
        retType: parseType(s[4]),
        args: @[]
      ))
    elif s[0] == "fp":
      expect s.len == 2
      expect result.functions.len > 0
      result.functions[result.functions.len - 1].args.add(
        parseType(s[1])
      )
    elif s[0] == "v":
      expect s.len == 6
      result.variables.add(NdbVariable (
        label: s[5],
        `type`: parseType(s[4]),
        bStart: uint32 parseHexInt(s[1]),
        bend: uint32 parseHexInt(s[2]),
        stackLoc: uint32 parseHexInt(s[3])
      ))
    elif s[0][0] == 'l':
      result.lines.add(NdbLine (
        fileNum: parseInt(s[0].substr(1)),
        lineNum: parseInt(s[1]),
        bStart: uint32 parseHexInt(s[2]),
        bend: uint32 parseHexInt(s[3]),
      ))
    else: raise newException(Defect, "unparsed line: " & ln)

  expect result.files.len == counters[0]
  expect result.structs.len == counters[1]
  expect result.functions.len == counters[2]
  expect result.variables.len == counters[3]
  expect result.lines.len == counters[4]
