import docopt; let ARGS = docopt """
nwsync_prune

This utility will perform housekeeping on a nwsync repository.

It will:
- Make sure `latest` is a valid pointer, if present.
- Warns about manifests missing metadata.
- Prune all data files not contained in any stored manifests.
- Warn about missing data files.
- Clean up the directory structure.

Usage:
  nwsync_prune [options] <root>
  nwsync_prune (-h | --help)
  nwsync_prune --version

Options:
  -h --help         Show this screen.
  -V --version      Show version.
  -v --verbose      Verbose operation (>= DEBUG).
  -q --quiet        Quiet operation (>= WARN).

  -n --dry-run      Simulate, don't actually do anything.
"""

from libversion import handleVersion
if ARGS["--version"]: handleVersion()

import os,streams, strutils, logging, critbits, sequtils, sets

import neverwinter/resref
import neverwinter/nwsync

import libshared

proc isSha1*(candidate: string): bool =
  candidate.len == 40 and candidate.count({'a'..'f', '0'..'9'}) == 40

addHandler newConsoleLogger(fmtStr = verboseFmtStr)
setLogFilter(if ARGS["--verbose"]: lvlDebug elif ARGS["--quiet"]: lvlWarn else: lvlInfo)

proc act*(hr: varargs[string, `$`], runnable: proc()) =
  if not ARGS["--dry-run"]: runnable()
  else: notice "Dry run: ", foldl(@hr, a & " " & b)

let root = $ARGS["<root>"]

### CHECK: Ensure `latest` points to a valid manifest file

proc ensureLatestHeadIsValid*(rootDirectory: string) =
  info "Ensuring `latest` is valid:"
  if fileExists(rootDirectory / "latest"):
    let latest = readFile(rootDirectory / "latest").strip
    if not fileExists(rootDirectory / "manifests" / latest):
      error "`latest` points to non-existing manifest ", latest
    else:
      info "OK: ", latest
  else:
    info "`latest` does not exist (advisory)"

ensureLatestHeadIsValid(root)

### CHECK: look for missing data files
### MAINTENANCE: Remove all unreferenced files

proc updateManifestMetaData*(rootDirectory: string, mfh: string, mf: Manifest) =
  if not fileExists(rootDirectory / "manifests" / mfh & ".json"):
    error "Manifest ", mfh, " found, but has no accompanying metadata file. ",
      "You need to fix this manually by re-generating the manifest from source."

proc pruneUnreferencedFiles*(rootDirectory: string) =
  info "Checking for orphaned and missing files"

  # Manifests we have in storage: hash => Manifest
  info "Loading all manifests (this may take a good while)"
  var manifestsInRepository: CritBitTree[Manifest]
  for pa in walkDir(rootDirectory / "manifests"):
    let mfh = pa.path.extractFilename

    if not isSha1(mfh): continue

    info "Reading manifest ", mfh
    let mf = readManifest(pa.path)

    updateManifestMetaData(rootDirectory, mfh, mf)

    manifestsInRepository[mfh] = mf
    info "Manifest ", mfh,
      " containing ", formatSize(int mf.totalSize()),
      " (deduplicated to ", formatSize(int mf.deduplicatedSize()),
      ") in ",
      mf.entries.len, " files"

  # Referenced files: fileHash => [manifestHashes..]
  var referenced: CritBitTree[CritBitTree[void]]
  for mfh, mf in manifestsInRepository:
    for mfRes, mfEntry in mf.entries:
      let entryHash = toLowerAscii($mfEntry.sha1)
      if not referenced.hasKey(entryHash):
        var newTree: CritBitTree[void]
        referenced[entryHash] = newTree
      referenced[entryHash].incl(mfh)

  let referencedHashes = toHashSet toSeq referenced.keys
  info "Found ", referenced.len, " referenced files in all manifests"

  let inStorage = getFilesInStorage(rootDirectory)
  let inStorageHashes = toHashSet toSeq inStorage.keys
  info "Found ", inStorage.len, " files in storage"

  let orphans = inStorageHashes - referencedHashes
  let missing = referencedHashes - inStorageHashes

  info "Orphans (not referenced, but in storage): ", orphans.len
  info "Missing (referenced, but not in storage): ", missing.len

  for m in missing:
    let mfh = toSeq(referenced[m].items).
      #mapIt("($1, $2)".format(it, manifestsInRepository[it].entries[m].resref)).
      join(", ")
    error "MISSING: ", m, ", referenced in ", mfh

  for o in orphans:
    let f = inStorage[o]
    act("Would delete file: ", f) do (): removeFile(f)

pruneUnreferencedFiles(root)

### MAINTENANCE: remove all empty hash dirs

proc pruneEmptyDirectories*(dir: string) =
  for pc in walkDir(dir, relative = true):
    if pc.kind == pcDir and pc.path.len == 2: #todo: unsuck
      # Recurse first.
      pruneEmptyDirectories(dir / pc.path)

      let contents = toSeq(walkDir(dir / pc.path))
      if contents.len == 0:
        act("Would remove directory: ", dir / pc.path) do(): removeDir(dir / pc.path)

pruneEmptyDirectories(root / "data" / "sha1")

### MAINTENANCE: remove all outdated metadata files

proc pruneDanglingMetadata*(rootDirectory: string) =
  for pa in walkDir(rootDirectory / "manifests"):
    let sp = pa.path.splitFile
    if not isSha1(sp.name): continue

    if sp.ext == ".json" and not fileExists(rootDirectory / "manifests" / sp.name):
      notice "Removing dangling manifest metadata with no manifest: ", sp.name
      act("Would delete file: ", pa.path) do (): removeFile(pa.path)

pruneDanglingMetadata(root)
