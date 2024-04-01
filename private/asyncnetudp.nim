import std/[net, nativesockets, asyncdispatch, os, asyncnet]

type RecvFromResult* = tuple[data: string, address: string, port: Port]

proc recvFrom*(socket: AsyncSocket, size: int,
    flags = {SocketFlag.SafeDisconn}): Future[RecvFromResult] =
  ## Reads up to ``size`` bytes from a AsyncSocket. This is for DGRAM socket
  ## types, like UDP, and thus does not support buffered sockets.

  var retFuture = newFuture[RecvFromResult]()

  var readBuffer = newString(size)
  var sockAddress: SockAddr_in
  var addrLen = sizeof(sockAddress).SockLen

  proc cb(sock: AsyncFD): bool =
    var nullpkt: RecvFromResult
    result = true
    let res = recvfrom(sock.SocketHandle, cstring(readBuffer),
                 size.cint, 0, cast[ptr SockAddr](addr(sockAddress)), addr(addrLen))

    if res < 0:
      let lastError = osLastError()
      when defined(posix):
        let lastErrorIsIntr = lastError.int32 notin {EINTR, EWOULDBLOCK, EAGAIN}
      elif defined(win32):
        let lastErrorIsIntr = lastError.int32 notin {WSAEWOULDBLOCK, WSAEINTR} # ?? WSAEAGAIN
      if lastErrorIsIntr:
        if flags.isDisconnectionError(lastError):
          retFuture.complete(nullpkt)
        else:
          retFuture.fail(newException(OSError, osErrorMsg(lastError)))
      else:
        result = false # We still want this callback to be called.

    elif res == 0:
      # Disconnected
      retFuture.complete(nullpkt)

    else:
      var goodpkt: RecvFromResult
      readBuffer.setLen(res)
      goodpkt.data = readBuffer
      goodpkt.address = $inet_ntoa(sockAddress.sin_addr)
      goodpkt.port = nativesockets.ntohs(sockAddress.sin_port).Port
      retFuture.complete(goodpkt)

  addRead(socket.fd.AsyncFD, cb)

  return retFuture

proc sendTo*(sock: AsyncSocket, address: string, port: Port, data: string,
  flags = 0'i32): int =
  ## Sends ``data`` to a AF_INET sockaddr ``address``:``port``.
  ## This is basically the same as net.sendTo, only for DGRAM sockets like
  ## udp.
  ##
  ## Returns the number of bytes sent, or -1 on failure, in which case
  ## errno is filled.

  var aiList = getAddrInfo(address, port, AF_INET)
  var success = false
  var it = aiList

  while it != nil:
    result = sendto(sock.fd, cstring(data), data.len.cint, flags.cint,
      it.ai_addr, it.ai_addrlen.SockLen)

    if result != -1'i32:
      success = true
      break

    it = it.ai_next

  freeAddrInfo(aiList)
