# --graphviz writes `node [shape=record]`, where { } | < > in a label are field
# syntax. String data must be escaped, or `dot` rejects the whole file.

import std/[os, osproc, strutils]
import neverwinter/nwscript/compiler
import neverwinter/[restype, resfile, resdir, resman]

let
  work = getTempDir() / "tgraphviz"
  workSrc = work / "src"
  workGv = work / "gv"

removeDir(work)
createDir(work)
createDir(workSrc)
createDir(workGv)

writeFile(workSrc / "gvlabels.nss", """
void main()
{
    string s = "{a|b} <c> \"q\" back\\slash";
}
""")

const
  SourcePath = currentSourcePath().splitFile().dir
  LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

let rm = newResMan()
rm.add newResFile(SourcePath / "nwtestvmscript.nss")
rm.add newResDir(workSrc)

let
  cNSS = newCompiler(LangSpecNWTestScript, false, rm, graphvizOut = workGv)
  ret = cNSS.compileFile("gvlabels")
doAssert ret.code == 0, "gvlabels.nss should compile, got $1 ($2)" % [$ret.code, ret.str]

let dot = readFile(workGv / "gvlabels.dot")

# The string survives, with every special character escaped.
doAssert """STR: '\{a\|b\} \<c\> \"q\" back\\slash'""" in dot,
  "string constant not escaped as expected:\n" & dot

# If graphviz is installed, it must accept the file.
let dotExe = findExe("dot")
if dotExe != "":
  let
    cmd = quoteShellCommand([dotExe, "-Tsvg", "-o", workGv / "out.svg", workGv / "gvlabels.dot"])
    (output, code) = execCmdEx(cmd)
  doAssert code == 0, "dot rejected the graph:\n" & output
