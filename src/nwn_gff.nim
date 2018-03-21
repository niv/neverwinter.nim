import shared

const GffExtensions = @[
  "utc", "utd", "ute", "uti", "utm", "utp", "uts", "utt", "utw",
  "git", "are", "gic", "mod", "ifo", "fac", "dlg", "itp", "bic",
  "jrl", "gff", "gui"
]

const SupportedFormatsSimple = ["gff", "json"]
const SupportedFormats = {
  "json": @["json"],
  "gff": GffExtensions
}.toTable

let args = DOC """
Convert gff data to json.

The json data is compatible with https://github.com/niv/nwn-lib.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """


Input and output default to stdin/stdout respectively.

Usage:
  $0 [options]
  $USAGE

Options:
  -i IN                       Input file [default: -]
  -l INFORMAT                 Input format [default: autodetect]

  -o OUT                      Output file [default: -]
  -k OUTFORMAT                Output format [default: autodetect]

  -p, --pretty                Pretty output (json only)
  $OPT
"""

let inputfile   = $args["-i"]
let outputfile  = $args["-o"]
let informat    = ensureValidFormat($args["-l"], inputfile, SupportedFormats)
let outformat   = ensureValidFormat($args["-k"], outputfile, SupportedFormats)

let input  = if $args["-i"] == "-": newFileStream(stdin) else: newFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: newFileStream($args["-o"], fmWrite)

var state: GffRoot

case informat:
of "gff":    state = input.readGffRoot(false)
of "json":   state = input.parseJson(inputfile).gffRootFromJson()
else: quit("Unsupported informat: " & informat)

case outformat:
of "gff":    output.write(state)
of "json":
             let j = state.toJson()
             output.write(if args["--pretty"]: j.pretty() else: $j)
             output.write("\c\L")
else: quit("Unsupported outformat: " & outformat)
