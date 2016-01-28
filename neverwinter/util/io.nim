import streams

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
