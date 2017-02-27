import streams, strutils, options, sequtils, tables

import util, lru, resman, resref, languages
export languages

type
  StrRef* = uint32

  TlkEntry* = ref object
    text*: string
    soundResRef*: string
    soundLength*: float

  SingleTlk* = ref object
    language*: Language

    # Manually assigned entries.
    staticEntries: Table[StrRef, TlkEntry]
    staticEntriesHighest: int

    # These are only valid when this tlk is sourced from a stream
    io: Stream
    ioStartPos: int
    ioEntryCount: int
    ioEntriesOffset: int
    ioCache*: WeightedLRU[StrRef, TlkEntry]

  TlkPair* = tuple[male: SingleTlk, female: SingleTlk]
  Tlk* = ref object
    chain*: seq[TlkPair]

const
  HeaderSize = 20
  DataElementSize = 40

proc `$`*(self: TlkEntry): string = self.text

proc `[]`*(self: SingleTlk, str: StrRef): Option[TlkEntry] =
  ## Look up a TLK entry.

  if self.staticEntries.hasKey(str):
    return some(self.staticEntries[str])

  if self.ioCache != nil:
    if str.int >= self.ioEntryCount: return

    let rs = self.ioCache.getOrPut(str) do (_: StrRef) -> (Weight, TlkEntry):
      new(result[1])
      self.io.setPosition(HeaderSize + DataElementSize * str.int)

      discard self.io.readInt32() # we dont care about flags atm
      result[1].soundResRef = self.io.readStrOrErr(16).strip(false, true, {'\0'})
      discard self.io.readInt32() # volume variance is unused
      discard self.io.readInt32() # pitch variance is unused
      let offsetToString = self.io.readInt32()
      let stringSz = self.io.readInt32()
      result[1].soundLength = self.io.readFloat32()

      self.io.setPosition(self.ioStartPos + self.ioEntriesOffset + offsetToString)
      result[1].text = self.io.readStrOrErr(stringSz).fromNwnEncoding
      result[0] = sizeof(TlkEntry) + result[1].soundResRef.len + result[1].text.len

    result = some(rs)

proc `[]=`*(self: SingleTlk, str: StrRef, entry: TlkEntry) =
  ## Assigns a str-ref to this tlk. The tlk will auto-expand to contain at least
  ## as many entries as the strref requires.
  if self.ioCache != nil: self.ioCache.del(str)
  self.staticEntries[str] = entry
  self.staticEntriesHighest = max(self.staticEntriesHighest, str.int)

proc `[]=`*(self: SingleTlk, str: StrRef, text: string) =
  ## Assigns a str-ref to this tlk. The tlk will auto-expand to contain at least
  ## as many entries as the strref requires.
  self[str] = TlkEntry(text: text, soundResRef: "")

proc `[]`*(self: Tlk, str: StrRef, gender = Gender.Male): Option[TlkEntry] =
  for pair in self.chain:
    if gender == Gender.Female and pair.female != nil:
      let queried = pair.female[str]
      if queried.isSome: return queried
    elif gender == Gender.MAle and pair.male != nil:
      let queried = pair.male[str]
      if queried.isSome: return queried

proc highest*(self: SingleTlk): int = max(self.ioEntryCount, self.staticEntriesHighest)
  ## Returns the highest entry in this SingleTlk.  Note: entries might not be
  ## continuous.

proc newSingleTlk*(): SingleTlk =
  new(result)
  result.language = Language.English
  result.staticEntries = initTable[StrRef, TlkEntry]()

proc readSingleTlk*(io: Stream): SingleTlk =
  result = newSingleTlk()
  result.io = io
  result.ioStartPos = io.getPosition

  expect("TLK " == io.readStrOrErr(4))
  expect("V3.0" == io.readStrOrErr(4))

  result.language = io.readInt32().Language
  result.ioEntryCount = io.readInt32()
  result.ioEntriesOffset = io.readInt32()

  # Try to be smart about the cache size: wild guess is 1/3 of entries
  result.ioCache = newWeightedLRU[StrRef, TlkEntry](
    sizeof(TlkEntry) * result.ioEntryCount div 2, 1)

proc write*(io: Stream, tlk: SingleTlk) =
  ## Writes a SingleTlk to the given output stream.
  io.write("TLK V3.0")

  var maxId: StrRef = 0
  # static entries ..
  for k in tlk.staticEntries.keys:
    if k > maxId: maxId = k

  if tlk.io != nil:
    maxId = max(tlk.ioEntryCount.StrRef, maxId.StrRef)

  let entryCount: uint32 = maxId + 1

  write[int32](io, tlk.language.int32) # language
  write[uint32](io, entrycount.uint32) # entrycount

  # pack the header in-memory, because we're cheap like that
  var offset: int32 = 0
  let hdr = newStringStream()
  for i in 0..maxId:
    let entry = tlk[i]

    if entry.isSome:
      let e = entry.get()
      var flags = 0
      if entry.isSome: flags += 0x1
      if entry.isSome and e.soundResRef != nil and e.soundResRef != "": flags += 0x6

      write[int32](hdr, flags.int32)
      var sr = if e.soundResRef != nil: e.soundResRef[0..<16] else: ""
      sr &= repeat("\x0", 16 - sr.len)
      assert(sr.len == 16)
      write(hdr, sr) # resref
      write[int32](hdr, 0) # vol var
      write[int32](hdr, 0) # pitch var

      let strlen = e.text.toNwnEncoding.len.int32
      write[int32](hdr, offset) # offsetToString
      write[int32](hdr, strlen)
      offset += strlen

      write[float32](hdr, e.soundLength) # soundLength

    else:
      write[int32](hdr, 0) # flags
      const EmptyResRef = repeat("\x0", 16)
      write(hdr, EmptyResRef) # resref
      write[int32](hdr, 0) # vol var
      write[int32](hdr, 0) # pitch var
      write[int32](hdr, 0) # offsetToString
      write[int32](hdr, 0) # len
      write[float32](hdr, 0.0) # soundLength

  let hdrsz = hdr.getPosition()
  hdr.setPosition(0)

  assert(hdrsz.uint32 == entrycount * 40)
  write[int32](io, (20 + hdrsz).int32)

  write(io, hdr.readAll)
  assert(io.getPosition == 20 + hdrsz)

  for i in 0..maxId:
    let entry = tlk[i]
    if entry.isSome:
      write(io, entry.get().text.toNwnEncoding)

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
