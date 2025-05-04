import ctypes
from ctypes.util import find_library
import timeit

CB_WRITE = ctypes.CFUNCTYPE(
    ctypes.c_int32,
    ctypes.c_char_p,
    ctypes.c_uint16,
    ctypes.c_void_p,
    ctypes.c_size_t,
    ctypes.c_bool,
)

CB_LOAD = ctypes.CFUNCTYPE(
    ctypes.c_char_p,
    ctypes.c_char_p,
    ctypes.c_uint16,
)


class NativeCompileResult(ctypes.Structure):
    _fields_ = [
        ("code", ctypes.c_int32),
        ("str", ctypes.c_char_p),
    ]


lib = ctypes.cdll.LoadLibrary(find_library("nwnscriptcomp"))
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
    ctypes.c_char_p,  # outputAlias
]

fn_compile = lib.scriptCompApiCompileFile
fn_compile.argtypes = [
    ctypes.c_void_p,  # compiler
    ctypes.c_char_p,  # filename
]
fn_compile.restype = NativeCompileResult

fn_deliver_file = lib.scriptCompApiDeliverFile
fn_deliver_file.argtypes = [
    ctypes.c_void_p,  # compiler
    ctypes.c_void_p,  # data
    ctypes.c_size_t,  # size
]

fn_destroycomp = lib.scriptCompApiDestroyCompiler
fn_destroycomp.argtypes = [
    ctypes.c_void_p,  # compiler
]


class CompilationError(Exception):
    """Exception raised for errors in the compilation process."""

    def __init__(self, code: int, message: bytes):
        super().__init__(message)
        self.message = message
        self.code = code
        self.str = b""

    def __str__(self):
        return f"CompilationError(code={self.code}, message={self.message})"


class Compiler:
    """
    A class to compile NWScript using the NWScript compiler.

    The compiler is encoding-agnostic and only deals with bytes; even
    when requesting filenames.

    Args:
        resolver: A callable that resolves the filename and resource type.
            It accepts two arguments: filename (bytes) and resource type (int).
            It should return the file contents as bytes.
    """

    def __init__(
        self,
        resolver: callable,  # callable(filename: bytes, restype: int) -> bytes
        src_rt=2009,  # nss
        bin_rt=2010,  # ncs
        dbg_rt=2064,  # ndb
        langspec=b"nwscript",
        max_include_depth=16,
    ):
        self._resolver = resolver
        self._ncs = None
        self._ndb = None

        def cb_write(fn, rt, data, size, is_binary):
            return self._write_file(fn, rt, data, size, is_binary)

        def cb_load(fn, rt):
            return self._load_file(fn, rt)

        self.cb_write = CB_WRITE(cb_write)
        self.cb_load = CB_LOAD(cb_load)
        self.comp = fn_newcomp(src_rt, bin_rt, dbg_rt, self.cb_write, self.cb_load)

        # NB: This will trigger the first request, for "nwscript.nss".
        fn_initcomp(self.comp, langspec, True, max_include_depth, None, b"scriptout")

    def __del__(self):
        if self.comp:
            fn_destroycomp(self.comp)
            self.comp = None

    def _write_file(self, fn, rt, data: bytes, size: int, is_binary: bool):
        dat = bytes(ctypes.cast(data, ctypes.POINTER(ctypes.c_char * size)).contents)
        if is_binary:
            assert not self._ncs
            self._ncs = dat
        else:
            assert not self._ndb
            self._ndb = dat
        return 0

    def _load_file(self, fn, rt):
        if data := self._resolver(fn, rt):
            fn_deliver_file(self.comp, data, len(data))
            return True

        return False

    def compile(self, filename: bytes) -> tuple[bytes, str]:
        """
        Compile the given script filename.

        Args:
            script: The script to compile. It will be requested
                from the resolver.

        Returns:
            A tuple of (bytecode, debug data).

        Raises:
            CompilationError: If the compilation fails.
        """
        r = fn_compile(self.comp, filename)
        if r.code != 0:
            raise CompilationError(r.code, r.str)

        assert self._ncs
        assert self._ndb

        ncs, ndb = self._ncs, self._ndb
        self._ncs = None
        self._ndb = None
        return (ncs, ndb)


test_files = {
    b"nwscript": b"""
int Nonsense(int n);
    """,
    b"incl": b"""
int retval() { return Nonsense(42); }
""",
    b"test": b"""
#include "incl"\n\nvoid main() {}
""",
}


def main():
    def resolver(filename: bytes, restype: int) -> bytes:
        assert restype == 2009, f"unexpected restype: {restype=}"

        if filename not in test_files:
            print(f"not found: {filename=}")
            return None

        return test_files[filename]

    comp = Compiler(resolver)

    ret = comp.compile(b"test")
    print(f"compilation result: {ret=}")

    def _compile():
        test = comp.compile(b"test")
        # ncs build is currently expected to be reproducible
        assert test[0] == ret[0]
        assert test[1] == ret[1]

    count = 10000
    print(f"compiling {count}x")
    bench = timeit.timeit("comp.compile(b'test')", number=count, globals=locals())
    print(f"= {bench=}")

    # Optional in production, but testing dtor code here.
    del comp
    print("done")


if __name__ == "__main__":
    main()
