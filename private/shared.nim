import strutils, algorithm, os, streams, json, sequtils, logging, times, tables, sets, strutils
export strutils, algorithm, os, streams, json, sequtils, logging, times, tables, sets, strutils

import neverwinter/util, neverwinter/resman,
  neverwinter/resref, neverwinter/key,
  neverwinter/resfile, neverwinter/resmemfile, neverwinter/resdir,
  neverwinter/resnwsync,
  neverwinter/erf, neverwinter/gff, neverwinter/gffjson,
  neverwinter/languages, neverwinter/compressedbuf,
  neverwinter/exo

# The things we do to cut down import hassle in tools.
# Should clean this up at some point and let the utils deal with it.
export util, resman, resref, key, resfile, resmemfile, resdir, erf, gff, gffjson,
  languages, compressedbuf, exo

import terminal, progressbar, version
export progressbar

when defined(profiler):
  import nimprof

const GffExtensions* = @[
  "utc", "utd", "ute", "uti", "utm", "utp", "uts", "utt", "utw",
  "git", "are", "gic", "ifo", "fac", "dlg", "itp", "bic",
  "jrl", "gff", "gui"
]

addHandler newFileLogger(stderr, fmtStr = "$levelid [$datetime] ")

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  if isatty(stdout):
    hideCursor()
    exitprocs.addExitProc do () -> void {.noconv.}:
      resetAttributes()
      showCursor()
else:
  if isatty(stdout):
    hideCursor()
    addQuitProc do () -> void {.noconv.}:
      resetAttributes()
      showCursor()

import docopt as docopt_internal
export docopt_internal

const GlobalUsage = """
  $0 -h | --help
  $0 --version
""".strip

# Options common to ALL utilities
let GlobalOpts = """

Logging:
  --verbose                   Turn on debug logging
  --quiet                     Turn off all logging except errors
  --version                   Show program version and licence info

Encoding:
  --nwn-encoding CHARSET      Sets the nwn encoding [default: """ & getNwnEncoding() & """]
  --other-encoding CHARSET    Sets the "other" file formats encoding, where
                              supported; see docs. Defaults to your current
                              shell/platform charset: [default: """ & getNativeEncoding() & """]
Resources:
  --add-restypes TUPLES       Add a restype. TUPLES is a comma-separated list
                              of colon-separated restypes. You do not need to do this
                              unless you want to handle files NWN does not know about
                              yet.
                              Example: txt:10,mdl:2002
"""

# Options common to utilities working with a resman.
let ResmanOpts = """

Resman:
  --root ROOT                 Override NWN root (autodetection is attempted)
  --userdirectory USERDIR     Override NWN user directory (autodetection is attempted)

  --no-keys                   Do not load keys into resman (ignore --keys)
  --keys KEYS                 key files to load (from root:data/)
                              [default: autodetect]
                              Will auto-detect if you are using a 1.69 or 1.8
                              layout.
  --no-ovr                    Do not load ovr/ in resman

  --language LANG             Load language overrides [default: en]

  --manifests MANIFESTS       Load comma-separated NWSync manifests [default: ]
  --erfs ERFS                 Load comma-separated erf files [default: ]
  --dirs DIRS                 Load comma-separated directories [default: ]
""" & GlobalOpts

var Args: Table[string, docopt_internal.Value]

proc DOC*(body: string): Table[string, docopt_internal.Value] =
  let body2 = body.replace("$USAGE", GlobalUsage).
                   replace("$0", getAppFilename().extractFilename()).
                   replace("$OPTRESMAN", ResmanOpts).
                   replace("$OPT", GlobalOpts)

  result = docopt_internal.docopt(body2)
  Args = result

  if Args["--version"]:
    printVersion()
    quit()

  if Args.hasKey("--verbose") and Args["--verbose"]: setLogFilter(lvlDebug)
  elif Args.hasKey("--quiet") and Args["--quiet"]: setLogFilter(lvlError)
  else: setLogFilter(lvlInfo)

  setNwnEncoding($Args["--nwn-encoding"])
  setNativeEncoding($Args["--other-encoding"])

  debug("NWN file encoding: " & getNwnEncoding())
  debug("Other file encoding: " & getNativeEncoding())

  if Args.hasKey("--add-restypes") and Args["--add-restypes"]:
    let types = ($Args["--add-restypes"]).split(",").mapIt(it.split(":"))
    for ty in types:
      if ty.len != 2:
        raise newException(ValueError,
          "Could not parse --add-restypes: '" & ($Args["--add-restypes"]) & "'")

      let (rt, ext) = (ty[1].parseInt, ty[0])

      if rt < low(uint16).int or rt > high(uint16).int:
        raise newException(ValueError, "Integer " & $rt & " out of range for ResType")

      registerCustomResType(ResType rt, ext)
      debug "Registering custom ResType ", ext, " -> ", rt

