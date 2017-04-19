import streams, encodings

# -----------------------
#  IO and error handling
# -----------------------

proc readStrChunked*(io: Stream, size: int): TaintedString =
  ## Read size bytes from stream, in chunks as to avoid memory contention.

  result = ""
  var remaining = size

  while remaining > 0:
    let want = min(remaining, 1024)
    let buf = io.readStr(want)
    if buf.len == 0 or buf.len < want: raise newException(IOError,
      "wanted to read " & $want & " but only got " & $buf.len)
    remaining -= buf.len
    result &= buf

proc readStrOrErr*(io: Stream, size: int): TaintedString =
  ## Reads a string of exactly size bytes off io, or error out.
  result = io.readStrChunked(size)

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



# ----------
#  Encoding
# ----------

var nwnEncoding = "windows-1252"
var nativeEncoding = getCurrentEncoding()

proc getNwnEncoding*(): string = nwnEncoding
  ## Returns the configured encoding you expect to be used by NWN data files.
  ## The default is windows-1252 for western NWN1.

proc setNwnEncoding*(e: string) = nwnEncoding = e
  ## Sets the encoding you expect your read and written nwn data formats to be in.
  ## The default is windows-1252 for western NWN1.

proc getNativeEncoding*(): string = nativeEncoding
  ## Returns the configured native encoding files are read and written as.
  ##   (This is ALWAYS utf-8 for json.)

proc setNativeEncoding*(e: string) = nativeEncoding = e
  ## Sets the configured native encoding files are read and written as.
  ##   (This is ALWAYS utf-8 for json.)


template toNwnEncoding*(s: string): string =
  ## Converts a string from the local/os encoding (probably UTF-8) to the
  ## configured NWN encoding.
  s.convert(nwnEncoding, nativeEncoding)

template fromNwnEncoding*(s: string): string =
  ## Converts a string to the local/os encoding (probably UTF-8) from the
  ## configured NWN encoding.
  s.convert(nativeEncoding, nwnEncoding)

# --------------------------------
#  Other helpers/stdlib additions
# --------------------------------

proc map*[T, R](data: openArray[T],
                op: proc(idx: int, x: T): R {.closure.}): seq[R] {.inline.} =
  ## same as sequtil.map(), except that it yields the index too.
  newSeq[R](result, data.len)
  for i in 0..<data.len: result[i] = op(i, data[i])
