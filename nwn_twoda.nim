import shared, neverwinter/twoda, parsecsv

const SupportedFormats = {
  "2da": @["2da"],
  "csv": @["csv"]
}.toTable

let args = DOC """
Converts twoda tables from/to various formats.

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

  --minify                    Minifies 2da output using minimal padding instead of using pretty formatting.

  --csv-separator SEP         What to use as separator for CSV cells [default: ,]

  --write-id-column           Generate ID column when exporting non-2da formats.
                              Not all formats might be supported. Note that the ID column
                              is ignored by the game and the generated column is only
                              for your convenience.
                              Thus, when reading files generated with this option, the ID column
                              is also discarded. IDs are assigned based on order of appearance.

  $OPT
"""

let inputfile   = $args["-i"]
let outputfile  = $args["-o"]
let informat    = ensureValidFormat($args["-l"], inputfile, SupportedFormats)
let outformat   = ensureValidFormat($args["-k"], outputfile, SupportedFormats)
doAssert(($args["--csv-separator"]).len > 0, "--csv-separator too short")

let input  = if $args["-i"] == "-": newFileStream(stdin) else: openFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: openFileStream($args["-o"], fmWrite)

proc readCsv(s: Stream): TwoDA =
  new(result)
  result.rows = newSeq[Row]()

  var p: CsvParser
  p.open(input = s, filename = inputfile, separator = ($args["--csv-separator"])[0])
  p.readHeaderRow()
  let haveid = p.headers[0].toLowerAscii() == "id"
  result.columns = if haveid: p.headers[1..<p.headers.len] else: p.headers
  while p.readRow():
    let row = if haveId: p.row[1..<p.row.len] else: p.row
    result.rows.add(row.mapIt(some it))

  p.close()

proc writeCsv(s: Stream, tbl: TwoDA) =
  let writeid = args["--write-id-column"]
  proc joinRow(r: Row): string =
    proc quoteOrStar(s: Cell): string =
      if s.isSome:
        let ss = s.get()
        if ss.find(Whitespace) != -1 or ss.find($args["--csv-separator"]) != -1: ("\"" & ss & "\"")
        elif ss == "": "\"\""
        else: ss
      else:
        "****"
    r.mapIt(it.quoteOrStar).join(($args["--csv-separator"])[0..0])

  let columns = if writeid: concat(@["ID"], tbl.columns)
                else: tbl.columns

  s.writeLine(columns.mapIt(some it).joinRow())
  for idx, r in tbl.rows:
    let row = if writeid: concat(@[some $idx], r) else: r
    s.writeLine(row.joinRow())

var state: TwoDA

case informat:
of "2da":    state = input.readTwoDA()
of "csv":    state = input.readCsv()
else: quit("Unsupported informat: " & informat)

case outformat:
of "2da":    output.writeTwoDA(state, args["--minify"])
of "csv":   output.writeCsv(state)
else: quit("Unsupported outformat: " & outformat)
