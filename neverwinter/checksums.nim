import checksums/[sha1, md5]

from std/strutils import toLowerAscii, escape

export sha1 except `$`, parseSecureHash
export md5

# Bit of a hack, sorry: always print securehash in lowercase
proc `$`*(s: SecureHash): string =
  toLowerAscii(sha1.`$`(s))

proc parseSecureHash*(s: string): SecureHash =
  try:
    sha1.parseSecureHash(s)
  except:
    raise newException(ValueError, "Not a valid SHA1: " & s.escape())
