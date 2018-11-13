import sequtils, ospaths, strutils

version       = "1.1.0"
author        = "Bernhard Stöckner <niv@nwnx.io>"
description   = "Neverwinter Nights 1 data accessor library and utilities"
license       = "MIT"

requires "nim >= 0.18.0"

srcDir = "src"
installDirs = @["neverwinter"]

binDir = "bin"
bin = listFiles("src").
  mapIt(it.splitFile.name).
  filterIt(it.startsWith("nwn_")).
  # There appears to be a compiler bug on 0.19.0 that segfaults it when
  # compiling nwn_net. So we skip it for 0.19.0.
  filterIt(NimVersion != "0.19.0" or it != "nwn_net")
