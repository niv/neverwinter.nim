# This file is imported in ALL nim files when running tests.
# Be really careful about running code that might influence component functionality.

{.used.}

import std/[strutils, logging]

type AssertLogger = ref object of Logger

method log*(log: AssertLogger, level: Level, args: varargs[string, `$`]) =
  doAssert(level < lvlError, substituteLog("Log print of $levelname: ", level, args))

var initOnce {.threadvar.}: bool
if not initOnce:
  # Make sure there's a logger. Some library output goes to std/logging and we
  # want to capture that in error reports.
  addHandler newConsoleLogger(fmtStr="$levelid $time $appname: ", levelThreshold=lvlAll)

  # Any error or fatal output is considered a failing condition
  addHandler new(AssertLogger)

  initOnce = true
