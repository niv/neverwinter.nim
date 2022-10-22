import std/[streams, critbits, os, algorithm, strutils, sequtils, math, options]

import neverwinter/restype, neverwinter/resref, neverwinter/streamext
import neverwinter/sha1shim

const HashTreeDepth = 2 # this needs to match with the nwn sources

const Version = 3
# Binary Format: version=3
#
#   Manifest:
#     uint32            version
#     uint32            count of ManifestEntries
#     uint32            count of ManifestMappings
#     ManifestEntry[]   count entries
#     ManifestMapping[] count additional mappings
#
#   ManifestEntry: (sorted)
#     byte[20]          SHA1 (as raw bytes) of resref
#     uint32            size (bytes)
#     char[16]          resref (WITHOUT extension)
#     uint16            restype
#
#   ManifestMapping: (sorted)
#     uint32            Index into ManifestEntry array
#     char[16]          resref (WITHOUT extension)
#     uint16            restype
#
# End of version=3

type
  ManifestEntry* = ref object
    sha1*: string
    size*: uint32
    resref*: ResRef

  Manifest* = ref object
    version: uint32
    hashTreeDepth: uint32
    entries*: seq[ManifestEntry]

  ManifestError* = object of CatchableError


template check(cond: untyped, msg: string) =
  bind instantiationInfo
  {.line: instantiationInfo().}:
    if not cond:
      raise newException(ManifestError, msg)

proc `$`*(m: ManifestEntry): string =
  format("$1 $2", m.sha1, m.resref)

func pathForEntry*(rootDirectory, sha1str: string, hashTreeDepth = 2): string =
  ## Returns the data store path for the given sha1.
  result = rootDirectory / "data" / "sha1"
  for i in 0..<hashTreeDepth:
    let pfx = sha1str[i*2..<(i*2+2)]
    result = result / pfx
  result = result / sha1str

proc newManifest*(hashTreeDepth: uint32 = HashTreeDepth): Manifest =
  new(result)
  result.version = Version
  result.entries = newSeq[ManifestEntry]()
  result.hashTreeDepth = hashTreeDepth

proc version*(mf: Manifest): uint32 =
  mf.version

proc hashTreeDepth*(mf: Manifest): int =
  if mf.version == 3:
    int mf.hashTreeDepth
  elif mf.version == 2:
    2
  else:
    raise newException(ManifestError, "Unsupported manifest version")
proc algorithm*(mf: Manifest): string =
  if mf.version == Version:
    "SHA1"
  else:
    raise newException(ManifestError, "Unsupported manifest version")

proc totalSize*(mf: Manifest): int64 =
  ## Total size of manifest in bytes.
  mf.entries.mapIt(int64 it.size).sum()

proc deduplicatedSize*(mf: Manifest): int64 =
  ## Dedup size of manifest.
  let a = mf.entries.mapIt((sha1: it.sha1, size: it.size))
  a.deduplicate().mapIt(int64 it.size).sum()

proc readResRef(io: Stream): ResRef =
  let resref = io.readString(16).strip(leading=false,trailing=true,chars={'\0'}).toLowerAscii
  let restype = ResType io.readUInt16()
  newResRef(resref, restype)

proc writeResRef(io: Stream, rr: ResRef) =
  io.write(rr.resRef.toLowerAscii & repeat("\x00", 16 - rr.resRef.len))
  io.write(uint16 rr.resType)

proc readManifest*(io: Stream): Manifest =
  result = newManifest()

  let magic = io.readString(4)
  check(magic == "NSYM", "Not a manifest (invalid magic bytes)")

  result.version = io.readUint32()
  check(result.version == Version, "Unsupported manifest version " & $result.version)

  let entryCount = io.readUint32()
  let mappingCount = io.readUint32()

  check(entryCount > 0u, "No entries in manifest. This is not supported.")

  for i in 0..<entryCount:
    let sha1 = SecureHash readArray[20, uint8](io) do -> uint8:
      io.readUInt8()
    let sha1str = toLowerAscii($sha1)
    let size = io.readUint32()
    let rr = io.readResRef()

    check(rr.resolve().isSome, "Entry at position " & $i &
      " does not resolve to a valid resref: " & escape($rr))

    let ent = ManifestEntry(sha1: sha1str, size: size, resRef: rr)
    result.entries.add(ent)

  if mappingCount > 0u:
    for i in 0..<mappingCount:
      let index = io.readUint32()
      let rr = io.readResRef()

      check(index.int >= 0 and index.int < result.entries.len,
        "Mapping " & $i & " references non-existent entry " & $index)

      let mf = result.entries[int index]

      let ent = ManifestEntry(sha1: mf.sha1, size: mf.size, resRef: rr)
      result.entries.add(ent)

proc readManifest*(file: string): Manifest =
  readManifest(openFileStream(file, fmRead))

proc writeManifest*(io: Stream, mf: Manifest) =
  check(mf.version == Version, "Unsupported manifest version")

  # seen sha1sums that have been written to entries.
  # if it's already stored in a entry, we add an (additional) mapping instead.
  # maps to entryIndex
  var seenHashes: CritBitTree[int]

  var entryCount = 0
  var mappingCount = 0
  var mappingIo = newStringStream()
  var entriesIo = newStringStream()

  let sortedEntries = mf.entries.sorted() do (a, b: ManifestEntry) -> int:
    case system.cmp[string](a.sha1, b.sha1)
    of -1: -1
    of  1:  1
    else: system.cmp[string](a.resRef.resRef, b.resRef.resRef)

  for e in sortedEntries:
    let sha1 = $e.sha1

    if seenHashes.hasKey(sha1):
      mappingIo.write(uint32 seenHashes[sha1])
      mappingIo.writeResRef(e.resref)
      inc mappingCount

    else:
      seenHashes[sha1] = entryCount
      inc entryCount

      let ha = parseSecureHash(e.sha1)
      assert(sizeof(ha) == sizeof(SecureHash))
      entriesIo.write(ha)
      entriesIo.write(uint32 e.size)
      entriesIo.writeResRef(e.resref)

  io.write("NSYM")
  io.write(uint32 mf.version)
  io.write(uint32 entryCount)
  io.write(uint32 mappingCount)

  entriesIo.setPosition(0)
  mappingIo.setPosition(0)
  io.write entriesIo.readAll()
  io.write mappingIo.readAll()
