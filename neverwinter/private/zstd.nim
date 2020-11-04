import neverwinter/private/zstd/binding

const ZSTD_CLEVEL_DEFAULT* = 3

type CompressionContext = ref object of RootObj
  ctx: ZSTD_CCtx

type DecompressionContext = ref object of RootObj
  ctx: ZSTD_DCtx

proc newCompressionContext*(): CompressionContext =
  new(result) do (r: CompressionContext):
    discard ZSTD_freeCCtx(r.ctx)
  result.ctx = ZSTD_createCCtx()

proc newDecompressionContext*(): DecompressionContext =
  new(result) do (r: DecompressionContext):
    discard ZSTD_freeDCtx(r.ctx)
  result.ctx = ZSTD_createDCtx()

proc getCompressBound*(inputlen: int): int =
  ZSTD_compressBound(inputlen.csize_t).int

proc getFrameContentSize*(input: string): int =
  result = int ZSTD_getFrameContentSize(unsafeAddr(input[0]), input.len.csize_t)
  if result == -1: raise newException(ValueError, "ContentSize Unknown")
  if result == -2: raise newException(ValueError, "ContentSize Error")

proc compress*(input: string, level: int = 3, ctx: CompressionContext = nil): string =
  let strlen = ZSTD_compressBound(input.len.csize_t)
  if ZSTD_isError(strlen) > 0:
    raise newException(ValueError, $ZSTD_getErrorName(strlen))
  result = newString(strlen)

  # Support compressing a zero-byte payload. Still need to generate a valid frame.
  let inputptr = if input.len > 0: unsafeAddr(input[0]) else: nil
  let err =
    if not isNil(ctx):
      ZSTD_compressCCtx(ctx.ctx, addr(result[0]), strlen, inputptr, input.len.csize_t, level.cint)
    else:
      ZSTD_compress(addr(result[0]), strlen, inputptr, input.len.csize_t, level.cint)

  if ZSTD_isError(err) > 0:
    raise newException(ValueError, $ZSTD_getErrorName(err))
  result.setLen(err)

proc decompress*(input: string, ctx: DecompressionContext = nil): string =
  let strlen = ZSTD_getFrameContentSize(unsafeAddr(input[0]), input.len.csize_t).csize_t
  if ZSTD_isError(strlen) > 0:
    raise newException(ValueError, $ZSTD_getErrorName(strlen))
  result = newString(strlen)

  let err =
    if not isNil(ctx):
      ZSTD_decompressDCtx(ctx.ctx, addr(result[0]), strlen, unsafeAddr(input[0]), input.len.csize_t)
    else:
      ZSTD_decompress(addr(result[0]), strlen, unsafeAddr(input[0]), input.len.csize_t)

  if ZSTD_isError(err) > 0:
    raise newException(ValueError, $ZSTD_getErrorName(err))
  result.setLen(err)
