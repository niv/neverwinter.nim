# begin Nimble config (version 2)
--noNimblePath
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

when defined(macosx) and defined(macos_amd64):
    --cpu:amd64
    --passC:"-target x86_64-apple-macos10.12"
    --passL:"-target x86_64-apple-macos10.12"

when defined(macosx) and defined(macos_arm64):
    --cpu:arm64
    --passC:"-target arm64-apple-macos10.12"
    --passL:"-target arm64-apple-macos10.12"

# WAR for https://github.com/nim-lang/Nim/issues/23913: clang's -Warray-bounds
# false-positives on Nim's C++ flexible-array hack
switch("passC", "-Wno-array-bounds")

when defined(macosx):
  switch("passC", "-Wno-deprecated-declarations")
