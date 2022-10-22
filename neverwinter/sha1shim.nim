import std/sha1
from std/strutils import toLowerAscii
export sha1 except `$`

# Bit of a hack, sorry: always print securehash in lowercase
proc `$`*(s: SecureHash): string =
  toLowerAscii(sha1.`$`(s))
