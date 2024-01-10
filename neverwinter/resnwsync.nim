import std/streams, std/tables, std/os, std/sequtils, std/strutils, std/times, std/logging,
  std/hashes

when NimMajor == 2:
  import db_connector/db_sqlite
else:
  import std/db_sqlite

import resman, compressedbuf, checksums

const NWSyncCompressedBufMagicStr* = "NSYC"
const NWSyncCompressedBufMagic* = makeMagic(NWSyncCompressedBufMagicStr)

# -----------
#  Shards/DB
# -----------

type
  ShardId       = int
  ManifestSHA1* = SecureHash
  ResRefSHA1*   = SecureHash

  NWSyncShard = tuple
    id: ShardId
    conn: DbConn

  NWSync* = ref object
    meta: DbConn
    shards: Table[ShardId, NWSyncShard]
    shardmap: Table[ResRefSHA1, ShardId]

proc hash(x: SecureHash): Hash = hash(Sha1Digest x)

proc `$`(self: NWSyncShard): string =
  "ResNWSyncShard:(" & $self.id & ")"

proc openNWSync*(nwsyncPath: string): NWSync =
  new(result)
  let metafn = nwsyncPath / "nwsyncmeta.sqlite3"
  doAssert(fileExists(metafn), "meta database not found: " & metafn)
  result.meta = open(metafn, "", "", "")
  for row in result.meta.fastRows(sql"select id, serial from shards"):
    let shardId = row[0].parseInt
    let shardfn = nwsyncPath / "nwsyncdata_" & $(shardId - 1) & ".sqlite3"
    doAssert(fileExists(shardfn), "shard database not found: " & shardfn)
    let shard = (id: shardId, conn: open(shardfn, "", "", "")).NWSyncShard
    debug "  ", shard
    result.shards[shardId] = shard
    for q in result.shards[shardId].conn.fastRows(sql"select sha1 from resrefs"):
      let sha1 = parseSecureHash(q[0])
      assert(not result.shardmap.contains(sha1))
      result.shardmap[sha1] = shardId

proc getAllManifests*(nwsync: NWSync): seq[ManifestSHA1] =
  nwsync.meta.getAllRows(sql"select sha1 from manifests").mapIt(it[0].parseSecureHash)

proc getAllResRefs*(nwsync: NWSync): seq[ResRefSHA1] =
  toSeq nwsync.shardmap.keys()

# Raises ValueError on error and when not found
proc readResRefData*(nwsync: NWSync, sha1: ResRefSHA1): string =
  if nwsync.shardmap.contains(sha1):
    let id = nwsync.shardmap[sha1]
    let ret = nwsync.shards[id].conn.getValue(
      sql"select data from resrefs where sha1 = ?",
      toLowerAscii($sha1))
    if ret.len > 4:
      return
        if ret.substr(0, 3) == NWSyncCompressedBufMagicStr:
          ret.decompress(NWSyncCompressedBufMagic)
        else:
          ret

  raise newException(ValueError, "not found: " & $sha1)

# -----------
#  Manifests
# -----------

type
  ResNWSyncManifest* = ref object of ResContainer
    nwcsync: NWSync
    ## A container referencing a single manifest.
    manifestSha1: ManifestSHA1
    mtime: Time
    contents: OrderedSet[ResRef]
    sha1map: Table[ResRef, ResRefSHA1]

proc newResNWSyncManifest*(nwsync: NWSync, manifestSha1: ManifestSHA1): ResNWSyncManifest =
  new(result)
  result.nwcsync = nwsync

  result.manifestSha1 = manifestSha1
  result.contents = initOrderedSet[ResRef]()

  result.mtime = result.nwcsync.meta.getValue(
    sql"select created_at from manifests where sha1 = ?", result.manifestSha1).parseInt().fromUnix()

  for row in result.nwcsync.meta.fastRows(
      sql"select resref, restype, resref_sha1 from manifest_resrefs where manifest_sha1 = ?",
        toLowerAscii($result.manifestSha1)):
    let resolved = newResolvedResRef(row[0] & "." & parseInt(row[1]).ResType.getResExt())
    result.contents.incl(resolved)
    result.sha1map[resolved] = parseSecureHash(row[2])

method contains*(self: ResNWSyncManifest, rr: ResRef): bool =
  self.contents.contains(rr)

method demand*(self: ResNWSyncManifest, rr: ResRef): Res =
  let sha1 = self.sha1map[rr]
  let shardId = self.nwcsync.shardmap[sha1]
  let data = self.nwcsync.shards[shardId].conn.getValue(
    sql"select data from resrefs where sha1 = ?", sha1)
  newRes(origin = newResOrigin(self), resref = rr, mtime = self.mtime,
    io = newStringStream(data), ioSize = data.len,
    sha1 = sha1)

method count*(self: ResNWSyncManifest): int =
  self.contents.len

method contents*(self: ResNWSyncManifest): OrderedSet[ResRef] =
  self.contents

method `$`*(self: ResNWSyncManifest): string =
  "ResNWSyncManifest:(" & toLowerAscii($self.manifestSha1) & ")"
