import streams, encodings

proc readStrChunked*(io: Stream, size: int): TaintedString =
  result = ""
  var remaining = size

  while remaining > 0:
    let want = min(remaining, 1024)
    let buf = io.readStr(want)
    if buf.len == 0 or buf.len < want: raise newException(IOError,
      "wanted to read " & $want & " but only got " & $buf.len)
    remaining -= buf.len
    result &= buf

proc readStrOrErr*(io: Stream, size: int): string =
  result = io.readStrChunked(size)

template expect*(cond: bool, msg: string = "") =
  ## Expect `cond` to be true, otherwise raise a ValueError.
  ## This works analogous to doAssert, except for the error type.

  bind instantiationInfo
  {.line: instantiationInfo().}:
    if not cond:
      raise newException(ValueError, "Expectation failed: " & astToStr(cond) & ' ' & msg)

const NwnEncoding = "windows-1252"
template toNwnEncoding*(s: string): string = s.convert(NwnEncoding, getCurrentEncoding())
template fromNwnEncoding*(s: string): string = s.convert(getCurrentEncoding(), NwnEncoding)