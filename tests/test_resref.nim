import unittest
include neverwinter.resref

suite "ResRef":
  test "are case-insensitive":
    let a = newResRef("Hello", 1.ResType)
    let b = newResRef("hello", 1.ResType)
    check(a == b)

  test "raise ValueError when empty":
    expect ValueError:
      discard newResRef("", 1.ResType)

  test "raise ValueError when too long":
    expect ValueError:
      discard newResRef(repeat("a", ResRefMaxLength + 1), 1.ResType)
