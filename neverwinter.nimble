import sequtils, os, strutils

version       = "1.5.4"
author        = "Bernhard Stöckner <n@e-ix.net>"
description   = "Neverwinter Nights 1: Enhanced Edition data accessor library and utilities"
license       = "MIT"

requires "nim >= 1.6.4"
requires "docopt >= 0.6.8"

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
