import shared
let args = DOC """
Find files in resman

Note: this is only the final resman view. This will NOT list resources
      not indiced by keyfiles/override/etc and will not list shadowed
      resource locations, only the latest.

Usage:
  $0 [options]
  $0 -h | --help

Options:
  -p, --pattern PATTERN       List files where the name contains PATTERN.
                              Wildcards are not supported at this time.
  -b, --binary BINARY         List files where the data contains BINARY.
  -v, --invert-match          List non-matching files.
  -d, --details               Show more details.
$OPT
"""

if not args["--binary"] and not args["--pattern"]:
  quit("Give one of -b or -p")

let rm = newBasicResMan()

let invert = args["--invert-match"]

for o in rm.contents:
  let str = $o
  let res = rm[o].get()

  let match = (args["--pattern"] and str.find($args["--pattern"]) != -1) or
              (args["--binary"] and res.readAll().find($args["--binary"]) != -1)

  if (match and not invert) or (not match and invert):
    stdout.write(str)
    # print: <filename padded to resref>
    if args["--details"]:
      stdout.write repeat(" ", 20 - str.len), "  ",
                   align(res.len.formatSize, 12), "  ",
                   res.origin()

    stdout.write("\c\L")
