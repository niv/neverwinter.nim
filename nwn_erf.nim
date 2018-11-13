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
  -v                          Echo file names as they are being worked on

  -r NUM                      Recurse at most N directories when finding entries to pack [default: 1]
  --no-symlinks               Don't follow symlinks

  -e, --erf-type TYPE         Set erf header type [default: ERF]
  $OPT
"""

let filename = $args["-f"]
let maxRecurseLevel = parseInt($args["-r"])
let noLinks = args["--no-symlinks"]
let verbose = args["-v"]

proc pathToResRefMapping(path: string, outTbl: var Table[ResRef, string],
    outSeq: var seq[ResRef], recurseLevel: int) =

  if recurseLevel > maxRecurseLevel: return

  if fileExists(path):
    # Fail for explicitly listed filenames.
    let rr = newResolvedResRef(path.extractFilename)
    if outSeq.find(rr) != -1:
      error("duplicate resef " & path)
      quit(1)
    else:
      outSeq.add(rr)
      outTbl[rr] = path

  elif dirExists(path):
    for wd in walkDir(path):
      if wd.kind == pcDir or (not noLinks and wd.kind == pcLinkToDir):
        pathToResRefMapping(wd.path, outTbl, outSeq, recurseLevel + 1)

      elif wd.kind == pcFile or (not noLinks and wd.kind == pcLinkToFile):
        let r = tryNewResolvedResRef(wd.path.extractFilename)
        if r.isSome: pathToResRefMapping(wd.path, outTbl, outSeq, recurseLevel)
        else: warn(wd.path & " is not a valid resref")

  else: quit("No idea what to do about: " & path)

proc openErf(): Erf =
  let infile = if filename == "-": newFileStream(stdin) else: newFileStream(filename)
  doAssert(infile != nil, "Coult not open " & filename & " for reading")
  result = infile.readErf()

if args["-c"]:
  var resrefToFile = initTable[ResRef, string]() # rr -> path to local file.

  var entries = newSeq[ResRef]()

  for fi in @(args["<entry>"]):
    pathToResRefMapping(fi, resrefToFile, entries, 1)

  let outfile = if filename == "-": newFileStream(stdout)
                else: newFileStream(filename, fmWrite)
  doAssert(outfile != nil, "Could not open " & filename & " for writing")

  writeErf(outFile, fileType = $args["--erf-type"], locStrings = initTable[int, string](),
      strRef = 0, entries = entries) do (r: ResRef, io: Stream):

    if verbose: echo r
    let data = readFile(resRefToFile[r])
    io.write(data)

elif args["-t"]:
  let erf = openErf()
  for c in erf.contents:
    echo c

elif args["-x"]:
  let erf = openErf()
  let want = @(args["<file>"])
  for c in erf.contents:
    if want.len == 0 or want.find($c) != -1:
      if verbose: echo c
      writeFile($c, erf.demand(c).readAll())

else: quit("??")
