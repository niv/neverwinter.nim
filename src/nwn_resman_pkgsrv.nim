import shared

let args = DOC """
Packages a resman view into a slimmed-down variant suitable for
docker deployment.

Usage:
  $0 [options]
  $USAGE

Options:
  -d DIRECTORY                Save files to DIRECTORY [default: .]
  -k KEYNAME                  Key filename [default: nwn_base]
  -b BIFPREFIX                Bif prefix inside key table [default: data\]
  -B BIFDIR                   Put bifs into subdirectory [default: ]
  --year YEAR                 Override embedded build year [default: """ & $getTime().getGMTime().year & """]
  --doy DOY                   Override embedded day of year [default: """ & $getTime().getGMTime().yearday & """]
  $OPTRESMAN
"""

let rm = newBasicResMan()

let keyName = $args["-k"]
let bifPrefix = $args["-b"]
let bifDir = $args["-B"]
let destination = ($args["-d"])
let (year, doy) = (($args["--year"]).parseInt.uint32, ($args["--doy"]).parseInt.uint32)
doAssert(dirExists(destination), "destination directory does not exist")
doAssert(year >= 1900u32, "year needs to be >= 1900")
doAssert(doy <= 365u32, "doy is out of range (0-365)")

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

let allContent: seq[ResolvedResRef] = rm.contents.mapIt(it.resolve().get()).
  # Only resrefs matching the predicate
  filterIt(it.resolve().get().shouldBeIncluded).
  # Sort entries so the build is reproducible
  sorted() do (lhs, rhs: ResolvedResRef) -> int:
    system.cmp[string](lhs.toFile.toUpperAscii, rhs.toFile.toUpperAscii)

# How many files to pack into a single bif at max.
const FilesPerBif = 5000
let allBifsToWrite = allContent.distribute(1 + allContent.len div FilesPerBif)

info "Including ", allContent.len, " files in shrunk set, split into ", allBifsToWrite.len, " bifs"

let bifs = allBifsToWrite.map() do (idx: int, k: seq[ResolvedResRef]) -> KeyBifEntry:
  result.name = "srvpkg" & $idx
  result.directory = bifDir
  result.entries = k.mapIt(it.ResRef)

writeKeyAndBif(destDir=destination, keyName=keyName, bifPrefix=bifPrefix,
    bifs=bifs, year, doy) do (r: ResRef, io: Stream):
  let res = rm[r].get()
  io.write(res.readAll)

info keyName, ".key written"
