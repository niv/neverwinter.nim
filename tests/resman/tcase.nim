import std/[os, strutils]
import neverwinter/[resman, resdir]

let rr = newResolvedResRef("SAMPLE.txt")
var rm = newResMan(0)

const sourceDir = currentSourcePath().splitFile().dir

rm.add newResDir(sourceDir / "corpus")
rm.add newResDir(sourceDir / "corpus_uc")

let rd = rm.demand(rr, useCache=false)

# The uppercase file must override the lowercase variant further up the stack
# (the uppercase variant contains OLLEH, the lowercase variant HELLO)
# This test will only be effective on case-sensitive file sytems.
let check = rd.readAll().strip()
doAssert check == "OLLEH", "got: " & check
