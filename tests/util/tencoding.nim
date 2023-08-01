import neverwinter/util

import std/encodings

let check = convert("±", getCurrentEncoding(), "utf-8")

doAssert fromNwnEncoding("\xb1") == check
doAssert toNwnEncoding(check) == "\xb1"

doAssert getNativeEncoding() == getCurrentEncoding()
doAssert getNwnEncoding() == "windows-1252"
