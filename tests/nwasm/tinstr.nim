import neverwinter/nwscript/nwasm

let ii = Instr (Opcode.LOGICAL_AND, Auxcode.TYPETYPE_INTEGER_INTEGER, "not-printed")

doAssert $ii == "LOGANDII"
doAssert ii.canonicalName() == "LOGANDII"
doAssert ii.canonicalName(true) == "LOGICAL_AND,TYPETYPE_INTEGER_INTEGER"
