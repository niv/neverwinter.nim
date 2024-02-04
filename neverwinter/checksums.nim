when NimMajor == 2:
  import checksums/[sha1, md5]
else:
  import std/[sha1, md5]

export sha1, md5
