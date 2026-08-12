# json support for gff reading/writing

import std/[json, tables, strutils, base64]

import gff, util, languages

proc toJson*(s: GffStruct): JSONNode =
  ## Transforms the given GffStruct into a JSONNode.

  result = newJObject()
  if s.id != -1: result["__struct_id"] = %s.id
  if s of GffRoot: result["__data_type"] = %s.GffRoot.fileType

  for k, v in pairs(s.fields):
    # Fill the outer container before inserting it, so we hash k only once.
    let field = newJObject()
    field["type"] = %($v.fieldKind).toLowerAscii

    case v.fieldKind:
    of GffFieldKind.Byte: field["value"] = %v.getValue(GffByte)
    of GffFieldKind.Char: field["value"] = %v.getValue(GffChar)
    of GffFieldKind.Word: field["value"] = %v.getValue(GffWord)
    of GffFieldKind.Short: field["value"] = %v.getValue(GffShort)
    of GffFieldKind.Dword: field["value"] = %v.getValue(GffDword)
    of GffFieldKind.Int: field["value"] = %v.getValue(GffInt)
    of GffFieldKind.Float: field["value"] = %v.getValue(GffFloat)
    of GffFieldKind.Dword64: field["value"] = %v.getValue(GffDword64)
    of GffFieldKind.Int64: field["value"] = %v.getValue(GffInt64)
    of GffFieldKind.Double: field["value"] = %v.getValue(GffDouble)
    of GffFieldKind.CExoString: field["value"] = %v.getValue(GffCExoString)
    of GffFieldKind.CExoLocString:
      let entries = newJObject()
      let locStr = v.getValue(GffCExoLocString)
      for kk, vv in pairs(locStr.entries): entries[$kk] = %vv
      let id = locStr.strRef
      if id != BadStrRef:
        # See reader codepath for comment why this lives on entries now.
        entries["id"] = %(int64 id)
      field["value"] = entries

    of GffFieldKind.ResRef: field["value"] = %v.getValue(GffResRef).string
    of GffFieldKind.Void: field["value64"] = %v.getValue(GffVoid).string.encode()

    of GffFieldKind.Struct:
      let s = v.getValue(GffStruct)
      field["value"] = toJSON(s)
      field["__struct_id"] = %s.id
    of GffFieldKind.List:
      let list = newJArray()
      for elem in v.getValue(GffList): list.add(elem.toJSON())
      field["value"] = list

    result[k] = field

proc gffStructFromJson*(j: JSONNode, result: GffStruct) =
  if j.hasKey("__struct_id"):
    expect(j["__struct_id"].kind == JInt)
    result.id = j["__struct_id"].getInt.int32

  for k, v in pairs(j):
    if k.startswith("__"): continue

    case v["type"].str:
    of "byte":
      expect(v["value"].kind == JInt, $v)
      result[k, GffByte] = v["value"].getInt.GffByte
    of "char":
      expect(v["value"].kind == JInt, $v)
      result[k, GffChar] = v["value"].getInt.GffChar
    of "word":
      expect(v["value"].kind == JInt, $v)
      result[k, GffWord] = v["value"].getInt.GffWord
    of "short":
      expect(v["value"].kind == JInt, $v)
      result[k, GffShort] = v["value"].getInt.GffShort
    of "dword":
      expect(v["value"].kind == JInt, $v)
      result[k, GffDword] = v["value"].getInt.GffDword
    of "int":
      expect(v["value"].kind == JInt, $v)
      result[k, GffInt] = v["value"].getInt.GffInt
    of "float":
      expect(v["value"].kind == JFloat or v["value"].kind == JInt, $v)
      result[k, GffFloat] = v["value"].getFloat.GffFloat
    of "dword64":
      expect(v["value"].kind == JInt, $v)
      result[k, GffDword64] = v["value"].getInt.GffDword64
    of "int64":
      expect(v["value"].kind == JInt, $v)
      result[k, GffInt64] = v["value"].getInt.GffInt64
    of "double":
      expect(v["value"].kind == JFloat, $v)
      result[k, GffDouble] = v["value"].getFloat.GffDouble
    of "cexostring":
      expect(v["value"].kind == JString, $v)
      result[k, GffCExoString] = v["value"].str.GffCExoString
    of "resref":
      expect(v["value"].kind == JString, $v)
      result[k, GffResRef] = v["value"].str.GffResRef
    of "void":
      expect((v.hasKey("value64") and v["value64"].kind == JString) or
             (v.hasKey("value") and v["value"].kind == JString), $v)
      let blob = if v.hasKey("value64"):
          v["value64"].str.decode()
        else:
          v["value"].str
      result[k, GffVoid] = blob.GffVoid

    of "struct":
      expect(v["value"].kind == JObject, $v)
      let st = newGffStruct()
      gffStructFromJson(v["value"], st)
      result[k, GffStruct] = st

    of "cexolocstring":
      expect(v["value"].kind == JObject, $v)
      let exo = newCExoLocString()
      for kk, vv in pairs(v["value"].getFields):
        # This used to be one level up (on the locstr struct directly), but the game
        # actually has a mismatch/compat where it put the strref on the value
        # struct. Instead of patching the game and breaking the format there, I'll
        # just make it the new default. The old format can still be read as well.
        if kk == "id":
          expect(vv.kind == JInt, $v)
          exo.strRef = vv.getBiggestInt.StrRef
        else:
          exo.entries[kk.parseInt] = vv.str
      result[k, GffCExoLocString] = exo

      # Legacy codepath: Don't clobber the entries one if both are set.
      if exo.strRef == BadStrRef and v.hasKey("id"):
        expect(v["id"].kind == JInt, $v)
        exo.strRef = v["id"].getBiggestInt.StrRef

    of "list":
      expect(v["value"].kind == JArray, $v)
      var list = newGffList()
      for le in items(v["value"].getElems):
        let st = newGffStruct()
        gffStructFromJson(le, st)
        list.add(st)
      result[k, GffList] = list

    else: raise newException(ValueError, "unknown field type " & $v["type"])

proc gffRootFromJson*(j: JSONNode): GffRoot =
  ## Attempts to read a GffRoot from j. Will raise ValueError on any issues.

  result = newGffRoot()
  gffStructFromJson(j, result)
  expect(j.hasKey("__data_type") and j["__data_type"].kind == JString)
  result.fileType = j["__data_type"].str

  discard
