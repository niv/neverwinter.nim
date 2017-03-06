import shared

let args = DOC """
This utility diffs two complete resman views.  We support two modes of operation:


Diffing against another language in the same repository:

  Just give the language path component to compare as the only argument (i.e. "de").
  The lefthand-side language will be "en", unless overriden by --language.
  Resman-modifying parameters like --keys and --erfs will apply to *both* sides.

  Example:
    $0 --keys nwn_base lang de  (This should show no differences)


Diffing against another install (no other-language support yet):

  The lefthand side will be set up by the builtin resman flags and options,
  like --keys. The RHS only supports autdetect for now.
  Hint: Give --verbose to see what exactly gets loaded into either.

  Example:
    $0 path ../00810            (diff to NWN 1.69, auto-detected)


This utility will explicitly ignore .wav files that:

- are binary mismatches
- are in only one or the other side: This is *expected* as translations were
  never completely complete

Give --wav to override this.

Usage:
  $0 [options] lang <lang2>
  $0 [options] path <path> [keyfiles]
  $USAGE

Options:
  --write-mismatches          Write out mismatches to a directory. Warning:
                              This will potentially be a LOT of data.
  --wav                       Include wav files in diff considation.
  $OPTRESMAN
"""

# Warning: might spam your disk with a few files.
let writeOutMismatches = args["--write-mismatches"]
# Do you want to consider missing or mismatching .wav files be an issue?
let includeWav = args["--wav"]

let root = findNwnRoot()
var resBase: ResMan
var resOther: ResMan
# The filename component where data gets written to. for example: lang_en_de
var filenamePrefix: string

if args["lang"]:
  let otherLang = $args["<lang2>"]

  let otherLangRoot = root / "lang" / otherLang
  doAssert(dirExists(otherLangRoot), "dir not found: " & otherLangRoot)

  resBase = newBasicResMan(root)
  resOther = newBasicResMan(root, otherLang)
  filenamePrefix = "lang_en_" & otherLang

elif args["path"]:
  resBase = newBasicResMan(root)
  resOther = newBasicResMan($args["<path>"])
  filenamePrefix = "path"

else: quit("??")

var baseContents = initSet[ResRef]()
var otherContents = initSet[ResRef]()

for o in resBase.contents().withProgressBar("filter: "):
  if includeWav or o.resType != getResType("wav"): baseContents.incl(o)

for o in resOther.contents().withProgressBar("filter: "):
  if includeWav or o.resType != getResType("wav"): otherContents.incl(o)

let baseOnly = baseContents - otherContents
let otherOnly = otherContents - baseContents
var binaryMismatch = initSet[ResRef]()

for it in intersection(baseContents, otherContents).withProgressBar("intersect: "):
  let olhs = resBase[it]
  doAssert(olhs.isSome, $it & " not in lhs")
  let orhs = resOther[it]
  doAssert(orhs.isSome, $it & " not in rhs")
  let lhs = olhs.get().readAll()
  let rhs = orhs.get().readAll()

  if lhs != rhs:
    binaryMismatch.incl(it)

let fnBase = "resman_diff_" & filenamePrefix & "_only_left.txt"
if baseOnly.card > 0:
  let f = open(fnBase, fmWrite)
  for o in toSeq(baseOnly.items).sorted(shared.cmp[ResRef]):
    let src = $resBase[o].get().origin()
    let resref = $o.resolve().get()
    f.write(resref)
    f.write(repeat(" ", 30 - resref.len))
    f.writeLine(src)
  close(f)

let fnOther = "resman_diff_" & filenamePrefix & "_only_right.txt"
if otherOnly.card > 0:
  let f2 = open(fnOther, fmWrite)
  for o in toSeq(otherOnly.items).sorted(shared.cmp[ResRef]):
    let src = $resOther[o].get().origin()
    let resref = $o.resolve().get()
    f2.write(resref)
    f2.write(repeat(" ", 30 - resref.len))
    f2.writeLine(src)
  close(f2)

let fnDiff = "resman_diff_" & filenamePrefix & "_hash_mismatch.txt"
if binaryMismatch.card > 0:
  let f3 = open(fndiff, fmWrite)
  for o in toSeq(binaryMismatch.items).sorted(shared.cmp[ResRef]):
    let srcLhs = $resBase[o].get().origin()
    let srcRhs = $resOther[o].get().origin()
    let resref = $o.resolve().get()
    f3.write(resref)
    f3.write(repeat(" ", 30 - resref.len))
    f3.writeLine(srcLhs & " <-> " & srcRhs)
  close(f3)

let fnDiffDir = "resman_diff_" & filenamePrefix & "_hash_mismatches"
if binaryMismatch.card > 0 and writeOutMismatches:
  createDir(fnDiffDir)
  for o in binaryMismatch.withProgressBar("write binarymismatch: "):
    # if $o != "c_a_bat.mdl": continue
    let lhs = resBase[o].get().readAll()
    let rhs = resOther[o].get().readAll()
    # write out the mismatch, but only if it isn't a wav.
    let resolved = o.resolve().get()
    let prefix = fnDiffDir / resolved.resRef()
    writeFile(prefix & "_left" & "." & resolved.resExt(), lhs)
    writeFile(prefix & "_right" & "." & resolved.resExt(), rhs)


echo align($baseContents.card, 15), " resRefs in base"
echo align($otherContents.card, 15), " resRefs in other"

echo align($baseOnly.card, 15), " resrefs ONLY in base"
# if baseOnly.card > 0: echo "  written to: ", fnBase

echo align($otherOnly.card, 15), " resrefs ONLY in other"
# if otherOnly.card > 0: echo "  written to: ", fnOther

echo align($binaryMismatch.card, 15), " resrefs with hash mismatch"
# if binaryMismatch.card > 0: echo "  written to: ", fndiff
# if binarymismatch.card > 0 and writeOutMismatches:
#   echo "  all mismatching files dumped to: ", fnDiffDir