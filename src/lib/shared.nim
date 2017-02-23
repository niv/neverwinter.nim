import os, streams

import neverwinter.resman,
  neverwinter.resref,
  neverwinter.key,
  neverwinter.resfile,
  neverwinter.resmemfile,
  neverwinter.resdir,
  neverwinter.erf

proc getInOutFilesFromParams*(allowOverwrite = false): tuple[i: Stream, o: Stream] =
  ## Used by command line utilities to transform simple in/out parameters to
  ## file streams.

  result.i = newFileStream(stdin)
  result.o = newFileStream(stdout)

  if paramCount() > 0 and paramStr(1) != "-":
    result.i = newFileStream(paramStr(1))
    doAssert(result.i != nil, "Could not open file for reading: " & paramStr(1))

  if paramCount() > 1 and paramStr(2) != "-":
    if not allowOverwrite and fileExists(paramStr(2)):
      quit("outfile exists, aborting for your own safety.")

    result.o = newFileStream(paramStr(2), fmWrite)
    doAssert(result.o != nil, "Could not open file for writing: " & paramStr(2))


proc newBasicResMan*(root: string, language = ""): ResMan =
  ## Sets up a resman that defaults to what 1.8 looks like.
  ## Will load an additional language directory, if language is given.

  let keys = ["chitin", "xp1",  "xp2", "xp3", "xp2patch"]

  let tryOther = language != ""
  let otherLangRoot = root / "lang" / language / "data"

  doAssert(not tryOther or dirExists(otherLangRoot), "language " & otherLangRoot &
    " not found")

  proc loadKey(into: ResMan, key: string) =
    let fn = if tryOther and fileExists(otherLangRoot / key & ".key"):
               otherLangRoot / key & ".key"
             else: root / "data" / key & ".key"

    let ktfn = newFileStream(fn)
    doAssert(ktfn != nil, "key not found or inaccessible: " & fn)

    let kt = readKeyTable(ktfn, fn) do (fn: string) -> Stream:
      let otherBifFn = otherLangRoot / fn.extractFilename()
      let bifFn = if tryOther and fileExists(otherBifFn): otherBifFn
                  else: root / fn

      result = newFileStream(bifFn)
      doAssert(result != nil, "bif not found or inaccessible: " & bifFn)

    into.add(kt)

  result = resman.newResMan()

  # Load resman. keyfiles and distro override.
  for k in keys: result.loadKey(k)
  result.add(newResDir(root / "ovr"))
