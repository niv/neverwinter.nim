#include "native/exobase.h"
#include "native/scriptcomp.h"

extern "C" CScriptCompiler* scriptCompApiNewCompiler(
    int src, int bin, int dbg,
    int32_t (*ResManWriteToFile)(const char* sFileName, RESTYPE nResType, const uint8_t* pData, size_t nSize, bool bBinary),
    bool (*ResManLoadScriptSourceFile)(const char* fn, RESTYPE rt)
)
{
    CScriptCompilerAPI api;
    api.ResManUpdateResourceDirectory = +[](const char* sAlias) -> BOOL { return FALSE; };
    api.ResManWriteToFile = ResManWriteToFile;
    api.ResManLoadScriptSourceFile = ResManLoadScriptSourceFile;
    return new CScriptCompiler(src, bin, dbg, api);
}

extern "C" void scriptCompApiInitCompiler(
    CScriptCompiler* instance,
    const char* lang,
    bool writeDebug,
    int maxIncludeDepth,
    const char *graphvizOut,
    const char* outputAlias
)
{
    instance->SetGenerateDebuggerOutput(writeDebug);
    instance->SetOptimizationFlags(writeDebug ? CSCRIPTCOMPILER_OPTIMIZE_NOTHING : CSCRIPTCOMPILER_OPTIMIZE_EVERYTHING);
    instance->SetCompileConditionalOrMain(1);
    instance->SetIdentifierSpecification(lang);
    instance->SetOutputAlias(outputAlias);
    instance->SetMaxIncludeDepth(maxIncludeDepth);
    instance->SetGraphvizOutputPath(graphvizOut);
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

    ret.str = ret.code ? (char*)instance->GetCapturedError()->CStr() : (char*)"";
    return ret;
}

extern "C" void scriptCompApiDeliverFile(CScriptCompiler* instance, const char* data, size_t size)
{
    instance->DeliverRequestedFile(data, size);
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

extern "C" void scriptCompApiDestroyCompiler(CScriptCompiler* instance)
{
    delete instance;
}
