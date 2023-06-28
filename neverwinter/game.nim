import std/os, std/logging, std/json, std/sequtils, std/strutils

import neverwinter/[resman, key, erf, resdir, resnwsync]

const GffExtensions* = @[
  "utc", "utd", "ute", "uti", "utm", "utp", "uts", "utt", "utw",
  "git", "are", "gic", "ifo", "fac", "dlg", "itp", "bic",
  "jrl", "gff", "gui"
]

proc findUserRoot*(override: string = ""): string =
  if override.len > 0:
    result = override
  elif getEnv("NWN_HOME") != "":
    result = getEnv("NWN_HOME")
  elif getEnv("NWN_USER_DIRECTORY") != "":
    result = getEnv("NWN_USER_DIRECTORY")
  else:
    when defined(macosx):
      result = r"~/Documents/Neverwinter Nights".expandTilde
    elif defined(linux):
      result = r"~/.local/share/Neverwinter Nights".expandTilde
    elif defined(windows):
      result = getHomeDir() / r"Documents\Neverwinter Nights"
    else: {.fatal: "Unsupported os for findUserRoot"}

  if result == "" or not dirExists(result): raise newException(ValueError,
    "Could not locate NWN user directory; try --userdirectory or set NWN_HOME (NWN_USER_DIRECTORY also works, but is considered alternate)")
  debug "NWN user directory: ", result

proc findNwnRoot*(override: string = ""): string =
  if override.len > 0:
    result = override
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

proc newDefaultResMan*(
    root: string,                      # game root
    userDirectory: string,             # user directory (needed for nwsync)
    language: string,                  # language override (en otherwise)
    cacheSize = 0,                     # see resman doc
    loadKeys: bool = true,             # Load keyfiles?
    loadOvr: bool = true,              # Load system ovr/?
    keys: seq[string] = @[],           # Override set of keys to load (ignored if not loadKeys)
    additionalErfs: seq[string] = @[], # Additional list of filenames, fully qualified
    additionalDirs: seq[string] = @[], # Additional list of directories, fully qualified
    additionalManifests: seq[ManifestSHA1] = @[]
): ResMan =

  ## Sets up a resman that defaults to what EE looks like.
  ## Will load an additional language directory, if language is given.

  let resolvedLanguage     = language
  let resolvedLanguageRoot = root / "lang" / resolvedLanguage

  doAssert(dirExists(resolvedLanguageRoot), "language " & resolvedLanguageRoot & " not found")

  let actualKeys =
    if keys.len > 0 and keys != @["autodetect"]: keys.join(",")
    else: "nwn_base,nwn_base_loc"

  let keys = actualKeys.split(",").mapIt(it.strip).filterIt(it.len > 0)
  let erfs = additionalErfs
  let dirs = additionalDirs

  for e in erfs:
    if not fileExists(e):
      raise newException(ValueError, "requested --erfs not found: " & e)

  for d in dirs:
    let d = expandTilde(d)
    if not dirExists(d):
      raise newException(ValueError, "requested --dirs not found: " & d)

  proc loadKey(into: ResMan, key: string) =
    let keyFile = "data" / key & ".key"

    let fn = if fileExists(resolvedLanguageRoot / keyFile): resolvedLanguageRoot / keyFile
             else: root / keyFile

    if not fileExists(fn):
      # Don't warn about loc missing, it's optional for some languages
      if key != "nwn_base_loc":
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

  if loadKeys:
    for k in keys:
      result.loadKey(k)

  for e in erfs:
    let fs = openFileStream(e)
    let erf = fs.readErf(e)
    debug "  ", erf
    result.add(erf)

  # find/initialise nwsync only if we actually need it
  var nwsync: NWSync

  if additionalManifests.len > 0:
    doAssert(dirExists(userDirectory))
    nwsync = openNWSync(userDirectory / "nwsync")

  for q in additionalManifests:
      let c = newResNWSyncManifest(nwsync, q)
      debug "  ", c
      result.add(c)

  if loadOvr:
    let c = newResDir(root / "ovr")
    debug "  ", c
    result.add(c)
  if loadOvr:
    let c = newResDir(resolvedLanguageRoot / "data" / "ovr")
    debug "  ", c
    result.add(c)

  for d in dirs:
    let c = newResDir(d)
    debug "  ", c
    result.add(c)
