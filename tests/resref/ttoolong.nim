discard """
  outputsub: "unhandled exception: 'aaaaaaaaaaaaaaaaa.bmp' is not a valid resref [ValueError]"
  exitcode: 1
"""

include neverwinter/resref

discard newResRef(repeat("a", ResRefMaxLength + 1), 1.ResType)
