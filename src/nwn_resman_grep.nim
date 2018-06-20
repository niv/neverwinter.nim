import shared, std/sha1, md5

let args = DOC """
Find files in resman

Note: this is only the final resman view. This will NOT list resources
      not indiced by keyfiles/override/etc and will not list shadowed
      resource locations, only the latest.

You can optionally generate file checksums for each entry found. The selectable
algorithms are printed in the order listed in this help.

Usage:
  $0 [options]
  $USAGE

Options:
  --all                       Match all files.
  -p, --pattern PATTERN       Match only files where the name contains PATTERN.
                              Wildcards are not supported at this time.
  -b, --binary BINARY         Match only files where the data contains BINARY.
  -v, --invert-match          Invert matching rules.

  -d, --details               Show more details.
  --md5                       Generate md5 checksums of files.
  --sha1                      Generate sha1 checksums of files.
  $OPTRESMAN
"""

if not args["--pattern"] and not args["--binary"] and not args["--all"]:
  quit("Give at least one of --pattern, --binary or --all")

let rm = newBasicResMan()

let invert       = args["--invert-match"]
let patternMatch = if args["--pattern"]: $args["--pattern"] else: ""
let binaryMatch  = if args["--binary"]: $args["--binary"] else: ""

for res in filterByMatch(rm, patternMatch, binaryMatch, invert):
  let str = $res.resRef
  stdout.write(str)

  if args["--md5"] or args["--sha1"] or args["--details"]:
    stdout.write repeat(" ", 20 - str.len), "  "

  if args["--md5"]:
    stdout.write getMD5(res.readAll()), "  "
  if args["--sha1"]:
    stdout.write secureHash(res.readAll()), "  "

  if args["--details"]:
    stdout.write align(res.len.formatSize, 12), "  ",
                 res.origin()

  stdout.write("\c\L")
