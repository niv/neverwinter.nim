import std/[logging, net, asyncdispatch, times, json, nativesockets, asyncnet, jsonutils]
import arpie

type AskResult* = tuple
  time: int64
  data: string

proc ask*(socket: AsyncSocket, host: string, port: Port,
    data: string, timeout = 5_000): Future[AskResult] {.async.} =
  debug "Asking ", host, ":", port, " for ", data

  let tstart = epochTime() * 1000
  try:
    socket.sendTo(host, port, data)
  except:
    raise newException(IOError, "Send failed: " & getCurrentExceptionMsg())

  let fut = socket.recvFrom(65_000)
  let waitable = withTimeout(fut, timeout)
  let ok = await(waitable)
  let ms = int64 epochTime() * 1000 - tstart

  if ok:
    debug "Got response from ", host, ":", port, " for ", data
    result = (time: ms, data: await(fut).data) # parseArpie[R](await(fut).data)
  else:
    debug "Timeout waiting for data"
    raise newException(IOError, "Timeout after " & $timeout & " ms")

proc askJson*[T, R](socket: AsyncSocket, qh: string, qp: Port,
    data: T, timeout = 5_000): Future[JsonNode] {.async.} =

  let laddr = socket.getFd().getLocalAddr(AF_INET)

  # If we're send BM/BN tuples, inject our client port all sneak-like.
  var data2 = data
  when compiles(data2.port): data2.port = laddr[1].uint16

  let ret = await ask(socket, qh, qp, toString(data2), timeout)

  result = parseArpie[R](ret.data).toJson
  result["_querymsec"] = newJInt(ret.time)
  result["_queryhost"] = %qh
  result["_queryport"] = %qp.int
  result["_localport"] = %laddr[1].int
  result["_localhost"] = %laddr[0]
