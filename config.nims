# begin Nimble config (version 2)
--noNimblePath
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

# WAR for https://github.com/nim-lang/Nim/issues/23913: clang's -Warray-bounds
# false-positives on Nim's C++ flexible-array hack
switch("passC", "-Wno-array-bounds")

when defined(macosx):
  switch("passC", "-Wno-deprecated-declarations")
