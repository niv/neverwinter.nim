## This tool unpacks a key file to the destination directory, exploded into subdirs.
## This will only work on *one* keyfile; if you wish to expand a full set of key files,
## you will have to do it for each one.
#
## Syntax: key_unpack <file.key> <destinationParent>
##
## Example: key_unpack xp1.key xp1out/
##   -> Unpacks to xp1out/bif1.bif...

import streams, tables, os, options, sequtils, securehash, logging, times

import neverwinter.key, neverwinter.resref

addHandler newConsoleLogger()

if paramCount() != 2: quit("Syntax: <file.key> <destinationParent>")

let keyfile = paramStr(1)
doAssert(fileExists(keyfile), "file not found: " & keyfile)
var keyfileLocation = splitFile(keyfile).dir
if keyfileLocation == "": keyfileLocation = "." # thanks, windows

let dest = paramStr(2) & DirSep

info "Will attempt to locate bif files in: ", keyfileLocation
info "Will unpack to: ", dest

if dirExists(dest):
  for k in walkDir(dest):
    quit("Target directory not empty; aborting for your own safety.")

createDir(dest)

let kt = readKeyTable(newFileStream(keyfile)) do (bif: string) -> Stream:
  let bifn = keyfileLocation & DirSep & extractFilename(bif) # eat "data\"
  doAssert(fileExists(bifn), "keyfile attempted to read nonexistant file '" & bif & "'")
  info "Loading bif: ", bifn
  newFileStream(bifn)

for bif in kt.bifs:
  let baseFn = extractFilename(bif.filename)
  let vrs = bif.getVariableResources()
  let targetDir = dest & DirSep & baseFn & DirSep
  info "Unpacking bif: ", baseFn, " containing ", vrs.len, " resources to ", targetDir

  createDir(targetDir)

  for vr in vrs:
    let fs = newFileStream(targetDir & $vr.resref, fmWrite)
    let str = bif.getStreamForVariableResource(vr.id)
    fs.write(str.readStr(vr.fileSize))
    fs.close()
