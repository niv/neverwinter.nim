import shared, terminal

let Args = DOC """
This utility walks a set of keyfiles and and prints out statistics on how much
data is transparent (duplicates that do not add changes to resman).

Usage:
  $0 [options] <key>...
  $OPT
"""

# Load keytables in order.
let keyTables = @(Args["<key>"]).map() do (key: string) -> KeyTable:
  let fs = newFileStream(key, fmRead)
  doAssert(fs != nil, "Could not read file: " & key)

  let keyRoot = key.expandFilename.splitFile().dir

  result = readKeyTable(fs, key) do (bif: string) -> Stream:
    result = newFileStream(keyRoot / bif.extractFilename)
    doAssert(result != nil, "Could not read bif for key: " & bif)

# Holds all resrefs per key table (idx) that are present in earlier key files
# and binary-identical.

let transparent = keyTables.map() do (keyIdx: int, key: KeyTable) -> seq[seq[ResRef]]:
  result = newSeq[seq[ResRef]]()
  for i in 0..keyTables.high: result.add(newSeq[ResRef]())

  if keyIdx > 0:

    for o in key.contents:
      let thisKeyOdata = key.demand(o).readAll()

      for chkIdx, chkKey in keyTables[0..<keyIdx-1]:
        if chkKey.contains(o) and chkKey.demand(o).readAll() == thisKeyOdata:
          result[chkIdx].add(o)

echo "Key has duplicates ->"
echo align("bytes", 15), "  ",
     align("files", 12), " in ",
     "keyfile"
echo repeat("-", terminalWidth())

for keyIdx, key in keyTables:
  let hasData = transparent[keyIdx].anyIt(it.len > 0)

  if hasData:
    echo key, " ->"

    for chkIdx, refs in transparent[keyIdx]:
      if refs.len > 0:
        let bytes = foldl(refs, a + key.demand(b).len, 0i64)
        echo align(bytes.formatSize, 15), "  ",
             align($refs.len, 12), " in ",
             keyTables[chkIdx]
