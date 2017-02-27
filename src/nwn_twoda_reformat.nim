## Reformats a 2da file, fixing any errors on the way.
##
## Syntax: twoda_reformat [in|-] [out|-]
##   Read from stdin (or a named file); write to stdout (or a named file).

import os, streams

import shared, neverwinter.twoda

proc getInOutFilesFromParams*(allowOverwrite = false): tuple[i: Stream, o: Stream] =
  ## Used by command line utilities to transform simple in/out parameters to
  ## file streams.

  result.i = newFileStream(stdin)
  result.o = newFileStream(stdout)

  if paramCount() > 0 and paramStr(1) != "-":
    result.i = newFileStream(paramStr(1))
    doAssert(result.i != nil, "Could not open file for reading: " & paramStr(1))

  if paramCount() > 1 and paramStr(2) != "-":
    if not allowOverwrite and fileExists(paramStr(2)):
      quit("outfile exists, aborting for your own safety.")

    result.o = newFileStream(paramStr(2), fmWrite)
    doAssert(result.o != nil, "Could not open file for writing: " & paramStr(2))

let io = getInOutFilesFromParams()

io.o.write(io.i.readTwoDA())
