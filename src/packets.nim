import arpie, hashes

type
  # Protocol {.pure.} = enum IPX = 'I', UDP = 'U'

  BNES* = object
    header: StaticValue["BNES"]
    port: uint16
    enumType: uint8

  BNER* = object
    header: StaticValue["BNER"]
    protocol: uint8
    port: uint16
    enumType: uint8
    sessionName: SizePrefixedString[uint8]

  BNLM* = object
    header: StaticValue["BNLM"]
    port: uint16
    messageNo: uint8
    sessionId: uint32

  BNLR* = object
    header: StaticValue["BNLR"]
    port: uint16
    messageNo: uint8
    sessionId: uint32

  BNXI* = object
    header: StaticValue["BNXI"]
    port: uint16

  # PvPMode {.pure.} = enum
  #   None = 0u8
  #   Party = 1u8
  #   Full = 2u8
  #   Default = 3u8

  BNXR* = object
    header: StaticValue["BNXR"]
    port: uint16
    bnxiVersionNumber: uint8
    hasPassword: uint8
    minLevel: uint8
    maxLevel: uint8
    currentPlayers: uint8
    maxPlayers: uint8
    vaultMode: uint8
    pvp: uint8
    playerPause: uint8
    oneParty: uint8
    elc: uint8
    ilr: uint8
    xp: uint8
    moduleName: SizePrefixedString[uint8]

  BNDS* = object
    header: StaticValue["BNDS"]
    port: uint16

  BNDR* = object
    header: StaticValue["BNDR"]
    port: uint16
    serverDescription: SizePrefixedString[uint32]
    moduleDescription: SizePrefixedString[uint32]
    serverVersion: SizePrefixedString[uint32]
    gameType: uint16

  BMST* = object
    header: StaticValue["BMST"]
    port: uint16

  BMSR* = object
    header: StaticValue["BMSR"]
    status: int16

  BMSU* = object
    header: StaticValue["BMSU"]
    hostType: uint8
    gameType: uint8
    build: uint32
    postGame: uint8
    languageId: uint8
    gameId: uint8

  BMHB* = object
    header: StaticValue["BMHB"]
    port: uint16

  BMDC* = object
    header: StaticValue["BMDC"]
    playerCount: int16
    # keys

  BMSA* = object
    header: StaticValue["BMSA"]
    port: uint16

  SLocation* = object
    ipv4: uint32
    port: uint16

  BMSB* = object
    header: StaticValue["BMSB"]
    addresses: SizePrefixedSeq[uint16, SLocation]

  BMMA* = object
    header: StaticValue["BMMA"]
    port: uint16
    languageId: uint16

  BMMB* = object
    header: StaticValue["BMMB"]
    motd: SizePrefixedString[uint16]

  BMRA* = object
    header: StaticValue["BMRA"]
    port: uint16
    languageId: uint16

  BMRB* = object
    header: StaticValue["BMRB"]
    version: SizePrefixedString[uint16]

proc int2ip*(ip: uint32): string =
  $(ip shr 24).uint8 & "." & $(ip shr 16 and 0xff).uint8 & "." &
    $(ip shr 8 and 0xff).uint8 & "." & $(ip and 0xff).uint8

proc hash*(t: SLocation): Hash = hash(0) !& hash(t.ipv4) !& hash(t.port)

proc `ipv4s`*(p: SLocation): string =
  p.ipv4.int2ip

proc `$`*(p: SLocation): string =
  int2ip(p.ipv4) & ":" & $p.port