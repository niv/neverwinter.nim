import sequtils, os, strutils

version       = "2.0.2"
author        = "Bernhard Stöckner <n@e-ix.net>"
description   = "Neverwinter Nights 1: Enhanced Edition data accessor library and utilities"
license       = "MIT"

requires "nim >= 2.0.0"

requires "checksums >= 0.2.1"
requires "https://github.com/docopt/docopt.nim#head"
requires "db_connector >= 0.1.0"

installDirs = @["neverwinter"]

binDir = "bin/"
bin = listFiles(thisDir()).
  mapIt(it.splitFile).
  filterIt(it.name.startsWith("nwn_") and it.ext == ".nim").
  mapIt(it.name)

task clean, "Remove compiled binaries and temporary data":
  for b in bin:
    rmFile(binDir / b)
    rmFile(binDir / b & ".exe")
    rmFile(b)
    rmFile(b & ".exe")
  rmdir(nimcacheDir())
  rmFile("testresults.html")
  rmdir("testresults")

task test, "Run all tests":
  # Megatest disabled for now: it appears to show all tests as skipped in html, and
  # i'm not sure it'll work well with threaded tests
  exec "testament --megatest:off all"

task build_macos_universal_binaries, "Build macOS universal binaries":
  doAssert(defined(macosx), "This task is only for macOS")
  doAssert(defined(arm64), "This task was only tested on macOS aarch64")
  echo "Building amd64 binaries for macOS"
  exec("nimble build -f -d:macos_amd64_hotfix")

  mkDir("bin/amd64")
  for b in bin:
    mvFile("bin/" & b, "bin/amd64/" & b)

  echo "Building aarch64 binaries for macOS"
  exec("nimble build -f --cpu:arm64")

  mkDir("bin/aarch64")
  for b in bin:
    mvFile("bin/" & b, "bin/aarch64/" & b)

  echo "Building universal binaries for macOS"
  for b in bin:
    exec("lipo -create -output bin/" & b & " bin/amd64/" & b & " bin/aarch64/" & b)

  rmDir("bin/amd64")
  rmDir("bin/aarch64")
