import shared, neverwinter.twoda, parsecsv

const SupportedFormats = {
  "2da": @["2da"],
  "csv": @["csv"]
}.toTable

let args = DOC """
Converts twoda tables from/to various fromats.

Input and output default to stdin/stdout respectively.

TwoDA format:
  2da output will always be formatted nicely.

  The parser is lenient: It will accept malformed input in exactly the same way
  that nwserver works; so any file shunted through this utility will be formatted
  nicely afterwards, but may lose data if the formatting was broken in the first
  place.

Usage:
  $0 [options]
  $USAGE

Options:
  -i IN                       Input file [default: -]
  -l INFORMAT                 Input format [default: autodetect]

  -o OUT                      Output file [default: -]
  -k OUTFORMAT                Output format [default: autodetect]

  --csv-separator SEP         What to use as separator for CSV cells [default: ,]
  $OPT
"""

let inputfile   = $args["-i"]
let outputfile  = $args["-o"]
let informat    = ensureValidFormat($args["-l"], inputfile, SupportedFormats)
let outformat   = ensureValidFormat($args["-k"], outputfile, SupportedFormats)
doAssert(($args["--csv-separator"]).len > 0, "--csv-separator too short")

let input  = if $args["-i"] == "-": newFileStream(stdin) else: newFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: newFileStream($args["-o"], fmWrite)

proc readCsv(s: Stream): TwoDA =
  new(result)
  result.rows = newSeq[Row]()

  var p: CsvParser
  p.open(input = s, filename = inputfile, separator = ($args["--csv-separator"])[0])
  p.readHeaderRow()
  result.columns = p.headers
  while p.readRow():
    result.rows.add(p.row.mapIt(some it))

  p.close()

proc writeCsv(s: Stream, tbl: TwoDA) =
  proc joinRow(r: Row): string =
    proc quoteOrStar(s: Cell): string =
      if s.isSome:
        let ss = s.get()
        if ss.find(Whitespace) != -1: ("\"" & ss & "\"")
        elif ss == "": "\"\""
        else: ss
      else:
        "****"
    r.mapIt(it.quoteOrStar).join(($args["--csv-separator"])[0..0])

  s.writeLine(tbl.columns.mapIt(some it).joinRow())
  for r in tbl.rows: s.writeLine(r.joinRow())

var state: TwoDA

case informat:
of "2da":    state = input.readTwoDA()
of "csv":    state = input.readCsv()
else: quit("Unsupported informat: " & informat)

case outformat:
of "2da":    output.write(state)
of "csv":   output.writeCsv(state)
else: quit("Unsupported outformat: " & outformat)
