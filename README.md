# neverwinter.nim

This is a nim-lang library to read and write data files used by Neverwinter Nights
1 & 2.  It's for you if you don't have the patience for C, are unreasonably scared
of modern C++, don't like Java, and Ruby is too slow!

## Current feature set

* a somewhat-opinionated, easy to use API to manage gff structures
* gff V3.2 reader both in streaming and full mode
* gff V3.2 writer
* json transformations

## Example

```nim
import neverwinter

let root: GffRoot = readFromStream(newFileStream(paramStr(1)), true)

echo root["Str", byte]
root["Str", byte] = 5.byte
echo root["Str", byte]
echo root.fields["Str"]

let outio = newFileStream("out.gff", fmWrite)
root.writeToStream(outio)
```

## Why?

Is that a trick question?

## Is it any good?

Yes.