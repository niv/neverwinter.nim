import terminal, sets, math, strutils, streams

type ProgressBar = ref object
  label: string
  min: int
  max: int
  current: int

  # tick: int
  updateFrequency: int
  currentItem: string

type Iterable[T] = HashSet[T] | openArray[T] | set[T] | seq[T] | OrderedSet[T] |
                   Slice[T]

proc scale(count: int): int =
  # We don't want to update for every item, because stdout on windows is
  #   really, really slow to update the terminal.
  # OTOH, we want to show every update if it's a low number of items, assuming
  #   they are slow and important.
  max(1, pow(10.float32, max(0, ($count).len - 3).float32).int)

proc newProgressBar*(min, max: int, label = ""): ProgressBar =
  new(result)
  result.label = label
  result.min = min
  result.max = max
  result.current = 0

  # result.tick = 0
  result.updateFrequency = scale(result.max)

proc `$`*(self: ProgressBar): string =
  let percentage = ((self.current.float32 / self.max.float32) * 100).int

  let lenlen = ($self.max).len

  result = self.label &
           align($percentage, 3) & "% " &
           align($self.current & "/" & $self.max, lenlen * 2 + 1) & " " &
           self.currentItem

proc write*(io: File, self: ProgressBar) =
  if isatty(io):
    let tWidth = terminalWidth() - 1
    var t = $self
    let tmax = min(tWidth, t.high)
    t = t[0..tmax] & repeat(" ", max(0, tWidth - tmax))
    io.write "\r" & t
    if defined(windows): io.cursorUp()
    io.flushFile()

proc finish*(self: ProgressBar, io: File) =
  if isatty(stdout):
    let tWidth = terminalWidth()
    io.write "\r", repeat(" ", tWidth), "\r"
    if defined(windows): io.cursorUp()
    io.flushFile()

proc tick*(self: ProgressBar, item: string): bool =
  self.currentItem = ($item).strip.replace("\n", "")
  self.current = min(self.max, self.current + 1)
  result = self.current mod self.updateFrequency == 0
  # if result: self.tick += 1

proc show*(self: ProgressBar, io: File, item = "") =
  ## Shows the progress bar on `io` for the current item, automatically incrementing
  ## the internal counter.  Call exactly once per loop.
  if self.tick(item): io.write(self)

iterator withProgressBar*[T](items: Iterable[T], prefix = "", showitemstring = true): T =
  ## Transforms a items() iterator into one that prints a progress bar
  ## on stdout (if a tty).
  ## `prefix` can be a string that labels the current effort.

  when compiles(items.len):
    let itemCount = items.len
  else:
    # Slice[T]
    let itemCount = items.b - items.a

  let bar = newProgressBar(0, itemCount, prefix)

  for i in items:
    bar.show(stdout, $i)

    yield(i)

  bar.finish(stdout)
