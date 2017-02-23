# neverwinter_utils.nim
internal nim tools for nwn development

## Build Process

* Have nim-0.16 or newer on PATH, and a working mingw install (gcc). You can
  grab a working one here (for Windows): https://nim-lang.org/download/mingw32.zip

* Clone this repository *with submodules*:
  `git clone --recursive https://github.com/niv/neverwinter_utils.nim`

* Switch to it and run `build.cmd` (on Windows).

* Optional: Add neverwinter_utils.nim\bin to your PATH.

The nwn data library is in-tree (as a submodule) because I don't have a stable
version up yet, and utilities might only work with specific commits.

## Debugging

If there's issues, build the binaries in debug mode (build.cmd builds release
binaries).

If debug mode is too slow, add `--lineTrace:on --stackTrace:on` to at least
get goodbacktraces.

## Plans for these utilities

It's a bit haphazard for now.  As soon as neverwinter.nim is stable enough
to go into nimble, installing these utilities will be a single-line command.
