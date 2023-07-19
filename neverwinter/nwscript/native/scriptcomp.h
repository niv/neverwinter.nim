//
// SPDX-License-Identifier: GPL-3.0
//
// This file is part of the NWScript compiler open source release.
//
// The initial source release is licensed under GPL-3.0.
//
// All subsequent changes you submit are required to be licensed under MIT.
//
// However, the project overall will still be GPL-3.0.
//
// The intent is for the base game to be able to pick up changes you explicitly
// submit for inclusion painlessly, while ensuring the overall project source code
// remains available for everyone.
//

#pragma once

#include <vector>

#include "exobase.h"
#include "scripterrors.h"

// Classes defined in scriptinternal.h
class CScriptParseTreeNode;
class CScriptParseTreeNodeBlock;
class CScriptCompilerStackEntry;
class CScriptCompilerIdListEntry;
class CScriptSourceFile;
class CScriptCompilerVarStackEntry;
class CScriptCompilerStructureEntry;
class CScriptCompilerStructureFieldEntry;
class CScriptCompilerSymbolTableEntry;
class CScriptCompilerKeyWordEntry;
class CScriptCompilerIdentifierHashTableEntry;

// Defines required for static size of values.
#define CSCRIPTCOMPILER_MAX_TABLE_FILENAMES  512
#define CSCRIPTCOMPILER_MAX_TOKEN_LENGTH     8192
#define CSCRIPTCOMPILER_MAX_INCLUDE_LEVELS   16
#define CSCRIPTCOMPILER_MAX_RUNTIME_VARS     8192

#define CSCRIPTCOMPILERIDLISTENTRY_MAX_PARAMETERS 32

//
// Compiler optimization flags.
// Note that some optimizations might interfere with NDB generation.
//

// Removes any functions that cannot possibly be called by any codepath
#define CSCRIPTCOMPILER_OPTIMIZE_DEAD_FUNCTIONS                       0x00000001
// Merges constant expressions into a single constant where possible.
// Note: Only affects runtime expressions, assignments to const variables are always folded.
#define CSCRIPTCOMPILER_OPTIMIZE_FOLD_CONSTANTS                       0x00000002
// Post processes generated instructions to merge sequences into shorter equivalents
#define CSCRIPTCOMPILER_OPTIMIZE_MELD_INSTRUCTIONS                    0x00000004

#define CSCRIPTCOMPILER_OPTIMIZE_NOTHING                              0x00000000
#define CSCRIPTCOMPILER_OPTIMIZE_EVERYTHING                           0xFFFFFFFF


class CScriptCompilerIncludeFileStackEntry
{
public:
	CExoString m_sCompiledScriptName;
	CExoString m_sSourceScript;

	// A stack of internal variables (used when processing includes to preserve
	// the previous state of the scripting language).
	int32_t m_nLine;
	int32_t m_nCharacterOnLine;
	int32_t m_nTokenStatus;
	int32_t m_nTokenCharacters;
};

class CScriptCompiler;

// Functions you need to implement when invoking script compiler.
// Default impl for game is in scriptcompapi.cpp.
struct CScriptCompilerAPI
{
    CScriptCompilerAPI() { memset(this, 0, sizeof(CScriptCompilerAPI)); }

    // Update resman resource dir (reload/reindex).
    BOOL (*ResManUpdateResourceDirectory)(const char* sAlias);

    // Return 0 if OK, or error STRREF on failure (scripterrors.h)
    int32_t (*ResManWriteToFile)(const char* sFileName, RESTYPE nResType, const uint8_t* pData, size_t nSize, bool bBinary);

    // Read the given filename+restype from resman, and return a zero-terminated string containing
    // the content (up to the first null terminator). Returns nullptr if the file cannot be read/loaded.
    // The returned string is a global static buffer and must not be freed by you.
    // Repeated calls to this function will replace the buffer.
    // Please see the default impl in scriptcompapi.cpp for load semantics (e.g. it will serve up .nss files for .css files when not found).
    const char* (*ResManLoadScriptSourceFile)(const char* sFileName, RESTYPE nResType);

