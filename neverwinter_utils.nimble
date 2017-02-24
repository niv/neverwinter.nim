version       = "0.1.0"
author        = "niv <niv@nwnx.io>"
description   = "nwn1 development tools"
license       = "mindflayer 1.0"

#requires "nim >= 0.16.0"
#requires "docopt = 0.6.4"

#srcDir = "."
#skipExt = @["nim"]

# This doesnt work in nimble 0.16.0 yet. Waiting for upstream bugfix in next
#  release.
# bin = @["gff2json", "json2gff", "twoda_reformat", "key_pack", "key_unpack"]