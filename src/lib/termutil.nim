import terminal, sets, strutils

export terminal

type Iterable[T] = HashSet[T] | openArray[T] | set[T] | seq[T]

iterator withProgressBar*[T](items: Iterable[T], prefix = "", showitemstring = true): T =
  ## Transforms a items() iterator into one that prints a progress bar
  ## on stdout (if a tty).
  ## `prefix` can be a string that labels the current effort.

  var idx = 0
  for i in items:
    if isatty(stdout):
      setCursorXPos(0)
      let t = prefix & $idx & "/" & $items.len & " " &
        (if showitemstring: $i else: "")
      stdout.write t, repeat(" ", terminalWidth() - t.len)
      stdout.flushFile
      idx += 1

    yield(i)

  if isatty(stdout):
    setCursorXPos(0)
    eraseLine()
