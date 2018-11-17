import streams, strutils, options, sequtils, tables, math

import util, lru, resman, resref, languages
export languages

type
  StrRef* = uint32

const
  BadStrRef* = high(StrRef)

type
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
    useCache*: bool
    ioCache*: WeightedLRU[StrRef, TlkEntry]

  TlkPair* = tuple[male: SingleTlk, female: SingleTlk]
  Tlk* = ref object
    chain*: seq[TlkPair]

const
  HeaderSize = 20
  DataElementSize = 40

proc `$`*(self: TlkEntry): string = self.text

proc hasValue*(self: TlkEntry): bool =
  ## Returns true if this TlkEntry holds a value; i.e. is worth saving.
  self.text != "" or self.soundResRef != ""

proc getFromIo(self: SingleTlk, str: StrRef): (Weight, TlkEntry) =
  new(result[1])
  self.io.setPosition(HeaderSize + DataElementSize * str.int)

  discard self.io.readInt32() # we dont care about flags atm

  # - Some translation house tlks contain this invalid gizmo: 0xcx0;
  #   presumably a leftover from some old editor.
  # - Also strip whitespace while we're here.
  result[1].soundResRef = self.io.readStrOrErr(16).strip(true, true, {'\x00', '\xc0'} + Whitespace)

  discard self.io.readInt32() # volume variance is unused
  discard self.io.readInt32() # pitch variance is unused
  let offsetToString = self.io.readInt32()
  let stringSz = self.io.readInt32()
  result[1].soundLength = max(round(self.io.readFloat32(), 4), 0)

  self.io.setPosition(self.ioStartPos + self.ioEntriesOffset + offsetToString)
  result[1].text = self.io.readStrOrErr(stringSz).fromNwnEncoding
  result[0] = sizeof(TlkEntry) + result[1].soundResRef.len + result[1].text.len

proc `[]`*(self: SingleTlk, str: StrRef): Option[TlkEntry] =
  ## Look up a TLK entry.

  if self.staticEntries.hasKey(str):
    return some(self.staticEntries[str])

  if self.ioCache != nil:
    if str.int >= self.ioEntryCount: return

    if self.useCache:
      let rs = self.ioCache.getOrPut(str) do (_: StrRef) -> (Weight, TlkEntry):
        result = self.getFromIo(str)
      result = some(rs)
    else:
      let rs = self.getFromIo(str)
      result = some(rs[1])

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

proc highest*(self: SingleTlk): int =
  ## Returns the highest entry in this SingleTlk.
  ## Note: entries might not be continuous.
  max(self.ioEntryCount - 1, self.staticEntriesHighest)

proc newSingleTlk*(): SingleTlk =
  new(result)
  result.language = Language.English
  result.staticEntries = initTable[StrRef, TlkEntry]()

proc readSingleTlk*(io: Stream, useCache = true): SingleTlk =
  result = newSingleTlk()
  result.io = io
  result.ioStartPos = io.getPosition

  expect("TLK " == io.readStrOrErr(4))
  expect("V3.0" == io.readStrOrErr(4))

  result.language = io.readInt32().Language
  result.ioEntryCount = io.readInt32()
  result.ioEntriesOffset = io.readInt32()

  result.useCache = useCache
  # Try to be smart about the cache size: wild guess is 1/3 of entries
  result.ioCache = newWeightedLRU[StrRef, TlkEntry](
    sizeof(TlkEntry) * result.ioEntryCount div 2, 1)

proc writeTlk*(io: Stream, tlk: SingleTlk) =
  ## Writes a SingleTlk to the given output stream.

  var maxId: StrRef = 0
  # static entries: This is rather lame, sorry.
  for k in tlk.staticEntries.keys:
    if k > maxId: maxId = k

  if tlk.io != nil:
    # if we are backed by a io, figure out their max entry count.
    maxId = max((tlk.ioEntryCount-1).StrRef, maxId.StrRef)

  # entry count is the max id + 1 (0-><maxId>)
  let entryCount: uint32 = maxId + 1

  # Reserve size for the entries table on the out stream. Not all
  # entries will write out a text entry.
  let entriesTableSize = 40 * entryCount.int
  let entriesTableOffset = io.getPosition() + 20
  let stringDataOffset = entriesTableOffset + entriesTableSize

  write(io, "TLK V3.0")
  write[int32](io, tlk.language.int32) # languageID
  write[uint32](io, entrycount.uint32) # stringCount
  write[uint32](io, stringDataOffset.uint32) # stringEntriesOffset

  # Pad io position to where the string data starts. We'll write
  # strings first, then rewind and write the table. This saves
  # us some extra string conversion work.
  io.write(repeat("\x00", stringDataOffset - io.getPosition))
  doAssert(io.getPosition == stringDataOffset)

  # pack the header in-memory, because we're cheap like that
  var offset: int32 = 0
  let entriesTableStream = newStringStream()
  for i in 0..maxId:
    let entry = tlk[i]

    if entry.isSome and entry.get().hasValue:
      let e = entry.get()
      var flags = 0
      if e.text != "": flags += 0x1
      if e.soundResRef != nil and e.soundResRef != "": flags += 0x6

      write[int32](entriesTableStream, flags.int32)
      var sr = if e.soundResRef != nil: e.soundResRef[0..<min(16, e.soundResRef.len)] else: ""
      sr &= repeat("\x00", 16 - sr.len)
      assert(sr.len == 16)
      write(entriesTableStream, sr) # resref
      write[int32](entriesTableStream, 0) # vol var
      write[int32](entriesTableStream, 0) # pitch var

      let txt = e.text.replace("\r", "").toNwnEncoding
      write[int32](entriesTableStream, offset) # offsetToString
      write[int32](entriesTableStream, int32 txt.len)
      offset += int32 txt.len

      write[float32](entriesTableStream, e.soundLength) # soundLength

      write(io, txt)

    else:
      write[int32](entriesTableStream, 0) # flags
      const EmptyResRef = repeat("\x00", 16)
      write(entriesTableStream, EmptyResRef) # resref
      write[int32](entriesTableStream, 0) # vol var
      write[int32](entriesTableStream, 0) # pitch var
      write[int32](entriesTableStream, 0) # offsetToString
      write[int32](entriesTableStream, 0) # len
      write[float32](entriesTableStream, 0.0) # soundLength

  doAssert(io.getPosition() == entriesTableOffset + entriesTableSize + offset)
  entriesTableStream.setPosition(0)

  io.setPosition(entriesTableOffset)
  write(io, entriesTableStream.readAll)
  doAssert(io.getPosition == entriesTableOffset + entriesTableSize)

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
