import arpie, net, strutils, sequtils, os, jser, docopt, times
import net, asyncnetudp, asyncdispatch, netutil
import shared

let args = DOC """
Generic NWN1 game server query tool.

<server> can be a hostname, a ip, or a host/ip:port tuple.  The BN*
packets are meant to go to game servers; the BM* packets are for
masterserver communication, so target them at a masterserver!

"list" isn't actually a network packet; instead it builds a full
json tree of all servers including their metadata.  This will fail
terribly on bad networks thanks to UDP.  If you need this fixed,
let me know.

Usage:
  $0 [options] <server> bnes
  $0 [options] <server> bnds
  $0 [options] <server> bnxi
  $0 [options] <server> bnlm
  $0 [options] <server> bmst
  $0 [options] <server> bmsa
  $0 [options] <server> bmma
  $0 [options] <server> bmra
  $0 [options] <server> list
  $USAGE

Options:
  -l, --lport=PORT        Local port to bind [default: 0]
  -a, --laddr=PORT        Local address to bind to [default: 0.0.0.0]
  -t, --timeout=TIMEOUT   Global timeout [default: 5000]
  $OPT
"""

include packets

let timeout = parseInt($args["--timeout"])
let lport = parseInt($args["--lport"]).uint16
let laddr = $args["--laddr"]
var socket = newAsyncSocket(sockType=SOCK_DGRAM, protocol=IPPROTO_UDP, buffered=false)
socket.bindAddr(lport.Port, laddr)

let queryPair = ($args["<server>"]).split(":", 2)
let queryHost = queryPair[0]
let queryPort = (if queryPair.len > 1: queryPair[1].parseInt else: 5121).Port

proc ask[T, R](p: T, qh: string = "", qp: Port = 0.Port): Future[JsonNode] {.async.} =
  # Wrap wrap timeout socket wrappedy wrap.
  result = await askJson[T, R](socket, if qh == "": queryHost else: qh,
    if qp == 0.Port: queryPort else: qp, p, timeout)

proc runner*() {.async.} =
  var response: JSONNode

  if args["bmst"]:
    response = await ask[BMST, BMSR](BMST(port: lport))

  elif args["bmsa"]:
    response = await ask[BMSA, BMSB](BMSA(port: lport))

  elif args["bmma"]:
    response = await ask[BMMA, BMMB](BMMA(port: lport))

  elif args["bmra"]:
    response = await ask[BMRA, BMRB](BMRA(port: lport))

  elif args["list"]:
    let list = waitFor ask[BMSA, BMSB](BMSA(port: lport))

    let resolvedAddr = list["addresses"].getElems().map() do (loc: JsonNode) -> JsonNode:
      let actualIp = loc["ipv4"].getNum.uint32.int2ip
      let actualPort = loc["port"].getNum.Port

      result = newJObject()
      # This will almost certainly fail on bad networks.
      result["_bnes"] = waitFor ask[BNES, BNER](BNES(port: lport), actualIp, actualPort)
      result["_bnxi"] = waitFor ask[BNXI, BNXR](BNXI(port: lport), actualIp, actualPort)
      result["_bnds"] = waitFor ask[BNDS, BNDR](BNDS(port: lport), actualIp, actualPort)

    response = list
    response["_list"] = %resolvedAddr

  elif args["bnes"]:
    response = await ask[BNES, BNER](BNES(port: lport))

  elif args["bnxi"]:
    response = await ask[BNXI, BNXR](BNXI(port: lport))

  elif args["bnds"]:
    response = await ask[BNDS, BNDR](BNDS(port: lport))

  elif args["bnlm"]:
    response = await ask[BNLM, BNLR](BNLM(port: lport, messageNo: 3, sessionId: 90))

  else: quit("wat")

  echo response.pretty
  quit()

asyncCheck runner()
runForever()