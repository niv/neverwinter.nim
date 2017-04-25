import shared, debugprinter, neverwinter.tlk, parsecsv

const SupportedFormatsSimple = ["tlk", "json", "csv", "debug"]
const SupportedFormats = {
  "json": @["json"],
  "tlk": @["tlk"],
  "csv": @["csv"],
  "review": @["review"],
  "debug": @["debug"]
}.toTable

let args = DOC """
Convert talk table to/from various formats.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """


The "debug" format dumps a tree-like view of the actual file structure.
This is useful to diff two files in a more human-readable way than resorting
to binary diffing.

The "review" format includes a single line for each tlk entry, containing:
  <strref> <lengthOfSoundResRef> <lengthOfText>
Only entries with data are dumped; empty entries (no sound, no text) are
ignored regardless of the FLAGS field set in the tlk.

Notes:
  * .json is *always* read and written as UTF-8, as the spec requires.
  * .review is output-only.
  * .debug is output-only.
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

  -p, --pretty                Pretty output (json only)

  --language LANG             Override language ID when writing files.
                              You can specify by enum const ("English"), or
                              by ID. (see languages.nim)

  --csv-separator SEP         What to use as separator for CSV cells [default: ,]

  --review-with-text          Only emit entries containing a text (and optionally sound).
  --review-only-text          Only emit entries containing a text, not sound or both,
                              regardless of FLAGS in the tlk.
  --review-only-sound         Only emit entries containing a sound, not text or both,
                              regardless of FLAGS in the tlk.
  $OPT
"""

if [args["--review-with-text"], args["--review-only-text"], args["--review-only-sound"]].
    filterIt(it == true).len > 1:
  raise newException(ValueError, "review-* options are mutually exclusive")

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

    if entry.hasValue:
      result[e["id"].getNum.StrRef] = entry

proc writeJson(fs: Stream, tlk: SingleTlk) =
  setNativeEncoding("UTF-8") # json is always utf-8

  var j = newJObject()
  j["language"] = %tlk.language.int
  j["entries"] = newJArray()

  for e in (0..tlk.highest()).withProgressBar():
    let opt = tlk[e.StrRef]
    if opt.isSome and opt.get().hasValue:
      var jj = newJObject()
      jj["id"] = %e
      jj["text"] = %opt.get().text
      if opt.get().soundResRef != "": jj["sound"] = %opt.get().soundResRef
      if opt.get().soundLength != 0.0: jj["soundLen"] = %opt.get().soundLength
      j["entries"].add jj

  fs.write(if args["--pretty"]: j.pretty else: $j)

proc readCsv(s: Stream): SingleTlk =
  result = newSingleTlk()

  var p: CsvParser
  p.open(input = s, filename = inputfile, separator = ($args["--csv-separator"])[0])
  while p.readRow():
    var e = TlkEntry()
    let id = p.row[0].parseInt.StrRef
    e.soundResRef = p.row[1].strip(leading = true, trailing = true, chars = Whitespace)
    if p.row[2] != "": e.soundLength = p.row[2].parseFloat
    e.text = p.row[3]
    if e.hasValue:
      result[id] = e
  p.close()

proc writeCsv(s: Stream, tlk: SingleTlk) =
  proc quote(s: string): string =
    "\"" & s.replace("\"", "\"\"") & "\""

  for e in (0..tlk.highest()):
    let ee = tlk[e.StrRef]
    if ee.isSome:
      let eee = ee.get()
      if eee.hasValue:
        s.writeLine([
          $e, # id
          if eee.soundResRef != "": eee.soundResRef.quote() else: "",
          if eee.soundLength != 0.0: $eee.soundLength else: "",
          eee.text.quote()
        ].join(($args["--csv-separator"])[0..0]))

proc writeReview(s: Stream, tlk: SingleTlk) =
  for e in (0..tlk.highest()):
    let ee = tlk[e.StrRef]
    if ee.isSome:
      let eee = ee.get()
      if eee.hasValue:
        let onlyText = args["--review-only-text"]
        let onlySound = args["--review-only-sound"]
        let emit = (not onlyText and not onlySound) or
                   (onlyText and eee.text.len > 0 and eee.soundResRef.len == 0) or
                   (onlySound and eee.text.len == 0 and eee.soundResRef.len > 0)

        if emit:
          s.writeLine([
            $e,
            $eee.soundResRef.len,
            $eee.text.len
          ].join(" "))

proc writeDebug(s: Stream, tlk: SingleTlk) =
  ## Writes a "debug" representation of the file that can be diffed easily.
  input.setPosition(0)

  var dbg = newDebugPrinter(input, s)

  var stringCount: int32 = 0
  var stringEntriesOffset: int32 = 0
  dbg.nest "Header":
    dbg.emit "FileType", input.readStr(4)
    dbg.emit "FileVersion", input.readStr(4)
    dbg.emit "LanguageID", input.readInt32()
    stringCount = input.readInt32()
    stringEntriesOffset = input.readInt32()
    dbg.emit "StringCount", stringCount
    dbg.emit "StringEntriesOffset", stringEntriesOffset

  dbg.nest "StringDataTable":
    for i in 0..<stringCount:
      dbg.nest $i:
        let flags = input.readInt32()
        let resRef = input.readStr(16) # .strip(leading=false,trailing=true,chars={'\0'})
        let volVar = input.readInt32()
        let pitchVar = input.readInt32()
        let offset = input.readInt32()
        let strSz = input.readInt32()
        let sndLen = input.readFloat32()
        dbg.emit "Flags", flags
        dbg.emit "ResRef", resRef
        dbg.emit "VolumeVariance", volVar
        dbg.emit "PitchVariance", pitchVar
        dbg.emit "Offset", offset
        dbg.emit "StringSize", strSz
        dbg.emit "SoundLength", sndLen

var state: SingleTlk

case informat:
of "tlk":    state = input.readSingleTlk()
of "json":   state = input.readJson()
of "csv":    state = input.readCsv()
else: quit("Unsupported informat: " & informat)

state.useCache = false

if args["--language"]:
  let slang = $args["--language"]
  if slang.isDigit():
    let id = slang.parseInt
    state.language = id.Language
    if state.language.ord != id: raise newException(ValueError, "Not a valid language id (see languages.nim)")
  else:
    state.language = parseEnum[Language]($args["--language"])

case outformat:
of "tlk":    output.write(state)
of "json":   output.writeJson(state)
of "csv":    output.writeCsv(state)
of "review": output.writeReview(state)
of "debug":  output.writeDebug(state)
else: quit("Unsupported outformat: " & outformat)
