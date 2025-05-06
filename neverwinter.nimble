import sequtils, os, strutils

version       = "2.0.3"
author        = "Bernhard Stöckner <n@e-ix.net>"
description   = "Neverwinter Nights 1: Enhanced Edition data accessor library and utilities"
license       = "MIT"

requires "nim >= 2.0.0"

requires "checksums >= 0.2.1"
requires "docopt >= 0.7.1"
requires "db_connector >= 0.1.0"

installDirs = @["neverwinter"]

binDir = "bin/"
bin = listFiles(thisDir()).
  mapIt(it.splitFile).
  filterIt(it.name.startsWith("nwn_") and it.ext == ".nim").
  mapIt(it.name)


proc execEcho(cmd: string): void =
  echo "[exec] ", cmd
  exec cmd

task tidy, "Remove compiled binaries and temporary data":
  for f in listFiles(binDir):
    if not f.endsWith(".gitkeep"):
      rmFile(f)
  rmdir(nimcacheDir())
  rmFile("testresults.html")
  rmdir("testresults")

task build_libnwnscriptcomp, "Compile libnwnscriptcomp into binDir":
  let
    prefix = "libnwnscriptcomp"
    isWindows = defined(windows)
    outFile = prefix & (if isWindows: ".dll" elif defined(macosx): ".dylib" else: ".so")
    outPath = binDir / outFile
    sources = @[
      "neverwinter/nwscript/compilerapi.cpp",
    ] & listFiles("neverwinter/nwscript/native").filterIt(it.endsWith(".cpp") or it.endsWith(".c"))

  echo "Creating output directory: " & binDir
  mkDir(binDir)

  var cmd = if isWindows: "g++ -shared -std=c++14" else: "g++ -shared -fPIC -std=c++14"

  cmd = cmd & " -O2"
  cmd = cmd & " " & sources.join(" ")

  if defined(macosx):
    cmd = cmd & " -Wno-deprecated-declarations"  # sprintf

  if defined(macosx):
    execEcho cmd & " -target x86_64-apple-macos10.12 -o " & outPath & ".x86_64"
    execEcho cmd & " -target arm64-apple-macos10.12 -o " & outPath & ".arm64"
    execEcho "lipo -create " & outPath & ".x86_64 " & outPath & ".arm64 -output " & outPath
    rmFile(outPath & ".x86_64")
    rmFile(outPath & ".arm64")
  else:
    execEcho cmd & " -o " & outPath

task test, "Run all tests":
  # Megatest disabled for now: it appears to show all tests as skipped in html, and
  # i'm not sure it'll work well with threaded tests
  exec "testament --megatest:off all"
