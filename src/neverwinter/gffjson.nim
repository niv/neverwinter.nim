# json support for gff reading/writing

import json, tables, strutils

import gff, util

proc toJson*(s: GffStruct): JSONNode =
  ## Transforms the given GffStruct into a JSONNode.

  result = newJObject()
  if s.id != -1: result["__struct_id"] = %s.id
  if s of GffRoot: result["__data_type"] = %s.GffRoot.fileType

  for k, v in pairs(s.fields):
    result[k] = newJObject()  # the outer container

    let s: string = $v.fieldKind
    result[k]["type"] = %s.toLowerAscii

    case v.fieldKind:
    of GffFieldKind.Byte: result[k]["value"] = %v.getValue(GffByte).int
    of GffFieldKind.Char: result[k]["value"] = %v.getValue(GffChar).int
    of GffFieldKind.Word: result[k]["value"] = %v.getValue(GffWord).int
    of GffFieldKind.Short: result[k]["value"] = %v.getValue(GffShort).int
    of GffFieldKind.Dword: result[k]["value"] = %v.getValue(GffDword).int
    of GffFieldKind.Int: result[k]["value"] = %v.getValue(GffInt).int
    of GffFieldKind.Float: result[k]["value"] = %v.getValue(GffFloat).float
    of GffFieldKind.Dword64: result[k]["value"] = %v.getValue(GffDword64).int64
    of GffFieldKind.Int64: result[k]["value"] = %v.getValue(GffInt64).int64
    of GffFieldKind.Double: result[k]["value"] = %v.getValue(GffDouble).float64
    of GffFieldKind.CExoString: result[k]["value"] = %v.getValue(GffCExoString)
    of GffFieldKind.CExoLocString:
      let entries = newJObject()
      for kk, vv in pairs(v.getValue(GffCExoLocString).entries): entries[$kk] = %vv
      let id = v.getValue(GffCExoLocString).strRef
      if id != -1: result[k]["id"] = %id
      result[k]["value"] = entries

    of GffFieldKind.ResRef: result[k]["value"] = %v.getValue(GffResRef).string
    of GffFieldKind.Void: result[k]["value"] = %v.getValue(GffVoid).string

    of GffFieldKind.Struct:
      let s = v.getValue(GffStruct)
      result[k]["value"] = toJSON(s)
      result[k]["__struct_id"] = %s.id
    of GffFieldKind.List:
      result[k]["value"] = newJArray()
      for elem in v.getValue(GffList): result[k]["value"].add(elem.toJSON())

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
      expect(v["value"].kind == JFloat, $v)
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
      expect(v["value"].kind == JString, $v)
      result[k, GffVoid] = v["value"].str.GffVoid

    of "struct":
      expect(v["value"].kind == JObject, $v)
      let st = newGffStruct()
      gffStructFromJson(v["value"], st)
      result[k, GffStruct] = st

    of "cexolocstring":
      expect(v["value"].kind == JObject, $v)
      let exo = newCExoLocString()
      for kk, vv in pairs(v["value"].getFields):
        exo.entries[kk.parseInt] = vv.str
      result[k, GffCExoLocString] = exo
      if v.hasKey("id"):
        exo.strRef = v["id"].getInt.GffInt

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