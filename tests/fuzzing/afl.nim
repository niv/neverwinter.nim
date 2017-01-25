import streams, asyncnet, asyncdispatch, tables, algorithm, os, posix

import neverwinter.gff
import neverwinter.twoda

include neverwinter.key

try:

  when defined(gff):
    discard gff.readFromStream(newFileStream(stdin), false)

  elif defined(key):
    discard key.readFromStream(newFileStream(stdin))

  elif defined(bif):
    discard openBif(newFileStream(stdin), nil, "")

  elif defined(twoda):
    discard newFileStream(stdin).readTwoDA()

  else: {.fatal: "what'cha gonna fuzz when they come for you"}

except ValueError, IOError:
  echo "This is a expected error - thank you."
  echo repr(getCurrentException())
  quit(0)

except:
  echo repr(getCurrentException())
  discard kill(getPid(), SIGSEGV)
