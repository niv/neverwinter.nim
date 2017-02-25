import shared
let args = DOC """
Extract file(s) from resman into a directory.

Usage:
  $0 [options] <file>...
  $0 [options] --all
  $0 -h | --help

Options:
  -d DIRECTORY                Save files to DIRECTORY [default: .]
$OPT
"""

let rm = newBasicResMan()

let destination = ($args["-d"]).expandFilename
doAssert(dirExists(destination), "destination directory does not exist")

proc toSeqx[T](c: HashSet[T]): seq[T] =
  # Grrr, stdlib.
  result = newSeq[T]()
  for cc in c: result.add(cc)

let scope: seq[ResRef] =
  if args["--all"]: toSeqx[ResRef](rm.contents)
  else: map(@(args["<file>"])) do (x: string) -> ResRef: newResolvedResRef(x)

let res = scope.mapIt(rm[it])

for o in res:
  if not o.isSome: quit("Could not find file in resman: " & $o & ", nothing written")

var rr = newSeq[Res]()
for o in res.withProgressBar("resolve: "):
  rr.add(o.get())

for resolved in rr.withProgressBar("write: "):
  writeFile(destination / $resolved.resRef, resolved.readAll())
