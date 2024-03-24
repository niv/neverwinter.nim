when NimMajor == 2:
  import checksums/[sha1, md5]
else:
  import std/[sha1, md5]

from std/strutils import toLowerAscii

export sha1 except `$`
export md5

# Bit of a hack, sorry: always print securehash in lowercase
proc `$`*(s: SecureHash): string =
  toLowerAscii(sha1.`$`(s))
