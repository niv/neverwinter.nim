import shared, securehash, md5

let args = DOC """
Find files in resman

Note: this is only the final resman view. This will NOT list resources
      not indiced by keyfiles/override/etc and will not list shadowed
      resource locations, only the latest.

You can optionally generate file checksums for each entry found. The selectable
algorithms are printed in the order listed in this help.

Usage:
  $0 [options]
  $0 -h | --help

Options:
  -p, --pattern PATTERN       List files where the name contains PATTERN.
                              Wildcards are not supported at this time.
  -b, --binary BINARY         List files where the data contains BINARY.
  -v, --invert-match          List non-matching files.
  -d, --details               Show more details.
  --md5                       Generate md5 checksums of files.
  --sha1                      Generate sha1 checksums of files.
  $OPTRESMAN
"""

if not args["--binary"] and not args["--pattern"]:
  quit("Give one of -b or -p")

let rm = newBasicResMan()

let invert = args["--invert-match"]

var filtered = newSeq[Res]()
for o in rm.contents.withProgressBar():
  let str = $o
  let res = rm[o].get()

  let match = (args["--pattern"] and str.find($args["--pattern"]) != -1) or
              (args["--binary"] and res.readAll().find($args["--binary"]) != -1)

  if (match and not invert) or (not match and invert):
    filtered.add(res)

for res in filtered:
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
