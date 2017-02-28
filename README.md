# neverwinter_utils.nim

nim tools for nwn development.  Build it, and they will come, they said.
On the other hand:  Good things are built with tools, but great things are built
with great tools.

Thus, If you are in need of a specific utility to solve a problem you are facing,
*please* contact me and we'll get it sorted ASAP: niv@nwnx.io

This suite is meant to eventually grow into a complete NWN toolkit that anyone,
be it dev or community member, can use.  They must be available on ALL supported
platforms and work on all of them equally well.

## Tools provided

* `nwn_gff`: Transforms gff data to/from various formats.
* `nwn_erf`: Un/pack erf files.
* `nwn_tlk`: Transforms tlk tables from/to various formats.
* `nwn_twoda`: Transforms 2da files from/to various formats.
* `nwn_key_pack, nwn_key_unpack`: Un/packs a keyfile into/from a directory structure.
* `nwn_key_shadows`: Get data on file shadowing in a list of key files.
* `nwn_key_transparent`: Get data on file duplication in a list of key files.
* `nwn_resman_stats`: Get data on what is in a resman view.
* `nwn_resman_grep`: Grep a resman view for data.
* `nwn_resman_extract`: Pull files from resman into directory.
* `nwn_resman_diff`: Diffs two resman views (for language support).

All utilities write their working output to stdout, and any library- or tool-
related logging goes to stderr.  You can turn on debug logging with `--verbose`,
and turn off all logging except errors with `--quiet`.

For detailed documentation, please see their source files in `src/`: They have
a documentation header right at the top.

### Philosophy

Most of these  utilities embed a complete resman.  The general idea is NOT to
operate on single file formats.  Instead, they all utilise the underlying resman
implementation from neverwinter.nim.  For example, if you want to get statistics
about a key file, you do not unpack it:  Instead, you use `nwn_resman_stats` and
tell it to only load the key file you are interested in.

## Build: Windows

* Have nim-0.16 or newer on PATH, and a working mingw install (for gcc). You can
  grab a working one here: https://nim-lang.org/download/mingw32.zip

  tl;dr:
  * Download nim.zip for windows, unpack to c:\nim-xxx.
  * Download mingw32, unpack to c:\mingw.
  * add mingw\bin and nim-xxx\bin to PATH.

* Clone this repository *with submodules*:
  `git clone --recursive https://github.com/niv/neverwinter_utils.nim`

* Switch to it and run `build.cmd` (on Windows). This will build release binaries
  into `bin`.

* To update the whole package, run `git pull --recurse-submodules --tags` and
  build again.

* Optional: Add `neverwinter_utils.nim\bin` to your PATH, so you can call them
  from everywhere.  All utilities are prefixed with `nwn_` so you can just tab-
  complete your way to happiness.

* All utilities have a help page. Just pass `-h` as the only argument.

## Build: OSX, Linux

* Install nim: `brew install nim` (OSX) or from apt/source (Linux). Make sure
  it's at least 0.16.

* Then follow the Windows instructions; but run `build.sh` instead.

## Debugging

If there's issues, build the binaries in debug mode (build.cmd builds release
binaries) to help find issues.  If you have trouble and you can't get a hold
of me otherwise, email me: niv@nwnx.io

If debug mode is too slow, add `--lineTrace:on --stackTrace:on` to at least
get good backtraces.
