discard """
  outputsub: "unhandled exception: '.bmp' is not a valid resref [ValueError]"
  exitcode: 1
"""

include neverwinter/resref

discard newResRef("", 1.ResType)
