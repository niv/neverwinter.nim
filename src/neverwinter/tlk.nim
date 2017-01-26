import streams, strutils, options, sequtils

import util, lru, res, resref, languages
export languages

type
  StrRef* = uint32

  TlkEntry* = ref object
    text*: string
    soundResRef*: string
    soundLength*: float

  SingleTlk = ref object
    io: Stream
    ioStartPos: int
    language: Language
    entrycount: int
    entriesOffset: int
    cache*: WeightedLRU[StrRef, TlkEntry]

  TlkPair* = tuple[male: SingleTlk, female: SingleTlk]
  Tlk* = ref object
    chain*: seq[TlkPair]

const
  HeaderSize = 20
  DataElementSize = 40

proc `$`*(self: TlkEntry): string = self.text

proc `[]`*(self: SingleTlk, str: StrRef): Option[TlkEntry] =
  ## Look up a TLK entry.

  if str.int >= self.entrycount: return

  let rs = self.cache.getOrPut(str) do (_: StrRef) -> (Weight, TlkEntry):
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
    result[0] = sizeof(TlkEntry) + result[1].soundResRef.len + result[1].text.len

  result = some(rs)

proc `[]`*(self: Tlk, str: StrRef, gender = Gender.Male): Option[TlkEntry] =
  for pair in self.chain:
    if gender == Gender.Female and pair.female != nil:
      let queried = pair.female[str]
      if queried.isSome: return queried
    elif gender == Gender.MAle and pair.male != nil:
      let queried = pair.male[str]
      if queried.isSome: return queried

proc readSingleTlk*(io: Stream): SingleTlk =
  new(result)
  result.io = io
  result.ioStartPos = io.getPosition

  expect("TLK " == io.readStrOrErr(4))
  expect("V3.0" == io.readStrOrErr(4))

  result.language = io.readInt32().Language
  result.entrycount = io.readInt32()
  result.entriesOffset = io.readInt32()

  # Try to be smart about the cache size: wild guess is 1/3 of entries
  result.cache = newWeightedLRU[StrRef, TlkEntry](
    sizeof(TlkEntry) * result.entrycount div 2, 1)

proc readSingleTlk*(res: Res): SingleTlk =
  res.seek()
  result = res.io.readSingleTlk()

proc newTlk*(chain: seq[tuple[male: Res, female: Res]]): Tlk =
  ## Creates a new tlk object that can be used to query a list of entries.
  new(result)
  result.chain = chain.map() do (tu: auto) -> TlkPair:
    (
      male:   if tu[0] != nil: tu[0].readSingleTlk else: nil,
      female: if tu[1] != nil: tu[1].readSingleTlk else: nil
    ).TlkPair
