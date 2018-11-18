import os, strutils, times

## This embeds the LICENCE file (and git revision data) at *compile time*.

const GitBranch*: string = staticExec("git symbolic-ref -q --short HEAD").strip
const GitRev*: string = staticExec("git rev-parse HEAD").strip
# const BuildTime = format(getLocalTime(getTime()), "d MMMM yyyy HH:mm")

const Template: string = readFile(currentSourcePath().splitFile().dir & "/../VERSION").strip
const Licence: string = readFile(currentSourcePath().splitFile().dir & "/../LICENCE").strip

proc printVersion*() =
  let version = GitBranch & " (" & GitRev[0..5] & ")"

  echo Template.
       replace("$LICENCE", Licence).
       replace("$VERSION", version)
