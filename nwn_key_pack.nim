import shared, std/sha1

let args = DOC """
This utility packs a .key file and all associated bifs from directory tree.

Usage:
  $0 [options] <key> <source> <destination>
  $USAGE

Options:
  --data-version VERSION      Data file version to write (one of V1, E1). [default: V1]
  --data-compression ALG      Compression for E1 (one of """ & SupportedAlgorithms & """) [default: none]

  --no-squash                 Do not squash bif files into same directory as key.
  --no-symlinks               Don't follow symlinks

  -f --force                  Force pack even if target directory has stuff in it.
  $OPT
"""

let noLinks = args["--no-symlinks"]
let noSquash = args["--no-squash"]
let dataVersion = parseEnum[KeyBifVersion](capitalizeAscii $args["--data-version"])
let dataCompAlg = parseEnum[Algorithm](capitalizeAscii $args["--data-compression"])
let dataExoComp = if dataCompAlg != Algorithm.None: ExoResFileCompressionType.CompressedBuf else: ExoResFileCompressionType.None

proc packKeyBif*(keyFilename: string, sourceDir: string, targetDir: string) =
  ## Packs a directory tree into a keyfile, with one bif file per
  ## subdirectory.

  # Internal references to bif files are prefixed with this.
  let bifPrefix = "data"

  var resrefToDir = initTable[ResRef, string]()

  proc indexBif(dir: string): KeyBifEntry =
    var sz: BiggestInt = 0
    var entries = newSeq[ResolvedResRef]()
    for f in walkDir(sourceDir / dir, true):
      if f.kind == pcFile or (not noLinks and f.kind == pcLinkToFile):
        # this will exception if the res doesnt have a good type
        let resref = newResolvedResRef(f.path)
        entries.add(resref)
        resrefToDir[resref] = dir
        let fullFn = sourceDir / dir / f.path
        sz += getFileSize(fullFn)

    # Make sure resrefs are stored in alphabetical order (per bif), to produce
    # reproducible builds.
    sort(entries) do (lhs, rhs: ResolvedResRef) -> int:
      system.cmp[string](lhs.toFile.toUpperAscii, rhs.toFile.toUpperAscii)

    result = (directory: if noSquash: bifPrefix else: "", name: splitFile(dir).name, entries: entries.mapIt(it.ResRef))

  # First walk: resolve all resrefs, bail on error.
  info "walking tree to resolve all resrefs"

  var bifs = newSeq[KeyBifEntry]()
  for wd0 in walkDir(sourceDir, true):
    if wd0.kind == pcDir:
        # If the file is part of any svn or git storage data, skip
        if [".svn", ".git"].find(wd0.path) != -1:
          continue
        var bif = indexBif(wd0.path)
        bifs.add(bif)

  info "writing"

  writeKeyAndBif(dataVersion, dataExoComp, dataCompAlg, targetDir, keyFilename, bifPrefix, bifs) do (r: ResRef, io: Stream) -> (int, SecureHash):
    let fullFn = sourceDir / resrefToDir[r] / r.resolve().get().toFile
    let data = readFile(fullFn)
    io.write(data)
    var sha1: SecureHash
    if dataVersion == KeyBifVersion.E1: sha1 = secureHash(data)
    (data.len, sha1)

  info "all done"

let keyName   = splitFile($args["<key>"]).name
let sourceDir = $args["<source>"]
let targetDir = $args["<destination>"]

if not dirExists(sourceDir):
  quit("source does not contain any data")

# Make sure we have a target dir
if not args["--force"] and dirExists(targetDir):
  for k in walkDir(targetDir):
    quit("Target directory not empty; aborting for your own safety.")

createDir(targetDir)

packKeyBif(keyName, sourceDir, targetDir)
