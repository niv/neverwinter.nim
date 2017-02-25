import shared; let args = DOC """
Un/packs erf files.

Supported file formats: HAK, ERF, MOD, NWM

Usage:
  $0 [options] -c <file>...
  $0 [options] -x [<file>...]
  $0 [options] -t
  $0 -h | --help

Options:
  -c                          Create archive from input files.
  -x                          Unpack files into current directory.
  -t                          List files in archive.
  -f ERF                      Operate on FILE instead of stdin/out [default: -]
  $OPT
"""

let filename = $args["-f"]

proc openErf(): Erf =
  let infile = if filename == "-": newFileStream(stdin) else: newFileStream(filename)
  result = infile.readErf()

if args["-c"]:
  quit("the api for that isnt really done yet, sorry. bug me if you need this now")

elif args["-t"]:
  let erf = openErf()
  for c in erf.contents:
    echo c

elif args["-x"]:
  let erf = openErf()
  let want = @(args["<file>"])
  for c in erf.contents.withProgressBar:
    if want.len == 0 or want.find($c) != -1:
      writeFile($c, erf.demand(c).readAll())

else: quit("??")
