## This program converts gff data to json.
## The json data is compatible with what https://github.com/niv/nwn-lib
## produces/expects.
##
## Syntax: gff2json [in|-] [out|-]
##   Read from stdin (or a named file); write to stdout (or a named file).

import streams, os, json

import neverwinter.gff, neverwinter.gffjson, neverwinter.util
import shared

let io = getInOutFilesFromParams()

let root: GffRoot = io.i.readGffRoot(false)
io.o.write(root.toJson().pretty())
