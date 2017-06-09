import json

## A module to easily de/serialize json data into/from native types, like tuples,
## seqs, or single variables.
##
## Usage
## -----
##
## .. code-block::nim
##   import jser
##
##   let t: tuple[x: string, y: float]
##   let myjson = parseJson("{x: \"test\", y: 1.2}")
##
##   t.fromJson(myjson)
##   echo t.toJson
##
## There is experimental support for iso8601-style timestamps. To use, simply
##
## .. code-block::nim
##   import jser/iso8601
##
## You can easily support arbitary custom types by implementing the respectively-
## typed to/fromJson procs. You need to handle all possible flags correctly.
##
## Error Handling
## --------------
##
## All serializing errors are supposed to be compiler errors. toJson should never
## throw any exceptions by itself.
##
## All deserializing errors should be robust (meaning, you can just throw user
## input against it without fear of unintended side effects/exploits). All
## conversion errors will raise a DeserializeError with a hopefully useful message,
## which should be okay to pass on to the user.
##
## If fromJson raises any errors, you are not supposed to rely on the state of
## the target variable you are parsing into - it is in a undefined state at that
## point.

export json

type
  DeserializeError* = object of Exception ## \
  ## Raised when something prevents json from being deserialized into a tuple.
  ## Your tuple might be in a undefined state at that point.

  DeserializerFlags* {.pure.} = enum ## \
    ## Possible flags to pass in to the deserializer.


    ErrorWhenMissing, ## Require all fields of the tuple.

    # Autocast types where possible, allows for gentler
    # deserialisation. Default is to error when types
    # cannot be converted directly.
    # TODO: LooseCasting

  SerializerFlags* {.pure.} = enum
    # Fail when encoutering nil
    # TODO: ForbidNil,

    SkipNil, ## Don't emit nil fields. (seqs and tuples only)

    # Transform nil fields into their json defaults
    # when nil. This means that strings will be ""
    # instead of null. Mutually exclusive with SkipNil
    # TODO: DefaultNil

const
  ## The default settings are strict parsing and generating,
  ## meaning all fields need to be filled.
  DefaultDeserializerFlags* = {
    DeserializerFlags.ErrorWhenMissing
  }

  DefaultSerializerFlags*: set[SerializerFlags] = {
    SerializerFlags.SkipNil
  }

import sequtils

type
  IntType =
    uint | int | int8 | int16 | int32 | int64 |
    uint8 | uint16 | uint32 | uint64 | BiggestInt

  FloatType = float | float32 | float64

  Nilable = seq|ref|string|ptr|pointer|cstring


# support for all native json types included by default

# bool

proc toJson*[T: bool](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = %t

proc fromJson*[T: bool](t: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JBool: raise newException(DeserializeError, $j & " not bool")
  t = j.getBVal

# string

proc toJson*[T: string](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = %t

proc fromJson*[T: string](t: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JString: raise newException(DeserializeError, $j & " not string")
  t = j.getStr

# integer

proc toJson*[T: IntType](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = newJInt(t.BiggestInt)

proc fromJson*[T: IntType](t: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JInt: raise newException(DeserializeError, $j & " not integer")
  t = cast[T](j.getNum)

# float

proc toJson*[T: FloatType](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = %t

proc fromJson*[T: FloatType](t: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JFloat: raise newException(DeserializeError, $j & " not floating point")
  t = j.getFNum

# enum

proc toJson*[T: enum](t: T, flags = DefaultSerializerFlags): JsonNode =
  newJInt(t.int)

proc fromJson*[T: enum](t: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JInt: raise newException(DeserializeError, $j & " not int (enumeration)")
  t = cast[T](j.getNum)

# tuple

proc toJson*[T: (tuple|object)](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = newJObject()
  for k, v in fieldPairs(t):
    # don't bother serialising fields we have no serialiser for
    when compiles(toJson(v, flags)):
      when compiles(isNil(v)):
        if not (SerializerFlags.SkipNil in flags and isNil(v)):
          let serialised = toJson(v, flags)
          if serialised != nil: result[k] = serialised
      else:
        let serialised = toJson(v, flags)
        if serialised != nil: result[k] = toJson(v, flags)

proc fromJson*[T: (tuple|object)](v: var T, j: JsonNode, flags = DefaultDeserializerFlags): void =
  try:
    if j.kind != JObject: raise newException(DeserializeError, $j & " not tuple")
    for k, v in fieldPairs(v):
      # hackhack: assign back to tuple
      if j.hasKey(k):
        when compiles(fromJson(v, j[k], flags)):
          fromJson(v, j[k], flags)
        # else:
        #   debugEcho "jser: " & name(T) & ": No deserializer for ", k, " of value ", repr(v)
      elif DeserializerFlags.ErrorWhenMissing in flags:
        raise newException(DeserializeError, "json missing key: " & $k)

  except DeserializeError:
    raise newException(DeserializeError, getCurrentExceptionMsg() & ", while deserializing " & $j)
  return

# seq

proc toJson*[T: seq](t: T, flags = DefaultSerializerFlags): JsonNode =
  result = newJArray()
  for e in t:
    when compiles(toJson(e, flags)):
      when compiles(isNil(e)):
        if not (SerializerFlags.SkipNil in flags and isNil(e)):
          let serialised = toJson(e, flags)
          if serialised != nil: result.add(serialised)
      else:
        let serialised = toJson(e, flags)
        if serialised != nil: result.add(serialised)

proc fromJson*[T](v: var seq[T], j: JsonNode, flags = DefaultDeserializerFlags): void =
  if j.kind != JArray: raise newException(DeserializeError, $j & " not array")
  v = newSeq[T](j.getElems.len)
  for idx, e in j.getElems:
    fromJson(v[idx], e, flags)
