import shared

let args = DOC """
This tool unpacks a key file to the destination directory, exploded into subdirs.
This will only work on *one* keyfile; if you wish to expand a full set of key files,
you will have to do it for each one.

Usage:
  $0 [options] <key> <destination>
  $0 -h | --help

Options:
  -f --force                  Force unpack even if target directory has stuff in it.
  $OPT
"""

let keyfile = $args["<key>"]
doAssert(fileExists(keyfile), "file not found: " & keyfile)
var keyfileLocation = splitFile(keyfile.expandFilename).dir

let dest = $args["<destination>"]

info "Will attempt to locate bif files in: ", keyfileLocation
info "Will unpack to: ", dest

if not args["--force"] and dirExists(dest):
  for k in walkDir(dest):
    quit("Target directory not empty; aborting for your own safety.")

createDir(dest)

let kt = readKeyTable(newFileStream(keyfile)) do (bif: string) -> Stream:
  let bifn = keyfileLocation / extractFilename(bif) # eat "data\"
  doAssert(fileExists(bifn), "keyfile attempted to read nonexistant file '" & bif & "'")
  info "Loading bif: ", bifn
  newFileStream(bifn)


let metaKeyOrder = newFileStream(dest / "key_order.txt", fmWrite)
doAssert(metaKeyOrder != nil)
for e in kt.contents: metaKeyOrder.writeLine($e)
metaKeyOrder.close()

let metaBifOrder = newFileStream(dest / "bif_order.txt", fmWrite)
doAssert(metaBifOrder != nil)
for e in kt.bifs: metaBifOrder.writeLine(e.filename.extractFilename)
metaBifOrder.close()

for bif in kt.bifs:
  let baseFn = extractFilename(bif.filename)
  let vrs = bif.getVariableResources()
  let targetDir = dest / baseFn
  info "Unpacking bif: ", baseFn, " containing ", vrs.len, " resources to ", targetDir

  createDir(targetDir)
  let metaFn = dest / baseFn & "_order.txt"
  var metaBifEntriesOrder = newFileStream(metaFn, fmWrite)
  doAssert(metaBifEntriesOrder != nil, "Could not create meta file: " & metaFn)

  for vr in vrs.withProgressBar(bif.filename & ": "):
    let fs = newFileStream(targetDir / $vr.resref, fmWrite)
    let str = bif.getStreamForVariableResource(vr.id)
    fs.write(str.readStr(vr.fileSize))
    fs.close()

    metaBifEntriesOrder.writeLine($vr.resref)

  metaBifEntriesOrder.close()
