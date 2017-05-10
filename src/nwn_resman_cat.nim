import shared

let args = DOC """
Extract file(s) from resman to stdout.

Usage:
  $0 [options] <file>...
  $USAGE

Options:
  $OPTRESMAN
"""

let rm = newBasicResMan()

let resolved = args["<file>"].mapIt(rm[it])

for i, o in resolved:
  doAssert(o.isSome, "not in resman: " & args["<file>"][i])

for o in resolved:
  stdout.write(o.get().readAll())
