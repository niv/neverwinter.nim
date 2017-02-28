import shared

let args = DOC """
Un/packs erf files.

Usage:
  $0 [options] -c <entry>...
  $0 [options] -x [<file>...]
  $0 [options] -t
  $USAGE

Options:
  -f ERF                      Operate on FILE instead of stdin/out [default: -]

  -c                          Create archive from input files or directories
  -x                          Unpack files into current directory
  -t                          List files in archive

  -e, --erf-type TYPE         Set erf header type [default: ERF]
  $OPT
"""

let filename = $args["-f"]

proc pathToResRefMapping(path: string, outTbl: var Table[ResRef, string]) =
  if fileExists(path):
    # Fail for explicitly listed filenames.
    let rr = newResolvedResRef(path.extractFilename)
    if outTbl.hasKey(rr): error("duplicate resef " & path); quit(1)
    else: outTbl[rr] = path

  elif dirExists(path):
    for wd in walkDir(path):
      if wd.kind == pcDir:
        pathToResRefMapping(wd.path, outTbl)

      elif wd.kind == pcFile:
        let r = tryNewResolvedResRef(wd.path.extractFilename)
        if r.isSome: pathToResRefMapping(wd.path, outTbl)
        else: warn(wd.path & " is not a valid resref")

  else: quit("No idea what to do about: " & path)

proc openErf(): Erf =
  let infile = if filename == "-": newFileStream(stdin) else: newFileStream(filename)
  result = infile.readErf()

if args["-c"]:
  var resrefToFile = initTable[ResRef, string]() # rr -> path to local file.

  for fi in @(args["<entry>"]):
    pathToResRefMapping(fi, resrefToFile)

  let outfile = if filename == "-": newFileStream(stdout)
                else: newFileStream(filename, fmWrite)
  doAssert(outfile != nil, "Could not open " & filename & " for writing")

  writeErf(outfile, $args["--erf-type"], resrefToFile,
           initTable[int, string](), 0) do (r: ResRef) -> void:
    debug("Writing: ", r)

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
