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


proc newBasicResMan*(root: string): ResMan =
  ## Sets up a resman that defaults to what 1.8 looks like.

  let keys = ["chitin", "xp1",  "xp2", "xp3", "xp2patch"]

  proc loadKey(into: ResMan, key: string) =
    # let fn = if tryOther and fileExists(otherLangRoot & "data" & DirSep & key & ".key"):
    #            otherLangRoot & "data" & DirSep & key & ".key"
    #          else: root & "data" & DirSep & key & ".key"

    let fn = root & "data" & DirSep & key & ".key"

    # echo "  key: ", key, " from ", fn
    doAssert(fileExists(fn), "key not found in other or base: " & key)

    let kt = readKeyTable(newFileStream(fn), fn) do (fn: string) -> Stream:
      # let bifFn = if tryOther and fileExists(otherLangRoot & fn): otherLangRoot & fn
      #             else: root & fn
      let bifFn = root & fn
      doAssert(fileExists(bifFn), "key file asks for " & fn & ", but not found")
      # echo "    bif: ", bifFn
      newFileStream(bifFn)

    into.add(kt)

  result = resman.newResMan()

  # Load resman. keyfiles and distro override.
  for k in keys: result.loadKey(k)
  result.add(newResDir(root & "ovr"))