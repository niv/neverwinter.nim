## Reformats a 2da file, fixing any errors on the way.
##
## Syntax: twoda_reformat [in|-] [out|-]
##   Read from stdin (or a named file); write to stdout (or a named file).

import os, streams

import neverwinter.twoda, neverwinter.util
import shared

let io = getInOutFilesFromParams()

io.o.write(io.i.readTwoDA())
