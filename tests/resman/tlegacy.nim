# This is a legacy test. It should be split up and rewritten to not use unittest.

import unittest, streams, tables

import neverwinter/resref, neverwinter/resmemfile,
  neverwinter/resman

suite "ResMan":
  test "resrefs are resolved case-insensitive when given lowercase resref":
    let resman = newResMan(0)
    let caseRef = newResRef("lc", 1.ResType)
    let memfile = newResMemFile(newStringStream(""), caseRef, 0)
    resman.add(memfile)
    check(resman[newResolvedResRef "lc.bmp"].isSome)
    check(resman[newResolvedResRef "LC.bmp"].isSome)
    check(resman[newResolvedResRef "LC.Bmp"].isSome)

  test "resrefs are resolved case-insensitive when given casey resref":
    let resman = newResMan(0)
    let caseRef = newResRef("Mc", 1.ResType)
    let memfile = newResMemFile(newStringStream(""), caseRef, 0)
    resman.add(memfile)
    check(resman[newResolvedResRef "mc.bmp"].isSome)
    check(resman[newResolvedResRef "Mc.bmp"].isSome)
    check(resman[newResolvedResRef "Mc.Bmp"].isSome)
