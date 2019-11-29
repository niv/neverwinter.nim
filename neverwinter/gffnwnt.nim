# custom grep language NeverWinterNightsText (nwnt) support for gff reading/writing

import tables, strutils, streams, parseutils
import gff, util, languages

proc manageEscapesToText(str: string): string =
  result = str.multiReplace([("\n","\\n"),("\r","\\r")])

proc manageEscapesToGff(str: string): string =
  result = str.multiReplace([("\\n","\n"),("\\r","\r")])

proc nwntFromGffStruct*(s: GffStruct, namePrefix: string = "", nameDepth: int = 0): seq[array[3, string]] =
  ##Transforms the given GFFStruct into a sequence of nwnt
  if s of GffRoot:
    result.add(["data_type", "", $s.GffRoot.fileType])

  for lable, gffValue in pairs(s.fields):

    let
      name = namePrefix & lable
      kind = '$' & $gffValue.fieldKind
    var
      value: string
      fieldHandled: bool

    case gffValue.fieldKind:
    of GffFieldKind.Byte: value = $gffValue.getValue(GffByte).int
    of GffFieldKind.Char: value = $gffValue.getValue(GffChar).int
    of GffFieldKind.Word: value = $gffValue.getValue(GffWord).int
    of GffFieldKind.Short: value = $gffValue.getValue(GffShort).int
    of GffFieldKind.Dword: value = $gffValue.getValue(GffDword).int
    of GffFieldKind.Int: value = $gffValue.getValue(GffInt).int
    of GffFieldKind.Float: value = $gffValue.getValue(GffFloat).float
    of GffFieldKind.Dword64: value = $gffValue.getValue(GffDword64).int64
    of GffFieldKind.Int64: value = $gffValue.getValue(GffInt64).int64
    of GffFieldKind.Double: value = $gffValue.getValue(GffDouble).float64
    of GffFieldKind.CExoString: value = $gffValue.getValue(GffCExoString)
    of GffFieldKind.ResRef: value = $gffValue.getValue(GffResRef).string
    of GffFieldKind.Void: value = $gffValue.getValue(GffVoid).string
    of GffFieldKind.CExoLocString:
      let id = gffValue.getValue(GffCExoLocString).strRef
      if id != BadStrRef: value = $id
      else: value = "-1"
      result.add([name, kind, value])
      let prefix = namePrefix & "-" #CExoLocString Prefix
      for subLable, subValue in pairs(gffValue.getValue(GffCExoLocString).entries):
        value = subValue
        result.add([prefix, $subLable, value])
      fieldHandled = true

    of GffFieldKind.Struct:
      let struct = gffValue.getValue(GffStruct)
      result.add([name, kind, $struct.id])
      let prefix = namePrefix & "+" #Struct Prefix
      let breakdown = nwntFromGffStruct(struct, prefix)
      result.add(breakdown)
      fieldHandled = true

    of GffFieldKind.List:
      #var listCounter = 0
      for i, elem in gffValue.getValue(GffList):
        result.add([name & '[' & $i & ']', kind, $elem.id])
        let prefix = namePrefix & ">" #List Prefix
        let breakdown = nwntFromGffStruct(elem, prefix)
        result.add(breakdown)
      fieldHandled = true

    if fieldHandled == false: result.add([name, kind, value])

proc toNwnt*(file: FileStream, s: GffStruct) =
  ##Passes GFFStruct to receive seq of nwnt, then processes for lines
  let nwnt = nwntFromGffStruct(s)

  for line in nwnt:
    file.write(line[0] & line[1] & " = " & manageEscapesToText(line[2]) & "\c\L")

proc gffStructFromNwnt*(file: FileStream, result: GffStruct, namePrefix: char = '\0', nameDepth: int = -1) =
  var line: string
  var pos: int
  while(true):
    pos = getPosition(file)
    if not file.readLine(line):
      return

    let
      valSplit = line.split('=', 1)
      value = valSplit[1][1..^1]
      nameKindSplit = valSplit[0].split('$', 1)

    if nameDepth != -1:
      if nameKindSplit[0][nameDepth] != namePrefix:
        setPosition(file, pos)
        return

    let
      name = nameKindSplit[0][nameDepth+1..^1]
      kind = toLowerAscii(nameKindSplit[1][0..^2])

    case kind:
    of "byte": result[name, GffByte] = parseInt(value).GffByte
    of "char": result[name, GffChar] = parseInt(value).GffChar
    of "word": result[name, GffWord] = parseInt(value).GffWord
    of "short": result[name, GffShort] = parseInt(value).GffShort
    of "dword": result[name, GffDword] = parseInt(value).GffDword
    of "int": result[name, GffInt] = parseInt(value).GffInt
    of "float": result[name, GffFloat] = parseFloat(value).GffFloat
    of "dword64": result[name, GffDword64] = parseBiggestInt(value).GffDword64
    of "int64": result[name, GffInt64] = parseBiggestInt(value).GffInt64
    of "double":
      var f64: float64
      discard value.parseBiggestFloat(f64)
      result[name, GffDouble] = f64.GffDouble
    of "cexostring": result[name, GffCExoString] = manageEscapesToGff(value).GffCExoString
    of "resref": result[name, GffResRef] = value.GffResRef
    of "void": result[name, GffVoid] = value.GffVoid
    of "cexolocstring":
      let exo = newCExoLocString()
      if value != "-1":
        exo.strRef = parseBiggestInt(value).StrRef
      while(true):
        pos = getPosition(file)
        if not file.readLine(line):
          break

        let
          subSplit = line.split('=', 1)
          subValue = subSplit[1][1..^1]
          subLable = subSplit[0][nameDepth+2..^2]


        if subSplit[0][nameDepth+1] != '-':
          setPosition(file, pos)
          break

        exo.entries[parseInt(subLable)] = manageEscapesToGff(subValue)

      result[name, GffCExoLocString] = exo
    of "struct":
      let st = newGffStruct()
      st.id = parseInt(value).int32
      gffStructFromNwnt(file, st, '+', nameDepth + 1)
      result[name, GffStruct] = st
    of "list":
      var
        list = newGffList()
        listStructID = parseInt(value).int32
      let
        listNameLen = name.len - 3

      while(true):
        let st = newGffStruct()
        st.id = listStructID
        gffStructFromNwnt(file, st, '>', nameDepth + 1)
        list.add(st)

        pos = getPosition(file)
        if not file.readLine(line):
          break

        let listTest = line.split('$', 1)

        if listTest[0].len - (nameDepth + 1) < name.len or
        listTest[0][nameDepth+1..(nameDepth + listNameLen)] != name[0..^4]:
          setPosition(file, pos)
          break

        let
          newListIDSplit = line.split('=', 1)
          newListID = newListIDSplit[1][1..^1]
        listStructID = parseInt(newListID).int32

      result[name[0..^4], GffList] = list
    else: raise newException(ValueError, "unknown field type " & kind)


proc gffRootFromNwnt*(file: FileStream): GffRoot =
  ## Attempts to read a GffRoot from nwnt file. Will raise ValueError on any issues.
  result = newGffRoot()
  let dataType = readline(file).split('=', 1)
  expect(dataType[0] == "data_type ")
  result.fileType = dataType[1][1..3] & ' '

  file.gffStructFromNwnt(result)