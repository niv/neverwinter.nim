import shared, checksums/sha1

const ServerPackageExtensions = [
  # walkmeshes: needed to pathfind
  "wok", "pwk", "dwk",
  # scripts
  "ncs",
  # script sources: because people want to use this pkg for compilation
  "nss",
  # templates: potentially needed by scripts and other templates
  "uti", "utc", "utp", "ssf", "uts", "utt", "ute", "utm", "dlg", "utw", "utd",
  # palette data
  "itp",
  # config data
  "2da",
  # tileset data
  "ini", "set",
  # CNWNameGen
  "ltr"
]

const ServerPackageStubExtensions = [
  "dds", "tga", "mdl", "plt"
]

let args = DOC """
Packages a resman view into a slimmed-down variant suitable for
limited-set deployments, like docker or script compilers.

Usage:
  $0 [options]
  $USAGE

Options:
  -d DIRECTORY                Save files to DIRECTORY [default: .]
  -k KEYNAME                  Key filename [default: nwn_base]
  -b BIFPREFIX                Bif prefix inside key table [default: data\]
  -B BIFDIR                   Put bifs into subdirectory [default: ]
  --year YEAR                 Override embedded build year [default: """ & $getTime().utc.year & """]
  --doy DOY                   Override embedded day of year [default: """ & $getTime().utc.yearday & """]
  --extensions LIST           Comma-separated list of extensions to pack [default: """ & ServerPackageExtensions.join(",") & """]
  --stubext LIST              Comma-separated list of extensions to pack as zero-byte stub files [default: """ & ServerPackageStubExtensions.join(",") & """]

  --data-version VERSION      Data file version to write (one of V1, E1). [default: V1]
  --data-compression ALG      Compression for E1 (one of """ & SupportedAlgorithms & """) [default: none]
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

let whitelistExt = ($args["--extensions"]).split(",")
let stublistExt  = ($args["--stubext"]).split(",")

let dataVersion = parseEnum[KeyBifVersion](capitalizeAscii $args["--data-version"])
let dataCompAlg = parseEnum[Algorithm](capitalizeAscii $args["--data-compression"])
let dataExoComp = if dataCompAlg != Algorithm.None: ExoResFileCompressionType.CompressedBuf else: ExoResFileCompressionType.None

proc shouldBePackaged(o: ResRef): bool =
  let r = ($o.resType).toLowerAscii
  whitelistExt.find(r) > -1 or stublistExt.find(r) > -1

proc shouldHaveData(o: ResRef): bool =
  whiteListExt.find(($o.resType).toLowerAscii) > -1

let allContent =
  toSeq(rm.contents.items).
    filterIt(it.shouldBePackaged).
    # Sort entries so the build is reproducible
    sorted() do (lhs, rhs: ResRef) -> int:
      system.cmp[string](($lhs).toUpperAscii, ($rhs).toUpperAscii)

# How many files to pack into a single bif at max.
const FilesPerBif = 5000
let allBifsToWrite = allContent.distribute(1 + allContent.len div FilesPerBif)

info "Including ", allContent.len, " files in shrunk set, split into ", allBifsToWrite.len, " bifs"

let bifs = allBifsToWrite.map() do (idx: int, k: seq[ResRef]) -> KeyBifEntry:
  result.name = "pkg" & $idx
  result.directory = bifDir
  result.entries = k.mapIt(it)

writeKeyAndBif(version=dataVersion,
  exocomp=dataExoComp, compalg=dataCompAlg,
  destDir=destination, keyName=keyName, bifPrefix=bifPrefix,
    bifs=bifs, year, doy) do (r: ResRef, io: Stream) -> (int, SecureHash):

  var sha1: SecureHash
  if shouldHaveData(r):
    let res = rm[r].get()
    let all = res.readAll()
    io.write(all)
    if dataVersion == KeyBifVersion.E1:
      sha1 = secureHash(all)
    (res.ioSize, sha1)
  else:
    (0, sha1)

info keyName, ".key written"
