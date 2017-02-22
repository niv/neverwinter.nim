when sizeof(int) < 4: {.fatal: "Only 32/64bit supported." }

import streams, options, sequtils, strutils, tables, times, os, sets

import resman, util

type
  ResId = int

  VariableResource = tuple
    id: ResId
    offset: int
    fileSize: int
    resType: ResType

  Bif* = ref object
    keyTable: KeyTable
    filename: string
    mtime: Time
    io: Stream
    fileType: string
    fileVersion: string

    variableResources: Table[ResId, VariableResource]

  KeyTable* = ref object of ResContainer
    io: Stream
    ioStart: int
    label: string

    bifs: seq[Bif]
    resrefIdLookup: Table[ResRef, ResId]

proc readBif(io: Stream, owner: KeyTable, filename: string): Bif =
  new(result)

  result.variableResources = initTable[ResId, VariableResource]()
  result.io = io
  result.keyTable = owner
  result.filename = filename
  result.mtime = getTime() # getLastModificationTime(filename)

  result.fileType = io.readStrOrErr(4)
  expect(result.fileType == "BIFF")
  result.fileVersion = io.readStrOrErr(4)
  expect(result.fileVersion == "V1  ")

  let varResCount = io.readInt32()
  let fixedResCount = io.readInt32()
  let variableTableOffset = io.readInt32()

  expect(fixedResCount == 0, "fixed resources in bif not supported")

  io.setPosition(variableTableOffset)
  for i in 0..<varResCount:
    let r: VariableResource = (
      id: (io.readInt32() and 0xfffff).ResId,
      offset: io.readInt32().int,
      fileSize: io.readInt32().int,
      resType: io.readInt32().ResType
    )

    result.variableResources[r.id] = r

proc hasResId*(self: Bif, id: ResId): bool =
  self.variableResources.hasKey(id)

proc getVariableResource*(self: Bif, id: ResId): VariableResource =
  self.variableResources[id]

proc getStreamForVariableResource*(self: Bif, id: ResId): Stream =
  result = self.io
  expect(self.variableResources.hasKey(id), "attempted to look up id " & $id &
    " in bif, but not found")

  result.setPosition(self.variableResources[id].offset)

proc readKeyTable*(io: Stream, label: string, resolveBif: proc (fn: string): Stream): KeyTable =
  new(result)
  result.label = label
  result.io = io
  result.ioStart = io.getPosition
  result.bifs = newSeq[Bif]()

  result.resrefIdLookup = initTable[Resref, ResId]()

  let ioStart = result.ioStart

  let ft = io.readStrOrErr(4)
  expect(ft == "KEY ")
  let fv = io.readStrOrErr(4)
  expect(fv == "V1  ")

  let bifCount = io.readInt32()
  let keyCount = io.readInt32()
  let offsetToFileTable = io.readInt32()
  let offsetToKeyTable = io.readInt32()
  let buildYear = io.readInt32()
  let buildDay = io.readInt32()
  io.setPosition(io.getPosition + 32) # reserved bytes

  const HeaderSize = 64
  assert(io.getPosition == ioStart + HeaderSize)

  # expect(offsetToFileTable > HeaderSize and offsetToFileTable < offsetToKeyTable)

  var fileTable = newSeq[tuple[fSize: int32, fnOffset: int32,
                               fnSize: int16, drives: int16]]()

  io.setPosition(offsetToFileTable)

  for i in 0..<bifCount:
    let fSize = io.readInt32()
    let fnOffset = io.readInt32()
    let fnSize = io.readInt16()
    let drives = io.readInt16()
    # expect(drives == 1, "only drives = 1 supported, but got: " & $drives)
    fileTable.add((fSize, fnOffset, fnSize, drives))

  let filenameTable = fileTable.map(proc (entry: auto): string =
    io.setPosition(ioStart + entry.fnOffset)
    expect(entry.fnSize >= 1, "bif filename in filenametable empty")
    result = io.readStrOrErr(entry.fnSize - 1)

    when defined(posix):
      result = result.replace("\\", "/")
  )

  for fn in filenameTable:
    let fnio = resolveBif(fn)
    expect(fnio != nil, "key file referenced file " & fn & " but cannot open")
    result.bifs.add(readBif(fnio, result, fn))

  io.setPosition(offsetToKeyTable)
  for i in 0..<keyCount:
    let resref = io.readStrOrErr(16).strip(true, true, {'\0'})
    let restype = io.readInt16().ResType
    let resId = io.readInt32()
    let bifIdx = resId shr 20
    let bifId = resId and 0xfffff

    expect(bifIdx >= 0 and bifIdx < result.bifs.len,
      "while reading res " & $resId & ", bifidx not indiced by keyfile: " &
      $bifIdx)

    expect(result.bifs[bifIdx].hasResId(bifId),
      "keytable references non-existant " &
      "(id: " & $bifId & ", resref: " & $resref & "." & $restype & ")" &
      " in bif " & filenameTable[bifIdx])

    let rr = newResRef(resref, restype)
    result.resrefIdLookup[rr] = resId

proc readKeyTable*(io: Stream, resolveBif: proc (fn: string): Stream): KeyTable =
  readKeyTable(io, label = "(anon-io)", resolveBif)

method contains*(self: KeyTable, rr: ResRef): bool =
  result = self.resrefIdLookup.hasKey(rr)

method demand*(self: KeyTable, rr: ResRef): Res =
  let resId = self.resrefIdLookup[rr]
  let bifIdx = resId shr 20
  let bifId = resId and 0xfffff

  expect(bifIdx >= 0 and bifIdx < self.bifs.len)

  let b = self.bifs[bifIdx]
  let va = b.getVariableResource(bifId)
  let st = b.getStreamForVariableResource(bifId)

  result = newRes(newResOrigin(self, b.filename),
    rr, b.mtime, st, va.offset, va.fileSize)

method count*(self: KeyTable): int = self.resrefIdLookup.len

method contents*(self: KeyTable): HashSet[ResRef] =
  result = initSet[ResRef]()
  for k in keys(self.resrefIdLookup):
    result.incl(k)

method `$`*(self: KeyTable): string =
  "KeyTable:" & self.label