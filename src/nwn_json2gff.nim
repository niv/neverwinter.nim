## This program converts json to gff data.
## The json data is compatible with what https://github.com/niv/nwn-lib
## produces/expects.
##
## Syntax: json2gff [in|-] [out|-]
##   Read from stdin (or a named file); write to stdout (or a named file).

import streams, os, json

import neverwinter.gff, neverwinter.gffjson, neverwinter.util
import shared

let io = getInOutFilesFromParams()

let jroot = io.i.parseJson("input").gffRootFromJson()
io.o.write(jroot)
