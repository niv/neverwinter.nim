# Tests scriptcomp on all nss files in corpus dir

import std/os

import neverwinter/[resman, resdir, resfile, restype, nwscript/compiler]

const DebugSymbols = true

let cwd = currentSourcePath().splitFile().dir

let rm = newResMan()
rm.add newResFile(cwd / "nwtestvmscript.nss")
rm.add newResDir(cwd / "corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

let cNSS = newCompiler(LangSpecNWTestScript, DebugSymbols, rm)

var anyRan = false
for file in walkFiles(cwd / "corpus" / "*.nss"):
  let ret = cNSS.compileFile(splitFile(file).name)
  doAssert ret.code == 0, file & " failed to compile: " & ret.str
  doAssert ret.bytecode != ""
  doAssert ret.debugcode != ""
  anyRan = true

doAssert anyRan
