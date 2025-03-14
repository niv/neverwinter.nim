# Changelog

## [2.0.3] - 2025-03-14

### Changed

- scriptcomp: disabled a for loop optimization where the compiler would sometimes generate code that caused an infinite loop.

## [2.0.2] - 2025-01-25

### Added

- scriptcomp: Added support for binary (0b101010) and octal (0o52) integers.

### Fixed

- The MacOS binary build via GHA is now amd64, not arm64. A proper universal build can come later.
- asm: Can now correctly disasm struct equality checks.

## [2.0.1] - 2024-10-12

This release now requires nim 2.0 or newer.

### Added

- Add support for nim 2.0.x and 2.2.x.
- lib: Now correctly reads retail.key for game version 37+.
- scriptcomp: Added support for `__FUNCTION__`, `__FILE__`, `__LINE__`, `__DATE__` and `__TIME__` keywords.
- scriptcomp: Added dead branch code optimisations for constant ifs.
- scriptcomp: Added support for unary plus (e.g. constants like `+7` now compile).
- scriptcomp: Added support for double bang (e.g. `!!x` not compiles).
- scriptcomp: Added support for hashed string literals (e.g. `h"foo"` -> int).
- scriptcomp: Can now output graphviz parse trees to help compiler engineers.
- scriptcomp: Added better error reporting on parser errors.

### Fixed

- lib: Fixed --manifests not working.
- lib: Compressedbuf can now correctly handle zero-byte payloads.
- nwn_resman_\*: Fixed --all not working.
- nwn_nwsync_prune: Incorrect size reporting on reference pruning.
- scriptcomp: Fixed potential stack overflow issue when compiling particularly complex switch statements.
- scriptcomp: Fixed Unidentified Identifier errors not displaying the identifier label.

## [1.8.0] - 2024-03-26

### Added

- The nwsync utilities from beamdog/nwsync have been moved into this repository.
- nwsync: prune utility will not trim recently-written files (default: 2 weeks).

### Fixed

- nwsync: Will now correctly error out if any lookup path element cannot be found.
- nwsync: Do not create directories in dryrun mode.

## [1.7.3] - 2024-02-17

### Fixed

