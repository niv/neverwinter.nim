# Attempt to transform all *.json files to gff and back, then compare.

import std/[os, json]

import neverwinter/[gff, gffjson]

for file in walkFiles(currentSourcePath().splitFile().dir / "*.json"):
  let before = readFile(file).parseJson()
  let gff    = before.gffRootFromJson() # test
  let after  = gff.toJson()
  doAssert before == after
