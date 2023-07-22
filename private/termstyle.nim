## This module is created to bring extremely easy to use terminal colours and styles.
## The official terminal module also does this but requires you to use calls like
## ``setStyle`` which clutters your input. This module on the other hand just defines
## simple, single-word procedures that applies styles to everything that follows.
## The most simple example is a regular ``echo`` statement for logging. To style it
## with a red text colour simply do:
## ::
##   echo red "mystring"
## This allows you to easily drop it into any echo statement without trouble.
## Similarily to an echo it also takes varargs, so this would also work:
## ::
##   echo red("mystring", 42)
## It even converts the integer to a string when concatenating just like echo does!
## If you want to have multiple colours on a single line you can use multiple of
## them and the ``echo`` varargs system:
## ::
##   echo red "This is blue: ", blue 42
## In case you want to add more styles and don't want to chain them you can of
## course also use the ``style`` procedure and combine the various styles:
## ::
##   echo style("mystring", termRed & termBlink)

var termStyleColorsEnabled = true

const
  termBlack* = "\e[30m"
  termRed* = "\e[31m"
  termGreen* = "\e[32m"
  termYellow* = "\e[33m"
  termBlue* = "\e[34m"
  termMagenta* = "\e[35m"
  termCyan* = "\e[36m"
  termWhite* = "\e[37m"
  termBgBlack* = "\e[40m"
  termBgRed* = "\e[41m"
  termBgGreen* = "\e[42m"
  termBgYellow* = "\e[43m"
  termBgBlue* = "\e[44m"
  termBgMagenta* = "\e[45m"
  termBgCyan* = "\e[46m"
  termBgWhite* = "\e[47m"
  termClear* = "\e[0m"
  termBold* = "\e[1m"
  termItalic* = "\e[3m"
  termUnderline* = "\e[4m"
  termBlink* = "\e[5m"
  termNegative* = "\e[7m"
  termStrikethrough* = "\e[9m"

proc setTermStyleColorsEnabled*(state: bool) = termStyleColorsEnabled = state

template addEnd(ss: varargs[string, `$`]): untyped =
  if not termStyleColorsEnabled: result = ""
  for s in ss:
    result &= s
  if not termStyleColorsEnabled: return
  result &= termClear

proc black*(ss: varargs[string, `$`]): string =
  ## Colours text black
  result = termBlack
  addEnd(ss)

proc red*(ss: varargs[string, `$`]): string =
  ## Colours text red
  result = termRed
  addEnd(ss)

proc green*(ss: varargs[string, `$`]): string =
  ## Colours text green
  result = termGreen
  addEnd(ss)

proc yellow*(ss: varargs[string, `$`]): string =
  ## Colours text yellow
  result = termYellow
  addEnd(ss)

proc blue*(ss: varargs[string, `$`]): string =
  ## Colours text blue
  result = termBlue
  addEnd(ss)

proc magenta*(ss: varargs[string, `$`]): string =
  ## Colours text magenta
  result = termMagenta
  addEnd(ss)

proc cyan*(ss: varargs[string, `$`]): string =
  ## Colours text cyan
  result = termCyan
  addEnd(ss)

proc white*(ss: varargs[string, `$`]): string =
  ## Colours text white
  result = termWhite
  addEnd(ss)

proc bgBlack*(ss: varargs[string, `$`]): string =
  ## Colours background black
  result = termBgBlack
  addEnd(ss)

proc bgRed*(ss: varargs[string, `$`]): string =
  ## Colours background red
  result = termBgRed
  addEnd(ss)

proc bgGreen*(ss: varargs[string, `$`]): string =
  ## Colours background green
  result = termBgGreen
  addEnd(ss)

proc bgYellow*(ss: varargs[string, `$`]): string =
  ## Colours background yellow
  result = termBgYellow
  addEnd(ss)

proc bgBlue*(ss: varargs[string, `$`]): string =
  ## Colours background blue
  result = termBgBlue
  addEnd(ss)

proc bgMagenta*(ss: varargs[string, `$`]): string =
  ## Colours background magenta
  result = termBgMagenta
  addEnd(ss)

proc bgCyan*(ss: varargs[string, `$`]): string =
  ## Colours background cyan
  result = termBgCyan
  addEnd(ss)

proc bgWhite*(ss: varargs[string, `$`]): string =
  ## Colours background white
  result = termBgWhite
  addEnd(ss)

proc bold*(ss: varargs[string, `$`]): string =
  ## Makes text bold
  result = termBold
  addEnd(ss)

proc italic*(ss: varargs[string, `$`]): string =
  ## Makes text italic
  result = termItalic
  addEnd(ss)

proc underline*(ss: varargs[string, `$`]): string =
  ## Makes text underlined
  result = termUnderline
  addEnd(ss)

proc blink*(ss: varargs[string, `$`]): string =
  ## Makes text blink (some terminals might not support this)
  result = termBlink
  addEnd(ss)

proc negative*(ss: varargs[string, `$`]): string =
  ## Switches the background and foreground of the text
  result = termNegative
  addEnd(ss)

proc strikethrough*(ss: varargs[string, `$`]): string =
  ## Makes text have the strikethrough effect
  result = termStrikethrough
  addEnd(ss)

proc style*(ss: varargs[string, `$`], style: string): string =
  ## Sets a custom style (Actually just appends ``style`` and ends the
  ## string with a clear style command)
  result = style
  addEnd(ss)
