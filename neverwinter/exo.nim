import compressedbuf

type ExoResFileCompressionType* {.pure.} = enum
  None = 0,
  CompressedBuf = 1

const ExoResFileCompressedBufMagic* = makeMagic("XRES")
