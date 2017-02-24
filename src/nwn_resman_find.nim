## This utility finds files matching a partial match in resman.
##
## Note: this is only the final resman view. This will NOT list resources
##       not indiced by keyfiles/override/etc and will not list shadowed
##       resource locations.
##
## Wildcards are not supported; just partial matches of the filename will be
## printed.
##
## Example: resman_find .ids

import streams, tables, os, options, sequtils, strutils, algorithm, pegs

import neverwinter.resman,
  neverwinter.resref,
  neverwinter.key,
  neverwinter.resfile,
  neverwinter.resmemfile,
  neverwinter.resdir,
  neverwinter.erf

import shared

if paramCount() != 2: quit("Syntax: <gameroot> <partial>")

let root = paramStr(1)
let match = paramStr(2)

let rm = newBasicResMan(root)

var q = newSeq[ResRef]()
for o in rm.contents:
  let str = $o
  if str.find(match) != -1: q.add(o)

sort(q) do (a, b: auto) -> int: system.cmp[string]($a, $b)

for o in q:
  let str = $o
  echo str, repeat(" ", 30 - str.len), rm[o].get().origin()
