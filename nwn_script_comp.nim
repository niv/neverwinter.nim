import std/[tables, cpuinfo, atomics, strutils, sequtils, monotimes]

import taskpools

import shared
import neverwinter/nwscript/compiler
import neverwinter/resman

proc fmtOptFlags(flags: set[OptimizationFlag], indentSize: int = 36): string =
  indent(join(toSeq(flags).mapIt("+" & $it), "\n"), indentSize)

const ArgsHelp = """
Compile one or more scripts using the official compiler library.

<file> must be a single fully-qualified source file.

<spec> can be one or more files or directories. In the case of directories, recursion
into subdirectories will only happen if -R is given.

Target artifacts are written to the same directory each source file is in, unless
overridden with -o or -d.

Usage:
  $0 [options] [-o <out>] <file>
  $0 [options] [-d <out>] [-R] -c <spec>...
  $USAGE

  -o OUT                      When compiling single file, specify outfile.

  -c                          Compile multiple files and/or directories.
  -d DIR                      When compiling multiple files, write all build artifacts into DIR.
  -R                          Recurse into subdirectories for each given directory.
  --follow-symlinks           Follow symlinks when compiling recursively.

  -g                          Write debug symbol files (NDB).
  -y                          Continue processing input files even on error.
  -j N                        Parallel execution (default: all CPUs).

  -O N                        Optimisation levels [default: 1]
                                0: Optimise nothing
                                1: Safe optimisations only, as used by the game and toolset
""" & fmtOptFlags(OptimizationFlagsO1, 36) & "\n" & """
                                2: Aggressive optimisations; faster and smaller code size
""" & fmtOptFlags(OptimizationFlagsO2, 36) & "\n" & """
                                3: Experimental optimisations; untested or known to break something
""" & fmtOptFlags(OptimizationFlagsO3, 36) & "\n" & """


  --max-include-depth=N       Maximum include depth [default: 16]

  -s                          Simulate: Compile, but write no file.
                              Use --verbose to see what would be written.

  --no-require-entry-point    Do not require an entry point (void main or
                              int StartingConditional). Scripts without an
                              entry point are validated but no code is
                              generated. Useful for validating include files.

  --langspec NSS              Language spec to load [default: nwscript]
  --restype-src TYPE          ResType to use for source lookup [default: nss]
  --restype-bin TYPE          ResType to use for binary output [default: ncs]
  --restype-dbg TYPE          ResType to use for debug output [default: ndb]

  --graphviz DIR              Dump the parse tree as graphviz DOT to DIR.
$OPTRESMAN
"""

type
  Params = ref object
    langSpec: LangSpec
    recurse: bool
    simulate: bool
    debugSymbols: bool
    optFlags: set[OptimizationFlag]
    continueOnError: bool
    parallel: Positive
    outDirectory: string
    maxIncludeDepth: 1..200
    followSymlinks: bool
    graphvizOut: string
    requireEntryPoint: bool

  GlobalState = object
    args: OptArgs  # readonly
    params: Params # readonly

  RMSearchPathEntry = (PathComponent, string)

  # Object holding all state each individual worker thread needs.
  # Accessible only via getThreadState(), which also does
  # first-time init for pool worker threads.
  ThreadState = ref object
    chDemandResRefResponse: Channel[string]
    currentRMSearchPath: seq[RMSearchPathEntry]
    cNSS: ScriptCompiler

# =================
# Global state is used on the main thread; the task pool is created per run
# in compileAll().

var
  globalState: GlobalState
  # Counters updated by worker threads; gAborted stops the queue on error.
  gSuccesses, gErrors, gSkips: Atomic[uint]
  gAborted: Atomic[bool]

globalState.args = DOC(ArgsHelp)
globalState.params = Params(
  langSpec: LangSpec (
    lang: $globalState.args["--langspec"],
    src: getResType $globalState.args["--restype-src"],
    bin: getResType $globalState.args["--restype-bin"],
    dbg: getResType $globalState.args["--restype-dbg"]
  ),
  recurse: globalState.args["-R"].to_bool,
  simulate: globalState.args["-s"].to_bool,
  debugSymbols: globalState.args["-g"].to_bool,
  optFlags: (case parseInt($globalState.args["-O"])
    of 0: OptimizationFlagsO0
    of 1: OptimizationFlagsO1
    of 2: OptimizationFlagsO2
    of 3: OptimizationFlagsO3
    else: raise newException(ValueError, "No such optimisation flag: " & $globalState.args["-O"])
  ),
  continueOnError: globalState.args["-y"].to_bool,
  parallel: (if globalState.args["-j"]: parseInt($globalState.args["-j"]) else: countProcessors()).Positive,
  outDirectory: if globalState.args["-d"]: ($globalState.args["-d"]) else: "",
  maxIncludeDepth: parseInt($globalState.args["--max-include-depth"]),
  followSymlinks: globalState.args["--follow-symlinks"],
  graphvizOut: if globalState.args["--graphviz"]: ($globalState.args["--graphviz"]) else: "",
  requireEntryPoint: not globalState.args["--no-require-entry-point"].to_bool,
)

