import terminal, sets, strutils, math

export terminal

type Iterable[T] = HashSet[T] | openArray[T] | set[T] | seq[T]

proc scale(count: int): int =
  # We don't want to update for every item, because stdout on windows is
  #   really, really slow to update the terminal.
  # OTOH, we want to show every update if it's a low number of items, assuming
  #   they are slow and important.
  max(1, pow(10.float32, max(0, ($count).len - 3).float32).int)

iterator withProgressBar*[T](items: Iterable[T], prefix = "", showitemstring = true): T =
  ## Transforms a items() iterator into one that prints a progress bar
  ## on stdout (if a tty).
  ## `prefix` can be a string that labels the current effort.

  let updateFreq = scale(items.len)

  var idx = 0
  for i in items:

    if isatty(stdout) and idx mod updateFreq == 0:
      let t = prefix & $idx & "/" & $items.len & " " &
        (if showitemstring: $i else: "")
      stdout.write t, repeat(" ", terminalWidth() - t.len)
      if defined(windows):
        stdout.cursorUp() # ?? thanks, windows
      setCursorXPos(0)
      stdout.flushFile()

    idx += 1

    yield(i)

  if isatty(stdout):
    setCursorXPos(0)
    eraseLine()
    if defined(windows):
      stdout.cursorUp()
      stdout.write("\L")
    stdout.flushFile()
