import std/os, std/logging, std/json, std/sequtils, std/strutils

const GffExtensions* = @[
  "utc", "utd", "ute", "uti", "utm", "utp", "uts", "utt", "utw",
  "git", "are", "gic", "ifo", "fac", "dlg", "itp", "bic",
  "jrl", "gff", "gui"
]

proc findUserRoot*(override: string = ""): string =
  if override.len > 0:
    echo "OVERRIDE: ", override.escape
    result = override
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
  echo result
  if result == "" or not dirExists(result): raise newException(ValueError,
    "Could not locate NWN user directory; try --userdirectory or set NWN_USER_DIRECTORY")
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