    // Returns zero-terminated string, or "" if lookup failed.
    // The returned string is a global static buffer and must not be freed by you.
    // Repeated calls to this function will replace the buffer.
    const char* (*TlkResolve)(STRREF strRef);
};


class CScriptCompiler
{
    // This can be left unimplemented on custom compilers, as long as you provide
    // callbacks to the constructor,
    static CScriptCompilerAPI MakeDefaultAPI();

    CScriptCompilerAPI m_cAPI;

	// *************************************************************************
public:
	// *************************************************************************
	explicit CScriptCompiler(RESTYPE nSource, RESTYPE nCompiled, RESTYPE nDebug,
        // When not given, uses default API as defined in scriptcompapi.cpp.
        // This is a concession to not changing all callsites.
        CScriptCompilerAPI api = MakeDefaultAPI());
	~CScriptCompiler();

	///////////////////////////////////////////////////////////////////////
	void SetIdentifierSpecification(const CExoString &sLanguageSource);
	//---------------------------------------------------------------------
	// Desc.: This routine will set the identifier specification that you
	//        want to use when compiling.
	//
	// sLanguageSource:  (IN) An .nss file containing the definition of
	//                        the language
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void SetOutputAlias(const CExoString &sAlias);
	//---------------------------------------------------------------------
	// Desc.: This routine will set the alias used by CompileFile to
	//        determine where to write the output code.
	//
	// sAlias:  (See ExoAlias for a description of how the aliases are
	//           used.)  This alias will be used by ExoResMan to target
	//           the output of the code.
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void SetGenerateDebuggerOutput(int32_t nValue);
	//---------------------------------------------------------------------
	// Desc.: This routine will determine whether a .ndb file will also
	//        be generated at the same time as the .ncs file.
	//
	// nValue:  (IN) A value to determine the type of output.
	//
	//          0:  No .ndb file will be generated.
	//          1:  An .ndb file will be generated.  This information, in
	//              addition to the .ncs file, will allow the debugger to
	//              behave correctly.
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void SetOptimizationFlags(uint32_t nFlags) { m_nOptimizationFlags = nFlags; }
	uint32_t GetOptimizationFlags() { return m_nOptimizationFlags; }

