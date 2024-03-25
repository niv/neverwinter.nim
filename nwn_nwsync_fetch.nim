import shared

let ARGS = DOC """
Build a download list for external downloaders to fully sync a manifest
into a repository. Can be used for mirroring.

Will not skip already downloaded files (but aria2c will if you say -c).

Currently only supports aria2c. Example:
  nwsync_fetch ./local/repo/path/ http://my-repo.url/ \
    4e1243bd22c66e76c2ba9eddc1f91394e57f9f83 | aria2c --input-file - -c

Usage:
  $0 [options] <root> <url> <sha1>
  $USAGE

Options:
  $OPT
"""

import std/[httpclient, streams, sets]

import neverwinter/nwsync

let rootDir = $(ARGS["<root>"])
let baseUrl = $(ARGS["<url>"])
let manifestSha1 = $(ARGS["<sha1>"])

let http = newHttpClient()

proc queue(path, file: string) =
  echo baseUrl & "/" & path & "/" & file
  echo " dir=" & rootDir & "/" & path
  echo " out=" & file
  echo " auto-file-renaming=false"

let mf = readManifest(newStringStream(http.getContent(baseUrl & "/manifests/" & manifestSha1)))

queue "manifests", manifestSha1
queue "manifests", manifestSha1 & ".json"

var seenSha1 = initHashSet[string]()

for q in mf.entries:
  if seenSha1.contains(q.sha1): continue
  seenSha1.incl(q.sha1)

  let dir = "data/sha1" & "/" & q.sha1[0..1] & "/" & q.sha1[2..3]
  queue dir, q.sha1
