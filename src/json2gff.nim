# This program converts json data to gff. It can read from stdin or a filename,
# and will write to stdout (for piping) or to a filename.

# To compile: nim c -d:release json2gff

import streams, os, json

import neverwinter.gff
import neverwinter.gffjson

let infile = if paramCount() > 0:
    newFileStream(paramStr(1))
  else:
    newFileStream(stdin)

var outfile: Stream
if paramCount() > 1:
  if fileExists(paramStr(2)): quit("outfile exists, aborting for your own safety.")
  outfile = newFileStream(paramStr(2), fmWrite)
else:
  outfile = newFileStream(stdout)

let jroot = infile.parseJson("input").gffRootFromJson()
outfile.write(jroot)
