import shared, std/sha1

import critbits, os, tables, options, sets, sequtils, strutils, logging

import neverwinter/gff, neverwinter/erf, neverwinter/resman,
  neverwinter/resref, neverwinter/tlk

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

Options:
  --languages N               Use language(s) N, discard all others [default: English]
                              You can specify by enum const ("English"),
                              shortcode ("de"), or by ID. (see languages.nim)
                              You can specify multiple languages separated by comma.
                              Only the first one will be used. The written TLK will
                              be the first in the list. This functionality only exists
                              to support adopting incorrectly-classified languages in
                              your module.

  --data-version VERSION      Data file version to write (one of V1, E1). [default: V1]
  --data-compression ALG      Compression for E1 (one of """ & SupportedAlgorithms & """) [default: none]
  $OPTRESMAN
"""

let erfFn = $ARGS["<erf>"]
doAssert(fileExists(erfFn))
let outFn = $ARGS["<out>"]
let tlkFn = $ARGS["<tlk>"]
let tlkBaseFn = splitFile(tlkFn).name.toLowerAscii

let selectedLanguages = ($ARGS["--languages"]).split(",").mapIt(it.resolveLanguage)
doAssert(selectedLanguages.len > 0)

let dataVersion = parseEnum[ErfVersion](capitalizeAscii $Args["--data-version"])
let dataCompAlg = parseEnum[Algorithm](capitalizeAscii $Args["--data-compression"])
let dataExoComp = if dataCompAlg != Algorithm.None: ExoResFileCompressionType.CompressedBuf else: ExoResFileCompressionType.None

info "Base TLK name: ", tlkBaseFn
info "Selected languages: ", $selectedLanguages
let dialogTlkFn = findNwnRoot() & "/data/dialog.tlk"
info "Base game dialog TLK at: ", dialogTlkFn
let dialogTlk = readSingleTlk(openFileStream(dialogTlkFn, fmRead))

# text => strref
var translations: CritBitTree[StrRef]
var newTranslations = 0
var latestStrref = StrRef 0

# Strings we skipped. We track them so we don't log them twice.
var skippedTranslations: CritBitTree[void]

proc trackSkipped(str: string): void =
  let strl = str.toLowerAscii
  if not skippedTranslations.contains(strl):
    skippedTranslations.incl(strl)
    info "Skipping string: ", str

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

      # No entries here. Nothing to do.
      if exolocstr.entries.len == 0:
        continue

      var textsToIgnore = newSeq[string]()
      # Don't translate fields that are just repeats of tags or resrefs.
      if gin.hasField("Tag", GffCExoString): textsToIgnore.add(($gin["Tag", GffCExoString]).toLowerAscii)
      if gin.hasField("TemplateResRef", GffResRef): textsToIgnore.add(($gin["TemplateResRef", GffResRef]).toLowerAscii)
      if gin.hasField("ResRef", GffResRef): textsToIgnore.add(($gin["ResRef", GffResRef]).toLowerAscii)

      # Don't translate strings the user can't see:

      # static/unused placeables
      if gin.hasField("Useable", GffByte) and gin["Useable", GffByte] == 0 or
         gin.hasField("Static", GffByte) and gin["Static", GffByte] == 1:
        continue

      # The user can specify one or more languages. The first language specified
      # is the one the TLK is written as, and where string are taken from.
      # If a string ref has more than one (or the wrong one), the first matching
      # is selected.
      var foundLanguage: Option[Language]

      for q in selectedLanguages:
        if exolocstr.entries.hasKey(q.int):
          foundLanguage = some(q)
          break

      doAssert(foundLanguage.isSome, "none of your selected languages satisfy string: " & $exolocstr)

      let str = exolocstr.entries[foundLanguage.unsafeGet.int]

      if str.len > 0 and not textsToIgnore.contains(str.toLowerAscii):

        # If a string is already translated AND has local strings, we just overwrite the strref.
        # This mirrors game behaviour where a toolset-provided string overrides the tlk entry.
        if StrRef(exolocstr.strRef) != BadStrRef:
          # If the base game has the key, check it's value. If the string is differing, rewrite.
          debug "String has strref AND overrides, dropping strref: ", exolocstr

        let rewriteStrRef = translate(str) + 16777216
        doAssert(rewriteStrRef != BadStrRef, "failed to assign strref")
        exolocstr.entries.clear
        exolocstr.strRef = rewriteStrRef

        assert(val.getValue(GffCExoLocString).strRef == exolocstr.strRef)

      elif str.len > 0:
        trackSkipped(str)

proc tlkify(ein: Erf, outFile: string) =
  writeErf(openFileStream(outFile, fmWrite),
      ein.fileType, dataVersion,
      dataExoComp, dataCompAlg,
      ein.locStrings,
      ein.strRef, toSeq(ein.contents.items)) do (r: ResRef, io: Stream) -> (int, SecureHash):

    let ff = ein.demand(r)
    ff.seek()
    let startPos = io.getPosition()
    var sha1: SecureHash

    let rr = r.resolve().get()
    if GffExtensions.contains(rr.resExt):
      var root = readGffRoot(ff.io)

      if $rr == "module.ifo":
        # hack up tlk entry.
        let existingTlk = root["Mod_CustomTlk", GffCExoString]
        if existingTlk != "":
          doAssert(existingTlk == tlkBaseFn, "Module already has a tlk name of a different name: " & existingTlk)
        else:
          info "module.ifo: Setting TLK to ", tlkBaseFn
          root["Mod_CustomTlk", GffCExoString] = tlkBaseFn

      tlkify(GffStruct root)

      debug "Writing out gff: ", rr
      io.write(root)

    else:
      debug "Writing out non-gff: ", rr
      io.write(ff.readAll())

    let endPos = io.getPosition()

    if dataVersion == ErfVersion.E1:
      io.setPosition(startPos)
      let peek = io.readStrOrErr(endPos - startPos)
      sha1 = secureHash(peek)
      doAssert(io.getPosition() == endPos)

    (endPos - startPos, sha1)

var newTlk: SingleTlk

if fileExists(tlkFn):
  newTlk = readSingleTlk(openFileStream(tlkFn))
  doAssert(newTlk.language == selectedLanguages[0],
    "existing TLK has mismatching language from selected primary " & $selectedLanguages[0])

  latestStrref = StrRef newTlk.highest
  info "Building translations from given tlk: ", latestStrref
  for strref in 0..latestStrref:
    let ent = newTlk[StrRef strref].unsafeGet()
    if ent.text != "":
      translations[ent.text] = StrRef strref
else:
  info "Translations: starting from scratch as language ", selectedLanguages[0]
  newTlk = newSingleTlk()
  newTlk.language = selectedLanguages[0]

info "Reading: ", erfFn
let module = readErf(openFileStream(erfFn))

tlkify(module, outFn)

if newTranslations > 0:
  info "Saving tlk, new translations: ", newTranslations

  for str, strref in translations:
    newTlk[StrRef strref] = str
  writeTlk(openFileStream(tlkFn, fmWrite), newTlk)

else:
  info "erf did not generate new translations, not touching tlk"