proc findNwnRoot*(): string =
  if Args["--root"]:
    result = $Args["--root"]
  elif getEnv("NWN_ROOT") != "":
    result = getEnv("NWN_ROOT")

  # 1) Steam
  if result == "":
    when defined(macosx):
      let steamapps = r"~/Library/Application Support/Steam/steamapps/common".expandTilde
    elif defined(linux):
      let steamapps = r"~/.local/share/Steam/steamapps/common".expandTilde
    elif defined(windows):
      let steamapps = r"c:\program files\steam\steamapps\common"
    else: {.fatal: "Unsupported os for findNwnRoot".}

    if dirExists(steamapps / "Neverwinter Nights" / "data") and
        fileExists(steamApps / "Neverwinter Nights" / "steam_appid.txt"):
      result = steamapps / "Neverwinter Nights"

  # 2) BDC
  if result == "":
    when defined(macosx):
      let settingsFile = r"~/Library/Application Support/Beamdog Client/settings.json".expandTilde
    elif defined(linux):
      let settingsFile = r"~/.config/Beamdog Client/settings.json".expandTilde
    elif defined(windows):
      let settingsFile = getHomeDir() / r"AppData\Roaming\Beamdog Client\settings.json"
    else: {.fatal: "Unsupported os for findNwnRoot"}

    let data = readFile(settingsFile)
    let j = data.parseJson
    doAssert(j.hasKey("folders"))
    doAssert(j["folders"].kind == JArray)

    # 00785: Stable
    # 00829: Development
    const releases = ["00829", "00785"]
    for torrentId in releases:
      var fo = j["folders"].mapIt(it.str / torrentId)

      fo.keepItIf(dirExists(it))
      if fo.len > 0:
        result = fo[0]
        break

  if result == "" or not dirExists(result):
    raise newException(ValueError, "Could not locate NWN; try --root")

  let databuild = if not fileExists(result / "databuild.txt"):
    warn "NWN root does not contain databuild.txt"
    ""
  else:
    readFile(result / "databuild.txt").split("\n")[0].strip

  debug "NWN root: ", result, " databuild: ", databuild

proc findUserRoot*(): string =
  if Args["--userdirectory"]:
    result = $Args["--userdirectory"]
  elif getEnv("NWN_USER_DIRECTORY") != "":
    result = getEnv("NWN_USER_DIRECTORY")
  else:
    when defined(macosx):
      result = r"~/Documents/Neverwinter Nights".expandTilde
    elif defined(linux):
      let settingsFile = r"~/.local/share/Neverwinter Nights".expandTilde
    elif defined(windows):
      let settingsFile = getHomeDir() / r"Documents\Neverwinter Nights"
    else: {.fatal: "Unsupported os for findUserRoot"}

  if result == "" or not dirExists(result): raise newException(ValueError,
    "Could not locate NWN user directory; try --userdirectory or set NWN_USER_DIRECTORY")
  debug "NWN user directory: ", result

