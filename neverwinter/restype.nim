## A ResType is just a 16bit identifier mapping a file type to a human-readable
## extension.
##
## There are a few builtins (all that NWN1 knows about); and if that makes you
## unhappy, you can call the global proc registerResType to add more at runtime.

import tables, strutils, options

import util

type ResType* = distinct uint16

proc `==`*(x, y: ResType): bool {.borrow.}

func makeResTypeTable(): tuple[types: Table[ResType, string], rtypes: Table[string, ResType]] =
  var r = result
  r.types = initTable[ResType, string]()
  r.rtypes = initTable[string, ResType]()
  defer: result = r
  func registerResType(resType: ResType, extension: string) =
    expect(extension.len > 0 and extension.len <= 3)

    if extension.count({'a'..'z', '0'..'9'}) != 3:
      raise newException(ValueError, "ResType '" & extension.escape &
        "' contains invalid characters")

    r.types[resType] = extension.toLowerAscii
    r.rtypes[extension.toLowerAscii] = resType

  # nwn1
  registerResType(ResType 1, "bmp")
  registerResType(ResType 2, "mve")
  registerResType(ResType 3, "tga")
  registerResType(ResType 4, "wav")
  registerResType(ResType 6, "plt")
  registerResType(ResType 7, "ini")
  registerResType(ResType 8, "bmu")
  registerResType(ResType 9, "mpg")
  registerResType(ResType 10, "txt")
  registerResType(ResType 2000, "plh")
  registerResType(ResType 2001, "tex")
  registerResType(ResType 2002, "mdl")
  registerResType(ResType 2003, "thg")
  registerResType(ResType 2005, "fnt")
  registerResType(ResType 2007, "lua")
  registerResType(ResType 2008, "slt")
  registerResType(ResType 2009, "nss")
  registerResType(ResType 2010, "ncs")
  registerResType(ResType 2011, "mod")
  registerResType(ResType 2012, "are")
  registerResType(ResType 2013, "set")
  registerResType(ResType 2014, "ifo")
  registerResType(ResType 2015, "bic")
  registerResType(ResType 2016, "wok")
  registerResType(ResType 2017, "2da")
  registerResType(ResType 2018, "tlk")
  registerResType(ResType 2022, "txi")
  registerResType(ResType 2023, "git")
  registerResType(ResType 2024, "bti")
  registerResType(ResType 2025, "uti")
  registerResType(ResType 2026, "btc")
  registerResType(ResType 2027, "utc")
  registerResType(ResType 2029, "dlg")
  registerResType(ResType 2030, "itp")
  registerResType(ResType 2031, "btt")
  registerResType(ResType 2032, "utt")
  registerResType(ResType 2033, "dds")
  registerResType(ResType 2034, "bts")
  registerResType(ResType 2035, "uts")
  registerResType(ResType 2036, "ltr")
  registerResType(ResType 2037, "gff")
  registerResType(ResType 2038, "fac")
  registerResType(ResType 2039, "bte")
  registerResType(ResType 2040, "ute")
  registerResType(ResType 2041, "btd")
  registerResType(ResType 2042, "utd")
  registerResType(ResType 2043, "btp")
  registerResType(ResType 2044, "utp")
  registerResType(ResType 2045, "dft")
  registerResType(ResType 2046, "gic")
  registerResType(ResType 2047, "gui")
  registerResType(ResType 2048, "css")
  registerResType(ResType 2049, "ccs")
  registerResType(ResType 2050, "btm")
  registerResType(ResType 2051, "utm")
  registerResType(ResType 2052, "dwk")
  registerResType(ResType 2053, "pwk")
  registerResType(ResType 2054, "btg")
  registerResType(ResType 2055, "utg")
  registerResType(ResType 2056, "jrl")
  registerResType(ResType 2057, "sav")
  registerResType(ResType 2058, "utw")
  registerResType(ResType 2059, "4pc")
  registerResType(ResType 2060, "ssf")
  registerResType(ResType 2061, "hak")
  registerResType(ResType 2062, "nwm")
  registerResType(ResType 2063, "bik")
  registerResType(ResType 2064, "ndb")
  registerResType(ResType 2065, "ptm")
  registerResType(ResType 2066, "ptt")
  registerResType(ResType 2067, "bak")
  registerResType(ResType 2068, "dat")
  registerResType(ResType 2069, "shd")
  registerResType(ResType 2070, "xbc")
  registerResType(ResType 2071, "wbm")
  registerResType(ResType 2072, "mtr")
  registerResType(ResType 2073, "ktx")
  registerResType(ResType 2074, "ttf")
  registerResType(ResType 2075, "sql")
  registerResType(ResType 2076, "tml")
  registerResType(ResType 2077, "sq3")
  registerResType(ResType 2078, "lod")
  registerResType(ResType 2079, "gif")
  registerResType(ResType 2080, "png")
  registerResType(ResType 2081, "jpg")
  registerResType(ResType 2082, "caf")
  registerResType(ResType 2083, "jui")
  registerResType(ResType 9996, "ids")
  registerResType(ResType 9997, "erf")
  registerResType(ResType 9998, "bif")
  registerResType(ResType 9999, "key")

var resTypesInit {.threadvar.}: bool
var types  {.threadvar.}: Table[ResType, string]
var rtypes {.threadvar.}: Table[string, ResType]

proc initResTypes() =
  if resTypesInit: return
  resTypesInit = true
  types = makeResTypeTable().types
  rtypes = makeResTypeTable().rtypes

# NB: needs to be called per-thread
proc registerCustomResType*(ty: ResType, ext: string) =
  initResTypes()
  types[ty] = ext
  rtypes[ext] = ty

proc resTypeRegistered*(resType: ResType): bool =
  initResTypes()
  types.hasKey(resType)

proc resExtRegistered*(resExt: string): bool =
  initResTypes()
  rtypes.hasKey(resExt)

proc lookupResType*(extension: string): Option[ResType] =
  initResTypes()
  if rtypes.hasKey(extension.toLowerAscii):
    result = some(rtypes[extension.toLowerAscii])

proc lookupResExt*(resType: ResType): Option[string] =
  initResTypes()
  if types.hasKey(resType):
    result = some(types[resType])

proc getResType*(extension: string): ResType =
  lookupResType(extension).get()

proc getResExt*(resType: ResType): string =
  lookupResExt(resType).get()

proc `$`*(r: ResType): string =
  let ext = lookupResExt(r)
  if ext.isSome: ext.get()
  else: $r.int
