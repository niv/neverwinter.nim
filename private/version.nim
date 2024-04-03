import std/[os, strutils, parsecfg, streams]

const Nimble: string   = slurp(currentSourcePath().splitFile().dir & "/../neverwinter.nimble")
const Template: string = slurp(currentSourcePath().splitFile().dir & "/../VERSION.tpl").strip
const Licence: string  = slurp(currentSourcePath().splitFile().dir & "/../LICENCE").strip

const GitBranch*: string = staticExec("git symbolic-ref -q --short HEAD").strip
const GitRev*: string    = staticExec("git rev-parse HEAD").strip

proc getVersionString*(): string =
  let nimbleConfig       = loadConfig(newStringStream(Nimble))
  let PackageVersion     = nimbleConfig.getSectionValue("", "version")
  result = "neverwinter " & PackageVersion & " (" & GitBranch & "/" & GitRev[0..5] & ", nim " & NimVersion & ")"

proc printVersion*() =
  let versionString = getVersionString()

  echo Template.
       replace("$LICENCE", Licence).
       replace("$VERSION", versionString)
  quit(0)