if globalState.params.outDirectory != "" and not dirExists(globalState.params.outDirectory):
  fatal "Directory given in -d must exist."
  quit(1)

proc getThreadState(): ThreadState {.gcsafe.}

# These will be referenced via untracked pointers on all other worker threads.
# This is OK to do because globalState is entirely readonly and will outlive
# all other threads.
let params: ptr Params = globalState.params.addr
let argsPtr: ptr OptArgs = globalState.args.addr

# =================
# ResMan: We have one global resman instance on a worker thread. It reads requests
# over a channel and services them sequentially. This was preferable to having one
# resman per worker thread, since bringing up rm takes quite a bit of IO and cpu.

# Cache container instances so resDir does not reload every time a file is queried.
# Variable is only valid on service thread.
var resContainerCache {.threadvar.}: Table[string, ResContainer]

proc serviceRmDemand(rm: ResMan, resref: ResRef, searchPath: seq[RMSearchPathEntry]): string =
  var containers: seq[ResContainer]
  for q in searchPath:
    if not resContainerCache.hasKey(q[1]):
      case q[0]
      of pcDir:  resContainerCache[q[1]] = newResDir(q[1])
      of pcFile: resContainerCache[q[1]] = newResFile(q[1])
      else: continue
    containers.add resContainerCache[q[1]]

  containers &= rm.containers

  for c in containers:
    if c.contains(resref):
      return c.demand(resref).readAll

  return ""

var chDemandResRef: Channel[tuple[
  resref: ResRef,
  searchPath: seq[RMSearchPathEntry], # Additional search path set up for this request only.
  response: ptr Channel[string]]
]
chDemandResRef.open()

var demandResRefThread: Thread[void]
createThread(demandResRefThread) do ():
  initThreadTLS(argsPtr[])

  let rm = newBasicResMan()

  while true:
    var msg = chDemandResRef.recv()
    # debug "ResMan: Serving ", msg.resref
    assert not isNil msg.response
    (msg.response[]).send serviceRmDemand(rm, msg.resref, msg.searchPath)

# =================
# native callbacks and compiler helpers.
# All of these run inside worker threads and only access TLS (via getThreadState()).

proc resolveFile(fn: string, ty: ResType): string =
  let r = newResRef($fn, ResType ty)
  chDemandResRef.send((
    resRef: r,
    searchPath: getThreadState().currentRMSearchPath,
    response: getThreadState().chDemandResRefResponse.addr
  ))
  let resolveFileBuf = getThreadState().chDemandResRefResponse.recv()
  if resolveFileBuf == "": raise newException(IOError, "not found: " & $r)
  return resolveFileBuf

var state {.threadvar.}: ThreadState
proc getThreadState(): ThreadState {.gcsafe.} =
  if isNil state:
    new(state)
    # Workers need per-thread state (args, logging, encodings) set up first.
    initThreadTLS(argsPtr[])
    state.chDemandResRefResponse.open(maxItems=1)
    state.cNSS = newCompiler(params.langSpec, params.debugSymbols, resolveFile, params.maxIncludeDepth, params.graphvizOut)
    state.cNSS.setOptimizations(params.optFlags)
    state.cNSS.setRequireEntryPoint(params.requireEntryPoint)
  state

