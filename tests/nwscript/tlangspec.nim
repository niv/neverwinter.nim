import std/os
import neverwinter/nwscript/langspec

const SourcePath = currentSourcePath().splitFile().dir

let spec = parseLanguageSpec readFile(SourcePath / "../scriptcomp/nwtestvmscript.nss")

# Needs to be adjusted every time the spec is changed.
# The hardcoded counts ensure correct parsing of all added lines.
doAssert spec.defines.len    == 1
doAssert spec.defines[0]     == ("ENGINE_NUM_STRUCTURES", "0")
doAssert spec.consts.len     == 3
doAssert spec.consts[0]      == ("int", "TRUE", "1")
doAssert spec.funcs.len      == 6
doAssert spec.funcs[0]       == ("void", "Assert", "int bCond, string sMsg = \"\"")
doAssert spec.funcs[^1]      == ("int", "PegMatch", "string sTest, string sPattern")
