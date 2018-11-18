import streams, tables, os, sequtils, strutils, times, logging, std/sha1
import db_sqlite

import resman

type
  ShardId = int
  SHA1 = string

  NWSyncShard = tuple
    id: ShardId
    conn: DbConn

  NWSync* = ref object
    meta: DbConn
    shards: Table[ShardId, NWSyncShard]
    shardmap: Table[SHA1, ShardId]

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
      result.shardmap[q[0]] = shardId

proc getAllManifests*(nwsync: NWSync): seq[string] =
  nwsync.meta.getAllRows(sql"select sha1 from manifests").mapIt(it[0])

type
  ResNWSyncManifest* = ref object of ResContainer
    nwcsync: NWSync
    ## A container referencing a single manifest.
    manifestSha1: SHA1
    mtime: Time
    contents: OrderedSet[ResRef]
    sha1map: Table[ResRef, SHA1]

proc newResNWSyncManifest*(nwsync: NWSync, manifestSha1: string): ResNWSyncManifest =
  new(result)
  result.nwcsync = nwsync

  result.manifestSha1 = manifestSha1
  result.contents = initOrderedSet[ResRef]()

  echo manifestSha1
  result.mtime = result.nwcsync.meta.getValue(
    sql"select created_at from manifests where sha1 = ?", result.manifestSha1).parseInt().fromUnix()

  for row in result.nwcsync.meta.fastRows(
      sql"select resref, restype, resref_sha1 from manifest_resrefs where manifest_sha1 = ?", result.manifestSha1):
    let resolved = newResolvedResRef(row[0] & "." & parseInt(row[1]).ResType.getResExt())
    result.contents.incl(resolved)
    result.sha1map[resolved] = row[2]

method contains*(self: ResNWSyncManifest, rr: ResRef): bool =
  self.contents.contains(rr)

method demand*(self: ResNWSyncManifest, rr: ResRef): Res =
  let sha1 = self.sha1map[rr]
  let shardId = self.nwcsync.shardmap[sha1]
  let data = self.nwcsync.shards[shardId].conn.getValue(
    sql"select data from resrefs where sha1 = ?", sha1)
  newRes(origin = newResOrigin(self), resref = rr, mtime = self.mtime,
    io = newStringStream(data), ioSize = data.len, ioOwned = true,
    sha1 = parseSecureHash(sha1))

method count*(self: ResNWSyncManifest): int =
  self.contents.len

method contents*(self: ResNWSyncManifest): OrderedSet[ResRef] =
  self.contents

method `$`*(self: ResNWSyncManifest): string =
  "ResNWSyncManifest:(" & self.manifestSha1 & ")"
