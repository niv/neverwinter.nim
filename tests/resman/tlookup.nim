import neverwinter/resman

let rm = newResMan(0)

let rr = newResolvedResRef "notfound.txt"

doAssert not rm.contains(rr)

# rm should raise exception when demand fails if no containers are registered
doAssertRaises ValueError:
  discard rm.demand(rr)
