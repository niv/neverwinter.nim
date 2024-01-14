#include "native/exobase.h"
#include "native/scriptcomp.h"

extern "C" CScriptCompiler* scriptCompApiNewCompiler(
    char* lang, int src, int bin, int dbg,
    int32_t (*ResManWriteToFile)(const char* sFileName, RESTYPE nResType, const uint8_t* pData, size_t nSize, bool bBinary),
    const char* (*ResManLoadScriptSourceFile)(const char* fn, RESTYPE rt),
    const char* (*TlkResolve)(STRREF strRef),
    bool writeDebug,
    int maxIncludeDepth
)
{
    CScriptCompilerAPI api;
    api.ResManUpdateResourceDirectory = +[](const char* sAlias) -> BOOL { return FALSE; };
    api.ResManWriteToFile = ResManWriteToFile;
    api.ResManLoadScriptSourceFile = ResManLoadScriptSourceFile;
    api.TlkResolve = TlkResolve;
    CScriptCompiler* instance = new CScriptCompiler(src, bin, dbg, api);
    instance->SetGenerateDebuggerOutput(writeDebug);
    instance->SetOptimizationFlags(writeDebug ? CSCRIPTCOMPILER_OPTIMIZE_NOTHING : CSCRIPTCOMPILER_OPTIMIZE_EVERYTHING);
    instance->SetCompileConditionalOrMain(1);
    instance->SetIdentifierSpecification(lang);
    instance->SetOutputAlias("scriptout");
    instance->SetMaxIncludeDepth(maxIncludeDepth);
    return instance;
}

struct NativeCompileResult
{
    int32_t code;
    char* str; // static buffer
};

extern "C" NativeCompileResult scriptCompApiCompileFile(CScriptCompiler* instance, char* filename)
{
    NativeCompileResult ret;

    ret.code = instance->CompileFile(filename);

    // Sometimes, CompileFile returns 1 or -1; in which case the error sould be in CapturedError.
    // Forward from there.
    if (ret.code == 1 || ret.code == -1)
    {
        ret.code = instance->GetCapturedErrorStrRef();
        assert(ret.code != 0);
        if (ret.code == 0)
            ret.code = STRREF_CSCRIPTCOMPILER_ERROR_FATAL_COMPILER_ERROR;
    }

    ret.str = ret.code ? instance->GetCapturedError()->CStr() : (char*)"";
    return ret;
}

extern "C" uint32_t scriptCompApiGetOptimizationFlags(CScriptCompiler* instance)
{
    return instance->GetOptimizationFlags();
}

extern "C" void scriptCompApiSetOptimizationFlags(CScriptCompiler* instance, uint32_t flags)
{
    instance->SetOptimizationFlags(flags);
}

extern "C" void scriptCompApiSetGenerateDebuggerOutput(CScriptCompiler* instance, uint32_t state)
{
    instance->SetGenerateDebuggerOutput(state);
}
