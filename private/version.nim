import os, strutils, parsecfg, streams

const Nimble: string   = slurp(currentSourcePath().splitFile().dir & "/../neverwinter.nimble")
const Template: string = slurp(currentSourcePath().splitFile().dir & "/../VERSION").strip
const Licence: string  = slurp(currentSourcePath().splitFile().dir & "/../LICENCE").strip

const GitBranch*: string = staticExec("git symbolic-ref -q --short HEAD").strip
const GitRev*: string    = staticExec("git rev-parse HEAD").strip

let nimbleConfig        = loadConfig(newStringStream(Nimble))
let PackageVersion*     = nimbleConfig.getSectionValue("", "version")
let PackageDescription* = nimbleConfig.getSectionValue("", "description")
let VersionString*  = "neverwinter " & PackageVersion & " (" & GitBranch & "/" & GitRev[0..5] & ", nim " & NimVersion & ")"

proc printVersion*() =
  echo Template.
       replace("$LICENCE", Licence).
       replace("$VERSION", VersionString)
  quit(0)
