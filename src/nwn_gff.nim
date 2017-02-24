import shared

const GffExtensions = @[
  "utc", "utd", "ute", "uti", "utm", "utp", "uts", "utt", "utw",
  "git", "are", "gic", "mod", "ifo", "fac", "ssf", "dlg", "itp",
  "bic", "jrl", "gff", "gui"
]

const SupportedFormatsSimple = ["gff", "json"]
const SupportedFormats = {
  "json": @["json"],
  "gff": GffExtensions
}.toTable

let args = DOC """
Convert gff data to json.

The json data is compatible with what https://github.com/niv/nwn-lib works with.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """


Usage:
  $0 [options]
  $0 -h | --help

Options:
  -i IN                       Input file [default: stdin]
  -l INFORMAT                 Input format [default: autodetect]

  -o OUT                      Output file [default: stdout]
  -k OUTFORMAT                Output format [default: autodetect]

  -p, --pretty                Pretty output (json only)
  $OPT
"""

let inputfile   = $args["-i"]
let outputfile  = $args["-o"]
var informat    = $args["-l"]
var outformat   = $args["-k"]

# attempt to detect format based on:
# - cli param
# - filename
# - maybe later: peeking the stream

if informat == "autodetect" and inputfile != "stdin":
  let ext = splitFile(inputfile).ext.strip(true, false, {'.'})
  for fmt, exts in SupportedFormats:
    if exts.contains(ext):
      informat = fmt
      break
if informat == "autodetect":
  quit("infile: cannot detect file format from filename: " & inputfile)
if not SupportedFormats.hasKey(informat):
  quit("informat: not supported format " & informat)

if outformat == "autodetect" and outputfile != "stdout":
  let ext = splitFile(outputfile).ext.strip(true, false, {'.'})
  for fmt, exts in SupportedFormats:
    if exts.contains(ext):
      outformat = fmt
      break
if outformat == "autodetect":
  quit("outformat: cannot detect file format from filename: " & outputfile)
if not SupportedFormats.hasKey(outformat):
  quit("outformat: not supported format " & outformat)

let input  = if $args["-i"] == "stdin": newFileStream(stdin) else: newFileStream($args["-i"])
let output = if $args["-o"] == "stdout": newFileStream(stdout) else: newFileStream($args["-o"], fmWrite)

if informat == "gff" and outformat == "json":
  let j = input.readGffRoot(false).toJson()
  output.write(if args["--pretty"]: j.pretty() else: $j)
  output.write("\c\L")

elif informat == "json" and outformat == "gff":
  let j = input.parseJson(inputfile).gffRootFromJson()
  output.write(j)
else:
  quit("Unsupported transformation: " & informat & " -> " & outformat)
