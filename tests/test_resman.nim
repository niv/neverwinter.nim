import unittest, streams

import neverwinter.resref, neverwinter.resmemfile,
  neverwinter.resman

suite "ResMan":
  test "resrefs are resolved case-insensitive when given lowercase resref":
    let resman = newResMan(0)
    let caseRef = newResRef("lc", 1.ResType)
    let memfile = newResMemFile(newStringStream(""), caseRef, 0)
    resman.add(memfile)
    check(resman["lc.bmp"].isSome)
    check(resman["LC.bmp"].isSome)
    check(resman["LC.Bmp"].isSome)

  test "resrefs are resolved case-insensitive when given casey resref":
    let resman = newResMan(0)
    let caseRef = newResRef("Mc", 1.ResType)
    let memfile = newResMemFile(newStringStream(""), caseRef, 0)
    resman.add(memfile)
    check(resman["mc.bmp"].isSome)
    check(resman["Mc.bmp"].isSome)
    check(resman["Mc.Bmp"].isSome)
