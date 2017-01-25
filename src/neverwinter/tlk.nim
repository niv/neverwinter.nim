import streams, strutils

import util, lru, languages

type
  StrRef* = uint32

  TlkEntry* = ref object
    text*: string
    soundResRef*: string
    soundLength*: float

  Tlk* = ref object
    io: Stream
    ioStartPos: int
    language: Language
    entrycount: int
    entriesOffset: int
    cache*: WeightedLRU[StrRef, TlkEntry]

const
  HeaderSize = 20
  DataElementSize = 40

proc `[]`*(self: Tlk, str: StrRef, language = Language.English): TlkEntry =
  ## Look up a TLK entry.

  expect(str.int <= self.entrycount)

  self.cache.getOrPut(str) do (_: StrRef) -> (Weight, TlkEntry):
    new(result[1])
    self.io.setPosition(HeaderSize + DataElementSize * str.int)

    discard self.io.readInt32() # we dont care about flags atm
    result[1].soundResRef = self.io.readStrOrErr(16).strip(true, true, {'\0'})
    discard self.io.readInt32() # volume variance is unused
    discard self.io.readInt32() # pitch variance is unused
    let offsetToString = self.io.readInt32()
    let stringSz = self.io.readInt32()
    result[1].soundLength = self.io.readFloat32()

    self.io.setPosition(self.ioStartPos + self.entriesOffset + offsetToString)
    result[1].text = self.io.readStrOrErr(stringSz).fromNwnEncoding
    result[0] = result[1].text.len

proc len*(self: Tlk): int =
  self.entrycount

proc readTlk*(io: Stream): Tlk =
  new(result)
  result.io = io
  result.ioStartPos = io.getPosition

  expect("TLK " == io.readStrOrErr(4))
  expect("V3.0" == io.readStrOrErr(4))

  result.language = io.readInt32().Language
  result.entrycount = io.readInt32()
  result.entriesOffset = io.readInt32()

  # Try to be smart about the cache size: wild guess is 1/3 of entries
  result.cache = newWeightedLRU[StrRef, TlkEntry](result.entrycount div 3, 1)
