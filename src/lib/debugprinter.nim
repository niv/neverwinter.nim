import typetraits, strutils, streams

type DebugPrinter* = ref object
  output: Stream
  depth: int

proc newDebugPrinter*(output: Stream): DebugPrinter =
  new(result)
  result.depth = 0
  result.output = output

template nest*(p: DebugPrinter, lbl: string, body: any) =
  p.output.writeLine repeat("  ", p.depth), lbl, ":"
  p.depth += 1
  body
  p.depth -= 1

proc emitPadded(p: DebugPrinter, k, t, v: string) =
  p.output.writeLine repeat("  ", p.depth), k, repeat(" ", 30 - k.len), " ", v, " (", t, ")"

proc emit*[T:SomeReal](p: DebugPrinter, k: string, v: T) =
  emitPadded p, k, name(type(T)), $v

proc emit*[T:string](p: DebugPrinter, k: string, v: T) =
  emitPadded p, k, name(type(T)), v.escape

proc emit*[T:SomeSignedInt|SomeUnsignedInt](p: DebugPrinter, k: string, v: T) =
  emitPadded p, k, name(type(T)), $v & "|0x" & toHex(v)
