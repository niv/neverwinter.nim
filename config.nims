# begin Nimble config (version 2)
--noNimblePath
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

# WAR for building amd64 binaries on GH releases, because GH switched
# to aarch64 runners for macos actions.
# Should refactor at some point to lipo together universial binaries.
when defined(macos_amd64_hotfix):
    --cpu:amd64
    --passC:"-target x86_64-apple-macos10.12"
    --passL:"-target x86_64-apple-macos10.12"
