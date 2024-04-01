import std/[tables, strutils]

type
  StrRef* = uint32

const
  BadStrRef* = high(StrRef)

type
  Language* {.pure.} = enum
    English = 0
    French = 1
    German = 2
    Italian = 3
    Spanish = 4
    Polish = 5

    # Not supported on EE:
    #Korean = 128
    #ChineseTraditional = 129
    #ChineseSimplified = 130
    #Japanese = 131

  Gender* {.pure.} = enum
    Male,
    Female

var
  LanguageShortCodes = initTable[string, Language]()
LanguageShortCodes["en"] = Language.English
LanguageShortCodes["fr"] = Language.French
LanguageShortCodes["de"] = Language.German
LanguageShortCodes["it"] = Language.Italian
LanguageShortCodes["es"] = Language.Spanish
LanguageShortCodes["pl"] = Language.Polish

proc resolveLanguage*(slang: string): Language =
  ## Resolves a language string of the following format:
  ##  - full text ("English")
  ##  - short code ("en")
  ##  - ID ("0")
  ## Raises ValueError if language does not exist.
  try:
    if slang.count({'0'..'9'}) == slang.len:
      let id = slang.parseInt
      result = id.Language
    elif slang.len == 2:
      if not LanguageShortCodes.hasKey(slang): raise newException(ValueError, "no such shortcode")
      result = LanguageShortCodes[slang]
    else:
      result = parseEnum[Language](slang)
  except:
    raise newException(ValueError, slang & ": Not a valid language (" & getCurrentExceptionMsg() & ")")
