# neverwinter_utils.nim
internal nim tools for nwn development

## Build Process

* Have nim-0.16 or newer on PATH, and a working mingw install (gcc). You can
  grab a working one here (for Windows): https://nim-lang.org/download/mingw32.zip

  tl;dr:
  * Download nim.zip for windows, unpack to c:\nim-xxx.
  * Download mingw32, unpack to c:\mingw.
  * add mingw\bin and nim-xxx\bin to PATH.

* Clone this repository *with submodules*:
  `git clone --recursive https://github.com/niv/neverwinter_utils.nim`

* Switch to it and run `build.cmd` (on Windows). This will build release binaries
  into `bin`.

* Optional: Add `neverwinter_utils.nim\bin` to your PATH, so you can call them
  from everywhere.  All utilities are prefixed with nwn_.

* To update the whole package, run `git pull --recurse-submodules --tags` and
  build again.

## Debugging

If there's issues, build the binaries in debug mode (build.cmd builds release
binaries) to help find issues.  If you have trouble and you can't get a hold
of me otherwise, email me: niv@nwnx.io

If debug mode is too slow, add `--lineTrace:on --stackTrace:on` to at least
get good backtraces.
