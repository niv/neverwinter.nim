# neverwinter.nim

This is a nim-lang library and utility collection to read and write data files used
by Neverwinter Nights: Enhanced Edition.

It also includes the official script compiler source code and CLI utility.

Binary releases are available on the Github Releases page of this project. You do
not need to install anything else.

## Tools

All utilities write their working output to stdout, and any library- or tool-
related logging goes to stderr.  You can turn on debug logging with `--verbose`,
and turn off all logging except errors with `--quiet`.

Call each utility with `--help` to get documentation on their usage.

### General resman utilities

* `nwn_resman_stats`: Get data on what is in a resman view.
* `nwn_resman_grep`: Grep a resman view for data.
* `nwn_resman_extract`: Pull files from resman into directory.
* `nwn_resman_cat`: Pull file(s) from resman and pipe them to stdout.
* `nwn_resman_diff`: Diffs two resman views (for language support).
* `nwn_resman_pkgsrv`: Repackage a resman view suitable for docker deployment.
* `nwn_key_pack, nwn_key_unpack`: Un/packs a keyfile into/from a directory structure.
* `nwn_key_shadows`: Get data on file shadowing in a list of key files.
* `nwn_key_transparent`: Get data on file duplication in a list of key files.

Most of these utilities embed a complete resman.  The general idea is NOT to
operate on single file formats.  Instead, they all utilise the underlying resman
implementation from the neverwinter library included in this repository.

For example, if you want to get statistics about a key file, you do not unpack it:
Instead, you use `nwn_resman_stats` and tell it to only load the key file you are
interested in.

### Format conversion and user data utilities

* `nwn_gff`: Transforms gff data to/from various formats, extract/embed SQLite.
* `nwn_erf`: Un/pack erf files.
* `nwn_tlk`: Transforms tlk tables from/to various formats.
* `nwn_twoda`: Transforms 2da files from/to various formats.
* `nwn_erf_tlkify`: Refactor strings in a erf into a exisiting or new tlk.
* `nwn_sff`: Convert SSF files to/from csv.
* `nwn_compressedbuf`: De/compress NWCompressedBuf payloads.
* `nwn_net`: A utility providing some network-related helpers, like querying servers.

### Script compiler

* `nwn_script_comp`: NWScript compiler using the official open-source compiler library.
* `nwn_asm`: Utility to deal with nwscript assembly.
