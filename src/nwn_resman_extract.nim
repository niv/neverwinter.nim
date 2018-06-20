import shared

let args = DOC """
Extract file(s) from resman into a directory.

Usage:
  $0 [options]
  $USAGE

Options:
  --all                       Match all files.
  -p, --pattern PATTERN       Match only files where the name contains PATTERN.
                              Wildcards are not supported at this time.
  -b, --binary BINARY         Match only files where the data contains BINARY.
  -v, --invert-match          Invert matching rules.

  -d DIRECTORY                Save files to DIRECTORY [default: .]
  $OPTRESMAN
"""

if not args["--pattern"] and not args["--binary"] and not args["--all"]:
  quit("Give at least one of --pattern, --binary or --all")

let rm = newBasicResMan()

let destination = ($args["-d"])
doAssert(dirExists(destination), "destination directory does not exist")

let invert       = args["--invert-match"]
let patternMatch = if args["--pattern"]: $args["--pattern"] else: ""
let binaryMatch  = if args["--binary"]: $args["--binary"] else: ""

for resolved in filterByMatch(rm, patternMatch, binaryMatch, invert):
  if args["--verbose"]: echo $resolved.resRef
  writeFile(destination / $resolved.resRef, resolved.readAll())