- Fixed checksums import when using neverwinter.nim as library (#110).
- scriptcomp: Fixed regression not utilising all threads when compiling (#109).

## [1.7.2] - 2024-02-04

### Changed

- All binaries now build with stacktraces enabled, to make user reports more useful.

### Fixed

- Fixed installation on nim 1.6 due to changed checksums package upstream.

### Performance Improvements

- scriptcomp: Optimized the common for loop construct `for (i = 0; i < N; ++i)`.

## [1.7.1] - 2023-12-17

### Changed

- ResDir instances now cache their contents on creation time. This is a change from previous behaviour, where additions to a local directory were reflected immediately.

### Fixed

- ResDir is now case-insensitive, same as base game and other ResContainer types.
- scriptcomp: Messages about encoding are no longer printed multiple times when using threads.

## [1.7.0] - 2023-11-26

### Added

- script_comp: Add cli flag to optionally follow symlinks.
- script_comp: Add cli flag to allow raising the max include depth.
- script_comp: Now also prints the full include chain for each error.
- script_comp: Now prints timing for each handled file; updated some help text to be clearer.

### Fixed

- ResMan/Res: Fix prematurely opening FDs and exhausting allowed pool when sourcing many files (e.g. script_comp *.nss).

## [1.6.4] - 2023-10-14

### Added

- Preliminary support for nim 2.0.

### Fixed

- script_comp: Don't ever compile nwscript.nss.
- script_comp: Don't link libstdc++ statically on LINUX.

## [1.6.3] - 2023-08-01

### Bytecode Disassembler

- Canonical op representation separates op and aux with a dot now, to make visual and machine parsing easier.
- Float formatting is now less noisy.
- nwn_asm no longer prints relative jump offsets.
- nwn_asm can now specify padding and term width for printing.

### Fixed

- Fixed encoding not initialising correctly when get*Encoding wasn't called.

## [1.6.2] - 2023-07-26

### Script Compiler

- Script compiler now supports raw string literals: `r".."` and `R".."`, which can also span multiple lines.
- Temporarily disabled MOVSP merging optimization (fixing STACK_UNDERFLOW errors when using -O2).

### Bytecode Disassembler

- `nwn_asm` now prints shorter, canonical opcodes.
- `nwn_asm` now parses `nwscript.nss` and prints the names of executed actions.
- `nwn_asm` now prints in colour; indicates jump source/target IPs; improved column display.
- `nwn_asm` now disassembles the whole file in debug mode (-g), not just known functions.

### Fixed

- Fixed the default steam path for Windows.
- Fixed a crash when the Beamdog Client settings.json file could not be found.
- Fixed `--language` not defaulting to `en` and overrides not working at all.
- resman.nim: Fixed sometimes not throwing a ValueError when the requested resref does not exist.

### Removed

- Removed remaining double-byte language support (this is not supported on EE).

## [1.6.1] - 2023-07-19

### Script Compiler

With 1.6.0, the official nwscript compiler source code has been added to the repository, licenced as GPL-3.0. This release builds on this:

- Parser now understands floating point values such as `0f`, `.0` and `.42f`.
- For loops can now take non-integer expressions in the first and third part of a loop statement. (e.g. floating point values now work).
- Constant folding: `const` declarations can now contain any constant expression (such as arithmetics), including previously defined consts.
- Instruction melding: A second pass over the generated bytecode will now meld some redundant instructions together.
- Where possible, expressions are now evaluated at compile time (instead of runtime).
- The CLI utility can now utilise all CPU cores to compile scripts in parallel.
- The script compiler will ensure no outdated .ndb remains when re/compiling scripts without debugging support enabled.
- Fixed structures passed using the `?:` operator causing a bad compiler state.
- The script compiler has gained support for enabling optimisations. Currently available:
  - `-O0` Turn off all optimisations
  - `-O2`: Turn on all optimisations:
    - Constant folding
    - Instruction melding
    - Removing all dead/unused code

### Bytecode Disassembler

- `nwn_asm` can now decode DE_STRUCT instructions.
- `nwn_asm` can now disable loading .ndb with a cli flag, if no per-function disassembly is desired.
- `nwn_asm` now prints global offsets in addition to per-function offsets when .ndb is enabled.
- `nwn_asm` can now optionally weave the originating source code into the disassembly, if both source code and .ndb is available.

### Other utilities

- Fixed regression introduced with 1.6.0 that resulted in GFF files failing to compile with a integer out of range error.
- All cli utilities now support the flag `--silent` to hide all output, even errors. Errors can be detected by checking the process exit code.
- Performance improvements on internal data structures to make utilities start up faster.
- Added some legacy (currently unused) restypes: .res, .wfx

## [1.6.0] - 2023-07-06

### Added

- First public release of the game script compiler source code.
- New CLI utility: nwn_script_comp.

### Fixed

- Builtin resman will no longer warn about missing _loc keytable on startup (they're optional for some languages).

## [1.5.9] - 2023-03-01

### Changed

- TwoDA library now considers `""` cells empty and transforms them into `****`.
- CLI utils: `compressedbuf`, `gff`, `ssf`, `tlk`, `twoda` now read input stream fully before writing to it, allowing write back to same file.

### Fixed

- ExoLocStr legacy codepath reader now correctly reads in `id` field.

## [1.5.8] - 2022-11-03

### Removed

- Removed NWN DE/1.69 support. If you need to work with a DE data layout, use an earlier version.

### Fixed

- Fixed auto-detecting user root on Linux and Windows.
- Fixed regression from 1.5.7 where default resman instance would not load erf files correctly.

## [1.5.7] - 2022-09-22

### Added

- Simple disassembler lib and sample tool to print out ncs bytecode.
- nwsync.nim libraries for reading/writing NWSync manifests.
- lib: ResMan ctor is now available externally.

### Changed

- gff: Duplicate field label error now prints which field is duplicated.
- NWN_HOME env var is now considered the primary env for detecting userdir, to match all other tools out there. NWN_USER_DIRECTORY remains as a fallback.
- shared (lib): added option to not inject the default logger, for library consumers that do their own logging.

### Removed

- Removed CLI progressbar support, it was just creating issues and never worked right.
- Removed a stray debug print in game.nim.

### Fixed

- gffjson: Game puts the "id" field of exolocstrs into the value array instead of the top level field. Library now reads this correctly.

## [1.5.6] - 2022-04-17

### Added

- nwn_twoda: Can now --minify to save on data size at cost of human-readableness.

## [1.5.5] - 2022-02-11

### Fixed

- gffjson: Fixed issue where it incorrectly throws RangeDefect on dwords due to incorrect cast.

## (Earlier)

Data not backfilled, please check git logs.
