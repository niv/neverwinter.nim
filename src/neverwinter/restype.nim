import tables, strutils, options

import util

type
  ResType* = uint16

var types  = initTable[ResType, string]()
var rtypes = initTable[string, ResType]()

proc resTypeRegistered*(resType: ResType): bool = types.hasKey(resType)
proc resExtRegistered*(resExt: string): bool = rtypes.hasKey(resExt)

proc registerResType*(resType: ResType, extension: string) =
  expect(extension.len > 0) #  and extension.len <= 3)

  types[resType] = extension.toLowerAscii
  rtypes[extension.toLowerAscii] = resType

proc lookupResType*(extension: string): Option[ResType] =
  if rtypes.hasKey(extension.toLowerAscii):
    result = some(rtypes[extension.toLowerAscii])

proc lookupResExt*(resType: ResType): Option[string] =
  if types.hasKey(resType):
    result = some(types[resType])

proc `$`*(r: ResType): string =
  proc IntToStr(x: int): string {.magic: "IntToStr", noSideEffect.}
  let ext = lookupResExt(r)
  if ext.isSome: ext.get()
  else: $r.int

# nwn1
registerResType(1, "bmp");
registerResType(2, "mve");
registerResType(3, "tga");
registerResType(4, "wav");
registerResType(6, "plt");
registerResType(7, "ini");
registerResType(8, "bmu");
registerResType(9, "mpg");
registerResType(10, "txt");
registerResType(2000, "plh");
registerResType(2001, "tex");
registerResType(2002, "mdl");
registerResType(2003, "thg");
registerResType(2005, "fnt");
registerResType(2007, "lua");
registerResType(2008, "slt");
registerResType(2009, "nss");
registerResType(2010, "ncs");
registerResType(2011, "mod");
registerResType(2012, "are");
registerResType(2013, "set");
registerResType(2014, "ifo");
registerResType(2015, "bic");
registerResType(2016, "wok");
registerResType(2017, "2da");
registerResType(2018, "tlk");
registerResType(2022, "txi");
registerResType(2023, "git");
registerResType(2024, "bti");
registerResType(2025, "uti");
registerResType(2026, "btc");
registerResType(2027, "utc");
registerResType(2029, "dlg");
registerResType(2030, "itp");
registerResType(2031, "btt");
registerResType(2032, "utt");
registerResType(2033, "dds");
registerResType(2034, "bts");
registerResType(2035, "uts");
registerResType(2036, "ltr");
registerResType(2037, "gff");
registerResType(2038, "fac");
registerResType(2039, "bte");
registerResType(2040, "ute");
registerResType(2041, "btd");
registerResType(2042, "utd");
registerResType(2043, "btp");
registerResType(2044, "utp");
registerResType(2045, "dft");
registerResType(2046, "gic");
registerResType(2047, "gui");
registerResType(2048, "css");
registerResType(2049, "ccs");
registerResType(2050, "btm");
registerResType(2051, "utm");
registerResType(2052, "dwk");
registerResType(2053, "pwk");
registerResType(2054, "btg");
registerResType(2055, "utg");
registerResType(2056, "jrl");
registerResType(2057, "sav");
registerResType(2058, "utw");
registerResType(2059, "4pc");
registerResType(2060, "ssf");
registerResType(2061, "hak");
registerResType(2062, "nwm");
registerResType(2063, "bik");
registerResType(2064, "ndb");
registerResType(2065, "ptm");
registerResType(2066, "ptt");
registerResType(2067, "bak");
registerResType(2068, "dat");
registerResType(2069, "shd");
registerResType(2070, "xbc");
registerResType(9997, "erf");
registerResType(9998, "bif");
registerResType(9999, "key");
