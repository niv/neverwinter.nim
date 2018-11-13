import shared

let args = DOC """
This utility packs a .key file and all associated bifs from directory tree.

Usage:
  $0 [options] <key> <source> <destination>
  $USAGE

Options:
  --no-symlinks               Don't follow symlinks
  -f --force                  Force pack even if target directory has stuff in it.
  $OPT
"""

let noLinks = args["--no-symlinks"]

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

    result = (directory: bifPrefix, name: splitFile(dir).name, entries: entries.mapIt(it.ResRef))

  # First walk: resolve all resrefs, bail on error.
  info "walking tree to resolve all resrefs"

  var bifs = newSeq[KeyBifEntry]()
  for wd0 in walkDir(sourceDir, true):
    if wd0.kind == pcDir:
        var bif = indexBif(wd0.path)
        bifs.add(bif)

  info "writing"

  writeKeyAndBif(targetDir, keyFilename, bifPrefix, bifs) do (r: ResRef, io: Stream):
    let fullFn = sourceDir / resrefToDir[r] / r.resolve().get().toFile
    io.write(readFile(fullFn))

  info "all done"

let keyName   = $args["<key>"]
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
