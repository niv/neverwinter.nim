import os
import platform
import ctypes

CB_WRITE = ctypes.CFUNCTYPE(
    ctypes.c_int32,
    ctypes.c_char_p,
    ctypes.c_uint16,
    ctypes.c_void_p,
    ctypes.c_size_t,
    ctypes.c_bool,
)

CB_LOAD = ctypes.CFUNCTYPE(
    ctypes.c_bool,
    ctypes.c_char_p,
    ctypes.c_uint16,
)


class NativeCompileResult(ctypes.Structure):
    _fields_ = [
        ("code", ctypes.c_int32),
        ("str", ctypes.c_char_p),
    ]


def detect_dylib_extension():
    match platform.system().lower():
        case "windows":
            return "dll"
        case "darwin":
            return "dylib"
        case _:
            return "so"


lib = ctypes.cdll.LoadLibrary(f"libscriptcomp.{detect_dylib_extension()}")
if lib is None:
    raise ImportError("Could not load libscriptcomp")

fn_abi = lib.scriptCompApiGetABIVersion
fn_abi.argtypes = []
fn_abi.restype = ctypes.c_int32

fn_newcomp = lib.scriptCompApiNewCompiler
fn_newcomp.argtypes = [
    ctypes.c_int,  # src
    ctypes.c_int,  # bin
    ctypes.c_int,  # dbg
    CB_WRITE,
    CB_LOAD,
]
fn_newcomp.restype = ctypes.c_void_p

fn_initcomp = lib.scriptCompApiInitCompiler
fn_initcomp.argtypes = [
    ctypes.c_void_p,  # compiler
    ctypes.c_char_p,  # lang
    ctypes.c_bool,  # writeDebug
    ctypes.c_int,  # maxIncludeDepth
    ctypes.c_char_p,  # graphvizOut
]

fn_compile = lib.scriptCompApiCompileFile
fn_compile.argtypes = [
    ctypes.c_void_p,  # compiler
    ctypes.c_char_p,  # filename
]
fn_compile.restype = NativeCompileResult

fn_destroycomp = lib.scriptCompApiDestroyCompiler
fn_destroycomp.argtypes = [
    ctypes.c_void_p,  # compiler
]

fn_deliver_file = lib.scriptCompApiDeliverFile
fn_deliver_file.argtypes = [
    ctypes.c_void_p,  # compiler
    ctypes.c_char_p,  # data
    ctypes.c_size_t,  # size
]


def write_file(fn, rt, data, size, is_binary):
    print(f"write_file: {fn=} {rt=} {data=} {size=} {is_binary=}")
    return 0


def load_file(fn, rt):
    print(f"load_file: {fn=} {rt=}")
    lfn = f"{fn.decode()}.nss"
    if not os.path.exists(lfn):
        print(f"not found: {lfn=}")
        return False
    with open(lfn, "rb") as f:
        bbuf = f.read()
    fn_deliver_file(comp, bbuf, len(bbuf))
    return True


cb_write = CB_WRITE(write_file)
cb_load = CB_LOAD(load_file)

fn_abi = fn_abi()
if fn_abi != 1:
    raise ImportError(f"Unsupported ABI version: {fn_abi} (wanted: 1)")

comp = fn_newcomp(
    2009,
    2010,
    2064,
    cb_write,
    cb_load,
)

fn_initcomp(comp, b"nwscript", True, 16, None)

ret = fn_compile(comp, b"test")
print(f"{ret.code=} {ret.str.decode()=}")
fn_destroycomp(comp)
