import sequtils, ospaths, strutils

version       = "1.1.0"
author        = "Bernhard Stöckner <niv@nwnx.io>"
description   = "Neverwinter Nights 1 data accessor library and utilities"
license       = "MIT"

requires "nim >= 0.18.0 & < 0.19"

srcDir = "src"
installDirs = @["neverwinter"]

binDir = "bin"
bin = listFiles("src").
  mapIt(it.splitFile.name).
  filterIt(it.startsWith("nwn_"))