proc doCompile(num, total: Positive, p: string, overrideOutPath: string = "") {.gcsafe.} =
  # After an error that aborts the run, skip files that have not started yet.
  if gAborted.load:
    return

  let parts = splitFile(absolutePath(p))
  doAssert(parts.dir != "")
  let outParts = if overrideOutPath != "": splitFile(absolutePath(overrideOutPath)) else: parts

  let outFilePrefix =
    # global params can override the out directory.
    if params.outDirectory == "": outParts.dir / outParts.name
    else:                         params.outDirectory / outParts.name

  case parts.ext
  of ".nss":
    # When compiling a file, we add it's contained directory to the search path.
    # This allows resolving includes. We need to pass this info to the RM worker
    # so it can set up the include path for this.
    getThreadState().currentRMSearchPath = @[(pcDir, parts.dir), (pcFile, p)]

    # Always remove the ndb file - in case of not generating it, it'd crash
    # the game or confuse the disassember. And in case of generating, a correct
    # version will come back.
    removeFile(parts.dir / parts.name & "." & getResExt(params.langSpec.dbg))

    let timeStart = getMonoTime()
    let ret = compileFile(getThreadState().cNSS, parts.name)
    proc timingPostfix(): string =
      let diff = getMonoTime() - timeStart
      let ms = diff.inMilliseconds()
      if ms == 0: " [<0ms]"
      else: " [" & $ms & "ms]"

    let prefix = format("[$#/$#] $#: ", num, total, p)
    case ret.code
    of 0:
      proc writeData(fn, data: string) =
        if data == "": return
        elif params.simulate: debug "[simulate] Would write file: ", fn
        else: writeFile(fn, data)

      atomicInc gSuccesses
      writeData(outFilePrefix & "." & getResExt(params.langSpec.bin), ret.bytecode)
      writeData(outFilePrefix & "." & getResExt(params.langSpec.dbg), ret.debugcode)

      if ret.bytecode == "" and ret.debugcode == "":
        # Validation-only compile (no entry point present): nothing was generated.
        debug prefix, "Success (validated, no entry point)", timingPostfix()
      else:
        debug prefix, "Success", timingPostfix()

    of 623:
      atomicInc gSkips
      debug prefix, "no main (include?)", timingPostfix()
    else:
      atomicInc gErrors
      if params.continueOnError:
        error prefix, ret.str, timingPostfix()
      else:
        fatal prefix, ret.str, timingPostfix()
        # Stop scheduling further files; tasks already in flight run to completion.
        gAborted.store(true)

  else: discard

proc doCompileTask(num, total: Positive, p: string, overrideOutPath: string) {.gcsafe, raises: [].} =
  ## Task-pool entry point: exceptions must not escape a pool task, so surface
  ## them as a counted error instead.
  try:
    doCompile(num, total, p, overrideOutPath)
  except Exception as e:
    atomicInc gErrors
    gAborted.store(true)
    echo "Exception while compiling ", p, ": ", e.msg

proc canCompileFile(path: string): bool =
  # Never compile language spec files
  if extractFilename(path) == "nwscript.nss":
    return false
  fileExists(path) and path.endsWith(".nss")

# Collect files to compile first in one go, and verify they exist.
proc collect(into: var seq[string], path: string) =
  let dirMask = if params.followSymlinks: {pcDir, pcLinkToDir} else: {pcDir}
  let fileMask = if params.followSymlinks: {pcFile, pcLinkToFile} else: {pcFile}
  if fileExists(path):
    if not canCompileFile(path):
      fatal path, ": Don't know how to compile file type"
      quit(1)
    into.add(path)
  elif dirExists(path):
    for subpath in walkDir(path, relative=true, checkdir=true):
      let absSubPath = path / subpath.path
      if subpath.kind in dirMask and params.recurse:
        collect(into, absSubPath)
      elif subpath.kind in fileMask and canCompileFile(absSubPath):
        into.add(absSubPath)
  else:
    fatal path,  ": Does not exist"
    quit(1)

# =================
# Global mainloop. Queues up all files to be compiled onto the task pool, then
# waits for the pool to become idle.

proc compileAll(queue: seq[string], overrideOutPath: string = "") =
  if queue.len == 0:
    return

  var pool = Taskpool.new(numThreads = globalState.params.parallel)
  for idx, q in queue:
    pool.spawn doCompileTask(idx+1, queue.len, q, overrideOutPath)

  # Barrier: wait for all tasks, then release the pool.
  pool.syncAll()
  pool.shutdown()

proc main() =
  if globalState.args["<spec>"]:
    var queue: seq[string]
    for fn in globalState.args["<spec>"]:
      collect(queue, fn)

    queue = queue.deduplicate

    compileAll(queue)

  elif globalState.args["<file>"]:
    let file = $globalState.args["<file>"]
    if not canCompileFile file:
      fatal file, ": Don't know how to compile or does not exist"
      quit(1)

    compileAll(@[file], if globalState.args["-o"]: $globalState.args["-o"] else: "")

  else:
    doAssert(false)

  info format("$# successful, $# skipped, $# errored",
    gSuccesses.load, gSkips.load, gErrors.load)

  if gErrors.load > 0:
    quit(1)

main()
