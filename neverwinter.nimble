import sequtils, os, strutils

version       = "2.0.3"
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
