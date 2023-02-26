# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

- TwoDA library now considers `""` cells empty and transforms them into `****`.

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
