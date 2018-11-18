import yamlsorteddom, yaml/serialization, yaml/presenter
import streams, tables, strutils, options, parseutils

proc toDom(v: GffField): YamlNode
proc toDom(s: GffStruct): YamlNode

const typeMap = {
  GffFieldKind.Byte: "byte",
  GffFieldKind.Char: "char",
  GffFieldKind.Word: "word",
  GffFieldKind.Short: "short",
  GffFieldKind.Dword: "dword",
  GffFieldKind.Int: "int",
  GffFieldKind.Float: "float",
  GffFieldKind.Dword64: "dword64",
  GffFieldKind.Int64: "int64",
  GffFieldKind.Double: "double",
  GffFieldKind.CExoString: "cexostr",
  GffFieldKind.ResRef: "resref",
  GffFieldKind.Void: "void",
  GffFieldKind.Struct: "struct",
  GffFieldKind.List: "list",
  GffFieldKind.CExoLocString: "cexolocstr"
}.toTable

proc lookupType(str: string): Option[GffFieldKind] =
  for k, v in typeMap:
    if v == str: return some(k)
  none(GffFieldKind)

proc toDom(v: GffField): YamlNode =
  result = YamlNode(kind: yMapping, fields: newOrderedTable[YamlNode, YamlNode](), tag: "?")
  result[newYamlNode "type"] = newYamlNode(typeMap[v.fieldKind])

  result[newYamlNode "value"] = case v.fieldKind:
  of GffFieldKind.Byte      : newYamlNode($v.getValue(GffByte).int)
  of GffFieldKind.Char      : newYamlNode($v.getValue(GffChar).int)
  of GffFieldKind.Word      : newYamlNode($v.getValue(GffWord).int)
  of GffFieldKind.Short     : newYamlNode($v.getValue(GffShort).int)
  of GffFieldKind.Dword     : newYamlNode($v.getValue(GffDword).int)
  of GffFieldKind.Int       : newYamlNode($v.getValue(GffInt).int)
  of GffFieldKind.Float     : newYamlNode($v.getValue(GffFloat).float)
  of GffFieldKind.Dword64   : newYamlNode($v.getValue(GffDword64).int64)
  of GffFieldKind.Int64     : newYamlNode($v.getValue(GffInt64).int64)
  of GffFieldKind.Double    : newYamlNode($v.getValue(GffDouble).float64)
  of GffFieldKind.CExoString: newYamlNode($v.getValue(GffCExoString))
  of GffFieldKind.ResRef    : newYamlNode($v.getValue(GffResRef).string)
  of GffFieldKind.Void      : newYamlNode($v.getValue(GffVoid).string)
  of GffFieldKind.Struct    : toDom(v.getValue(GffStruct))
  of GffFieldKind.List      : newYamlNode(v.getValue(GffList).mapIt(toDom(it)))
  of GffFieldKind.CExoLocString:
    let id = v.getValue(GffCExoLocString).strRef
    if id != -1: result[newYamlNode("id")] = newYamlNode($id)
    let f = newOrderedTable[YamlNode, YamlNode]()
    for k, v in v.getValue(GffCExoLocString).entries:
      if v.len > 0: f[newYamlNode($k)] = newYamlNode v
    YamlNode(kind: yMapping, fields: f, tag: "?")

proc toDom(s: GffStruct): YamlNode =
  var elems = newOrderedTable[YamlNode, YamlNode]()

  if s of GffRoot: elems[newYamlNode "__data_type"] = newYamlNode(s.GffRoot.fileType)
  if s.id != -1: elems[newYamlNode "__struct_id"] = newYamlNode($s.id)

  let sortedPairs = sorted(toSeq(pairs(s.fields))) do (a, b: auto) -> int: system.cmp[string](a[0], b[0])

  for pa in sortedPairs: elems[newYamlNode(pa[0])] = toDom(pa[1])
  result = YamlNode(kind: yMapping, fields: elems, tag: "?")

proc gffStructFromDom(dom: YamlNode, into: GffStruct) =
  expect(dom.kind == yMapping)
  for k, v in dom.fields:
    let lb = k.content

    if lb == "__struct_id": into.id = cast[int32](v.content.parseBiggestInt)
    if into of GffRoot and lb == "__data_type": into.GffRoot.fileType = v.content
    if lb.startsWith("__"): continue

    let ty = lookupType(v["type"].content)
    expect(ty.isSome)
    case ty.unsafeGet():

    of GffFieldKind.Byte         : into[lb, GffByte] = v["value"].content.parseUInt.GffByte
    of GffFieldKind.Char         : into[lb, GffChar] = v["value"].content.parseInt.GffChar
    of GffFieldKind.Word         : into[lb, GffWord] = v["value"].content.parseUInt.GffWord
    of GffFieldKind.Short        : into[lb, GffShort] = v["value"].content.parseInt.GffShort
    of GffFieldKind.Dword        : into[lb, GffDword] = v["value"].content.parseUInt.GffDword
    of GffFieldKind.Int          : into[lb, GffInt] = v["value"].content.parseInt.GffInt
    of GffFieldKind.Float        : into[lb, GffFloat] = v["value"].content.parseFloat.GffFloat

    of GffFieldKind.Dword64      : into[lb, GffDword64] = v["value"].content.parseBiggestUInt.GffDword64
    of GffFieldKind.Int64        : into[lb, GffInt64] = v["value"].content.parseBiggestInt.GffInt64
    of GffFieldKind.Double       :
      var bf: BiggestFloat
      let r = parseBiggestFloat(v["value"].content, bf)
      doAssert(r > 0)
      into[lb, GffDouble] = cast[float64](bf)

    of GffFieldKind.CExoString   : into[lb, GffCExoString] = v["value"].content.GffCExoString
    of GffFieldKind.ResRef       : into[lb, GffResRef] = v["value"].content.GffResRef
    of GffFieldKind.Void         : into[lb, GffVoid] = v["value"].content.GffVoid

    of GffFieldKind.List         :
      let va = v["value"].elems
      var os = newSeq[GffStruct](va.len)
      for i, e in va:
        os[i] = newGffStruct()
        gffStructFromDom(e, os[i])
      into[lb, GffList] = os

    of GffFieldKind.Struct       :
      var st = newGffStruct()
      gffStructFromDom(v["value"], st)
      into[lb, GffStruct] = st

    of GffFieldKind.CExoLocString:
      let st = newCExoLocString()
      if v.fields.hasKey(newYamlNode "id"):
        st.strref = v["id"].content.parseInt
      if v["value"].kind == yMapping:
        let f = v["value"].fields
        for k, v in f:
          st.entries[k.content.parseInt] = v.content
      into[lb, GffCExoLocString] = st

proc writeYAML*(io: Stream, s: GffStruct): void =
  dumpDom(initYamlDoc(toDom(s)), io)

proc gffRootFromYAML*(io: Stream): GffRoot =
  let doc = loadDom(io)
  result = newGffRoot()
  gffStructFromDom(doc.root, result)
