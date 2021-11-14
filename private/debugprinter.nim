import typetraits, strutils, streams

type DebugPrinter* = ref object
  input: Stream
  output: Stream
  nextOffset: int
  depth: int

proc newDebugPrinter*(input, output: Stream): DebugPrinter =
  new(result)
  result.depth = 0
  result.input = input
  result.output = output
  result.nextOffset = 0

template nest*(p: DebugPrinter, lbl: string, body: auto) =
  p.output.writeLine repeat(" ", 8), " ",
    repeat("  ", p.depth), lbl, ":"
  p.depth += 1
  body
  p.depth -= 1

template emitPadded[T](p: DebugPrinter, t: typedesc[T], k, v: string) =
  # addr(8) " " depthpadding label(30) " "
  let offset = p.nextOffset
  p.nextOffset = p.input.getPosition()
  let a = offset.toHex(8).strip(leading=true, chars={'0'})
  p.output.writeLine a, repeat(" ", 8 - a.len), " ",
    repeat("  ", p.depth), k,
    repeat(" ", 30 - k.len), " ", v,
    " (", name(t), ")"

when not compiles(SomeFloat): # 0.18->0.19 shim
  type SomeFloat* = SomeReal

proc emit*[T:SomeFloat](p: DebugPrinter, k: string, v: T) =
  emitPadded p, type(T), k, $v

proc emit*[T:string](p: DebugPrinter, k: string, v: T) =
  emitPadded p, type(T), k, v.escape

proc emit*[T:SomeSignedInt|SomeUnsignedInt](p: DebugPrinter, k: string, v: T) =
  emitPadded p, type(T), k, $v & "|0x" & toHex(v)
