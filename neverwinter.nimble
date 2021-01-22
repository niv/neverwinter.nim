import sequtils, os, strutils

version       = "1.4.2"
author        = "Bernhard Stöckner <n@e-ix.net>"
description   = "Neverwinter Nights 1: Enhanced Edition data accessor library and utilities"
license       = "MIT"

requires "nim >= 1.0.8"

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
  rmdir(nimcacheDir())
