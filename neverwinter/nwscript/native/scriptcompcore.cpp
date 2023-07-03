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

///////////////////////////////////////////////////////////////////////////////
//                 BIOWARE CORP. CONFIDENTIAL INFORMATION.                   //
//               COPYRIGHT BIOWARE CORP. ALL RIGHTS RESERVED                 //
///////////////////////////////////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////////
//::
//::  Script Project
//::
//::  Copyright (c) 2002, BioWare Corp.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  ScriptCompCore.cpp
//::
//::  Implementation of conversion from scripting language to virtual machine
//::  code.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Mark Brockington
//::  Created On: Oct. 8, 2002
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  This file contains "ported" code (used when writing out floating point
//::  numbers on the MacIntosh platforms.
//::
//::///////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <string.h>

// external header files
#include "exobase.h"
#include "scriptcomp.h"

// internal header files
#include "scriptinternal.h"

//::///////////////////////////////////////////////////////////////////////////
//::
//::  class CScriptCompilerIdListEntry
//::
//::///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompilerIdListEntry::CScriptCompilerIdListEntry()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 05/18/2001
//  Description:  Default constructor for class.
///////////////////////////////////////////////////////////////////////////////

CScriptCompilerIdListEntry::CScriptCompilerIdListEntry()
{
	m_nIdentifierType = 0;
	m_nReturnType = 0;
	m_bImplementationInPlace = FALSE;

	m_nIntegerData = 0;
	m_fFloatData = 0.0f;
	m_fVectorData[0] = 0.0f;
	m_fVectorData[1] = 0.0f;
	m_fVectorData[2] = 0.0f;
	m_nParameters = 0;
	m_nNonOptionalParameters = 0;

	m_nParameterSpace = 0;
	m_pchParameters = NULL;
	m_psStructureParameterNames = NULL;
	m_pbOptionalParameters = NULL;
	m_pnOptionalParameterIntegerData = NULL;
	m_pfOptionalParameterFloatData = NULL;
	m_psOptionalParameterStringData = NULL;
	m_poidOptionalParameterObjectData = NULL;
	m_pfOptionalParameterVectorData = NULL;

	m_nBinarySourceStart = -1;
	m_nBinarySourceFinish = -1;
	m_nBinaryDestinationStart = -1;
	m_nBinaryDestinationFinish = -1;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompilerIdListEntry::~CScriptCompilerIdListEntry()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/10/2001
//  Description:  Default destructor for class.
///////////////////////////////////////////////////////////////////////////////
CScriptCompilerIdListEntry::~CScriptCompilerIdListEntry()
{

	// Delete the allocated arrays.
	if (m_pchParameters)
	{
		delete[] m_pchParameters;
	}
	if (m_psStructureParameterNames)
	{
		delete[] m_psStructureParameterNames;
	}
	if (m_pbOptionalParameters)
	{
		delete[] m_pbOptionalParameters;
	}
	if (m_pnOptionalParameterIntegerData)
	{
		delete[] m_pnOptionalParameterIntegerData;
	}
	if (m_pfOptionalParameterFloatData)
	{
		delete[] m_pfOptionalParameterFloatData;
	}
	if (m_psOptionalParameterStringData)
	{
		delete[] m_psOptionalParameterStringData;
	}
	if (m_poidOptionalParameterObjectData)
	{
		delete[] m_poidOptionalParameterObjectData;
	}
	if (m_pfOptionalParameterVectorData)
	{
		delete[] m_pfOptionalParameterVectorData;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompilerIdListEntry::ExpandParameterSpace()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 05/18/2001
//  Description:  Used to expand the parameter space (when required).
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompilerIdListEntry::ExpandParameterSpace()
{
	int32_t nNewParameterSpace;

	if (m_nParameterSpace == CSCRIPTCOMPILERIDLISTENTRY_MAX_PARAMETERS)
	{
		return STRREF_CSCRIPTCOMPILER_ERROR_TOO_MANY_PARAMETERS_ON_FUNCTION;
	}

	if (m_nParameterSpace == 0)
	{
		nNewParameterSpace = 4;
	}
	else
	{
		nNewParameterSpace = m_nParameterSpace * 2;
	}

	// Declare the new arrays.
	char       *pchNewParameters                    = new char[nNewParameterSpace];
	CExoString *psNewStructureParameterNames        = new CExoString[nNewParameterSpace];
	BOOL       *pbNewOptionalParameters             = new BOOL[nNewParameterSpace];
	int32_t        *pnNewOptionalParameterIntegerData   = new int32_t[nNewParameterSpace];
	float      *pfNewOptionalParameterFloatData     = new float[nNewParameterSpace];
	CExoString *psNewOptionalParameterStringData    = new CExoString[nNewParameterSpace];
	OBJECT_ID  *poidNewOptionalParameterObjectData  = new OBJECT_ID[nNewParameterSpace];
	float      *pfNewOptionalParameterVectorData    = new float[nNewParameterSpace * 3];

	// Copy the old values to the new arrays.
	int32_t nCount;

	if (m_nParameterSpace != 0)
	{
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			pchNewParameters[nCount]                   = m_pchParameters[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			psNewStructureParameterNames[nCount]       = m_psStructureParameterNames[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			pbNewOptionalParameters[nCount]            = m_pbOptionalParameters[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			pnNewOptionalParameterIntegerData[nCount]  = m_pnOptionalParameterIntegerData[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			pfNewOptionalParameterFloatData[nCount]    = m_pfOptionalParameterFloatData[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			psNewOptionalParameterStringData[nCount]   = m_psOptionalParameterStringData[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace; nCount++)
		{
			poidNewOptionalParameterObjectData[nCount] = m_poidOptionalParameterObjectData[nCount];
		}
		for (nCount = 0; nCount < m_nParameterSpace * 3; nCount++)
		{
			pfNewOptionalParameterVectorData[nCount]   = m_pfOptionalParameterVectorData[nCount];
		}
	}

	// Oh, yeah, it's a good idea to declare what the values are!
	for (nCount = m_nParameterSpace; nCount < nNewParameterSpace; nCount++)
	{
		pchNewParameters[nCount]                   = 0;
		psNewStructureParameterNames[nCount]       = "";
		pbNewOptionalParameters[nCount]            = FALSE;
		pnNewOptionalParameterIntegerData[nCount]  = 0;
		pfNewOptionalParameterFloatData[nCount]    = 0.0f;
		psNewOptionalParameterStringData[nCount]   = "";
		poidNewOptionalParameterObjectData[nCount] = INVALID_OBJECT_ID;
	}

	for (nCount = m_nParameterSpace * 3; nCount < nNewParameterSpace * 3; nCount++)
	{
		pfNewOptionalParameterVectorData[nCount]   = 0.0f;
	}

	m_nParameterSpace = nNewParameterSpace;

	// Delete the old arrays.
	if (m_pchParameters)
	{
		delete[] m_pchParameters;
	}
	if (m_psStructureParameterNames)
	{
		delete[] m_psStructureParameterNames;
	}
	if (m_pbOptionalParameters)
	{
		delete[] m_pbOptionalParameters;
	}
	if (m_pnOptionalParameterIntegerData)
	{
		delete[] m_pnOptionalParameterIntegerData;
	}
	if (m_pfOptionalParameterFloatData)
	{
		delete[] m_pfOptionalParameterFloatData;
	}
	if (m_psOptionalParameterStringData)
	{
		delete[] m_psOptionalParameterStringData;
	}
	if (m_poidOptionalParameterObjectData)
	{
		delete[] m_poidOptionalParameterObjectData;
	}
	if (m_pfOptionalParameterVectorData)
	{
		delete[] m_pfOptionalParameterVectorData;
	}

	m_pchParameters                   = pchNewParameters;
	m_psStructureParameterNames       = psNewStructureParameterNames;
	m_pbOptionalParameters            = pbNewOptionalParameters;
	m_pnOptionalParameterIntegerData  = pnNewOptionalParameterIntegerData;
	m_pfOptionalParameterFloatData    = pfNewOptionalParameterFloatData;
	m_psOptionalParameterStringData   = psNewOptionalParameterStringData;
	m_poidOptionalParameterObjectData = poidNewOptionalParameterObjectData;
	m_pfOptionalParameterVectorData   = pfNewOptionalParameterVectorData;

	return 0;
}

//::///////////////////////////////////////////////////////////////////////////
//::
//::  class CScriptCompiler
//::
//::///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CScriptCompiler()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Default constructor for class.
///////////////////////////////////////////////////////////////////////////////

CScriptCompiler::CScriptCompiler(RESTYPE nSource, RESTYPE nCompiled, RESTYPE nDebug, CScriptCompilerAPI api)
{
    m_cAPI = api;

	m_nDebugSymbolicOutput = 0;
	m_nGenerateDebuggerOutput = 1;

	m_sLanguageSource = "";
	m_sOutputAlias = "OVERRIDE";
	m_bOptimizeBinarySpace = TRUE;
	m_nIdentifierListState = 0;

	m_pSRStack = NULL;
	m_pcIdentifierList = NULL;
	m_pcVarStackList = NULL;
	m_pcStructList = NULL;
	m_pcStructFieldList = NULL;
	m_pcKeyWords = NULL;
	m_pSymbolQueryList = NULL;
	m_pSymbolLabelList = NULL;
	m_pIdentifierHashTable = NULL;
	m_ppsParseTreeFileNames = NULL;

	m_pParseTreeNodeBlockHead = NULL;
	m_pParseTreeNodeBlockTail = NULL;
	m_nParseTreeNodeBlockEmptyNodes = -1;
	m_pCurrentParseTreeNodeBlock = NULL;

	m_pnHashString = new int32_t[256];
	int32_t nHashCount;
	for (nHashCount = 0; nHashCount < 256; nHashCount++)
	{
		m_pnHashString[nHashCount] = rand();
	}

	m_pIdentifierHashTable = new CScriptCompilerIdentifierHashTableEntry[CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE];

	m_nCompileFileLevel = 0;
	m_bCompileConditionalFile = FALSE;
	m_bOldCompileConditionalFile = FALSE;
	m_bCompileConditionalOrMain = FALSE;
	m_bAutomaticCleanUpAfterCompiles = TRUE;

	m_nNumEngineDefinedStructures = 0;
	m_pbEngineDefinedStructureValid = NULL;
	m_psEngineDefinedStructureName = NULL;
	m_nIdentifierListEngineStructure = 0;

	m_pchOutputCode = NULL;
	m_pchDebuggerCode = NULL;
	m_pchResolvedOutputBuffer = NULL;
	m_nResolvedOutputBufferSize = 0;

    m_nResTypeSource = nSource;
    m_nResTypeCompiled = nCompiled;
    m_nResTypeDebug = nDebug;

	Initialize();

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::~CScriptCompiler()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Default destructor for class.
///////////////////////////////////////////////////////////////////////////////

CScriptCompiler::~CScriptCompiler()
{
	ShutDown();

	if (m_pIdentifierHashTable)
	{
		delete[] m_pIdentifierHashTable;
		m_pIdentifierHashTable = NULL;
	}

	if (m_pnHashString)
	{
		delete[] m_pnHashString;
		m_pnHashString = NULL;
	}

	// Delete linked list of ParseTreeNodeBlock structures.
	if (m_pParseTreeNodeBlockHead)
	{
		CScriptParseTreeNodeBlock *pBlockPtr = m_pParseTreeNodeBlockHead;

		while (pBlockPtr != NULL)
		{
			CScriptParseTreeNodeBlock *pCurrentPtr = pBlockPtr;
			pBlockPtr = pBlockPtr->m_pNextBlock;
			delete pCurrentPtr;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ShutDown()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Removes memory allocated by CScriptCompiler during process
//                of running.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ShutDown()
{

	if (m_pSRStack)
	{
		delete[]  m_pSRStack;
	}

	if (m_pcIdentifierList)
	{
		delete[] m_pcIdentifierList;
	}

	if (m_pcVarStackList)
	{
		delete[] m_pcVarStackList;
	}

	int32_t nCount = CSCRIPTCOMPILER_MAX_KEYWORDS - 1;
	while (nCount >= 0)
	{
		HashManagerDelete(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD, nCount);
		--nCount;
	}

	if (m_pcKeyWords != NULL)
	{
		delete[] m_pcKeyWords;
	}

	if (m_pcStructList != NULL)
	{
		delete[] m_pcStructList;
		m_pcStructList = NULL;
	}

	if (m_pcStructFieldList != NULL)
	{
		delete[] m_pcStructFieldList;
		m_pcStructFieldList = NULL;
	}

	if (m_psEngineDefinedStructureName != NULL)
	{
		delete[] m_psEngineDefinedStructureName;
		m_psEngineDefinedStructureName = NULL;
	}

	if (m_pbEngineDefinedStructureValid)
	{
		delete[] m_pbEngineDefinedStructureValid;
		m_pbEngineDefinedStructureValid = NULL;
	}

	if (m_ppsParseTreeFileNames)
	{
		for (int32_t count = 0; count < CSCRIPTCOMPILER_MAX_TABLE_FILENAMES; count++)
		{
			if (m_ppsParseTreeFileNames[count] != NULL)
			{
				delete m_ppsParseTreeFileNames[count];
				m_ppsParseTreeFileNames[count] = NULL;
			}
		}
		delete[] m_ppsParseTreeFileNames;
		m_ppsParseTreeFileNames = NULL;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::Initialize()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Sets up parsing routine to be ready to accept a new script.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::Initialize( )
{


	m_sCapturedError = "";

	m_nLines = 1;
	m_nCharacterOnLine = 1;

	m_nSRStackStates = -1;
	m_nSRStackEntries = CSCRIPTCOMPILER_MAX_STACK_ENTRIES;
	if (m_pSRStack == NULL)
	{
		m_pSRStack = new CScriptCompilerStackEntry[m_nSRStackEntries];
	}
	PushSRStack(0,0,0,NULL);

	if (m_pcStructList == NULL)
	{
		m_pcStructList = new CScriptCompilerStructureEntry[CSCRIPTCOMPILER_MAX_STRUCTURES];
	}

	if (m_pcStructFieldList == NULL)
	{
		m_pcStructFieldList = new CScriptCompilerStructureFieldEntry[CSCRIPTCOMPILER_MAX_STRUCTURE_FIELDS];
	}

	if (m_ppsParseTreeFileNames == NULL)
	{
		m_ppsParseTreeFileNames = new CExoString *[CSCRIPTCOMPILER_MAX_TABLE_FILENAMES];
		for (int32_t count = 0; count < CSCRIPTCOMPILER_MAX_TABLE_FILENAMES; count++)
		{
			m_ppsParseTreeFileNames[count] = NULL;
		}
	}

	int32_t count;

	for (count = 0; count < CSCRIPTCOMPILER_MAX_TABLE_FILENAMES; count++)
	{
		if (m_ppsParseTreeFileNames[count] != NULL)
		{
			delete m_ppsParseTreeFileNames[count];
			m_ppsParseTreeFileNames[count] = NULL;
		}
	}

	for (count = 0; count < 512; count++)
	{
		m_pSymbolLabelStartEntry[count] = -1;
	}

	m_nCurrentParseTreeFileName = -1;
	m_nNextParseTreeFileName = 0;

	m_nParseTreeNodeBlockEmptyNodes = -1;
	m_pCurrentParseTreeNodeBlock = m_pParseTreeNodeBlockHead;
	if (m_pCurrentParseTreeNodeBlock != NULL)
	{
		m_pCurrentParseTreeNodeBlock->CleanBlockEntries();
		m_nParseTreeNodeBlockEmptyNodes = CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE - 1;
	}

	if (m_pcKeyWords == NULL)
	{
		m_nKeyWords = CSCRIPTCOMPILER_MAX_KEYWORDS;
		m_pcKeyWords = new CScriptCompilerKeyWordEntry[CSCRIPTCOMPILER_MAX_KEYWORDS];
		m_pcKeyWords[0] .Add("if"     ,HashString("if"),    CSCRIPTCOMPILER_TOKEN_KEYWORD_IF);
		m_pcKeyWords[1] .Add("do"     ,HashString("do"),    CSCRIPTCOMPILER_TOKEN_KEYWORD_DO);
		m_pcKeyWords[2] .Add("else"   ,HashString("else"),  CSCRIPTCOMPILER_TOKEN_KEYWORD_ELSE);
		m_pcKeyWords[3] .Add("int"    ,HashString("int"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_INT);
		m_pcKeyWords[4] .Add("float"  ,HashString("float"), CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT);
		m_pcKeyWords[5] .Add("string" ,HashString("string"),CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING);
		m_pcKeyWords[6] .Add("object" ,HashString("object"),CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT);
		m_pcKeyWords[7] .Add("return" ,HashString("return"),CSCRIPTCOMPILER_TOKEN_KEYWORD_RETURN);
		m_pcKeyWords[8] .Add("while"  ,HashString("while"), CSCRIPTCOMPILER_TOKEN_KEYWORD_WHILE);
		m_pcKeyWords[9] .Add("for"    ,HashString("for"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_FOR);
		m_pcKeyWords[10].Add("void"   ,HashString("void"),  CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID);
		m_pcKeyWords[11].Add("case"   ,HashString("case"),  CSCRIPTCOMPILER_TOKEN_KEYWORD_CASE);
		m_pcKeyWords[12].Add("break"  ,HashString("break"), CSCRIPTCOMPILER_TOKEN_KEYWORD_BREAK);
		m_pcKeyWords[13].Add("struct" ,HashString("struct"),CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT);
		m_pcKeyWords[14].Add("action" ,HashString("action"),CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION);
		m_pcKeyWords[15].Add("switch" ,HashString("switch"),CSCRIPTCOMPILER_TOKEN_KEYWORD_SWITCH);
		m_pcKeyWords[16].Add("default" ,HashString("default"),  CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFAULT);
		m_pcKeyWords[17].Add("#include",HashString("#include"), CSCRIPTCOMPILER_TOKEN_KEYWORD_INCLUDE);
		m_pcKeyWords[18].Add("continue",HashString("continue"), CSCRIPTCOMPILER_TOKEN_KEYWORD_CONTINUE);
		m_pcKeyWords[19].Add("vector"  ,HashString("vector"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR);
		m_pcKeyWords[20].Add("const"   ,HashString("const"),    CSCRIPTCOMPILER_TOKEN_KEYWORD_CONST);
		m_pcKeyWords[21].Add("#define" ,HashString("#define"),  CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFINE);
		m_pcKeyWords[22].Add("OBJECT_SELF"           ,HashString("OBJECT_SELF"),          CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_SELF);
		m_pcKeyWords[23].Add("OBJECT_INVALID"        ,HashString("OBJECT_INVALID"),       CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_INVALID);
		m_pcKeyWords[24].Add("ENGINE_NUM_STRUCTURES" ,HashString("ENGINE_NUM_STRUCTURES"),CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_NUM_STRUCTURES_DEFINITION);
		m_pcKeyWords[25].Add("ENGINE_STRUCTURE_0"    ,HashString("ENGINE_STRUCTURE_0"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[26].Add("ENGINE_STRUCTURE_1"    ,HashString("ENGINE_STRUCTURE_1"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[27].Add("ENGINE_STRUCTURE_2"    ,HashString("ENGINE_STRUCTURE_2"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[28].Add("ENGINE_STRUCTURE_3"    ,HashString("ENGINE_STRUCTURE_3"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[29].Add("ENGINE_STRUCTURE_4"    ,HashString("ENGINE_STRUCTURE_4"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[30].Add("ENGINE_STRUCTURE_5"    ,HashString("ENGINE_STRUCTURE_5"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[31].Add("ENGINE_STRUCTURE_6"    ,HashString("ENGINE_STRUCTURE_6"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[32].Add("ENGINE_STRUCTURE_7"    ,HashString("ENGINE_STRUCTURE_7"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[33].Add("ENGINE_STRUCTURE_8"    ,HashString("ENGINE_STRUCTURE_8"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
		m_pcKeyWords[34].Add("ENGINE_STRUCTURE_9"    ,HashString("ENGINE_STRUCTURE_9"),   CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION);
        m_pcKeyWords[35].Add("JSON_NULL"             ,HashString("JSON_NULL"),            CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL);
        m_pcKeyWords[36].Add("JSON_FALSE"            ,HashString("JSON_FALSE"),           CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE);
        m_pcKeyWords[37].Add("JSON_TRUE"             ,HashString("JSON_TRUE"),            CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE);
        m_pcKeyWords[38].Add("JSON_OBJECT"           ,HashString("JSON_OBJECT"),          CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT);
        m_pcKeyWords[39].Add("JSON_ARRAY"            ,HashString("JSON_ARRAY"),           CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY);
        m_pcKeyWords[40].Add("JSON_STRING"           ,HashString("JSON_STRING"),          CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING);
		m_pcKeyWords[41].Add("LOCATION_INVALID"      ,HashString("LOCATION_INVALID"),     CSCRIPTCOMPILER_TOKEN_KEYWORD_LOCATION_INVALID);

		int32_t nCount;
		for (nCount = 0; nCount < CSCRIPTCOMPILER_MAX_KEYWORDS; ++nCount)
		{
			HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD,nCount);
		}
	}

	//HashManagerAddKeywords();

	m_nMaxStructures = 0;
	m_nMaxStructureFields = 0;
	m_nStructureDefinition = 0;
	m_bGlobalVariableDefinition = FALSE;
	m_nGlobalVariables = 0;
	m_nGlobalVariableSize = 0;
	m_bConstantVariableDefinition = FALSE;

	m_nVarStackRecursionLevel = 0;

	m_nSwitchLevel = 0;
	m_nSwitchIdentifier = 0;
	m_nSwitchStackDepth = 0;
	m_bSwitchLabelDefault = FALSE;
	m_nSwitchLabelNumber = 0;
	m_nSwitchLabelArraySize = 16;
	m_pnSwitchLabelStatements = NULL;

	m_nLoopIdentifier = 0;
	m_nLoopStackDepth = 0;

	InitializePreDefinedStructures();

	m_bCompileIdentifierConstants = FALSE;
	m_bCompileIdentifierList = FALSE;

	if (m_pcVarStackList == NULL)
	{
		m_pcVarStackList = new CScriptCompilerVarStackEntry[CSCRIPTCOMPILER_MAX_VARIABLES];
	}

	// MGB - 06/07/2001 - Moved this out of the first declaration of the var stack list,
	// since this should really be run every time we're initializing the compiler.
	m_nOccupiedVariables = -1;
	m_nVarStackVariableType = CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION;

	// Set up the runtime stacks.
	m_nStackCurrentDepth = 0;
	m_bAssignmentToVariable = FALSE;
	m_bInStructurePart = FALSE;
	m_nBinaryCodeLength = 0;

	ClearAllSymbolLists();

	m_bFunctionImp = FALSE;
	m_sFunctionImpName = "";
	m_nFunctionImpReturnType = 0;
	m_sFunctionImpReturnStructureName = "";
	m_nFunctionImpAbortStackPointer = 0;

	m_pGlobalVariableParseTree = NULL;
	m_nCurrentLineNumber = 0;
	m_nCurrentLineNumberFileReference = -1;
	m_nCurrentLineNumberReferences = 0;
	m_nCurrentLineNumberBinaryStartInstruction = 0;
	m_nCurrentLineNumberBinaryEndInstruction = 0;

	m_nTableFileNames = 0;

	m_nFinalLineNumberEntries = 0;
	m_nLineNumberEntries = 0;

	m_nSymbolTableVariables = 0;
	m_nFinalSymbolTableVariables = 0;

	TokenInitialize();

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::HashString()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 20, 2002
//  Description:  Hashes a string and returns a 32-bit value associated with
//                the string.  (The theory is that two identifiers will not
//                match unless the hash values match.)
///////////////////////////////////////////////////////////////////////////////

uint32_t CScriptCompiler::HashString(const char *pString)
{
	if (m_pnHashString == NULL || pString == NULL)
	{
		return 0;
	}

	uint32_t nHashValue = 0;
	uint32_t nStringLength = (uint32_t)strlen(pString);
	uint32_t nStringCount = 0;

	for (nStringCount = 0; nStringCount < nStringLength; nStringCount++)
	{
		nHashValue ^= m_pnHashString[pString[nStringCount]];
		nHashValue += (nStringCount + 512);
	}

	return nHashValue;
}


uint32_t CScriptCompiler::HashString(const CExoString &sString)
{
	if (m_pnHashString == NULL)
	{
		return 0;
	}

	uint32_t nHashValue = 0;
	uint32_t nStringLength = sString.GetLength();
	uint32_t nStringCount = 0;
	char *pcString = sString.CStr();

	for (nStringCount = 0; nStringCount < nStringLength; nStringCount++)
	{
		nHashValue ^= m_pnHashString[pcString[nStringCount]];
		nHashValue += (nStringCount + 512);
	}

	return nHashValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetHashEntryByName()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Dec. 3, 2002
//  Description:  This routine will return the location of the entry in the
//                hash table for the given token.  Returns -1 if no hash entry
//                has been found.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::GetHashEntryByName(const char *psIdentifierName)
{
	BOOL bInfiniteLoop = TRUE;
	uint32_t nOriginalHash = HashString(psIdentifierName);

	// Search for the exact entry.
	uint32_t nHash = nOriginalHash % CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE;
	uint32_t nEndHash = nHash + (CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE - 1) & CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;

	while (bInfiniteLoop)
	{
		// If we're at the correct entry, confirm that the strings are identical and then
		// return to the main routine.
		if (m_pIdentifierHashTable[nHash].m_nHashValue == nOriginalHash)
		{
			int32_t nIndex = m_pIdentifierHashTable[nHash].m_nIdentifierIndex;
			if (m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
			{
				if (strcmp(m_pcIdentifierList[nIndex].m_psIdentifier.CStr(),psIdentifierName) == 0)
				{
					return nHash;
				}
			}
			else if (m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD)
			{
				if (strcmp((m_pcKeyWords[nIndex].GetPointerToName())->CStr(),psIdentifierName) == 0)
				{
					return nHash;
				}
			}
			else if (m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE)
			{
				if (strcmp(m_psEngineDefinedStructureName[nIndex].CStr(),psIdentifierName) == 0)
				{
					return nHash;
				}
			}
		}

		// Have we hit a blank entry?  Then it's not in the list.
		if (m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
		}

		// Have we searched the entire list?
		if (nEndHash == nHash)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
		}

		// Move to the next entry in the list.
		++nHash;
		nHash &= CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;

	}

	return STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::HashManagerAdd()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 21, 2002
//  Description:  Adds a identifier or keyword to the identifier hash table
//                so that we can figure out what the identifier is quickly!
///////////////////////////////////////////////////////////////////////////////
uint32_t CScriptCompiler::HashManagerAdd(uint32_t nType, uint32_t nIndice)
{
	uint32_t nHash;
	uint32_t nOriginalHash=0;

	// Get the hash value based on the type of entry.
	if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
	{
		CScriptCompilerIdListEntry *pIdentifier = &(m_pcIdentifierList[nIndice]);
		nOriginalHash = HashString(pIdentifier->m_psIdentifier);
	}
	else if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD)
	{
		CScriptCompilerKeyWordEntry *pEntry = &(m_pcKeyWords[nIndice]);
		nOriginalHash = HashString(pEntry->GetAlphanumericName());
	}
	else if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE)
	{
		nOriginalHash = HashString(m_psEngineDefinedStructureName[nIndice]);
	}


	// Search for an empty entry.
	nHash = nOriginalHash % CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE;
	uint32_t nEndHash = nHash + (CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE - 1) & CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;
	while (m_pIdentifierHashTable[nHash].m_nIdentifierType != CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN && nHash != nEndHash)
	{
		++nHash;
		nHash &= CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;
	}

	// If we found an empty entry, do something about it.
	if (m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN)
	{
		m_pIdentifierHashTable[nHash].m_nHashValue = nOriginalHash;
		m_pIdentifierHashTable[nHash].m_nIdentifierType = nType;
		m_pIdentifierHashTable[nHash].m_nIdentifierIndex = nIndice;

		return 0;
	}

	// We didn't find an empty entry.  This is bad.
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::HashManagerDelete()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 21, 2002
//  Description:  Removes a identifier or keyword from the identifier hash table
//                so that we don't look for it any more in the table!
///////////////////////////////////////////////////////////////////////////////
uint32_t CScriptCompiler::HashManagerDelete(uint32_t nType, uint32_t nIndice)
{
	uint32_t nHash;
	uint32_t nOriginalHash=0;

	// Generate the hash value based on the type
	if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
	{
		CScriptCompilerIdListEntry *pIdentifier = &(m_pcIdentifierList[nIndice]);
		nOriginalHash = HashString(pIdentifier->m_psIdentifier);
	}
	else if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD)
	{
		CScriptCompilerKeyWordEntry *pEntry = &(m_pcKeyWords[nIndice]);
		nOriginalHash = HashString(pEntry->GetAlphanumericName());
	}
	else if (nType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE)
	{
		nOriginalHash = HashString(m_psEngineDefinedStructureName[nIndice]);
	}

	// Search for the exact entry.
	nHash = nOriginalHash % CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE;
	uint32_t nEndHash = nHash + (CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE - 1) & CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;
	while (((m_pIdentifierHashTable[nHash].m_nHashValue != nOriginalHash) ||
	        (m_pIdentifierHashTable[nHash].m_nIdentifierType != nType) ||
	        (m_pIdentifierHashTable[nHash].m_nIdentifierIndex != nIndice)) && nHash != nEndHash)
	{
		++nHash;
		nHash &= CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;
	}

	// Delete the entry if we find its exact match.
	if (m_pIdentifierHashTable[nHash].m_nIdentifierType == nType &&
	        m_pIdentifierHashTable[nHash].m_nIdentifierIndex == nIndice &&
	        m_pIdentifierHashTable[nHash].m_nHashValue == nOriginalHash)
	{
		m_pIdentifierHashTable[nHash].m_nHashValue = 0;
		m_pIdentifierHashTable[nHash].m_nIdentifierType = CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN;
		m_pIdentifierHashTable[nHash].m_nIdentifierIndex = 0;
		return 0;
	}

	// We didn't find it ... this is also bad.
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InitializePreDefinedStructures()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 10/17/2000
//  Description:  Sets up script compiler internal variables for the next
//                include file.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::InitializePreDefinedStructures()
{

	// Define the "vector" structure (used to compile vector calls).
	m_nMaxStructures = 1;

	m_pcStructList[0].m_nByteSize = 12;
	m_pcStructList[0].m_nFieldStart = 0;
	m_pcStructList[0].m_nFieldEnd = 2;
	m_pcStructList[0].m_psName = "vector";

	m_nMaxStructureFields = 3;

	m_pcStructFieldList[0].m_psVarName = "x";
	m_pcStructFieldList[0].m_nLocation = 0;
	m_pcStructFieldList[0].m_pchType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;

	m_pcStructFieldList[1].m_psVarName = "y";
	m_pcStructFieldList[1].m_nLocation = 4;
	m_pcStructFieldList[1].m_pchType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;

	m_pcStructFieldList[2].m_psVarName = "z";
	m_pcStructFieldList[2].m_nLocation = 8;
	m_pcStructFieldList[2].m_pchType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;

}

void CScriptCompiler::InitializeIncludeFile(int32_t nCompileFileLevel)
{

	// Preserve the old state
	if (nCompileFileLevel >= 1)
	{
		m_pcIncludeFileStack[nCompileFileLevel-1].m_nLine            = m_nLines;
		m_pcIncludeFileStack[nCompileFileLevel-1].m_nCharacterOnLine = m_nCharacterOnLine;
		m_pcIncludeFileStack[nCompileFileLevel-1].m_nTokenStatus     = m_nTokenStatus;
		m_pcIncludeFileStack[nCompileFileLevel-1].m_nTokenCharacters = m_nTokenCharacters;

		m_nLines = 1;
		m_nCharacterOnLine = 1;
		TokenInitialize();
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ShutdownIncludeFile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/18/2000
//  Description:  Reinstantiates script compiler internal variables when going
//                back to the earlier script.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ShutdownIncludeFile(int32_t nCompileFileLevel)
{

	// Retrieve the old state
	if (nCompileFileLevel >= 1)
	{
		m_nLines           = m_pcIncludeFileStack[nCompileFileLevel - 1].m_nLine;
		m_nCharacterOnLine = m_pcIncludeFileStack[nCompileFileLevel - 1].m_nCharacterOnLine;
		m_nTokenStatus     = m_pcIncludeFileStack[nCompileFileLevel - 1].m_nTokenStatus;
		m_nTokenCharacters = m_pcIncludeFileStack[nCompileFileLevel - 1].m_nTokenCharacters;
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::DeleteParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 08/05/99
//  Description:  This routine will take the root of a compile tree, ensure that
//                each of its branches have been deleted (recursively), and
//                then we can delete the node itself!
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::DeleteParseTree(BOOL bStack, CScriptParseTreeNode *pNode)
{
	if (pNode != NULL)
	{
		// Delete all of the subtrees
		DeleteParseTree(bStack, pNode->pLeft);
		DeleteParseTree(bStack, pNode->pRight);

		if (bStack == TRUE)
		{
			// Delete any references to this node from the stack.
			int32_t i;

			for (i=0; i <= m_nSRStackStates; i++)
			{
				if (m_pSRStack[i].pCurrentTree != NULL)
				{
					m_pSRStack[i].pCurrentTree = NULL;
				}
				if (m_pSRStack[i].pReturnTree != NULL)
				{
					m_pSRStack[i].pReturnTree = NULL;
				}
			}
		}

		// Finally delete the node itself.
		DeleteScriptParseTreeNode(pNode);
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetGenerateDebuggerOutput()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 30, 2002
//  Description:  This determines whether the debugger.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetGenerateDebuggerOutput(int32_t nValue)
{
	m_nGenerateDebuggerOutput = nValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetCompileSymbolicOutput()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/27/99
//  Description:  This routine will set whether the compiler should generate
//                a symbolic output or a regular output.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetCompileSymbolicOutput(int32_t nValue)
{
	m_nDebugSymbolicOutput = nValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetIdentifierSpecification()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/15/2001
//  Description:  This routine will set whether the compiler should generate
//                a symbolic output or a regular output.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetIdentifierSpecification(const CExoString &sLanguageSource)
{

	if (m_sLanguageSource != sLanguageSource)
	{
		m_sLanguageSource = sLanguageSource;

		if (m_pcIdentifierList != NULL)
		{
			while (m_nOccupiedIdentifiers > 0)
			{
				--m_nOccupiedIdentifiers;
				HashManagerDelete(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, m_nOccupiedIdentifiers);
			}

			delete[] m_pcIdentifierList;
		}

		if (m_pbEngineDefinedStructureValid != NULL)
		{
			int32_t nCount = 9;
			while (nCount >= 0)
			{
				if (m_pbEngineDefinedStructureValid[nCount] == TRUE)
				{
					HashManagerDelete(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE, nCount);
					m_pbEngineDefinedStructureValid[nCount] = FALSE;
				}
				--nCount;
			}
		}

		if (m_pcIdentifierList == NULL)
		{
			m_pcIdentifierList = new CScriptCompilerIdListEntry[CSCRIPTCOMPILER_MAX_IDENTIFIERS];
			m_bCompileIdentifierList = TRUE;
			m_bCompileIdentifierConstants = TRUE;
			m_nOccupiedIdentifiers = 0;
			m_nMaxPredefinedIdentifierId = 0;
			ParseIdentifierFile();

			m_nLines = 1;
			m_nCharacterOnLine = 1;
			m_nSRStackStates = -1;

			m_bCompileIdentifierList = FALSE;
			m_bCompileIdentifierConstants = FALSE;
		}
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetOutputAlias()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/09/2001
//  Description:  This routine will set the output alias for where we wish
//                to output the result of CompileFile.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetOutputAlias(const CExoString &sAlias)
{
	m_sOutputAlias = sAlias;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetOptimizeBinaryCodeLength()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
//  Description:  This routine will set whether the compiler should generate
//                all functions (whether or not they are called), or only
//                those functions that could possibly be called via any
//                execution.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetOptimizeBinaryCodeLength(BOOL bValue)
{
	m_bOptimizeBinarySpace = bValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetCompileConditionalFile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
//  Description:  This routine will set whether the compiler should generate
//                all functions (whether or not they are called), or only
//                those functions that could possibly be called via any
//                execution.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::SetCompileConditionalFile(BOOL bValue)
{
	m_bCompileConditionalFile = bValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetCompileConditionalOrMain()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Feb. 17, 2003
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::SetCompileConditionalOrMain(BOOL bValue)
{
	m_bCompileConditionalOrMain = bValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::SetAutomaticCleanUpAfterCompiles()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Feb/06/2003
//  Description:
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::SetAutomaticCleanUpAfterCompiles(BOOL bValue)
{
	m_bAutomaticCleanUpAfterCompiles = bValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::UpdateOutputDirectory()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Feb/06/2003
//  Description:  Updates the current output alias to allow the resource
//                manager to use the scripts that were compiled!  (Use of this
//                function is ONLY required when you have set the automatic
//                update of the output directory to FALSE.  If the value was
//                TRUE during a CompileFile instruction, this code has already
//                been run on the newly created files!)
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::CleanUpAfterCompiles()
{
	// Update the resource directory.
	CExoString sDirectoryFileName;

	sDirectoryFileName.Format("%s:",m_sOutputAlias.CStr());
    m_cAPI.ResManUpdateResourceDirectory(sDirectoryFileName.CStr());

	// Delete the Debugger code buffer.
	if (m_pchDebuggerCode != NULL)
	{
		delete[] m_pchDebuggerCode;
		m_pchDebuggerCode = NULL;
		m_nDebuggerCodeSize = 0;
	}

	// The resolved output buffer should go, too.
	if (m_pchResolvedOutputBuffer != NULL)
	{
		delete[] m_pchResolvedOutputBuffer;
		m_pchResolvedOutputBuffer = NULL;
		m_nResolvedOutputBufferSize = 0;
	}

	// And the script code buffer should also be deallocated.
	ClearCompiledScriptCode();
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CompileFile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  This routine will compile the file specified in sFileName
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::CompileFile(const CExoString &sFileName)
{

	char *pScript;
	uint32_t nScriptLength;

	if (m_nCompileFileLevel == 0)
	{
		Initialize();
	}

	if (m_nCompileFileLevel >= CSCRIPTCOMPILER_MAX_INCLUDE_LEVELS)
	{
		return STRREF_CSCRIPTCOMPILER_ERROR_INCLUDE_TOO_MANY_LEVELS;
	}

	if (m_nCompileFileLevel > 0)
	{
		int count;

		for (count = 0; count < m_nCompileFileLevel; ++count)
		{
			if (m_pcIncludeFileStack[count].m_sCompiledScriptName == sFileName)
			{
				return STRREF_CSCRIPTCOMPILER_ERROR_INCLUDE_RECURSIVE;
			}
		}

		InitializeIncludeFile(m_nCompileFileLevel);
	}

	m_pcIncludeFileStack[m_nCompileFileLevel].m_sCompiledScriptName = sFileName;

    const char* sTest = m_cAPI.ResManLoadScriptSourceFile(sFileName.CStr(), m_nResTypeSource);
	if (!sTest)
	{
		if (m_nCompileFileLevel > 0)
		{
			ShutdownIncludeFile(m_nCompileFileLevel);
		}

		return STRREF_CSCRIPTCOMPILER_ERROR_FILE_NOT_FOUND;
	}
    m_pcIncludeFileStack[m_nCompileFileLevel].m_sSourceScript = sTest;
    pScript = m_pcIncludeFileStack[m_nCompileFileLevel].m_sSourceScript.CStr();
    nScriptLength = m_pcIncludeFileStack[m_nCompileFileLevel].m_sSourceScript.GetLength();

	++m_nCompileFileLevel;

	int32_t nReturnValue = ParseSource(pScript,nScriptLength);

	if (nReturnValue < 0)
	{
		// MGB - 02/15/2001 - DO NOT SUBTRACT ONE FROM COMPILEFILELEVEL.
		// Why?  It is taken off in CleanUpDuringCompile.
		m_pcIncludeFileStack[m_nCompileFileLevel].m_sSourceScript = "";
		return nReturnValue;
	}

	// We have successfully compiled this file.  If we are still in
	// the middle of another CompileFile (i.e. this is an included
	// file, return success back to the main routine.

	m_pcIncludeFileStack[m_nCompileFileLevel-1].m_sSourceScript = "";

	--m_nCompileFileLevel;
	if (m_nCompileFileLevel > 0)
	{
		ShutdownIncludeFile(m_nCompileFileLevel);
		return 0;
	}

	// This is the "outermost" script level.  Here, we should
	// attempt to write out the virtual machine code.

	InitializeFinalCode();

	nReturnValue = GenerateFinalCodeFromParseTree(sFileName);

	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	FinalizeFinalCode();

	nReturnValue = WriteFinalCodeToFile(sFileName);

	if (nReturnValue < 0)
	{
		return nReturnValue;
	}



	return nReturnValue;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CompileScriptChunk()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/11/2001
//  Description:  This routine will compile the string specified in sStringData.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::CompileScriptChunk(const CExoString &sScriptChunk, BOOL bWrapIntoMain)
{
	char *pScript;
	uint32_t nScriptLength;

	Initialize();

	if (m_nCompileFileLevel != 0)
	{
		return STRREF_CSCRIPTCOMPILER_ERROR_INCLUDE_TOO_MANY_LEVELS;
	}

	m_pcIncludeFileStack[m_nCompileFileLevel].m_sCompiledScriptName = "!Chunk";

	if (bWrapIntoMain)
	{
		nScriptLength = sScriptChunk.GetLength() + 13;
		pScript = new char[nScriptLength + 13];
		sprintf(pScript, "void main(){%s}", sScriptChunk.CStr());
	}
	else
    {
	    nScriptLength = sScriptChunk.GetLength();
	    pScript = new char[nScriptLength];
	    memmove(pScript, sScriptChunk.CStr(), nScriptLength);
    }

	++m_nCompileFileLevel;

	int32_t nReturnValue = ParseSource(pScript,nScriptLength);

	if (nReturnValue < 0)
	{
		delete[] pScript;
		return nReturnValue;
	}

	--m_nCompileFileLevel;

	InitializeFinalCode();

	nReturnValue = GenerateFinalCodeFromParseTree("!Chunk");

	if (nReturnValue < 0)
	{
		delete[] pScript;
		return nReturnValue;
	}

	FinalizeFinalCode();

	delete[] pScript;
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CompileScriptConditional()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/11/2001
//  Description:  This routine will compile the string specified in sStringData.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::CompileScriptConditional(const CExoString &sScriptConditional)
{

	char *pScript;
	uint32_t nScriptLength;

	Initialize();

	if (m_nCompileFileLevel != 0)
	{
		return STRREF_CSCRIPTCOMPILER_ERROR_INCLUDE_TOO_MANY_LEVELS;
	}

	m_pcIncludeFileStack[m_nCompileFileLevel].m_sCompiledScriptName = "!Conditional";

	nScriptLength = sScriptConditional.GetLength() + 22;
	pScript = new char[nScriptLength + 22];
	sprintf(pScript,"int main(){ return(%s);}",sScriptConditional.CStr());

	++m_nCompileFileLevel;

	int32_t nReturnValue = ParseSource(pScript,nScriptLength);

	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	--m_nCompileFileLevel;

	InitializeFinalCode();

	nReturnValue = GenerateFinalCodeFromParseTree("!Conditional");

	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	FinalizeFinalCode();

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetCompiledScriptCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/11/2001
//  Description:  This routine will return the data that has already been
//                compiled.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GetCompiledScriptCode(char **ppnCode, int32_t *pnCodeSize)
{
	*pnCodeSize = m_nOutputCodeSize;
	*ppnCode = m_pchOutputCode;

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ClearCompiledScriptCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/11/2001
//  Description:  This routine will return delete any data that has already
//                been compiled.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ClearCompiledScriptCode()
{
	m_nOutputCodeSize = 0;
	if (m_pchOutputCode)
	{
		delete[] m_pchOutputCode;
		m_pchOutputCode = NULL;
	}
	m_nOutputCodeLength = 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::OutputError()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/23/2001
//  Description:  A standardization of ALL error messages that could possibly
//                come out of the compilation of any/all code.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::OutputError(int32_t nError, CExoString *psFileName, int32_t nLineNumber, const CExoString &sErrorText)
{
	// Construct the error string, if appropriate
	if (nError == STRREF_CSCRIPTCOMPILER_ERROR_ALREADY_PRINTED)
	{
		return nError;
	}

	CExoString sFullErrorText;

	if (psFileName->Left(1) == "!")
	{
		if (nLineNumber > 0)
		{
			sFullErrorText.Format("%s(%d): %s\n",psFileName->Right(psFileName->GetLength()-1).CStr(),nLineNumber,sErrorText.CStr());
		}
		else
		{
			sFullErrorText.Format("%s: %s\n",psFileName->Right(psFileName->GetLength()-1).CStr(),sErrorText.CStr());
		}
	}
	else
	{
		if (nLineNumber > 0)
		{
			sFullErrorText.Format("%s.nss(%d): %s\n",psFileName->CStr(),nLineNumber,sErrorText.CStr());
		}
		else
		{
			sFullErrorText.Format("%s.nss: %s\n",psFileName->CStr(),sErrorText.CStr());
		}
	}

	m_sCapturedError = sFullErrorText;

	// Print the full error text to the log file.
    // This is used and parsed by the toolset :( Do not remove.
#ifdef BORLAND
	g_pExoBase->m_pcExoDebug->m_sLogString.Format("%s",sFullErrorText.CStr());
	g_pExoBase->m_pcExoDebug->WriteToLogFile(g_pExoBase->m_pcExoDebug->m_sLogString);
	g_pExoBase->m_pcExoDebug->FlushLogFile();
#endif

	return nError;
}
