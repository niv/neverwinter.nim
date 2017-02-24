# neverwinter_utils.nim
internal nim tools for nwn development

## Tools provided

Note: All tools built are being prefixed with `nwn_`.

* `json2gff, gff2json`: Transforms gff data to/from json.
* `key_pack, key_unpack`: Un/packs a keyfile into/from a directory structure.
* `key_shadows`: Get data on file shadowing in a list of key files.
* `key_transparent`: Get data on file duplication in a list of key files.
* `resman_diff`: Diffs two resman views (for language support).
* `resman_stats`: Get data on what is in a resman view.
* `resman_grep`: Grep a resman view for data.
* `twoda_reformat`: Reformats a twoda file to be nicely formatted and valid.

All utilities write their working output to stdout, and any library- or tool-
related logging goes to stderr.

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
