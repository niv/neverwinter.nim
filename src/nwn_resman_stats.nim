import shared
let Args = DOC """
This utility gives you some general statistics on a resman view.  This only
includes files seen by resman, not shadowed content.

Usage:
  $0 [options]

Options:
$OPT
"""

let rm = newBasicResMan()

var count = initCountTable[ResType]()
var size  = initTable[ResType, int64]()

for o in rm.contents.withProgressBar("index: "):
  count.inc(o.resType)
  if not size.hasKey o.resType: size[o.resType] = 0
  let retr = rm[o].get()

  doAssert(retr.len >= 0, $retr & " size is " & $retr.len)

  size[o.resType] += retr.len

count.sort

for k, v in count:
  echo k, "\t", v, "\t", size[k].formatSize
