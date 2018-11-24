import strutils

# This is pure/json, but patched to render things slightly differently.
# It's only used for nwn_gff and neverwinter/gff. Unfortunately, it can't
# really interop with pure/json.

var normalizeFloatsPrecision: range[-1 .. 32] = 16
proc jsonNormalizeFloatsTo*(precision: range[-1 .. 32]) =
  normalizeFloatsPrecision = if precision == 0: 16 else: precision

proc add(s: var string, data: float) =
  s.add(formatFloat(data, ffDecimal, normalizeFloatsPrecision, '.'))

include json
