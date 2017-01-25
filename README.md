# neverwinter.nim

This is a nim-lang library to read and write data files used by Neverwinter Nights 1 & 2.  It's for you if you don't have the patience for C, are unreasonably scared of modern C++, don't like Java, and Ruby is too slow!

## import neverwinter.gff

A fully-featured gff reader and writer, that can work both in gobble-all mode or in streaming mode.  It supports all known data types and has been battle-tested through fuzzing, so it should be perfectly safe to pass user input to it.

It has a nice, fluid API to it that transparently maps native data types to GFF fields.  Please see the generated docs for details.

```nim
import neverwinter.gff

# GffRoot is like a GffStruct
let root: GffRoot = newFileStream(paramStr(1)).readGffRoot(true)

echo root["Str", byte]
root["Str", byte] = 3
newFileStream("out.gff").write(root)
```

## import neverwinter.json

gff<->json transformation helpers.

```nim
import neverwinter.gff, neverwinter.gffjson

let root: GffRoot = newFileStream(paramStr(1)).readGffRoot(false)
let json: JSONNode = someRoot.toJson()
let root2 = s.gffRootFromJson()
```

## import neverwinter.resman

A eventually-fully-featured resman implementation that works just like the one in the game.  You can stack compatible containers into it (key, erf, directories, ..) or just write your own.

Also includes helpers to identify resources (ResRef) and a streaming API to read data out of those containers (Res).

Also also includes a rather experimental, builtin weighted LRU cache that will feather off multiple reads to the same resource.

## import neverwinter.key, neverwinter.erf, neverwinter.resdir

.key/.bif/.erf/override-style readonly support, to be used together with resman.  Fuzz-tested to catch the biggest snafus.

```nim
import neverwinter.resman, neverwinter.key

let r = resman.newResMan(100) #100MB of in-memory cache for requests

for f in ["chitin", "xp1", "xp1patch", "xp2", "xp2patch", "xp3"]:
  r.add(newFileStream(f & ".key").readKeyTable())

r.add(newFileStream("my.erf").readErf())

r.add(resdir.newResDir("./override/"))

echo r = r["nwscript.nss"]
if r.isSome: echo r.read()
```

## import neverwinter.twoda

A simple twoda parser.

```nim
import neverwinter.twoda

let app = newFileStream("appearance.2da").readTwoDA()
echo app[5]["Race"] # lookups are case-insensitive
```

## Why?

Is that a trick question?

## Is it fast?

Yes.

## Is it any good?

Yes.
