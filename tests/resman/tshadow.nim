import neverwinter/[resman, resmemfile]

let rm = newResMan(0)

doAssert rm.contents.len == 0

let rr = newResolvedResRef "found.txt"

rm.add newResMemFile(newStringStream(), rr, 0)

doAssert rm.contents.len == 1

rm.add newResMemFile(newStringStream(), rr, 0)

# counting needs to observe shadow behaviour

doAssert rm.contents.len == 1

