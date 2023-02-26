import shared, neverwinter/ssf, parsecsv

const SupportedFormatsSimple = ["ssf", "csv"]
const SupportedFormats = {
  "ssf": @["ssf"],
  "csv": @["csv"]
}.toTable

let args = DOC """
Convert SSF tables to/from various formats.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """

Notes:
  * Input and output default to stdin/stdout respectively ("-").
  * You cannot pipe the input file into itself (this will result in a
    zero-length file).

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

# Always fully read input file.
let input  = if $args["-i"] == "-":
  newStringStream(stdin.readAll())
else:
  newStringStream(readFile(inputfile))

let output = if $args["-o"] == "-": newFileStream(stdout) else: openFileStream($args["-o"], fmWrite)

proc readCsv(s: Stream): SsfRoot =
  result = newSsf()

  var p: CsvParser
  p.open(input = s, filename = inputfile, separator = ($args["--csv-separator"])[0])
  while p.readRow():
    var e = SsfEntry()
    let idx = p.row[0].parseInt.StrRef
    e.resref = p.row[1].strip(leading = true, trailing = true, chars = Whitespace)
    e.strref = uint32 p.row[2].parseUInt()
    result.entries.add(e)
  p.close()

proc writeCsv(s: Stream, ssf: SsfRoot) =
  proc quote(s: string): string =
    "\"" & s.replace("\"", "\"\"") & "\""

  for idx, e in ssf.entries:
    s.writeLine([
      $idx,
      if e.resref != "": e.resref.quote() else: "",
      $e.strref
    ].join(($args["--csv-separator"])[0..0]))

var state: SsfRoot

case informat:
of "ssf":    state = input.readSsf()
of "csv":    state = input.readCsv()
else: quit("Unsupported informat: " & informat)

case outformat:
of "ssf":    output.writeSsf(state)
of "csv":    output.writeCsv(state)
else: quit("Unsupported outformat: " & outformat)
