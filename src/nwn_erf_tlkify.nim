import shared

let Args = DOC """
This utility reads a ERF (mod, hak), extracting all strings in
contained gff files and normalising them into a tlk.

The <tlk> file will be read at startup if it exists, and new entries
will be merged in.

The changed <erf> will be written to <out>; leaving the original
file untouched.

Usage:
  $0 [options] <tlk> <erf> <out>
  $USAGE

  $OPT
"""

let erfFn = $ARGS["<erf>"]
doAssert(fileExists(erfFn))
let outFn = $ARGS["<out>"]
let tlkFn = $ARGS["<tlk>"]
let tlkBaseFn = splitFile(tlkFn).name.toLowerAscii

info "Base TLK name: ", tlkBaseFn

import critbits, os, osproc, tables, options, sets, sequtils, strutils, logging

import neverwinter/gff, neverwinter/erf, neverwinter/resman,
  neverwinter/resref, neverwinter/tlk, neverwinter/twoda

# text => strref
var translations: CritBitTree[StrRef]
var newTranslations = 0
var latestStrref = StrRef 0

proc translate(str: string): StrRef =
  if str.len > 0:
    if not translations.hasKey(str):
      translations[str] = latestStrref
      inc(latestStrref)
      inc(newTranslations)
      debug "[", latestStrref, "]: ", str.substr(0, 15).escape & ".."

    result = translations[str]
  else:
    result = BadStrRef

proc tlkify(gin: var GffStruct) =
  ## Translate all embedded strings in this gff struct, rewriting
  ## them into StrRefs in place.
  for lbl,val in gin.fields:
    if val.fieldKind == GffFieldKind.Struct:
      var substruct: GffStruct = val.getValue(GffStruct)
      tlkify(subStruct)

    elif val.fieldKind == GffFieldKind.List:
      var lst = val.getValue(GffList)
      for substruct in mitems(lst):
        tlkify(substruct)

    elif val.fieldKind == GffFieldKind.CExoLocString:
      var exolocstr = val.getValue(GffCExoLocString)

      var textsToIgnore = newSeq[string]()
      # Don't translate fields that are just repeats of tags or resrefs.
      if gin.hasField("Tag", GffCExoString): textsToIgnore.add($gin["Tag", GffCExoString])
      if gin.hasField("TemplateResRef", GffResRef): textsToIgnore.add($gin["TemplateResRef", GffResRef])
      if gin.hasField("ResRef", GffResRef): textsToIgnore.add($gin["ResRef", GffResRef])

      # Don't translate strings the user can't see:

      # static/unused placeables
      if gin.hasField("Useable", GffByte) and gin["Useable", GffByte] == 0 or
         gin.hasField("Static", GffByte) and gin["Static", GffByte] == 1:
        continue

      if exolocstr.strRef == -1 and exolocstr.entries.len > 0:
        doAssert(exolocstr.entries.len == 1) # we can only do english, sorry.
        doAssert(exolocstr.entries.hasKey(0))
        doAssert(StrRef(exolocstr.strRef) == BadStrRef)
        let str = exolocstr.entries[0]

        if str.len > 0 and not textsToIgnore.contains(str):
          let rewriteStrRef = translate(str) + 16777216
          doAssert(rewriteStrRef != BadStrRef)
          exolocstr.entries.clear
          exolocstr.strRef = int rewriteStrRef

          assert(val.getValue(GffCExoLocString).strRef == exolocstr.strRef)

proc tlkify(ein: Erf, outFile: string) =
  writeErf(newFileStream(outFile, fmWrite),
      ein.fileType, ein.locStrings,
      ein.strRef, toSeq(ein.contents.items)) do (r: ResRef, io: Stream):

    let ff = ein.demand(r)
    ff.seek()

    let rr = r.resolve().get()
    if GffExtensions.contains(rr.resExt):
      var root = readGffRoot(ff.io)

      if $rr == "module.ifo":
        # hack up tlk entry.
        let existingTlk = root["Mod_CustomTlk", GffCExoString]
        if existingTlk != "":
          doAssert(existingTlk == tlkBaseFn, "Module already has a tlk name of a different name: " & existingTlk)
        else:
          info "Setting TLK to ", tlkBaseFn
          root["Mod_CustomTlk", GffCExoString] = tlkBaseFn

      tlkify(GffStruct root)

      debug "Writing out gff: ", rr
      io.write(root)

    else:
      debug "Writing out non-gff: ", rr
      io.write(ff.readAll())
    discard

var newTlk: SingleTlk

if fileExists(tlkFn):
  newTlk = readSingleTlk(newFileStream(tlkFn))
  latestStrref = StrRef newTlk.highest
  info "Building translations from given tlk: ", latestStrref
  for strref in 0..latestStrref:
    let ent = newTlk[StrRef strref].unsafeGet()
    if ent.text != "":
      translations[ent.text] = StrRef strref
else:
  info "Translations: starting from scratch"
  newTlk = newSingleTlk()
  newTlk.language = Language.English

info "Reading: ", erfFn
let module = readErf(newFileStream(erfFn))

tlkify(module, outFn)

if newTranslations > 0:
  info "Saving tlk, new translations: ", newTranslations

  for str, strref in translations:
    newTlk[StrRef strref] = str
  newFileStream(tlkFn, fmWrite).write(newTlk)

else:
  info "erf did not generate new translations, not touching tlk"
