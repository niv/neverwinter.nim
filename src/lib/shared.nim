import strutils, algorithm, os, streams, json, sequtils, logging
export strutils, algorithm, os, streams, json, sequtils, logging

import neverwinter.resman,
  neverwinter.resref,
  neverwinter.key,
  neverwinter.resfile,
  neverwinter.resmemfile,
  neverwinter.resdir,
  neverwinter.erf

export resman,
  resref,
  key,
  resfile,
  resmemfile,
  resdir,
  erf

import termutil
export termutil

addHandler newFileLogger(stderr, fmtStr = "$levelid [$datetime] ")

hideCursor()
system.addQuitProc do () -> void {.noconv.}:
  resetAttributes()
  showCursor()

import docopt as docopt_internal
export docopt_internal

const GlobalOpts = """

  --root ROOT                 Set NWN root
  --keys KEYS                 Key files loaded in ascending order [default: nwn_base,nwn_base_loc,xp1,xp2,xp3,xp2patch]
  --ovr BOOL                  Include ovr/ in resman [default: true]
  -v --verbose                Turn on debug logging"""

var Args: Table[string, docopt_internal.Value]

proc DOC*(body: string): Table[string, docopt_internal.Value] =
  let body2 = body.replace("$0", getAppFilename().extractFilename()).
                   replace("$OPT", GlobalOpts)

  result = docopt_internal.docopt(body2)
  Args = result

  if Args["--verbose"]: setLogFilter(lvlDebug) else: setLogFilter(lvlInfo)

proc getInOutFilesFromParams*(allowOverwrite = false): tuple[i: Stream, o: Stream] =
  ## Used by command line utilities to transform simple in/out parameters to
  ## file streams.

  result.i = newFileStream(stdin)
  result.o = newFileStream(stdout)

  if paramCount() > 0 and paramStr(1) != "-":
    result.i = newFileStream(paramStr(1))
    doAssert(result.i != nil, "Could not open file for reading: " & paramStr(1))

  if paramCount() > 1 and paramStr(2) != "-":
    if not allowOverwrite and fileExists(paramStr(2)):
      quit("outfile exists, aborting for your own safety.")

    result.o = newFileStream(paramStr(2), fmWrite)
    doAssert(result.o != nil, "Could not open file for writing: " & paramStr(2))

proc findNwnRoot*(): string =
  if Args["--root"]:
    result = $Args["--root"]
  else:
    when defined(macosx):
      const settingsFile = r"~/Library/Application Support/Beamdog Experience/settings.json".expandTilde
    elif defined(linux):
      const settingsFile = r"~/.config/Beamdog Client/settings.json".expandTilde
    else: {.fatal: "Unsupported os for findNwnRoot"}

    let data = readFile(settingsFile)
    let j = data.parseJson
    doAssert(j.hasKey("folders"))
    doAssert(j["folders"].kind == JArray)
    var fo = j["folders"].mapIt(it.str / "00785")
    fo.keepItIf(dirExists(it))
    if fo.len > 0: result = fo[0]

  if result == "" or not dirExists(result): raise newException(ValueError, "Could not locate NWN")
  debug "NWN root: ", result

proc newBasicResMan*(root: string, language = "en", cacheSize = 0): ResMan =
  ## Sets up a resman that defaults to what 1.8 looks like.
  ## Will load an additional language directory, if language is given.

  let keys = ($Args["--keys"]).split(",").mapIt(it.strip)

  let tryOther = language != "en"
  let otherLangRoot = root / "lang" / language

  doAssert(not tryOther or dirExists(otherLangRoot), "language " & otherLangRoot &
    " not found")

  proc loadKey(into: ResMan, key: string) =
    let fn = if tryOther and fileExists(otherLangRoot / "data" / key & ".key"):
               otherLangRoot / "data" / key & ".key"
             else: root / "data" / key & ".key"

    let ktfn = newFileStream(fn)
    doAssert(ktfn != nil, "key not found or inaccessible: " & fn)

    debug("  key: ", fn)

    let kt = readKeyTable(ktfn, fn) do (fn: string) -> Stream:
      let otherBifFn = otherLangRoot / "data" / fn.extractFilename()
      let bifFn = if tryOther and fileExists(otherBifFn): otherBifFn
                  else: root / fn

      debug("    bif: ", bifFn)
      result = newFileStream(bifFn)
      doAssert(result != nil, "bif not found or inaccessible: " & bifFn)

    into.add(kt)

  debug "new resman: ", language
  result = resman.newResMan(cacheSize)

  for k in keys: result.loadKey(k)

  if Args["--ovr"]:
    let c = newResDir(root / "ovr")
    debug "  ", c
    result.add(c)
  if tryOther and Args["--ovr"]:
    let c = newResDir(otherLangRoot / "ovr")
    debug "  ", c
    result.add(c)

