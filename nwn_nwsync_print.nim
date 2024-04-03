import shared

let ARGS = DOC """
This utility prints a manifest in human-readable form.

Usage:
  $0 [options] <manifest>
  $USAGE

Options:
  --verify                    Verify presence and checksum of files in manifest.
  $OPT
"""

import std/[logging, streams, strutils, options, os]

import neverwinter/[nwsync]
import neverwinter/nwsync/private/libupdate

addHandler newFileLogger(stderr, fmtStr = verboseFmtStr)
setLogFilter(if ARGS["--verbose"]: lvlDebug elif ARGS["--quiet"]: lvlWarn else: lvlInfo)

let doVerify = ARGS["--verify"]

doAssert(fileExists($ARGS["<manifest>"]))
let mf = readManifest(newFileStream($ARGS["<manifest>"], fmRead))


echo "--"
echo "Version:          ", mf.version
echo "Hash algorithm:   ", mf.algorithm
echo "Hash tree depth:  ", mf.hashTreeDepth
echo "Entries:          ", mf.entries.len
echo "Size:             ", formatSize(totalSize(mf))
echo "--"
echo ""

for entry in mf.entries:
  let resolved = entry.resref.resolve()

  let rystr = if resolved.isSome:
    resolved.unsafeGet().resExt
  else:
    $entry.resref.resType.int

  echo entry.sha1,
    " ",
    align($entry.size, 15),
    " ",
    align(rystr, 7),
    " ",
    escape(entry.resref.resref, "", "")

  if doVerify:
    let pa = pathForEntry(mf, $ARGS["<manifest>"] / ".." / "..", entry.sha1, false)
    let fs = openFileStream(pa, fmRead)
    defer: fs.close()
    if entry.sha1 != toLowerAscii $secureHash(decompress(fs, makeMagic("NSYC"))):
      raise newException(ValueError, "File checksum mismatch: " & pa)
