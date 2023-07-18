import neverwinter/[resman, resmemfile]

let rm = newResMan(0)
let caseRef = newResRef("dummy", 1.ResType)
let memfile = newResMemFile(newStringStream("content"), caseRef, 7)
rm.add(memfile)

let d = rm[newResolvedResRef "dummy.bmp"]
doAssert d.get.readAll(false) == "content"
