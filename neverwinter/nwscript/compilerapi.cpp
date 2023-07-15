#include "native/exobase.h"
#include "native/scriptcomp.h"

extern "C" CScriptCompiler* scriptCompApiNewCompiler(
    char* lang, int src, int bin, int dbg,
    int32_t (*ResManWriteToFile)(const char* sFileName, RESTYPE nResType, const uint8_t* pData, size_t nSize, bool bBinary),
    const char* (*ResManLoadScriptSourceFile)(const char* fn, RESTYPE rt),
    const char* (*TlkResolve)(STRREF strRef),
    bool writeDebug
)
{
    CScriptCompilerAPI api;
    api.ResManUpdateResourceDirectory = +[](const char* sAlias) -> BOOL { return FALSE; };
    api.ResManWriteToFile = ResManWriteToFile;
    api.ResManLoadScriptSourceFile = ResManLoadScriptSourceFile;
    api.TlkResolve = TlkResolve;
    CScriptCompiler* instance = new CScriptCompiler(src, bin, dbg, api);
    instance->SetGenerateDebuggerOutput(writeDebug);
    instance->SetOptimizeBinaryCodeLength(!writeDebug);
    instance->SetCompileConditionalOrMain(1);
    instance->SetIdentifierSpecification(lang);
    instance->SetOutputAlias("scriptout");
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
    ret.str = ret.code ? instance->GetCapturedError()->CStr() : (char*)"";
    return ret;
}