	///////////////////////////////////////////////////////////////////////
	void SetAutomaticCleanUpAfterCompiles(BOOL bValue);
	//---------------------------------------------------------------------
	// Desc.: This routine will determine whether CompileFile will make
	//        automatic updates to the Output Directory in the resouce
	//        manager, and clean up large buffers used to compile a file.
	//
	// nValue:  (IN) A value to determine the type of output.
	//
	//          FALSE:  Does not attempt to call the resource manager to
	//              update the output directory.  If you set this value
	//              to false, you are responsible for calling
	//              CScriptCompiler::CleanUpAfterCompiles() before
	//              you attempt to use these files.
	//
	//          TRUE (default):  After each .ncs and .ndb file is created,
	//              the directory where the file is created is updated
	//              in the resource manager and some "memory leaks" are
	//              removed.  This is the best choice if you don't know
	//              how to use this.  (Other than actually talking to
	//              Mark, or looking in the Test_CompileAllFilesInDirectory
	//              function for how to use a value of FALSE correctly!)
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void CleanUpAfterCompiles();
	//---------------------------------------------------------------------
	// Desc.: This routine will update the output directory (set by
	//        CScriptCompiler::SetOutputAlias).  This is required to be
	//        done before you can access any files compiled with
	//        CleanUpAfterCompiles set to FALSE.  It will also delete any
	//        buffers created during compilation that are required.
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void SetCompileConditionalFile(BOOL nValue);
	//---------------------------------------------------------------------
	// Desc.: This routine will set the type of output generated by the
	//        parsing routine.
	//
	// nValue:  (IN) A value to determine the type of output.
	//
	//          0:  Will compile files that have a "void main()" in them.
	//
	//          1:  Will compile files that have an
	//              "int StartingConditional()" in them.
	//
	//          An error will result, depending on the value of this
	//          parameter, if the wrong type of file is attempted to be
	//          passed through CompileFile()
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void SetCompileConditionalOrMain(BOOL nValue);
	//---------------------------------------------------------------------
	// Desc.: This routine will set the type of output generated by the
	//        parsing routine.
	//
	// bValue:  (IN) A value to determine the type of output.
	//
	//          0:  Will compile files based on CompileConditionalFile.
	//
	//          1:  Will compile files that have a void main() by
	//              preference.  It will compile int StartingConditional()
	//              files if we can't find a void main() function.
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	int32_t CompileFile(const CExoString &sFileName);
	//---------------------------------------------------------------------
	// Desc.: This routine will generate whether the code in the file
	//        specified in sFileName is a valid Script, and then write
	//        the output to sFileName.ncs
	//
	// sFileName:  (IN) The name of the file to compile.
	//
	// Returns:  0 if the script is valid and output has been generated,
	//           and a value other than zero if there is an error during
	//           compilation!
	//
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	int32_t CompileScriptChunk(const CExoString &sScriptChunk, BOOL bWrapIntoMain);
	//---------------------------------------------------------------------
	// Desc.: This routine will attempt to generate code from the string
	//        passed in.
	//
	// sFileName:  (IN) The script to compile.
	//
	// Returns:  0 if the script is valid, and a value other than zero if
	//           there is an error during parsing.
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	int32_t CompileScriptConditional(const CExoString &sScriptConditional);
	//---------------------------------------------------------------------
	// Desc.: This routine will generate whether the code in the string
	//        specified (sStringData) is a valid Script.
	//
	// sFileName:  (IN) The script to compile.
	//
	// Returns:  0 if the script is valid, and a value other than zero if
	//           there is an error during parsing.
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	int32_t GetCompiledScriptCode(char **pnCode, int32_t *nCodeSize);
	//---------------------------------------------------------------------
	// Desc.: This routine will allow you to access the code generated by
	//        CompileScript
	//
	// pnCode [OUT]:  Will point to the new location of the code.
	//
	// nCodeSize [OUT]:  Will point to the size of the new code.
	//
	// Returns:  0 if successful, non-zero if there is no code available.
	///////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////
	void ClearCompiledScriptCode();
	//---------------------------------------------------------------------
	// Desc.: This routine will remove the code that has been run.
	///////////////////////////////////////////////////////////////////////

	// Returns the captured error string for use by tools that don't need
	// to access the log.
	CExoString *GetCapturedError() { return &m_sCapturedError; }

    STRREF GetCapturedErrorStrRef() const { return m_nCapturedErrorStrRef; }

	int32_t WriteFinalCodeToFile(const CExoString &sFileName);
	int32_t WriteDebuggerOutputToFile(CExoString sFileName);

	// *************************************************************************
private:
	// *************************************************************************

    RESTYPE m_nResTypeSource;
    RESTYPE m_nResTypeCompiled;
    RESTYPE m_nResTypeDebug;

	void Initialize();
	void ShutDown();

	uint32_t HashString(const CExoString &sString);
	uint32_t HashString(const char *pString);
	void InitializePreDefinedStructures();
	void InitializeIncludeFile(int32_t nCompileFileLevel);
	void ShutdownIncludeFile(int32_t nCompileFileLevel);

	void TokenInitialize();

	void PushSRStack(int32_t nState, int32_t nRule, int32_t nTerm,
	                 CScriptParseTreeNode *pCurrentTree);
	int32_t PopSRStack(int32_t *nState,int32_t *nRule, int32_t *nTerm,
	               CScriptParseTreeNode **pCurrentTree,
	               CScriptParseTreeNode **pReturnTree );
	void ModifySRStackReturnTree( CScriptParseTreeNode *pReturnTree );

	int32_t GenerateParseTree();

	float ParseFloatFromTokenString();

	int32_t HandleToken();
	int32_t TestIdentifierToken();
	int32_t HandleIdentifierToken();
	int32_t m_nKeyWords;
	CScriptCompilerKeyWordEntry *m_pcKeyWords;

