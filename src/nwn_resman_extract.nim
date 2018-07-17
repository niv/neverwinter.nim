import shared

let args = DOC """
Extract file(s) from resman into a directory.

Usage:
  $0 [options] <file>...
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

if not (args["<file>"] xor (args["--pattern"] or args["--binary"] or args["--all"])):
  quit("Give <file> OR any of (--pattern, --binary, --all); try -h to see all options")

let rm = newBasicResMan()

let destination = ($args["-d"])
doAssert(dirExists(destination), "destination directory does not exist")

if args["<file>"]:
  let res = args["<file>"].mapIt(newResolvedResRef(it)).mapIt(rm[it].get())
  for f in res:
    if args["--verbose"]: echo $f.resRef
    writeFile(destination / $f.resRef, f.readAll())

elif args["--all"]:
  for rr in rm.contents:
    let resolved = rm[rr].get()
    if args["--verbose"]: echo $resolved.resRef
    writeFile(destination / $resolved.resRef, resolved.readAll())

else:
  let invert       = args["--invert-match"]
  let patternMatch = if args["--pattern"]: $args["--pattern"] else: ""
  let binaryMatch  = if args["--binary"]: $args["--binary"] else: ""

  for resolved in filterByMatch(rm, patternMatch, binaryMatch, invert):
    if args["--verbose"]: echo $resolved.resRef
    writeFile(destination / $resolved.resRef, resolved.readAll())
