import sequtils, ospaths, strutils

version       = "1.2.1"
author        = "Bernhard Stöckner <niv@nwnx.io>"
description   = "Neverwinter Nights 1 data accessor library and utilities"
license       = "MIT"

requires "nim >= 0.19.4"

installDirs = @["neverwinter"]

binDir = "bin/"
bin = listFiles(thisDir()).
  mapIt(it.splitFile.name).
  filterIt(it.startsWith("nwn_"))

task clean, "Remove compiled binaries and temporary data":
  for b in bin:
    rmFile(binDir / b)
    rmFile(binDir / b & ".exe")
  rmdir(nimcacheDir())
