# Tests for the compiler warning channel (issue #157).
#
# A declaration/implementation return type mismatch is only accepted in the
# one direction that keeps the VM stack balanced, and it must say so. These
# checks pin down both the acceptance and the diagnostic, so that neither can
# silently disappear.

import std/[os, strutils, logging]
import neverwinter/nwscript/compiler
import neverwinter/[restype, resfile, resdir, resman]

const SourcePath = currentSourcePath().splitFile().dir

let rm = newResMan()
rm.add newResFile(SourcePath / "nwtestvmscript.nss")
rm.add newResDir(SourcePath / "corpus")

const LangSpecNWTestScript = ("nwtestvmscript", ResType 2009, ResType 2010, ResType 2064).LangSpec

let cNSS = newCompiler(LangSpecNWTestScript, false, rm)
cNSS.setRequireEntryPoint(false)

proc compile(file: string): CompileResult =
  result = cNSS.compileFile(file)

proc checkAccepted(file: string, declaredType: string) =
  let ret = compile(file)
  doAssert ret.code == 0, "$# should compile, got $# ($#)" % [file, $ret.code, ret.str]
  doAssert ret.warnings.len == 1,
    "$#: expected exactly one warning, got $# ($#)" % [file, $ret.warnings.len, ret.str]

  let w = ret.warnings[0]
  # 617 is FUNCTION IMPLEMENTATION AND DEFINITION DIFFER, reusing the error
  # strref numbering so tooling can match the diagnostic.
  doAssert w.code == 617, "$#: expected warning code 617, got $#" % [file, $w.code]
  doAssert "WARNING:" in w.str, "$#: warning text lacks a severity prefix: $#" % [file, w.str]
  doAssert (file & ".nss") in w.str, "$#: warning does not name the file: $#" % [file, w.str]
  doAssert "some_function" in w.str, "$#: warning does not name the function: $#" % [file, w.str]
  doAssert declaredType in w.str,
    "$#: warning does not name the declared return type ($#): $#" % [file, declaredType, w.str]

  info "ok: ", file, " -> ", w.str

# The two shapes that exist in the shipped game scripts.
checkAccepted("pos_implvoid_obj", "object")
checkAccepted("pos_implvoid_int", "int")

# Warnings are per-compile: repeated compiles of the same file must not
# accumulate, and a clean file must not inherit warnings from a previous one.
for i in 0..<3:
  doAssert compile("pos_implvoid_obj").warnings.len == 1, "warning count drifted on recompile"

let clean = compile("simple")
doAssert clean.code == 0, "simple.nss should compile, got " & $clean.code
doAssert clean.warnings.len == 0, "clean script reported warnings: " & $clean.warnings

# The dangerous direction stays an error, and must not also emit a warning.
let dangerous = compile("neg_funcimpl_ret")
doAssert dangerous.code == 617, "expected 617 for void decl / int impl, got " & $dangerous.code
doAssert dangerous.warnings.len == 0, "rejected mismatch should not warn: " & $dangerous.warnings

let differing = compile("neg_implfloat")
doAssert differing.code == 617, "expected 617 for int decl / float impl, got " & $differing.code
doAssert differing.warnings.len == 0, "rejected mismatch should not warn: " & $differing.warnings

# A compile that fails can still have produced warnings first; the warning list
# must be usable independently of the result code.
let both = compile("nomain_badsem")
doAssert both.code != 0
doAssert both.warnings.len == 0

info "warning channel tests completed OK"
