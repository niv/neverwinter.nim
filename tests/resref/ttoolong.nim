include neverwinter/resref

doAssertRaises ValueError:
  discard newResRef(repeat("a", ResRefMaxLength + 1), 1.ResType)
