## This is a implementation of NWCompressedBuffer, as used internally in NWN for various
## storage concerns, such as SQLite embedding, campaign database blob compression,
## and NWSync.

import std/streams
when defined(zlib):
  import zip/zlib
import private/zstd

import util

type Algorithm* {.pure.} = enum
  None = 0,
  Zlib = 1,
  Zstd = 2

const SupportedAlgorithms* = "none, " & (when defined(zlib): "zlib, " else: "") & "zstd"

const Version = 3
## uint32_t m_magic;
## uint32_t m_version;
## uint32_t m_compressionAlgorithm;
## uint32_t m_uncompressedSize;

const ZlibVersion = 1
## uint32_t m_version;

const ZstdVersion = 1
## uint32_t m_version;
## uint32_t m_dictionary; // Currently always 0. Dictionaries will have to be shipped with the game data.

proc makeMagic*(magic: string): uint32 =
  expect(magic.len == 4, "magic needs to be 4 bytes exactly")
  magic[0].uint32 or magic[1].uint32 shl 8 or magic[2].uint32 shl 16 or magic[3].uint32 shl 24

proc decompress*(buf: string|Stream, expectMagic: uint32): string =
  let instream = when buf is Stream: buf else: newStringStream(buf)

  let magic = instream.readUint32()
  expect(magic == expectMagic, "invalid magic: " & $magic)
  let headerVersion = instream.readUint32()
  expect(headerVersion == Version, "invalid header version: " & $headerVersion)
  let algorithm = instream.readUint32().Algorithm
  let uncompressedSize = instream.readUint32()
  if uncompressedSize == 0:
    return ""

  case algorithm
  of Algorithm.None: instream.readStrOrErr(int uncompressedSize)
  of Algorithm.Zlib:
    when defined(zlib):
      let vers = instream.readUint32()
      expect(vers == ZlibVersion, "invalid zlib header version: " & $vers)
      zlib.uncompress(instream.readAll())
    else:
      raise newException(ValueError, "zlib support not compiled in as it is deprecated (-d:zlib to enable)")
  of Algorithm.Zstd:
    let vers = instream.readUint32()
    expect(vers == ZstdVersion, "invalid zstd header version: " & $vers)
    let dictionary = instream.readUint32()
    expect(dictionary == 0u32, "dictionaries are not supported")
    zstd.decompress(instream.readAll())

proc compress*(outStream: Stream, inData: string|Stream, alg: Algorithm, magic: uint32) =
  let data = when inData is Stream: inData.readAll() else: inData

  outstream.write(magic)
  outstream.write(uint32 Version)
  outstream.write(uint32 alg)
  outstream.write(uint32 data.len)

  case alg
  of Algorithm.None: outstream.write(data)
  of Algorithm.Zlib:
    when defined(zlib):
      outstream.write(uint32 ZlibVersion)
      outstream.write(zlib.compress(data, Z_DEFAULT_COMPRESSION, ZLIB_STREAM))
    else:
      raise newException(ValueError, "zlib support not compiled in as it is deprecated (-d:zlib to enable)")
  of Algorithm.Zstd:
    outstream.write(uint32 ZstdVersion)
    outstream.write(uint32 0)
    outstream.write(zstd.compress(data, ZSTD_CLEVEL_DEFAULT))

proc compress*(data: string, alg: Algorithm, magic: uint32): string =
  let outStream = newStringStream()
  compress(outstream, data, alg, magic)
  outStream.setPosition(0)
  outStream.readAll()
