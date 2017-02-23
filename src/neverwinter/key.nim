import streams, options, sequtils, strutils, tables, times, os, sets

import resman, util

type
  ResId = int32

  VariableResource* = ref object
    # N.B.: Full ID (with bif idx)
    id: ResId

    # Where in the bif can we find our data?
    offset: int
    fileSize: int

    # This is a bit of a hack: We are storing the resref in the bif structure,
    # because our key_unpack utility needs to know that in order to write out
    # the data on a per-bif basis; and this is a bit faster than a global lookup
    # table on the keyfile itself.
    resref: ResRef

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

# Accessors for VariableResource: Don't allow modifications from outside.
proc id*(self: VariableResource): ResId = self.id
  ## The id of this VA. Note: This is already stripped of the bif idx component.
proc offset*(self: VariableResource): int = self.offset
  ## The offset where this VA starts inside a bif.
proc fileSize*(self: VariableResource): int = self.fileSize
  ## The data size of this VA inside the owning bif.
proc resref*(self: VariableResource): ResRef = self.resref
  ## The resref of this VA.

proc readBif(io: Stream, owner: KeyTable, filename: string, expectIdx: int): Bif =
  ## Read a bif file from a stream. Used internally; as reading bif files from
  ## the outside isn't very useful (you can't get resrefs).

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
    let fullId = io.readInt32()
    let offset = io.readInt32()
    let fileSize = io.readInt32()
    let resType = io.readInt32()

    let r = VariableResource(
      id: fullId.ResId,
      offset: offset,
      fileSize: fileSize
    )

    # I'm not even sure anymore what's wrong with you, nwn data files.
    # This triggers with the distro files from 1.69.
    # let bifId = fullId shr 20
    # expect(expectIdx == bifId, "bif " & filename & " has ID not belonging to its " &
    #   "idx: expected " & $expectIdx & " but got " & $bifId)

    result.variableResources[r.id and 0xfffff] = r

proc hasResId*(self: Bif, id: ResId): bool =
  ## Returns true if this bif has a id of ResId.
  self.variableResources.hasKey(id and 0xfffff)

proc getVariableResource*(self: Bif, id: ResId): VariableResource =
  ## Returns a variable resource by ID.

  self.variableResources[id and 0xfffff]

proc getVariableResources*(self: Bif): seq[VariableResource] =
  ## Returns a seq of all VariableResouces contained in this bif.

  result = newSeq[VariableResource]()
  for k, v in self.variableResources: result.add(v)

proc getStreamForVariableResource*(self: Bif, id: ResId): Stream =
  ## Gets the stream data for a ID. The offset is already correct; but you
  ## will have to know the VA length to read data correctly (see getVariableResource).

  result = self.io
  expect(self.variableResources.hasKey(id and 0xfffff), "attempted to look up id " & $id &
    " in bif, but not found")

  result.setPosition(self.variableResources[id and 0xfffff].offset)

proc filename*(self: Bif): string =
  ## Returns the filename with which this bif was referenced in the key table.
  self.filename

proc readKeyTable*(io: Stream, label: string, resolveBif: proc (fn: string): Stream): KeyTable =
  ## Read a key table from a stream.
  ## The optional label contains debug info that describes where the table came from;
  ## you usually want to set this to the path/filename.
  ##
  ## resolveBif is expected to look up a bif (by the stored filename) and return
  ## a open, readable stream to it.  This stream will be kept open until the key
  ## table itself is closed.

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
    let e = (fSize, fnOffset, fnSize, drives)
    # expect(drives == 1, "only drives = 1 supported, but got: " & $drives)
    fileTable.add(e)

  let filenameTable = fileTable.map(proc (entry: auto): string =
    io.setPosition(ioStart + entry.fnOffset)
    expect(entry.fnSize >= 1, "bif filename in filenametable empty")

    result = io.readStrOrErr(entry.fnSize).strip(false, true, {'\0'})

    when defined(posix):
      result = result.replace("\\", "/")
  )

  for fnidx, fn in filenameTable:
    let fnio = resolveBif(fn)
    expect(fnio != nil, "key file referenced file " & fn & " but cannot open")
    let bf = readBif(fnio, result, fn, fnidx)
    result.bifs.add(bf)

  io.setPosition(offsetToKeyTable)
  for i in 0..<keyCount:
    let resref = io.readStrOrErr(16).strip(false, true, {'\0'})
    let restype = io.readInt16().ResType
    let resId = io.readInt32()
    let bifIdx = resId shr 20

    expect(bifIdx >= 0 and bifIdx < result.bifs.len,
      "while reading res " & $resId & ", bifidx not indiced by keyfile: " &
      $bifIdx)

    let rr = newResRef(resref, restype)

    expect(result.bifs[bifIdx].hasResId(resId),
      "keytable references non-existent id: " & $resId & ", resref: " & $rr &
      " in bif " & filenameTable[bifIdx])

    result.resrefIdLookup[rr] = resId

    # We're reading VAs from the bif files above (in readBif); and here we
    # re-assign the ID we just read to a resref, so the bif has the proper
    # data entry for it.
    let vra = result.bifs[bifIdx].getVariableResource(resId)
    expect(vra != nil, "key table references unknown variable resource (bug?): " &
      $bifIdx & " doesn't have " & $resId)
    vra.resref = rr

proc readKeyTable*(io: Stream, resolveBif: proc (fn: string): Stream): KeyTable =
  ## Alias for readKeyTable, just without a label.
  readKeyTable(io, label = "(anon-io)", resolveBif)

method contains*(self: KeyTable, rr: ResRef): bool =
  result = self.resrefIdLookup.hasKey(rr)

method demand*(self: KeyTable, rr: ResRef): Res =
  let resId = self.resrefIdLookup[rr]
  let bifIdx = resId shr 20

  expect(bifIdx >= 0 and bifIdx < self.bifs.len)

  let b = self.bifs[bifIdx]
  let va = b.getVariableResource(resId)
  let st = b.getStreamForVariableResource(resId)

  result = newRes(newResOrigin(self, "id=" & $resId & " in " & b.filename),
    rr, b.mtime, st, va.offset, va.fileSize)

method count*(self: KeyTable): int = self.resrefIdLookup.len

method contents*(self: KeyTable): HashSet[ResRef] =
  result = initSet[ResRef]()
  for k in keys(self.resrefIdLookup):
    result.incl(k)

method `$`*(self: KeyTable): string =
  "KeyTable:" & self.label

proc bifs*(self: KeyTable): seq[Bif] =
  ## Returns the bifs this key table references.
  self.bifs
