# Compiles the entire base-game script corpus and compares the outcome against
# a checked-in expectation table.
#
# This is the only test that runs the compiler over real-world input. The
# shipped base scripts are vendored verbatim in base-game-data-37-17/ (see the
# LICENSE next to it), and they are what notices when a compiler change rejects
# or mis-diagnoses code that ships with the game. Issue #157 is the example:
# 30 shipped scripts stopped compiling when a new check was added, and nothing
# in the suite failed until a user reported it.
#
# The corpus is pinned, so the expectations only move when the compiler does.
# After an intentional diagnostic change, regenerate them and review the diff:
#
#   NWN_UPDATE_BASELINE=1 nim c -r tests/nwscript/tbasescripts.nim
#
# Only files that do not compile cleanly, or that produce warnings, are listed
# in the baseline. Line numbers are deliberately not recorded: they churn on
# any diagnostic improvement, while the error code is the meaningful class.

import std/[os, strutils, tables, algorithm, cpuinfo, monotimes, times]
import taskpools

import neverwinter/nwscript/compiler
import neverwinter/[restype, resdir, resman]

const
  SourcePath = currentSourcePath().splitFile().dir
  CorpusDir = SourcePath / "base-game-data-37-17"
  BaselineFile = SourcePath / "base-game-data-37-17.expected.txt"
  LangSpecNWScript = ("nwscript", ResType 2009, ResType 2010, ResType 2064).LangSpec
  MaxThreads = 16

type
  Outcome = object
    code: int32
    warnings: int

doAssert dirExists(CorpusDir), "missing base-game script corpus: " & CorpusDir

var files: seq[string]
for f in walkFiles(CorpusDir / "*.nss"):
  let name = f.extractFilename
  # nwscript.nss is the language specification, not a script to compile.
  if name == "nwscript.nss":
    continue
  files.add name.splitFile().name

files.sort()
doAssert files.len > 4000, "base-game script corpus looks incomplete: " & $files.len

var results = newSeq[Outcome](files.len)

# One compiler per worker thread; compilers are not shareable, and bringing one
# up parses the language spec. Files are handed out in strided slices so every
# worker gets an equivalent mix of small and large scripts.
proc runSlice(corpusDir: string, files: ptr seq[string], results: ptr seq[Outcome],
              offset, stride: int) {.gcsafe, raises: [].} =
  try:
    let rm = newResMan()
    rm.add newResDir(corpusDir)

    let c = newCompiler(LangSpecNWScript, false, rm)
    c.setRequireEntryPoint(false)
    c.setOptimizations(OptimizationFlagsO1)

    var i = offset
    while i < files[].len:
      let ret = c.compileFile(files[][i])
      results[][i] = Outcome(code: ret.code, warnings: ret.warnings.len)
      i += stride
  except Exception as e:
    # A worker must not take the whole process down with an unhandled
    # exception; report it and fail loudly.
    echo "base script worker failed: ", e.msg
    quit(2)

let numThreads = min(min(countProcessors(), MaxThreads), files.len)

let start = getMonoTime()
if numThreads > 1:
  var pool = Taskpool.new(numThreads = numThreads)
  for t in 0..<numThreads:
    pool.spawn runSlice(CorpusDir, files.addr, results.addr, t, numThreads)
  pool.syncAll()
  pool.shutdown()
else:
  runSlice(CorpusDir, files.addr, results.addr, 0, 1)
let elapsed = (getMonoTime() - start).inMilliseconds

proc header(): string =
  "# Base-game script corpus expectations for " & CorpusDir.extractFilename & ".\n" &
  "#\n" &
  "# Every .nss is compiled with no entry point required at -O1. Only files that\n" &
  "# do not compile cleanly, or that produce warnings, are listed.\n" &
  "#\n" &
  "# Format: <name> <error code> <warning count>\n" &
  "#\n" &
  "# Regenerate with:\n" &
  "#   NWN_UPDATE_BASELINE=1 nim c -r tests/nwscript/tbasescripts.nim\n"

proc render(name: string, o: Outcome): string =
  name & " " & $o.code & " " & $o.warnings

if getEnv("NWN_UPDATE_BASELINE") != "":
  var lines: seq[string]
  for i, name in files:
    if results[i].code != 0 or results[i].warnings != 0:
      lines.add render(name, results[i])
  lines.sort()
  writeFile(BaselineFile, header() & "\n" & lines.join("\n") & "\n")
  echo "baseline rewritten: ", lines.len, " entries, ", files.len, " scripts compiled"
  quit(0)

var expected = initTable[string, Outcome]()
for line in readFile(BaselineFile).splitLines:
  let s = line.strip
  if s.len == 0 or s.startsWith("#"):
    continue
  let parts = s.splitWhitespace
  doAssert parts.len == 3, "malformed baseline line: " & line
  expected[parts[0]] = Outcome(code: parts[1].parseInt.int32, warnings: parts[2].parseInt)

var clean, failed, warned: int
var problems: seq[string]

for i, name in files:
  let actual = results[i]
  let want = expected.getOrDefault(name, Outcome(code: 0, warnings: 0))

  if actual.code == 0: inc clean else: inc failed
  if actual.warnings > 0: inc warned

  var diffs: seq[string]
  if actual.code != want.code:
    diffs.add "code " & $want.code & " -> " & $actual.code
  if actual.warnings != want.warnings:
    diffs.add "warnings " & $want.warnings & " -> " & $actual.warnings
  if diffs.len > 0:
    problems.add "  " & name & ": " & diffs.join(", ")

for name in expected.keys:
  if name notin files:
    problems.add "  " & name & ": listed in baseline but not in the corpus"

if problems.len > 0:
  const shown = 40
  var msg = "base-game script corpus does not match the baseline:\n" &
    problems[0..<min(shown, problems.len)].join("\n")
  if problems.len > shown:
    msg &= "\n  ... and " & $(problems.len - shown) & " more"
  msg &= "\n\nIf these changes are intentional, regenerate the baseline with:\n" &
    "  NWN_UPDATE_BASELINE=1 nim c -r tests/nwscript/tbasescripts.nim"
  doAssert false, msg

echo files.len, " base scripts compiled in ", elapsed, "ms (" &
  $numThreads, " threads): ", clean, " clean, ", failed, " failed, ", warned,
  " with warnings"
