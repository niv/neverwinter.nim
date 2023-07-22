import std/[strutils, sequtils, pegs]

type
  LanguageSpec* = tuple
    defines: seq[tuple[name, value: string]]
    consts:  seq[tuple[typ, name, value: string]]
    funcs:   seq[tuple[rettyp, name, args: string]]

proc parseLanguageSpec*(code: string): LanguageSpec =
  let lines = code.splitLines().
    mapIt(it.replace(peg" '//' .+ $")).
    mapIt(it.strip).
    filterIt(not it.startsWith("//")).
    filterIt(it.len > 0)

  for ln in lines:
    if ln =~ peg"^ '#define' \s+ {\ident} \s+ {.+} $":
      result.defines.add (matches[0], matches[1])
    elif ln =~ peg"^ {'int'/'string'/'float'} \s+ {\ident} \s* '=' \s* {[^;]+} ';' $":
      result.consts.add (matches[0], matches[1], matches[2])
    elif ln =~ peg"^ {\ident} \s+ {\ident} \( \s* {[^\)]*} \s* \) ';' $":
      result.funcs.add (matches[0], matches[1], matches[2])
    else:
      raise newException(ValueError, "Unparseable line in langspec: " & ln.escape())
