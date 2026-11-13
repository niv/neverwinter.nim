import neverwinter/[nwsync, resref, restype]

let mf = newManifest()

proc add(sha1: string, size: uint32, resref: string) =
  mf.entries.add ManifestEntry(sha1: sha1, size: size,
    resref: newResRef(resref, 2022.ResType))

add("1111111111111111111111111111111111111111", 10, "a")
add("2222222222222222222222222222222222222222", 20, "b")
add("1111111111111111111111111111111111111111", 10, "c") # same data as a
add("3333333333333333333333333333333333333333", 5, "d")
add("2222222222222222222222222222222222222222", 20, "e") # same data as b

doAssert mf.totalSize() == 65
doAssert mf.deduplicatedSize() == 35

doAssert newManifest().deduplicatedSize() == 0
