import std/[streams, encodings, endians]

# -----------------------
#  IO and error handling
# -----------------------

proc readStrOrErr*(io: Stream, size: int): string =
  ## Reads a string of exactly size bytes off io, or error out.
  result = io.readStr(size)
  if result.len < size:
    raise newException(IOError, "wanted to read " & $size & " but only got " & $result.len)

proc readFixedCountSeq*[T](io: Stream, count: int, reader: proc(idx: int): T): seq[T] =
  result = newSeq[T](count)
  for idx, e in result: result[idx] = reader(idx)

template expect*(cond: bool, msg: string = "") =
  ## Expect `cond` to be true, otherwise raise a ValueError.
  ## This works analogous to doAssert, except for the error type.

  bind instantiationInfo
  {.line: instantiationInfo().}:
    if not cond:
      let expmsg =
        if msg != "": msg
        else: "Expectation failed: " & astToStr(cond)
      raise newException(ValueError, expmsg)

func swapEndian*[T: SomeInteger | SomeFloat](u: T): T =
  when sizeof(T) == 1: result = u
  elif sizeof(T) == 2: endians.swapEndian16(unsafeAddr result, unsafeAddr u)
  elif sizeof(T) == 4: endians.swapEndian32(unsafeAddr result, unsafeAddr u)
  elif sizeof(T) == 8: endians.swapEndian64(unsafeAddr result, unsafeAddr u)
  else: {.error: "swapEndian not implemented for " & $typedesc(T).}


# ----------
#  Encoding
# ----------

# These are initialised on first use per thread.
var nwnEncoding {.threadvar.}: string
var nativeEncoding {.threadvar.}: string

proc getNwnEncoding*(): string =
  ## Returns the configured encoding you expect to be used by NWN data files.
  ## The default is windows-1252 for western NWN1.
  if nwnEncoding == "":
    nwnEncoding = "windows-1252"
  nwnEncoding

proc setNwnEncoding*(e: string) = nwnEncoding = e
  ## Sets the encoding you expect your read and written nwn data formats to be in.
  ## The default is windows-1252 for western NWN1.

proc getNativeEncoding*(): string =
  ## Returns the configured native encoding files are read and written as.
  ##   (This is ALWAYS utf-8 for json.)
  if nativeEncoding == "":
    nativeEncoding = getCurrentEncoding()
  nativeEncoding

proc setNativeEncoding*(e: string) = nativeEncoding = e
  ## Sets the configured native encoding files are read and written as.
  ##   (This is ALWAYS utf-8 for json.)


template toNwnEncoding*(s: string): string =
  ## Converts a string from the local/os encoding (probably UTF-8) to the
  ## configured NWN encoding.
  s.convert(getNwnEncoding(), getNativeEncoding())

template fromNwnEncoding*(s: string): string =
  ## Converts a string to the local/os encoding (probably UTF-8) from the
  ## configured NWN encoding.
  s.convert(getNativeEncoding(), getNwnEncoding())

# --------------------------------
#  Other helpers/stdlib additions
# --------------------------------

proc map*[T, R](data: openArray[T],
                op: proc(idx: int, x: T): R {.closure.}): seq[R] {.inline.} =
  ## same as sequtil.map(), except that it yields the index too.
  newSeq[R](result, data.len)
  for i in 0..<data.len: result[i] = op(i, data[i])
