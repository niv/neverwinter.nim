import sequtils, ospaths, strutils

version       = "1.2.0"
author        = "Bernhard Stöckner <niv@nwnx.io>"
description   = "Neverwinter Nights 1 data accessor library and utilities"
license       = "MIT"

requires "nim >= 0.18.0"

installDirs = @["neverwinter"]

binDir = "bin/"
bin = listFiles(thisDir()).
  mapIt(it.splitFile.name).
  filterIt(it.startsWith("nwn_")).
  # There appears to be a compiler bug on 0.19.0 that segfaults it when
  # compiling nwn_net. So we skip it for 0.19.0.
  filterIt(NimVersion != "0.19.0" or it != "nwn_net")

task clean, "Remove compiled binaries and temporary data":
  for b in bin:
    rmFile(binDir / b)
    rmFile(binDir / b & ".exe")
  rmdir(nimcacheDir())
