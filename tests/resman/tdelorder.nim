import std/streams
import neverwinter/[resman, resmemfile]

# Removing a container must keep the others in order: nwn_script_comp adds and removes the
# source folder around every lookup, and a reordered stack resolves ovr/ and the keys differently.

let rr = newResolvedResRef "inc.nss"
proc layer(s: string): ResContainer = newResMemFile(newStringStream(s), rr, s.len)

let rm = newResMan(0)
let base = layer("base")
let ovr = layer("ovr")
rm.add base
rm.add ovr  # queried first
rm.add layer("x")
rm.add layer("y")

for i in 0..<4:
  let tmp = layer("tmp")
  rm.add tmp
  rm.del tmp
  doAssert rm.containers.len == 4
  rm.del rm.containers[0]
  rm.add layer("x" & $i)

doAssert rm.containers[^1] == base, "base moved"
doAssert rm.containers[^2] == ovr, "ovr moved"
rm.del 0
rm.del 0
doAssert rm.demand(rr, usecache = false).readAll(useCache = false) == "ovr"
