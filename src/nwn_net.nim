import arpie, net, strutils, sequtils, os, jser, docopt, times
import net, asyncnetudp, asyncdispatch, netutil, nativesockets
import shared

let args = DOC """
Generic NWN1 game server query tool.

<server> can be a hostname, a ip, or a host/ip:port tuple.  The BN*
packets are meant to go to game servers; the BM* packets are for
masterserver communication, so target them at a masterserver!

Usage:
  $0 [options] <server> bnes
  $0 [options] <server> bnds
  $0 [options] <server> bnxi
  $0 [options] <server> bnlm
  $0 [options] <server> bmst
  $0 [options] <server> bmma
  $0 [options] <server> bmra
  $0 [options] <server> bsst
  $USAGE

Options:
  -t, --timeout=TIMEOUT   Global timeout [default: 5000]
  -a, --laddr=PORT        Local address to bind to [default: 0.0.0.0]
  $OPT
"""

include packets

let timeout = parseInt($args["--timeout"])

let laddr = $args["--laddr"]
let queryPair = ($args["<server>"]).split(":", 2)
let queryHost = queryPair[0]
let queryPort = (if queryPair.len > 1: queryPair[1].parseInt else: 5121).Port

proc ask[T, R](p: T, qh: string = "", qp: Port = 0.Port): Future[JsonNode] {.async.} =
  let socket = newAsyncSocket(sockType=SOCK_DGRAM, protocol=IPPROTO_UDP, buffered=false)
  socket.bindAddr(0.Port, laddr)
  # Wrap wrap timeout socket wrappedy wrap.
  var p2 = p
  when compiles(p2.port):
    p2.port = socket.getFd().getLocalAddr(AF_INET)[1].uint16
  result = await askJson[T, R](socket, if qh == "": queryHost else: qh,
    if qp == 0.Port: queryPort else: qp, p2, timeout)

proc getServerDetails*(host: string, port: Port, bnes, bnxi, bnds: bool): Future[JsonNode] {.async.} =
  var bnesfut: Future[JsonNode]
  var bnxifut: Future[JsonNode]
  var bndsfut: Future[JsonNode]
  if bnes: bnesfut = ask[BNES, BNER](BNES(), host, port)
  if bnxi: bnxifut = ask[BNXI, BNXR](BNXI(), host, port)
  if bnds: bndsfut = ask[BNDS, BNDR](BNDS(), host, port)

  var futsToRead = newSeq[Future[JsonNode]]()
  if bnes: futsToRead.add(bnesfut)
  if bnxi: futsToRead.add(bnxifut)
  if bnds: futsToRead.add(bndsfut)

  discard await all(futsToRead)

  result = newJObject()
  if bnes: result["_bner"] = bnesfut.read
  if bnxi: result["_bnxr"] = bnxifut.read
  if bnds: result["_bndr"] = bndsfut.read

proc runner*() {.async.} =
  var response: JSONNode

  if args["bmst"]:
    response = await ask[BMST, BMSR](BMST())

  elif args["bmma"]:
    response = await ask[BMMA, BMMB](BMMA())

  elif args["bmra"]:
    response = await ask[BMRA, BMRB](BMRA())

  elif args["bnes"]:
    response = await ask[BNES, BNER](BNES())

  elif args["bnxi"]:
    response = await ask[BNXI, BNXR](BNXI())

  elif args["bnds"]:
    response = await ask[BNDS, BNDR](BNDS())

  elif args["bnlm"]:
    response = await ask[BNLM, BNLR](BNLM(messageNo: 3, sessionId: 90))

  elif args["bsst"]:
    response = await ask[BSST, BSSR](BSST())

  else: quit("wat")

  echo response.pretty

waitFor runner()
