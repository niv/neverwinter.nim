import std/[os, strutils, pegs]

const Nimble          = slurp(currentSourcePath().splitFile().dir & "/../neverwinter.nimble")
const Template        = slurp(currentSourcePath().splitFile().dir & "/../VERSION.tpl").strip
const Licence         = slurp(currentSourcePath().splitFile().dir & "/../LICENCE").strip
const GitBranch*      = staticExec("git symbolic-ref -q --short HEAD").strip
const GitRev*         = staticExec("git rev-parse HEAD").strip
const PackageVersion* = block:
  var matches: seq[string] = newSeq[string](1)
  if Nimble.find(peg"""\n'version'\s+'='\s+'"'{\d+'.'\d+'.'\d+}'"'\n""", matches) == -1:
    raise newException(ValueError,
      "Could not extract version number from neverwinter.nimble at compile time")
  else:
    matches[0]
const VersionString* = "neverwinter " & PackageVersion & " (" & GitBranch & "/" & GitRev[0..5] &
  ", nim " & NimVersion & ")"

proc getVersionString*(): string = VersionString

proc printVersion*() =
  echo Template.
       replace("$LICENCE", Licence).
       replace("$VERSION", VersionString)
  quit(0)
