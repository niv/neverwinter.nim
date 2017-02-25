import shared
let args = DOC """
Extract file(s) from resman into a directory.

Usage:
  $0 [options] <file>...
  $0 -h | --help

Options:
  -o DIRECTORY                Save files to DIRECTORY [default: .]
$OPT
"""

let rm = newBasicResMan()

let destination = ($args["-o"]).expandFilename
doAssert(dirExists(destination), "destination directory does not exist")

let res = args["<file>"].mapIt((rr: it, res: rm[it]))
for o in res: doAssert(o.res.isSome, "Not in resman: " & $o.rr)

for o in res: writeFile(destination / $o.rr, o.res.get().readAll())
