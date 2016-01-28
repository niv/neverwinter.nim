import streams, asyncnet, asyncdispatch, tables, algorithm, os

import neverwinter/gff

proc exit(code: cint): void {.importc.}

try:
  let root: GffRoot = gff.readFromStream(newFileStream(stdin), false)

except ValueError:
  echo repr(getCurrentException())
  quit(0)

except:
  echo repr(getCurrentException())
  exit(11)
