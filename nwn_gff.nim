import std/[cpuinfo]
import taskpools

import shared

const SupportedFormatsSimple = ["gff", "json"]
const SupportedFormats = {
  "json": @["json"],
  "gff": GffExtensions
}.toTable

const ArgsHelp = """
Convert gff data to json.

The json data is compatible with https://github.com/niv/nwn-lib.

Supported input/output formats: """ & SupportedFormatsSimple.join(", ") & """


Input and output default to stdin/stdout respectively.

With -c, every supported file in <dir> is converted in parallel instead. Since
there is no single output filename to autodetect the format from, -k is required.
Target artifacts are written next to each source file, unless overridden with -d.
The SQLite options name a directory in that mode, holding one <file>.sqlite each.

Usage:
  $0 [options]
  $0 [options] -c [-R] [-d DIR] <dir>
  $USAGE

Options:
  -i IN                       Input file [default: -]
  -l INFORMAT                 Input format [default: autodetect]
  --in-sqlite FILE            Squash the given SQLite database into the struct
                              after reading IN. Only some GFF formats support
                              embedded SQLite databases. This will clobber any
                              SQLite data already present in IN.

  -o OUT                      Output file [default: -]
  -k OUTFORMAT                Output format [default: autodetect]
  --out-sqlite FILE           Extract the SQLite contained in the operated-on
                              file. Only some GFF formats support embedded SQLite
                              databases.

  -c                          Convert all files in <dir> instead of a single file.
                              Mutually exclusive with -i and -o.
  -d DIR                      When converting a directory, write all artifacts into DIR.
  -R                          Recurse into subdirectories.
  -j N                        Parallel execution (default: all CPUs).

  -p, --pretty                Pretty output (json only)
  $OPT
"""

let args = DOC ArgsHelp

type
  GlobalState = object
    args: OptArgs
    pretty: bool
    inSqliteArg: string
    outSqliteArg: string
    outDir: string
    informatArg: string
    outformatArg: string
    recurse: bool

var gState: GlobalState

gState = GlobalState(
  args: args,
  pretty: args["--pretty"].to_bool,
  informatArg: $args["-l"],
  outformatArg: $args["-k"],
  inSqliteArg: if args["--in-sqlite"]: $args["--in-sqlite"] else: "",
  outSqliteArg: if args["--out-sqlite"]: $args["--out-sqlite"] else: "",
  outDir: if args["-d"]: $args["-d"] else: "",
  recurse: args["-R"].to_bool
)


proc postProcessJson(j: JsonNode) =
  ## Post-process json before emitting: We make sure to re-sort.
  if j.kind == JObject:
    for k, v in j.fields: postProcessJson(v)
    j.fields.sort do (a, b: auto) -> int: cmpIgnoreCase(a[0], b[0])
  elif j.kind == JArray:
    for e in j.elems: postProcessJson(e)

proc convert(inputfile, outputfile, inSqlite, outSqlite, informat, outformat: string, pretty: bool) =

  # Always fully read input file, so we can write back to the same file.
  let input = if inputfile == "-":
    newStringStream(stdin.readAll())
  else:
    newStringStream(readFile(inputfile))

  var state: GffRoot

  case informat:
  of "gff":    state = input.readGffRoot(false)
  of "json":   state = input.parseJson(inputfile).gffRootFromJson()
  else: raise newException(ValueError, "Unsupported informat: " & informat)

  if inSqlite != "":
    let blob = compress(readFile(inSqlite), Algorithm.Zstd, makeMagic("SQL3"))
    state["SQLite", GffStruct] = newGffStruct(10)
    state["SQLite", GffStruct]["Data", GffVoid] = blob.GffVoid
    state["SQLite", GffStruct]["Size", GffDword] = blob.len.GffDword

  if outSqlite != "":
    if state.hasField("SQLite", GffStruct) and state["SQLite", GffStruct].hasField("Data", GffVoid):
      let blob = state["SQLite", GffStruct]["Data", GffVoid].string
      writeFile(outSqlite, decompress(blob, makeMagic("SQL3")))

  let output = if outputfile == "-": newFileStream(stdout) else: openFileStream(outputfile, fmWrite)

  case outformat:
  of "gff":    output.write(state)
  of "json":
               let j = state.toJson()
               postProcessJson(j)
               output.write(if pretty: j.pretty() else: $j)
               output.write("\n")
  else: raise newException(ValueError, "Unsupported outformat: " & outformat)

  output.close()

