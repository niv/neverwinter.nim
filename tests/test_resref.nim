import unittest
include neverwinter/resref

suite "ResRef":
  test "compares case-insensitive":
    let a = newResRef("Hello", 1.ResType)
    let b = newResRef("hello", 1.ResType)
    check(a == b)
    check(cmp[ResRef](a, b) == 0)

  test "lowercase comes first":
    let a = newResRef("Hello", 1.ResType)
    let b = newResRef("hello", 1.ResType)
    check(b > a)

  test "stores original case of resref":
    check($newResRef("HellO", 1.ResType) == "HellO.bmp")

  test "raise ValueError when empty":
    expect ValueError:
      discard newResRef("", 1.ResType)

  test "raise ValueError when too long":
    expect ValueError:
      discard newResRef(repeat("a", ResRefMaxLength + 1), 1.ResType)
