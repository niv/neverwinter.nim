# neverwinter.nim

This is a nim-lang library and utility collection to read and write data files used
by Neverwinter Nights 1.  It's for you if you don't have the patience for C, are
unreasonably scared of modern C++, don't like Java, and Ruby is too slow!

This README has two parts. First the utilties are explained, then the data library.

# Utilities

nim tools for nwn development.  Build it, and they will come, they said.
On the other hand:  Good things are built with tools, but great things are built
with great tools.

Thus, If you are in need of a specific utility to solve a problem you are facing,
please open a ticket or contact me directly, and we will try to find a solution for
you.

This suite is meant to eventually grow into a complete NWN toolkit that anyone,
be it dev or community member, can use.  They must be available on ALL supported
platforms and work on all of them equally well.

## Tools provided

* `nwn_gff`: Transforms gff data to/from various formats.
* `nwn_erf`: Un/pack erf files.
* `nwn_tlk`: Transforms tlk tables from/to various formats.
* `nwn_twoda`: Transforms 2da files from/to various formats.
* `nwn_key_pack, nwn_key_unpack`: Un/packs a keyfile into/from a directory structure.
* `nwn_key_shadows`: Get data on file shadowing in a list of key files.
* `nwn_key_transparent`: Get data on file duplication in a list of key files.
* `nwn_resman_stats`: Get data on what is in a resman view.
* `nwn_resman_grep`: Grep a resman view for data.
* `nwn_resman_extract`: Pull files from resman into directory.
* `nwn_resman_cat`: Pull file(s) from resman and pipe them to stdout.
* `nwn_resman_diff`: Diffs two resman views (for language support).
* `nwn_resman_pkgsrv`: Repackage a resman view suitable for docker deployment.
* `nwn_net`: A utility providing some network-related helpers, like querying servers.
* `nwn_erf_tlkify`: Refactor strings in a erf into a exisiting or new tlk.

All utilities write their working output to stdout, and any library- or tool-
related logging goes to stderr.  You can turn on debug logging with `--verbose`,
and turn off all logging except errors with `--quiet`.

For detailed documentation, please see their source files in `src/`: They have
a documentation header right at the top.

### Philosophy

Most of these utilities embed a complete resman.  The general idea is NOT to
operate on single file formats.  Instead, they all utilise the underlying resman
implementation from the neverwinter library included in this repository.

For example, if you want to get statistics about a key file, you do not unpack it:
Instead, you use `nwn_resman_stats` and tell it to only load the key file you are
interested in.

## Just static binaries please

Binary releases are available on the Github Releases page of this project. You do
not need to install anything else.

## Install for library use

* Install nim 0.19.4 or greater, have it on PATH and working. The best way to do this
  as of this writing is https://github.com/dom96/choosenim, which will install it
  for your user on Linux/OSX, and on Windows will even pull in the required compiler
  and package manager.

* Run `nimble install neverwinter`.

* This will also compile the binaries into your nimble PATH.

## Build from scratch

* Clone this repository: `git clone https://github.com/niv/neverwinter.nim`

* Switch to it and run `nimble build  -d:release`.
  This will build release binaries into `bin`.

* To update the whole package, run `git pull --tags` and build again.

* Optional: Add `bin` to your PATH, so you can call them
  from everywhere.  All utilities are prefixed with `nwn_` so you can just tab-
  complete your way to happiness.

* All utilities have a help page. Just pass `-h` as the only argument.

## Debugging

If there's issues, build the binaries in debug mode (nim build builds release
binaries) to help find issues.  If you have trouble, email me.

If debug mode is too slow, add `--lineTrace:on --stackTrace:on` to at least
get good backtraces.


# Library

## import neverwinter.gff

A fully-featured gff reader and writer, that can work both in gobble-all mode or in streaming mode.  It supports all known data types and has been battle-tested through fuzzing, so it should be perfectly safe to pass user input to it.

It has a nice, fluid API to it that transparently maps native data types to GFF fields.  Please see the generated docs for details.

```nim
import neverwinter.gff

# GffRoot is like a GffStruct
let root: GffRoot = openFileStream(paramStr(1)).readGffRoot(true)

echo root["Str", byte]
root["Str", byte] = 3
openFileStream("out.gff").write(root)
```

## import neverwinter.gffjson

gff<->json transformation helpers.

```nim
import neverwinter.gff, neverwinter.gffjson

let root: GffRoot = openFileStream(paramStr(1)).readGffRoot(false)
let json: JSONNode = someRoot.toJson()
let root2 = s.gffRootFromJson()
```

## import neverwinter.resman

A eventually-fully-featured resman implementation that works just like the one in the game.  You can stack compatible containers into it (key, erf, directories, ..) or just write your own.

Also includes helpers to identify resources (ResRef) and a streaming API to read data out of those containers (Res).

Also also includes a rather experimental, builtin weighted LRU cache that will feather off multiple reads to the same resource.

## import neverwinter.key, neverwinter.erf, neverwinter.resdir, neverwinter.resfile, neverwinter.resmemfile

.key/.bif/.erf/override-style readonly support, to be used together with resman.  Fuzz-tested to catch the biggest snafus.

```nim
import neverwinter.resman, neverwinter.key, neverwinter.resref

let r = resman.newResMan(100) #100MB of in-memory cache for requests

for f in ["chitin", "xp1", "xp1patch", "xp2", "xp2patch", "xp3"]:
  let keyTable = openFileStream(f & ".key").readKeyTable(f) do (bifFn: string) -> Stream:
    doAssert(fileExists(bifFn), "key file asks for " & bifFn & ", but not found")
    openFileStream(bifFn)

  r.add(keyTable)

r.add(openFileStream("my.erf").readErf())

r.add(resdir.newResDir("./override/"))

r.add(resdir.newResFile("./dialog.tlk"))

r.add(resdir.newResMemFile(newStringStream("khaaaaaaan"), "test.txt""))

echo r = r["nwscript.nss"]
if r.isSome: echo r.get().readAll()
```

## import neverwinter.twoda

A simple twoda parser/writer.

```nim
import neverwinter.twoda

let app = openFileStream("appearance.2da").readTwoDA()
echo app[5]["Race"] # lookups are case-insensitive
openFileStream(stdout).write(app)
```

## import neverwinter.tlk

A tlk file reader. It's using a LRU cache to theoretically speed up access.

```nim
import neverwinter.resman
import neverwinter.tlk

let rs = newResMan()
rs.add(newResFile("dialog.tlk"))
rs.add(newResFile("dialogf.tlk"))

let dlg = newTlk(@[
  (rs["dialog.tlk"].get(), rs["dialogf.tlk"].get())
])

echo dlg[5, gender = Gender.Female]
```
