import shared

let args = DOC """
This utility diffs the base (english) view of resman versus a language
override one as implemented for 1.8; so the torrent/lang/xx/data path is in code.

This utility will explicitly ignore .wav files that:
- are binary mismatches
- are in only one or the other side: This is *expected* as translations were
  never completely complete
(give --wav to override this)

Files that are present in both, but mismatch in binary, are written to:
   (cwd)/resman_diff_mismatches/<resref>_<langprefix>.<ext>
(but only with --write-mismatches)
Regardless, a list of them is written to a text file.

Resrefs only present in one side or the other are written to text files too.

Usage:
  $0 [options] <otherLanguageKey>
  $0 -h | --help

Options:
  --write-mismatches          Write out mismatches to a directory.
  --wav                       Include wav files in diff considation.
  $OPTRESMAN
"""

# Warning: might spam your disk with a few files.
let writeOutMismatches = args["--write-mismatches"]

# Do you want to consider missing or mismatching .wav files be an issue?
let includeWav = args["--wav"]

let root = findNwnRoot() # (if paramCount() > 1: paramStr(2) else: getCurrentDir()) & DirSep
let otherLang = $args["<otherLanguageKey>"]

let otherLangRoot = root / "lang" / otherLang
doAssert(dirExists(otherLangRoot), "dir not found: " & otherLangRoot)

let resBase = newBasicResMan(root)

let resOther = newBasicResMan(root, otherLang)

var baseContents = initSet[ResRef]()
var otherContents = initSet[ResRef]()

for o in resBase.contents().withProgressBar("filter: "):
  if includeWav or o.resType != 4: baseContents.incl(o)

echo "ResRefs in base: ", baseContents.card

for o in resOther.contents().withProgressBar("filter: "):
  if includeWav or o.resType != 4: otherContents.incl(o)

echo "ResRefs in other: ", otherContents.card

let baseOnly = baseContents - otherContents
let otherOnly = otherContents - baseContents
var binaryMismatch = initSet[ResRef]()

for it in intersection(baseContents, otherContents).withProgressBar("intersect: "):
  let lhs = resBase[it].get().readAll()
  let rhs = resOther[it].get().readAll()

  if lhs != rhs:
    binaryMismatch.incl(it)

if writeOutMismatches:
  createDir("resman_diff_mismatches_en_" & otherLang)
  for o in binaryMismatch:
    # if $o != "c_a_bat.mdl": continue
    let lhs = resBase[o].get().readAll()
    let rhs = resOther[o].get().readAll()
    # write out the mismatch, but only if it isn't a wav.
    let resolved = o.resolve().get()
    let prefix = "resman_diff_mismatches" / resolved.resRef()
    writeFile(prefix & "_en" & "." & resolved.resExt(), lhs)
    writeFile(prefix & "_" & otherLang &  "." & resolved.resExt(), rhs)

echo "ResRefs only in base: ", baseOnly.card
let f = open("resman_diff_en_" & otherLang & "_only_in_en.txt", fmWrite)
for o in baseOnly:
  let src = $resBase[o].get().origin()
  let resref = $o.resolve().get()
  f.write(resref)
  f.write(repeat(" ", 30 - resref.len))
  f.writeLine(src)
close(f)

echo "ResRefs only in other: ", otherOnly.card
let f2 = open("resman_diff_en_" & otherLang & "_only_in_" & otherLang & ".txt", fmWrite)
for o in otherOnly:
  let src = $resOther[o].get().origin()
  let resref = $o.resolve().get()
  f.write(resref)
  f.write(repeat(" ", 30 - resref.len))
  f.writeLine(src)
close(f2)

echo "Binary-mismatching content: ", binaryMismatch.card
let f3 = open("resman_diff_en_" & otherLang & "_binary_mismatches.txt", fmWrite)
for o in binaryMismatch:
  let srcLhs = $resBase[o].get().origin()
  let srcRhs = $resOther[o].get().origin()
  let resref = $o.resolve().get()
  f.write(resref)
  f.write(repeat(" ", 30 - resref.len))
  f3.writeLine(srcLhs & " <-> " & srcRhs)
close(f3)
