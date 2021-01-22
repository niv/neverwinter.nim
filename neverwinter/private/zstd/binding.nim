from os import splitPath, quoteShell
const sourceRoot = currentSourcePath().splitPath.head

{.passC: ("-I" & sourceRoot & "/lib/common").quoteShell.}
{.passC: ("-I" & sourceRoot & "/lib/decompress").quoteShell.}
{.passC: ("-I" & sourceRoot & "/lib/compress").quoteShell.}
{.passC: ("-I" & sourceRoot & "/lib/dictBuilder").quoteShell.}
{.passC: ("-I" & sourceRoot & "/lib/legacy").quoteShell.}

{.compile: sourceRoot & "/lib/compress/zstd_compress_superblock.c".}
{.compile: sourceRoot & "/lib/compress/zstdmt_compress.c".}
{.compile: sourceRoot & "/lib/compress/zstd_double_fast.c".}
{.compile: sourceRoot & "/lib/compress/zstd_fast.c".}
{.compile: sourceRoot & "/lib/compress/zstd_compress_sequences.c".}
{.compile: sourceRoot & "/lib/compress/zstd_ldm.c".}
{.compile: sourceRoot & "/lib/compress/hist.c".}
{.compile: sourceRoot & "/lib/compress/zstd_compress.c".}
{.compile: sourceRoot & "/lib/compress/zstd_lazy.c".}
{.compile: sourceRoot & "/lib/compress/zstd_compress_literals.c".}
{.compile: sourceRoot & "/lib/compress/huf_compress.c".}
{.compile: sourceRoot & "/lib/compress/zstd_opt.c".}
{.compile: sourceRoot & "/lib/compress/fse_compress.c".}
{.compile: sourceRoot & "/lib/dictBuilder/cover.c".}
{.compile: sourceRoot & "/lib/dictBuilder/divsufsort.c".}
{.compile: sourceRoot & "/lib/dictBuilder/fastcover.c".}
{.compile: sourceRoot & "/lib/dictBuilder/zdict.c".}
{.compile: sourceRoot & "/lib/decompress/zstd_ddict.c".}
{.compile: sourceRoot & "/lib/decompress/huf_decompress.c".}
{.compile: sourceRoot & "/lib/decompress/zstd_decompress.c".}
{.compile: sourceRoot & "/lib/decompress/zstd_decompress_block.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v05.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v01.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v06.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v02.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v07.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v03.c".}
{.compile: sourceRoot & "/lib/legacy/zstd_v04.c".}
{.compile: sourceRoot & "/lib/common/entropy_common.c".}
{.compile: sourceRoot & "/lib/common/fse_decompress.c".}
{.compile: sourceRoot & "/lib/common/debug.c".}
{.compile: sourceRoot & "/lib/common/xxhash.c".}
{.compile: sourceRoot & "/lib/common/pool.c".}
{.compile: sourceRoot & "/lib/common/threading.c".}
{.compile: sourceRoot & "/lib/common/zstd_common.c".}
{.compile: sourceRoot & "/lib/common/error_private.c".}

# compat shim for 1.0.x
when not compiles(csize_t):
  type csize_t* = csize

proc ZSTD_versionString*(): cstring {.importc,cdecl.}
proc ZSTD_versionNumber*(): cuint {.importc,cdecl.}

proc ZSTD_isError*(srcsize: csize_t): csize_t {.importc,cdecl.}
proc ZSTD_getErrorName*(srcsize: csize_t): cstring {.importc,cdecl.}

proc ZSTD_compressBound*(srcsize: csize_t): csize_t {.importc,cdecl.}

proc ZSTD_compress*(
  dst: pointer, dstCapacity: csize_t,
  src: pointer, srcsize: csize_t,
  compressionLevel: cint): csize_t {.importc,cdecl.}

proc ZSTD_getFrameContentSize*(src: pointer, srcsize: csize_t): culonglong {.importc,cdecl.}

proc ZSTD_decompress*(
  dst: pointer, dstSize: csize_t,
  src: pointer, compressedSize: csize_t): csize_t {.importc,cdecl.}

type ZSTD_CCtx* = distinct pointer
type ZSTD_DCtx* = distinct pointer
proc ZSTD_createCCtx*(): ZSTD_CCtx {.importc,cdecl.}
proc ZSTD_freeCCtx*(ctx: ZSTD_CCtx): cuint {.importc,cdecl.}
proc ZSTD_createDCtx*(): ZSTD_DCtx {.importc,cdecl.}
proc ZSTD_freeDCtx*(ctx: ZSTD_DCtx): cuint {.importc,cdecl.}

proc ZSTD_compressCCtx*(
  ctx: ZSTD_CCtx,
  dst: pointer, dstCapacity: csize_t,
  src: pointer, srcsize: csize_t,
  compressionLevel: cint): csize_t {.importc,cdecl.}

proc ZSTD_decompressDCtx*(
  ctx: ZSTD_DCtx,
  dst: pointer, dstCapacity: csize_t,
  src: pointer, srcsize: csize_t): csize_t {.importc,cdecl.}
