import std/[tables, threadpool, cpuinfo, atomics, strutils, sequtils]

import shared
import neverwinter/nwscript/compiler
import neverwinter/resman

const ArgsHelp = """
Compile one or more scripts using the official compiler library.

<file> must be a single fully-qualified source file.

<spec> can be one or more files or directories. In the case of directories, recursion
into subdirectories will only happen if -R is given.

Target artifacts are written to the same directory each source file is in, unless
overridden with -o or -d.

Usage:
  $0 [options] [-o <out>] <file>
  $0 [options] -c <spec>...
  $USAGE

  -o OUT                      When compiling single file, specify outfile.

  -c                          Compile multiple files and/or directories.
  -d DIR                      Write all build artifacts into DIR.
  -R                          Recurse into subdirectories for each given directory.

  -g                          Write debug symbol files (NDB).
  -y                          Continue processing input files even on error.
  -j N                        Parallel execution (default: all CPUs).

  -O N                        Optimisation levels [default: 2]
                                0: Optimise nothing
                                2: Aggressive optimisations; fastest and smallest code size:
""" & indent(join(toSeq(OptimizationFlagsO2).mapIt("+" & $it), "\n"), 36) & """


  -s                          Simulate: Compile, but write no filee.
                              Use --verbose to see what would be written.

  --langspec NSS              Language spec to load [default: nwscript]
  --restype-src TYPE          ResType to use for source lookup [default: nss]
  --restype-bin TYPE          ResType to use for binary output [default: ncs]
  --restype-dbg TYPE          ResType to use for debug output [default: ndb]
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

  GlobalState = object
    successes, errors, skips: Atomic[uint]
    args: OptArgs  # readonly
    params: Params # readonly

  RMSearchPathEntry = (PathComponent, string)

  # Object holding all state each individual thread needs.
  # Accessible only via getThreadState(), which also does
  # first-time init for threadpool threads.
  ThreadState = ref object
    chDemandResRefResponse: Channel[string]
    currentRMSearchPath: seq[RMSearchPathEntry]
    cNSS: ScriptCompiler

# =================
# Global state is used on the main thread.
# We also initialise the thread pool and other global properties here.

var globalState: GlobalState
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
    of 2: OptimizationFlagsO2
    else: raise newException(ValueError, "No such optimisation flag: " & $globalState.args["-O"])
  ),
  continueOnError: globalState.args["-y"].to_bool,
  parallel: (if globalState.args["-j"]: parseInt($globalState.args["-j"]) else: countProcessors()).Positive,
  outDirectory: if globalState.args["-d"]: ($globalState.args["-d"]) else: ""
)

if globalState.params.outDirectory != "" and not dirExists(globalState.params.outDirectory):
  fatal "Directory given in -d must exist."
  quit(1)

setMinPoolSize 1
setMaxPoolSize globalState.params.parallel

proc getThreadState(): ThreadState {.gcsafe.}

# This will be referenced via untracked pointer on all other worker threads.
# This is OK to do because globalState.params is entirely readonly and will outlive
# all other threads.
let params: ptr Params = globalState.params.addr

# =================
# ResMan: We have one global resman instance on a worker thread. It reads requests
# over a channel and services them sequentially. This was preferable to having one
# resman per worker thread, since bringing up rm takes quite a bit of IO and cpu.

proc serviceRmDemand(rm: ResMan, resref: ResRef, searchPath: seq[RMSearchPathEntry]): string =
  var containers: seq[ResContainer]
  for q in searchPath:
    case q[0]
    of pcDir:  containers.add newResDir(q[1])
    of pcFile: containers.add newResFile(q[1])
    else: continue
  for c in containers:
    rm.add(c)
  defer:
    for c in containers:
      rm.del(c)

  if not rm.contains(resref):
    return ""
  else:
    # TODO: will run into open fd ulimit on some systems because of how resman handles fds currently
    return rm.demand(resref).readAll

var chDemandResRef: Channel[tuple[
  resref: ResRef,
  searchPath: seq[RMSearchPathEntry], # Additional search path set up for this request only.
  response: ptr Channel[string]]
]
chDemandResRef.open()

var demandResRefThread: Thread[void]
createThread(demandResRefThread) do:
  # TODO: Make shared init less sucky. We need to call this here to set up args (again)
  #       so newBasicResMan can refer to it.
  discard DOC(ArgsHelp)

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
    # TODO: make shared init less sucky. We need to init this here because workers
    #       will depend on logging and related to be set up.
    discard DOC(ArgsHelp)
    state.chDemandResRefResponse.open(maxItems=1)
    state.cNSS = newCompiler(params.langSpec, params.debugSymbols, resolveFile)
    state.cNSS.setOptimizations(params.optFlags)
  state

proc doCompile(num, total: Positive, p: string, overrideOutPath: string = "") {.gcsafe.} =
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

    let ret = compileFile(getThreadState().cNSS, parts.name)

    # This cast is here only to access globalState.
    # We know the atomics are threadsafe to touch, and so is logging.
    {.cast(gcsafe).}:
      let prefix = format("[$#/$#] $#: ", num, total, p)
      case ret.code
      of 0:
        proc writeData(fn, data: string) =
          if data == "": return
          elif params.simulate: debug "[simulate] Would write file: ", fn
          else: writeFile(fn, data)

        atomicInc globalState.successes
        debug prefix, "Success"

        writeData(outFilePrefix & "." & getResExt(params.langSpec.bin), ret.bytecode)
        writeData(outFilePrefix & "." & getResExt(params.langSpec.dbg), ret.debugcode)
      of 623:
        atomicInc globalState.skips
        debug prefix, "no main (include?)"
      else:
        atomicInc globalState.errors
        if params.continueOnError:
          error prefix, ret.str
        else:
          fatal prefix, ret.str
          # This might not be so safe in conjunction with the threadpool being loaded
          # We'll see if it starts crashing ..
          quit(1)

  else: discard

# =================
# Global mainloop. This queues up all files to be compiled onto the threadpool.

proc canCompileFile(path: string): bool =
  fileExists(path) and path.endsWith(".nss")

# Collect files to compile first in one go, and verify they exist.
proc collect(into: var seq[string], path: string) =
  if fileExists(path):
    if not canCompileFile(path):
      fatal path, ": Don't know how to compile file type"
      quit(1)
    into.add(path)
  elif dirExists(path):
    for subpath in walkDir(path, relative=true, checkdir=true):
      let absSubPath = path / subpath.path
      if subpath.kind == pcDir and params.recurse:
        collect(into, absSubPath)
      elif subpath.kind == pcFile and canCompileFile(absSubPath):
        into.add(absSubPath)
  else:
    fatal path,  ": Does not exist"
    quit(1)

if globalState.args["<spec>"]:
  var queue: seq[string]
  for fn in globalState.args["<spec>"]:
    collect(queue, fn)

  queue = queue.deduplicate

  let queueLen = queue.len
  for idx, q in queue:
    spawn doCompile(idx+1, queueLen, q)

elif globalState.args["<file>"]:
  let file = $globalState.args["<file>"]
  if not canCompileFile file:
    fatal file, ": Don't know how to compile or does not exist"
  spawn doCompile(1, 1, file, if globalState.args["-o"]: $globalState.args["-o"] else: "")

else:
  doAssert(false)

# Barrier to wait for threadpool to become idle.
sync()

info format("$# successful, $# skipped, $# errored",
  globalState.successes.load, globalState.skips.load, globalState.errors.load)

if globalState.errors.load > 0:
  quit(1)
