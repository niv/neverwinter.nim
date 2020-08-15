
{.passC: "-DZSTD_STATIC_LINKING_ONLY".}

from os import splitPath
const sourceRoot = currentSourcePath().splitPath.head

{.passC: "-I" & sourceRoot & "/lib/common".}
{.passC: "-I" & sourceRoot & "/lib/decompress".}
{.passC: "-I" & sourceRoot & "/lib/compress".}
{.passC: "-I" & sourceRoot & "/lib/dictBuilder".}
{.passC: "-I" & sourceRoot & "/lib/legacy".}

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


proc ZSTD_versionString*(): cstring {.importc.}
proc ZSTD_versionNumber*(): cuint {.importc.}

proc ZSTD_isError*(srcSize: csize): csize {.importc.}
proc ZSTD_getErrorName*(srcSize: csize): cstring {.importc.}

proc ZSTD_compressBound*(srcSize: csize): csize {.importc.}

proc ZSTD_compress*(
  dst: pointer, dstCapacity: csize,
  src: pointer, srcSize: csize,
  compressionLevel: cint): csize {.importc: "ZSTD_compress".}

proc ZSTD_getFrameContentSize*(src: pointer, srcSize: csize): culonglong {.importc.}

proc ZSTD_decompress*(
  dst: pointer, dstSize: csize,
  src: pointer, compressedSize: csize): csize {.importc.}

type ZSTD_CCtx* = distinct pointer
type ZSTD_DCtx* = distinct pointer
proc ZSTD_createCCtx*(): ZSTD_CCtx {.importc.}
proc ZSTD_freeCCtx*(ctx: ZSTD_CCtx): cuint {.importc.}
proc ZSTD_createDCtx*(): ZSTD_DCtx {.importc.}
proc ZSTD_freeDCtx*(ctx: ZSTD_DCtx): cuint {.importc.}

proc ZSTD_compressCCtx*(
  ctx: ZSTD_CCtx,
  dst: pointer, dstCapacity: csize,
  src: pointer, srcSize: csize,
  compressionLevel: cint): csize {.importc.}

proc ZSTD_decompressDCtx*(
  ctx: ZSTD_DCtx,
  dst: pointer, dstCapacity: csize,
  src: pointer, srcSize: csize): csize {.importc.}