	int32_t ParseCharacterNumeric(int32_t ch);
	int32_t ParseCharacterPeriod(int32_t chNext);
	int32_t ParseCharacterSlash(int32_t chNext);
	int32_t ParseCharacterAsterisk(int32_t chNext);
	int32_t ParseCharacterAmpersand(int32_t chNext);
	int32_t ParseCharacterVerticalBar(int32_t chNext);
	int32_t ParseCharacterAlphabet(int32_t ch);
	int32_t ParseStringCharacter(int32_t ch, int32_t chNext, char *pScript, int32_t nScriptLength);
	int32_t ParseRawStringCharacter(int32_t ch, int32_t chNext);
	int32_t ParseCharacterQuotationMark();
	int32_t ParseCharacterHyphen(int32_t chNext);
	int32_t ParseCharacterLeftBrace();
	int32_t ParseCharacterRightBrace();
	int32_t ParseCharacterLeftBracket();
	int32_t ParseCharacterRightBracket();
	int32_t ParseCharacterLeftSquareBracket();
	int32_t ParseCharacterRightSquareBracket();
	int32_t ParseCharacterLeftAngle(int32_t chNext);
	int32_t ParseCharacterRightAngle(int32_t chNext);
	int32_t ParseCharacterExclamationPoint(int32_t chNext);
	int32_t ParseCharacterEqualSign(int32_t chNext);
	int32_t ParseCharacterPlusSign(int32_t chNext);
	int32_t ParseCharacterPercentSign(int32_t chNext);
	int32_t ParseCharacterSemicolon();
	int32_t ParseCharacterComma();
	int32_t ParseCharacterCarat(int32_t chNext);
	int32_t ParseCharacterTilde();
	int32_t ParseCharacterEllipsis();
	int32_t ParseCharacterQuestionMark();
	int32_t ParseCharacterColon();

	int32_t ParseCommentedOutCharacter(int32_t ch);

	int32_t ParseNextCharacter(int32_t ch, int32_t chNext, char *pScript, int32_t nScriptLength);

	int32_t PrintParseSourceError(int32_t nParseCharacterError);
	int32_t ParseSource(char *pScript, int32_t nScriptLength);

	int32_t OutputError(int32_t nError, CExoString *psFileName, int32_t nLineNumber, const CExoString &sErrorText);
	CScriptParseTreeNode *DuplicateScriptParseTree(CScriptParseTreeNode *pNode);
	CScriptParseTreeNode *CreateScriptParseTreeNode(int32_t nNodeOperation, CScriptParseTreeNode *pNodeLeft, CScriptParseTreeNode *pNodeRight);
	BOOL CheckForBadLValue(CScriptParseTreeNode *pNode);
	void DeleteScriptParseTreeNode(CScriptParseTreeNode *pParseTreeNode);
	CScriptParseTreeNode *GetNewScriptParseTreeNode();

	int32_t                        m_nParseTreeNodeBlockEmptyNodes;
	CScriptParseTreeNodeBlock *m_pCurrentParseTreeNodeBlock;
	CScriptParseTreeNodeBlock *m_pParseTreeNodeBlockHead;
	CScriptParseTreeNodeBlock *m_pParseTreeNodeBlockTail;

	int32_t OutputWalkTreeError(int32_t nError, CScriptParseTreeNode *pNode);
	int32_t PreVisitGenerateCode(CScriptParseTreeNode *pNode);
	int32_t InVisitGenerateCode(CScriptParseTreeNode *pNode);
	int32_t PostVisitGenerateCode(CScriptParseTreeNode *pNode);

	void WriteByteSwap32(char *buffer, int32_t value);
	int32_t ReadByteSwap32(char *buffer);
	char *EmitInstruction(uint8_t nOpCode, uint8_t nAuxCode = 0, int32_t nDataSize = 0);
	void EmitModifyStackPointer(int32_t nModifyBy);

