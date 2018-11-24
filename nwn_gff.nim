import shared

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

  --normalize-floats N        Normalize floating point values to 0 < N <= 32
                              decimal places (json only) [default: 16].
  -p, --pretty                Pretty output (json only)
  $OPT
"""

let inputfile   = $args["-i"]
let outputfile  = $args["-o"]
let informat    = ensureValidFormat($args["-l"], inputfile, SupportedFormats)
let outformat   = ensureValidFormat($args["-k"], outputfile, SupportedFormats)

let input  = if $args["-i"] == "-": newFileStream(stdin) else: newFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: newFileStream($args["-o"], fmWrite)

import patched_json
jsonNormalizeFloatsTo parseInt($args["--normalize-floats"])

var state: GffRoot

case informat:
of "gff":    state = input.readGffRoot(false)
of "json":   state = input.parseJson(inputfile).gffRootFromJson()
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
else: quit("Unsupported outformat: " & outformat)
