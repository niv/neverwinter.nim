import shared, terminal

let Args = DOC """
This utility walks a set of keyfiles and and prints out statistics on how much
data is shadowed.

Usage:
  $0 [options] <key>...
  $USAGE

  $OPT
"""

# Load keytables in order.
let keyTables = @(Args["<key>"]).map() do (key: string) -> KeyTable:
  let keyRoot = key.expandFilename.splitFile().dir
  result = readKeyTable(openFileStream(key, fmRead), key) do (bif: string) -> Stream:
    result = openFileStream(keyRoot / bif.extractFilename)

# Holds all resrefs per key table (idx) that are shadowed by later key tables.
let shadowed = keyTables.map() do (keyIdx: int, key: KeyTable) -> seq[ResRef]:
  result = newSeq[ResRef]()
  for o in key.contents:
    if keyTables[keyIdx+1..keyTables.high].anyIt(it.contains(o)):
      result.add(o)

const Padding = 12

echo "Shadowed:"
echo align("bytes", Padding), "  ",
     align("files", Padding), "  ",
     "in"
echo repeat("-", terminalWidth())

for keyIdx, key in keyTables:
  let shadowedBytes = foldl(shadowed[keyIdx], a + key.demand(b).len, 0i64)

  echo align(shadowedBytes.formatSize, Padding), "  ",
    align($shadowed[keyIdx].len, Padding), "  ",
    key