var threadInitialised {.threadvar.}: bool

proc tryConvert(state: ptr GlobalState, inputfile, outputfile, inSqliteCandidate, outSqlite, informat, outformat: string): string {.gcsafe, raises: [].} =
  ## Converts one file on a worker thread, returning the error message on failure.
  {.cast(gcsafe).}:
    try:
      if not threadInitialised:
        threadInitialised = true
        initThreadTLS(state.args)

      let inSqlite = if inSqliteCandidate != "" and fileExists(inSqliteCandidate): inSqliteCandidate else: ""

      convert(inputfile, outputfile, inSqlite, outSqlite, informat, outformat, state.pretty)
    except Exception as e:
      result = e.msg

if args["-c"]:
  if $args["-i"] != "-" or $args["-o"] != "-":
    quit("-c cannot be combined with -i or -o; use -d to redirect output.")

  for opt in ["-d", "--in-sqlite", "--out-sqlite"]:
    if args[opt] and not dirExists($args[opt]):
      quit("Directory given in " & opt & " must exist when using -c.")

  let inFmtGlob = if gState.informatArg != "autodetect": gState.informatArg else: ""
  let convertibleExts =
    if inFmtGlob == "": SupportedFormats.values.toSeq.concat.toHashSet
    else: SupportedFormats[inFmtGlob].toHashSet

  proc canConvert(path: string): bool =
    splitFile(path).ext.strip(true, false, {'.'}) in convertibleExts

  proc collect(into: var seq[string], dir: string) =
    for kind, path in walkDir(dir, checkDir = true):
      case kind
      of pcFile:
        if canConvert(path): into.add(path)
      of pcDir:
        if gState.recurse: collect(into, path)
      else: discard

  proc outFileName(inputfile, outFmt: string): string =
    let name = extractFilename(inputfile)
    let isJson = name.endsWith(".json")
    let stem =
      if outFmt == "json": (if isJson: name else: name & ".json")
      elif isJson: name[0 ..< name.len - ".json".len]
      else: name
    if gState.outDir != "": gState.outDir / stem else: splitFile(inputfile).dir / stem

  proc sqliteName(dir, inputfile: string): string =
    if dir == "": "" else: dir / extractFilename(inputfile) & ".sqlite"

  let dir = $args["<dir>"]
  if not dirExists(dir):
    fatal dir, ": Does not exist or is not a directory"
    quit(1)

  var queue: seq[string]
  collect(queue, dir)

  let numThreads = if args["-j"]: parseInt($args["-j"]) else: countProcessors()
  var pool = Taskpool.new(numThreads = max(1, numThreads))
  
  var pending = newSeq[FlowVar[string]](queue.len)
  for idx, inputfile in queue:
    let iFmt = ensureValidFormat(gState.informatArg, inputfile, SupportedFormats)
    let oFmt = if gState.outformatArg != "autodetect": gState.outformatArg else: (if iFmt == "json": "gff" else: "json")
    let outF = outFileName(inputfile, oFmt)
    let inSql = sqliteName(gState.inSqliteArg, inputfile)
    let outSql = sqliteName(gState.outSqliteArg, inputfile)
    pending[idx] = pool.spawn tryConvert(addr gState, inputfile, outF, inSql, outSql, iFmt, oFmt)

  var errors = 0
  for idx, fv in pending:
    let err = sync(fv)
    if err == "":
      debug format("[$#/$#] $#: Success", idx + 1, queue.len, queue[idx])
    else:
      inc errors
      error queue[idx], ": ", err

  pool.shutdown()

  info format("$# successful, $# errored", queue.len - errors, errors)

  if errors > 0:
    quit(1)

else:
  let informat = ensureValidFormat(gState.informatArg, $args["-i"], SupportedFormats)
  let outformat = ensureValidFormat(gState.outformatArg, $args["-o"], SupportedFormats)
  convert($args["-i"], $args["-o"], gState.inSqliteArg, gState.outSqliteArg, informat, outformat, gState.pretty)