proc newBasicResMan*(root = findNwnRoot(), language = "", cacheSize = 0): ResMan =
  ## Sets up a resman that defaults to what 1.8 looks like.
  ## Will load an additional language directory, if language is given.

  let resolvedLanguage = if language == "": $Args["--language"] else: language
  let resolvedLanguageRoot = root / "lang" / resolvedLanguage

  # 1.6
  let legacyLayout = fileExists(root / "chitin.key")
  if legacyLayout: debug("legacy resman layout detected (1.69)")
  else: debug("new resman layout detected (1.8 w/ nwn_base & _loc)")

  doAssert(dirExists(resolvedLanguageRoot), "language " & resolvedLanguageRoot & " not found")

  # Attempt to auto-detect the resman type we have.
  let actualKeys =
    if $Args["--keys"] == "autodetect":
      # 1.6:
      if legacyLayout: "chitin,xp1,xp2,xp3,xp2patch"
      # 1.8:
      #else: "nwn_base,nwn_base_loc,xp1,xp2,xp3,xp2patch"
      else: "nwn_base,nwn_base_loc"
    else: $Args["--keys"]

  let keys =        actualKeys.split(",").mapIt(it.strip).filterIt(it.len > 0)
  let erfs = ($Args["--erfs"]).split(",").mapIt(it.strip).filterIt(it.len > 0)
  let dirs = ($Args["--dirs"]).split(",").mapIt(it.strip).filterIt(it.len > 0)

  for e in erfs:
    if not fileExists(e): quit("requested --erfs not found: " & e)

  for d in dirs:
    if not dirExists(d): quit("requested --dirs not found: " & d)

  proc loadKey(into: ResMan, key: string) =
    let keyFile = if legacyLayout: key & ".key"
                  else: "data" / key & ".key"

    let fn = if fileExists(resolvedLanguageRoot / keyFile): resolvedLanguageRoot / keyFile
             else: root / keyFile

    if not fileExists(fn):
      warn("  key not found, skipping: ", fn)
      return
    let ktfn = openFileStream(fn)

    debug("  key: ", fn)

    let kt = readKeyTable(ktfn, fn) do (fn: string) -> Stream:
      let otherBifFn = resolvedLanguageRoot / "data" / fn.extractFilename()
      let bifFn = if fileExists(otherBifFn): otherBifFn
                  else: root / fn

      debug("    bif: ", bifFn)
      result = openFileStream(bifFn)

    into.add(kt)

  debug "Resman (language=", resolvedLanguage, ")"
  result = resman.newResMan(cacheSize)

  if not Args["--no-keys"]:
    for k in keys: #.withProgressBar("load key: "):
      result.loadKey(k)

  for e in erfs: #.withProgressBar("load erf: "):
    let fs = openFileStream(e)
    let erf = fs.readErf(e)
    debug "  ", erf
    result.add(erf)

  # find/initialise nwsync only if we actually need it
  var nwsync: NWSync

  # load manifests
  let manifestsToRead = if ($Args["--manifests"]).toUpperAscii == "ALL":
      nwsync = openNWSync(findUserRoot() / "nwsync")
      nwsync.getAllManifests()
    else:
      let v = ($Args["--manifests"]).split(",").filterIt(it.len > 0)
      if v.len > 0: nwsync = openNWSync(findUserRoot() / "nwsync")
      v

  for q in manifestsToRead.filterIt(it.len > 0):
      let c = newResNWSyncManifest(nwsync, q)
      debug "  ", c
      result.add(c)

  if not legacyLayout and not Args["--no-ovr"]:
    let c = newResDir(root / "ovr")
    debug "  ", c
    result.add(c)
  if not legacyLayout and not Args["--no-ovr"]:
    let c = newResDir(resolvedLanguageRoot / "data" / "ovr")
    debug "  ", c
    result.add(c)

  for d in dirs: #.withProgressBar("load resdir: "):
    let c = newResDir(d)
    debug "  ", c
    result.add(c)

proc ensureValidFormat*(format, filename: string,
                       supportedFormats: Table[string, seq[string]]): string =
  result = format
  if result == "autodetect" and filename != "-":
    let ext = splitFile(filename).ext.strip(true, false, {'.'})
    for fmt, exts in supportedFormats:
      if exts.contains(ext):
        result = fmt
        break

  if result == "autodetect":
    quit("Cannot detect file format from filename: " & filename)

  if not supportedFormats.hasKey(result):
    quit("Not a supported file format: " & result)

iterator filterByMatch*(rm: ResMan, patternMatch: string, binaryMatch: string, invert: bool): Res =
  for o in rm.contents:
    let str = $o
    let res = rm[o].get()

    let match = (patternMatch != "" and str.find(patternMatch) != -1) or
                (binaryMatch != "" and res.readAll().find(binaryMatch) != -1)

    if (match and not invert) or (not match and invert):
      yield(res)
