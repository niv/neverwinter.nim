import shared

let args = DOC """
Packages a resman view into a slimmed-down variant suitable for
docker deployment.

Usage:
  $0 [options]
  $USAGE

Options:
  -d DIRECTORY                Save files to DIRECTORY [default: .]
  $OPTRESMAN
"""

let rm = newBasicResMan()

let destination = ($args["-d"])
doAssert(dirExists(destination), "destination directory does not exist")

const whiteListExt = [
  # walkmeshes: needed to pathfind
  "wok", "pwk", "dwk",
  # scripts
  "ncs",
  # templates: potentially needed by scripts and other templates
  "uti", "utc", "utp", "ssf", "uts", "utt", "ute", "utm", "dlg", "utw", "utd",
  # palette data
  "itp",
  # config data
  "2da",
  # tileset data
  "ini", "set"
]

proc shouldBeIncluded(o: ResolvedResRef): bool =
  whiteListExt.find(($o.resType).toLowerAscii) > -1

# How many files to pack into a single bif at max.
const FilesPerBif = 5000

# find all the resRefs we want to include.
var allContent = newSeq[ResolvedResRef]()
for o in rm.contents.withProgressBar("filter"):
  let oo = o.resolve().get()
  if oo.shouldBeIncluded: allContent.add(oo)

# Sort entries so the build is reproducible
sort(allContent) do (lhs, rhs: ResolvedResRef) -> int:
  system.cmp[string](lhs.toFile.toUpperAscii, rhs.toFile.toUpperAscii)

let allBifsToWrite = allContent.distribute(1 + allContent.len div FilesPerBif)

info "Including ", allContent.len, " files in shrunk set, split into ", allBifsToWrite.len, " bifs"

let bifs = allBifsToWrite.map() do (idx: int, k: seq[ResolvedResRef]) -> KeyBifEntry:
  result.name = "srvpkg" & $idx
  result.entries = k.mapIt(it.ResRef)

writeKeyAndBif(destDir=destination, keyName="nwn_base", bifPrefix=r"data\\", bifs=bifs) do (r: ResRef, io: Stream):
  let res = rm[r].get()
  io.write(res.readAll)

info "nwn_base.key written"