	CExoString **m_ppsParseTreeFileNames;
	int32_t m_nNextParseTreeFileName;
	int32_t m_nCurrentParseTreeFileName;
	void StartLineNumberAtBinaryInstruction(int32_t nFileReference, int32_t nLineNumber, int32_t nBinaryInstruction);
	void EndLineNumberAtBinaryInstruction(int32_t nFileReference, int32_t nLineNumber, int32_t nBinaryInstruction);
	void ResolveDebuggingInformation();
	void ResolveDebuggingInformationForIdentifier(int32_t nIdentifier);

	int32_t m_nCurrentLineNumber;
	int32_t m_nCurrentLineNumberFileReference;
	int32_t m_nCurrentLineNumberReferences;
	int32_t m_nCurrentLineNumberBinaryStartInstruction;
	int32_t m_nCurrentLineNumberBinaryEndInstruction;

	int32_t m_nTableFileNames;
	CExoString m_psTableFileNames[CSCRIPTCOMPILER_MAX_TABLE_FILENAMES];
	int32_t m_nLineNumberEntries;
	int32_t m_nFinalLineNumberEntries;
	std::vector<int32_t> m_pnTableInstructionFileReference;
	std::vector<int32_t> m_pnTableInstructionLineNumber;
	std::vector<int32_t> m_pnTableInstructionBinaryStart;
	std::vector<int32_t> m_pnTableInstructionBinaryEnd;
	std::vector<int32_t> m_pnTableInstructionBinaryFinal;
	std::vector<int32_t> m_pnTableInstructionBinarySortedOrder;

	int32_t m_nSymbolTableVariables;
	int32_t m_nFinalSymbolTableVariables;
	std::vector<int32_t> m_pnSymbolTableVarType;
	std::vector<CExoString> m_psSymbolTableVarName;
	std::vector<CExoString> m_psSymbolTableVarStructureName;
	std::vector<int32_t> m_pnSymbolTableVarStackLoc;
	std::vector<int32_t> m_pnSymbolTableVarBegin;
	std::vector<int32_t> m_pnSymbolTableVarEnd;
	std::vector<int32_t> m_pnSymbolTableBinaryFinal;
	std::vector<int32_t> m_pnSymbolTableBinarySortedOrder;


	void DeleteCompileStack();
	void DeleteParseTree(BOOL bStack, CScriptParseTreeNode *pNode);
	int32_t WalkParseTree(CScriptParseTreeNode *pNode);

	void InitializeFinalCode();
	void FinalizeFinalCode();
	int32_t GenerateFinalCodeFromParseTree(CExoString sFileName);

	CExoString GenerateDebuggerTypeAbbreviation(int32_t nType, CExoString sStructureName);

	BOOL m_bCompileConditionalFile;
	BOOL m_bOldCompileConditionalFile;
	BOOL m_bCompileConditionalOrMain;
	CExoString m_sLanguageSource;
	CExoString m_sOutputAlias;

	int32_t m_nLines;
	int32_t m_nCharacterOnLine;

	// Variable for storing the values for each character (assembled in HashString) for identifiers
	int32_t *m_pnHashString;
	// The actual hash table.
	CScriptCompilerIdentifierHashTableEntry *m_pIdentifierHashTable;
	uint32_t HashManagerAdd(uint32_t nType, uint32_t nTypeIndice);
	uint32_t HashManagerDelete(uint32_t nType, uint32_t nTypeIndice);
	int32_t GetHashEntryByName(const char *psIdentifierName);

	// Status of the current token
	int32_t m_nTokenStatus;
	int32_t m_nTokenCharacters;
	char m_pchToken[CSCRIPTCOMPILER_MAX_TOKEN_LENGTH];

	// Status of the current "compile stack"
	CScriptCompilerStackEntry *m_pSRStack;
	int32_t m_nSRStackEntries;
	int32_t m_nSRStackStates;


	// Identifiers (read from language definition file)
	int32_t m_bCompileIdentifierList;
	int32_t m_bCompileIdentifierConstants;
	int32_t m_nIdentifierListState;
	int32_t m_nIdentifierListVector;
	int32_t m_nIdentifierListEngineStructure;
	int32_t m_nIdentifierListReturnType;
	CScriptCompilerIdListEntry *m_pcIdentifierList;
	int32_t m_nOccupiedIdentifiers;
	int32_t m_nMaxPredefinedIdentifierId;
	int32_t m_nPredefinedIdentifierOrder;

