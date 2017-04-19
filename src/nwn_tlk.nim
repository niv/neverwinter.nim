import shared, neverwinter.tlk

const SupportedFormatsSimple = ["tlk", "json", "csv"]
const SupportedFormats = {
  "json": @["json"],
  "tlk": @["tlk"],
  # "csv": @["csv"],
  # "txt": @["txt"]
}.toTable

let args = DOC """
Convert talk table to/from various formats.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """

Note that .json is *always* read and written as UTF-8, as the spec requires.

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

import neverwinter.tlk

let input  = if $args["-i"] == "-": newFileStream(stdin) else: newFileStream($args["-i"])
let output = if $args["-o"] == "-": newFileStream(stdout) else: newFileStream($args["-o"], fmWrite)

proc readJson(fs: Stream): SingleTlk =
  setNativeEncoding("UTF-8") # json is always utf-8

  let j = fs.parseJson("<input>")
  doAssert(j.hasKey("language") and j["language"].kind == JInt, "'language' missing or invalid")
  doAssert(j.hasKey("entries") and j["entries"].kind == JArray, "'entries' missing or invalid")

  result = newSingleTlk()

  result.language = j["language"].getNum.Language

  for e in j["entries"].getElems.withProgressBar():
    doAssert(e.hasKey("id") and e["id"].kind == JInt)
    doAssert(e.hasKey("text") and e["text"].kind == JString)
    doAssert(not e.hasKey("sound") or e["sound"].kind == JString)
    doAssert(not e.hasKey("soundLen") or e["soundLen"].kind == JFloat)

    var entry = TlkEntry()
    entry.text = e["text"].str
    if e.hasKey("sound"): entry.soundResRef = e["sound"].str
    if e.hasKey("soundLen"):
      doAssert(e["soundLen"].getFNum >= 0.0)
      entry.soundLength = e["soundLen"].getFNum

    result[e["id"].getNum.StrRef] = entry

proc writeJson(fs: Stream, tlk: SingleTlk) =
  setNativeEncoding("UTF-8") # json is always utf-8

  var j = newJObject()
  j["language"] = %tlk.language.int
  j["entries"] = newJArray()

  for e in (0..tlk.highest()).withProgressBar():
    let opt = tlk[e.StrRef]
    if opt.isSome:
      var jj = newJObject()
      jj["id"] = %e
      jj["text"] = %opt.get().text
      if opt.get().soundResRef != "": jj["sound"] = %opt.get().soundResRef
      if opt.get().soundLength != 0.0: jj["soundLen"] = %opt.get().soundLength
      j["entries"].add jj

  fs.write(if args["--pretty"]: j.pretty else: $j)

var state: SingleTlk

case informat:
of "tlk":    state = input.readSingleTlk()
of "json":   state = input.readJson()
else: quit("Unsupported informat: " & informat)

case outformat:
of "tlk":    output.write(state)
of "json":   output.writeJson(state)
else: quit("Unsupported outformat: " & outformat)
