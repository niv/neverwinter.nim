import shared, neverwinter/gffnwnt

const SupportedFormatsSimple = ["gff", "json", "nwnt"]
const SupportedFormats = {
  "json": @["json"],
  "nwnt": @["nwnt"],
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

let input  = if $args["-i"] == "-": newFileStream(stdin) else: openFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: openFileStream($args["-o"], fmWrite)

var state: GffRoot

case informat:
of "gff":    state = input.readGffRoot(false)
of "json":   state = input.parseJson(inputfile).gffRootFromJson()
of "nwnt":   state = input.gffRootFromNwnt()
else: quit("Unsupported informat: " & informat)

proc postProcessJson(j: JsonNode) =
  ## Post-process json before emitting: We make sure to re-sort.
  if j.kind == JObject:
    for k, v in j.fields: postProcessJson(v)
    j.fields.sort do (a, b: auto) -> int: cmpIgnoreCase(a[0], b[0])
  elif j.kind == JArray:
    for e in j.elems: postProcessJson(e)

case outformat:
of "gff":    output.write(state)
of "json":
             let j = state.toJson()
             postProcessJson(j)
             output.write(if args["--pretty"]: j.pretty() else: $j)
             output.write("\c\L")
of "nwnt":
             output.toNwnt(state)
else: quit("Unsupported outformat: " & outformat)