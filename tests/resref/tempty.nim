include neverwinter/resref

doAssertRaises ValueError:
  discard newResRef("", 1.ResType)
