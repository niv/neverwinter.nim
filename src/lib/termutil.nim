import terminal, sets, strutils, math

export terminal

type Iterable[T] = HashSet[T] | openArray[T] | set[T] | seq[T] | OrderedSet[T] |
                   Slice[T]

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

  let tWidth = terminalWidth()

  when compiles(items.len):
    let itemCount = items.len
  else:
    # slice
    let itemCount = items.b - items.a

  let lenlen = ($itemCount).len
  let updateFreq = scale(itemCount)

  var idx = 0
  var displayTick = 0
  for i in items:

    if isatty(stdout):
      if idx mod updateFreq == 0:
        let percentage = ((idx.float32 / itemCount.float32) * 100).int

        let repi = ($i).strip.replace("\n", "")

        let t = prefix &
                align($percentage, 3) & "% " &
                align($idx & "/" & $itemCount, lenlen * 2 + 1) & " " &
                (if showitemstring: repi else: "")

        let tmax = min(tWidth, t.high)

        stdout.write "\r", t[0..<tmax], repeat(" ", tWidth - tmax)
        if defined(windows): stdout.cursorUp()

        displayTick += 1

      stdout.flushFile()

    idx += 1

    yield(i)

  if isatty(stdout):
    stdout.write "\r", repeat(" ", tWidth), "\r"
    if defined(windows): stdout.cursorUp()
    stdout.flushFile()
