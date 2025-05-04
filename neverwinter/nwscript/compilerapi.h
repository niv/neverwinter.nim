#pragma once

//
// To build the shared library on MacOS:
//   g++ -O2 -fPIC -shared -std=c++14 \
//     -o libnwnscriptcomp.dylib \
//     neverwinter/nwscript/compilerapi.cpp \
//     neverwinter/nwscript/native/*.{cpp,c}
//

#include <cstdint>
#include <stddef.h>
#include <stdint.h>

typedef uint16_t RESTYPE;
typedef uint32_t STRREF;

//
// High level flow:
// 1) Check ABI version (You must do this to ensure you're not loading a incompatible library)
//    - scriptCompApiGetABIVersion
// 2) Create a compiler instance, give it callbacks into your space.
//    - scriptCompApiNewCompiler
// 3) Call init, as that sets up the language spec.
//    - scriptCompApiInitCompiler
// 4) Compile one or more files. The files and all needed includes will be requested
//    during this call (via the ResManLoadScriptSourceFile callback).
//    After compilation, the compiler will call the ResManWriteToFile callback
//    to write the compiled file and optionally the debug file.
//    - scriptCompApiCompileFile
// 5) Don't forget to destroy the compiler instance when you're done.
//    - scriptCompApiDestroyCompiler
//

//
// Called by the compiler when it wants to write a file.
// Return 0 on success, or an error STRREF on failure.
//
typedef int32_t (*ResManWriteToFile)(const char* sFileName, RESTYPE nResType, const uint8_t* pData,
    size_t nSize, bool bBinary);

//
// Called by the compiler when it wants the contents of a script file.
//
// Call Compiler->DeliverFile(...) to satisfy the request during the invocation
// of this callback. The convoluted to/from is to work around managed memory
// tracking issues on some languages.
//
// Return true if you serviced the request. Returning false indicates the
// requested file does not exist; in which case you do not have to call
// Compiler->DeliverFile(...).
//
typedef bool (*ResManLoadScriptSourceFile)(const char* fn, RESTYPE rt);

class CScriptCompiler;

struct NativeCompileResult
{
    // 0: OK, otherwise -(TLK) entry of error code.
    int32_t code;
    // This is a static buffer managed by the compiler.
    const char* str;
};

//
// Get the ABI version of the compiler API.
// This is used to ensure that the compiler and the client are compatible.
// Clients using this ABI must check the version before using it, and abort
// if it is a mismatch.
//
extern "C" int32_t scriptCompApiGetABIVersion();

//
// Create a new compiler instance.
//
// The compiler will use the given language specifier to load the identifier spec file
// as the first request; if you fail to service it, you will likely crash.
//
extern "C" CScriptCompiler* scriptCompApiNewCompiler(int src, // 2009 = nss
    int bin,                                                  // 2010 = ncs
    int dbg,                                                  // 2064 = ndb
    ResManWriteToFile resManWriteToFile, ResManLoadScriptSourceFile resManLoadScriptSourceFile);

//
// Initialize the compiler instance.
// You MUST call this after NewCompiler. This is a separate step to allow
// setting up callbacks and returning a instance.
//
extern "C" void scriptCompApiInitCompiler(CScriptCompiler* instance,
    const char* lang,       // usually "nwscript"
    bool writeDebug = true, // Also emit NDB files
    int maxIncludeDepth = 16,
    // Graphviz output path (writes file directly, does not go trough ResManWriteToFile)
    const char* graphvizOut = nullptr, const char* outputAlias = "scriptout");

//
// The compiler will use the given callbacks to load files and write output.
// Upon completion of the compile, the compiler will call the write callback
// to write the compiled file and optionally the debug file.
// If the script is not compilable, the callback will never be invoked; instead, you will
// get a STRREF error code in the result.
//
extern "C" NativeCompileResult scriptCompApiCompileFile(CScriptCompiler* instance,
    const char* filename);

//
// Deliver a requested file to the compiler. Behavior is undefined
// outside of the ResManLoadScriptSourceFile callback.
//
extern "C" void scriptCompApiDeliverFile(CScriptCompiler* instance, const char* data, size_t size);

//
// Get the current optimization flags.
// This is a bitmask of CSCRIPTCOMPILER_OPTIMIZE_* values.
// The default is CSCRIPTCOMPILER_OPTIMIZE_EVERYTHING.
//
extern "C" uint32_t scriptCompApiGetOptimizationFlags(CScriptCompiler* instance);

//
// Set the optimization flags.
// This allows you to toggle optimizations without re-creating the compiler.
//
extern "C" void scriptCompApiSetOptimizationFlags(CScriptCompiler* instance, uint32_t flags);

//
// Set the compiler to generate debugger output.
// This allows you to toggle the generation of NDB files without re-creating the compiler.
//
extern "C" void scriptCompApiSetGenerateDebuggerOutput(CScriptCompiler* instance, bool state);

extern "C" void scriptCompApiDestroyCompiler(CScriptCompiler* instance);
