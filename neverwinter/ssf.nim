import streams, strutils
import languages, util

type
  SsfEntry* = object
    resref*: string
    strref*: StrRef

  SsfRoot* = object
    entries*: seq[SsfEntry]

proc newSsf*(): SsfRoot =
  discard

proc readSsf*(s: Stream): SSfRoot =
  let fileType = s.readStrOrErr(4)
  expect fileType == "SSF "
  let fileVers = s.readStrOrErr(4)
  expect fileVers == "V1.0"
  let entryCount = int s.readUint32()
  let tableOffset = int s.readUint32()
  let padding = s.readStrOrErr(24)
  expect padding == repeat("\x00", 24)
  let entries = readFixedCountSeq[int](s, entryCount) do (idx: int) -> int: int s.readUint32()
  result.entries = readFixedCountSeq[SsfEntry](s, entryCount) do (idx: int) -> SsfEntry:
    s.setPosition(entries[idx])
    result.resref = s.readStrOrErr(16).strip(true, true, {'\0'})
    result.strref = s.readUint32()

proc writeSsf*(s: Stream, ssf: SsfRoot) =
  s.write("SSF V1.0")
  s.write(uint32 ssf.entries.len)
  s.write(uint32 ssf.entries.len)
  s.write(repeat("\x00", 24))
  for idx, e in ssf.entries:
    let offset = ssf.entries.len * 4 + 40 + idx * 20
    s.write(uint32 offset)
  for e in ssf.entries:
    s.write(e.resref & repeat("\x00", 16 - e.resref.len))
    s.write(uint32 e.strref)