	int32_t PrintParseIdentifierFileError(int32_t nParseCharacterError);
	int32_t ParseIdentifierFile();
	int32_t GenerateIdentifierList();
	int32_t AddUserDefinedIdentifier(CScriptParseTreeNode *pFunctionDeclaration, BOOL bFunctionImplementation);
	void ClearUserDefinedIdentifiers();


	// A stack of includes.
	int32_t m_nCompileFileLevel;
	CScriptCompilerIncludeFileStackEntry m_pcIncludeFileStack[CSCRIPTCOMPILER_MAX_INCLUDE_LEVELS];


	// A Variable Stack
	int32_t m_nVarStackRecursionLevel;
	CScriptCompilerVarStackEntry *m_pcVarStackList;
	int32_t m_nOccupiedVariables;
	int32_t m_nVarStackVariableType;
	CExoString m_sVarStackVariableTypeName;

	// Global variable, Structure and structure field information.
	CScriptCompilerStructureEntry      *m_pcStructList;
	CScriptCompilerStructureFieldEntry *m_pcStructFieldList;
	int32_t m_nMaxStructures;
	int32_t m_nMaxStructureFields;
	int32_t m_nStructureDefinition;
	int32_t m_nStructureDefinitionFieldStart;
	int32_t GetStructureField(const CExoString &sStructureName, const CExoString &sFieldName);
	int32_t GetStructureSize(const CExoString &sStructureName);
	int32_t GetIdentifierByName(const CExoString &sIdentifierName);

	BOOL m_bGlobalVariableDefinition;
	int32_t m_nGlobalVariables;
	int32_t m_nGlobalVariableSize;  // size of all global variables in bytes.
	CScriptParseTreeNode *m_pGlobalVariableParseTree;
	int32_t AddToGlobalVariableList(CScriptParseTreeNode *pGlobalVariableNode);

	BOOL ConstantFoldNode(CScriptParseTreeNode *pNode, BOOL bForce=FALSE);

	BOOL m_bConstantVariableDefinition;

	int32_t m_nLoopIdentifier;
	int32_t m_nLoopStackDepth;

	int32_t m_nSwitchLevel;
	int32_t m_nSwitchIdentifier;
	int32_t m_nSwitchStackDepth;

	CExoString m_sUndefinedIdentifier;

	BOOL m_bSwitchLabelDefault;
	int32_t  m_nSwitchLabelNumber;
	int32_t  m_nSwitchLabelArraySize;
	int32_t* m_pnSwitchLabelStatements;
	void InitializeSwitchLabelList();
	int32_t  TraverseTreeForSwitchLabels(CScriptParseTreeNode *pNode);
	void ClearSwitchLabelList();
	int32_t  GenerateCodeForSwitchLabels(CScriptParseTreeNode *pNode);

	int32_t  GenerateIdentifiersFromConstantVariables(CScriptParseTreeNode *pNode);

	// Engine-defined structures that can be compiled, but
	// we don't actually do a lot with them during compilation
	int32_t m_nNumEngineDefinedStructures;
	BOOL *m_pbEngineDefinedStructureValid;
	CExoString *m_psEngineDefinedStructureName;

	int32_t m_bAssignmentToVariable;  // we're in the middle of processing an "assignment to a
	// variable.  This is a good thing.
	BOOL m_bInStructurePart;      // In an expression, we want to prevent the part name from
	// being looked up as a variable ... that'll be done at the
	// structure part node above this one.

	int32_t        FoundReturnStatementOnAllBranches(CScriptParseTreeNode *pNode);

	BOOL       m_bFunctionImp;
	CExoString m_sFunctionImpName;
	int32_t        m_nFunctionImpReturnType;
	CExoString m_sFunctionImpReturnStructureName;
	int32_t        m_nFunctionImpAbortStackPointer;

	// The Run-Time Stacks for Stuff.
	int32_t         m_nStackCurrentDepth;
	char        m_pchStackTypes[CSCRIPTCOMPILER_MAX_RUNTIME_VARS];

