import std/[os, sequtils]
import neverwinter/[resman, resfile, resdir]

proc getFdCount(): int =
  when defined(macosx):
    return walkdir("/dev/fd").toSeq().len
  elif defined(linux):
    return walkdir("/proc/self/fd").toSeq().len
  else:
    {.warning: "Unsupported platform for this test.".}
    return 0

# This exercises the readAll proc, which is shared for all res.
# This assert specifically checks that the res summons the iostream dynamically and closes
# the file handle immediately after.
# Saying useCache = false ensures the read file isn't stored in memory and the IO
# handle is respawned every call.

let before = getFdCount()

let sources = [
  newResFile(currentSourcePath().splitFile().dir / "corpus" / "sample.txt"),
  newResDir(currentSourcePath().splitFile().dir / "corpus")
]

doAssert getFdCount() == before, "instancing ResContainers should not open fds"

for container in sources:
  var res = container.demand(newResolvedResRef("sample.txt"))
  doAssert getFdCount() == before, "demanding Res from " & $container & " should not open fd"

  for i in 0..<10:
    discard res.readAll(useCache = false)

  doAssert getFdCount() == before, "readAll() should not leave fds open"
