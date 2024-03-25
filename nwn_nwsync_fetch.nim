import docopt; let ARGS = docopt """
nwsync_fetch

Build a download list for external downloaders to fully sync a manifest
into a repository. Can be used for mirroring.

Will not skip already downloaded files (but aria2c will if you say -c).

Currently only supports aria2c. Example:
  nwsync_fetch ./local/repo/path/ http://my-repo.url/ \
    4e1243bd22c66e76c2ba9eddc1f91394e57f9f83 | aria2c --input-file - -c

Usage:
  nwsync_fetch [options] <root> <url> <sha1>
  nwsync_fetch (-h | --help)
  nwsync_fetch --version

Options:
  -h --help         Show this screen.
  -V --version      Show version.
  -v --verbose      Verbose operation (>= DEBUG).
  -q --quiet        Quiet operation (>= WARN).
"""

from libversion import handleVersion
if ARGS["--version"]: handleVersion()

import httpclient, streams, sets

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