	void AddVariableToStack(int32_t nVariableType, CExoString *psVariableTypeName, BOOL bGenerateCode);
	void AddStructureToStack(const CExoString &sStructureName, BOOL bGenerateCode);

	void AddToSymbolTableVarStack(int32_t nOccupiedIdentifier, int32_t nStackCurrentDepth, int32_t nGlobalVariableSize);
	void RemoveFromSymbolTableVarStack(int32_t nOccupiedIdentifier, int32_t nStackCurrentDepth, int32_t nGlobalVariableSize);

	int32_t         m_nRunTimeIntegers;
	int32_t         m_nRunTimeFloats;
	int32_t         m_nRunTimeStrings;
	int32_t         m_nRunTimeObjects;
	int32_t         m_nRunTimeActions;

	// The symbols to be added in between the code generation and output passes.

	int32_t         m_nSymbolQueryListSize;
	int32_t         m_nSymbolQueryList;
	CScriptCompilerSymbolTableEntry *m_pSymbolQueryList;

	int32_t         m_nSymbolLabelListSize;
	int32_t         m_nSymbolLabelList;
	CScriptCompilerSymbolTableEntry *m_pSymbolLabelList;
	int32_t         m_pSymbolLabelStartEntry[512];

	CExoString  GetFunctionNameFromSymbolSubTypes(int32_t nSubType1,int32_t nSubType2);
	int32_t AddSymbolToQueryList(int32_t nLocationPointer, int32_t nSymbolType, int32_t nSymbolSubType1, int32_t nSymbolSubType2 = 0);
	int32_t AddSymbolToLabelList(int32_t nLocationPointer, int32_t nSymbolType, int32_t nSymbolSubType1, int32_t nSymbolSubType2 = 0);

	void ClearAllSymbolLists();

	int32_t CleanUpDuringCompile(int32_t nReturnValue);
	int32_t CleanUpAfterCompile(int32_t nReturnValue,CScriptParseTreeNode *pReturnTree);

	// Generation of Code
	int32_t         m_nGenerateDebuggerOutput;

	BOOL        m_bAutomaticCleanUpAfterCompiles;
	uint32_t    m_nOptimizationFlags;
	int32_t         m_nTotalCompileNodes;
	BOOL        m_bCompilingConditional;
	char       *m_pchOutputCode;
	int32_t         m_nOutputCodeSize;
	int32_t         m_nOutputCodeLength;
	std::vector<int32_t> m_aOutputCodeInstructionBoundaries;

	char *InstructionLookback(uint32_t last=1);

	// Resolving code to its proper location ... some buffers!
	char       *m_pchResolvedOutputBuffer;
	int32_t         m_nResolvedOutputBufferSize;

	// Generation of Debug Code
	char       *m_pchDebuggerCode;
	int32_t         m_nDebuggerCodeSize;
	int32_t         m_nDebuggerCodeLength;

	// These are used when parsing "operation action" commands to keep track of
	// what the actual parameters are.
	char m_pchActionParameters[CSCRIPTCOMPILERIDLISTENTRY_MAX_PARAMETERS];
	CExoString m_pchActionParameterStructureNames[CSCRIPTCOMPILERIDLISTENTRY_MAX_PARAMETERS];

	// Second Stage Of Code Generation
	int32_t         InstallLoader();
	CScriptParseTreeNode *InsertGlobalVariablesInParseTree(CScriptParseTreeNode *pOldTree);
	int32_t         OutputIdentifierError(const CExoString &sFunctionName, int32_t nError, int32_t nFileStackDrop = 0);
	int32_t         ValidateLocationOfIdentifier(const CExoString &sFunctionName);
	int32_t         DetermineLocationOfCode();
	int32_t         ResolveLabels();
	int32_t         WriteResolvedOutput();

	int32_t         m_nFinalBinarySize;

	// Error generation.

	CExoString  m_sCapturedError;
    STRREF      m_nCapturedErrorStrRef;

    void* m_pUserData;
};
