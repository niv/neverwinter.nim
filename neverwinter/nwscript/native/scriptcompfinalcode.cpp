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
//::  Copyright (c) 2001, BioWare Corp.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  ScriptCompFinalCode.cpp
//::
//::  Implementation of changing the parse tree into a piece of code that we
//::  can deal with.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Mark Brockington
//::  Created On: October 8, 2002
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  This file contains "ported" code (used when writing out floating point
//::  numbers on the MacIntosh platforms).
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
//::  Class CScriptCompiler
//::
//::///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GenerateCodeFromParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/26/2000
// Description: Clears out the user defined identifiers.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GenerateFinalCodeFromParseTree(CExoString sFileName)
{

	int nState;
	int nRule;
	int nTerm;
	CScriptParseTreeNode *pCurrentTree;
	CScriptParseTreeNode *pReturnTree;
	CScriptParseTreeNode *pNewReturnTree;  // after the global variables have been re-added.

	PopSRStack(&nState,&nRule,&nTerm,&pCurrentTree,&pReturnTree);

	m_nTotalCompileNodes = 1;

	int32_t nReturnValue = InstallLoader();
	pNewReturnTree = InsertGlobalVariablesInParseTree(pReturnTree);
	if (nReturnValue >= 0)
	{
		nReturnValue = WalkParseTree(pNewReturnTree);
	}
	else
	{
		OutputWalkTreeError(nReturnValue, NULL);
	}

	if (nReturnValue < 0)
	{
		return CleanUpAfterCompile(nReturnValue,pNewReturnTree);
	}
	else
	{
		nReturnValue = DetermineLocationOfCode();
		if (nReturnValue >= 0)
		{
			nReturnValue = ResolveLabels();
		}
		if (nReturnValue >= 0)
		{
			ResolveDebuggingInformation();

			nReturnValue = WriteResolvedOutput();
		}
		if (nReturnValue >= 0)
		{
			nReturnValue = WriteDebuggerOutputToFile(sFileName);
		}
		if (nReturnValue < 0)
		{
			return CleanUpAfterCompile(nReturnValue,pNewReturnTree);
		}
		return CleanUpAfterCompile(0,pNewReturnTree);
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InitializeFinalCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/16/2001
// Description: Sets up all of the data structures for the development of
//              the final game code.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::InitializeFinalCode()
{
	if (m_pchOutputCode == NULL)
	{
		m_pchOutputCode = new char[CSCRIPTCOMPILER_MAX_CODE_SIZE];
		m_nOutputCodeSize = CSCRIPTCOMPILER_MAX_CODE_SIZE;
	}

	sprintf(m_pchOutputCode,"NCS V1.0");
	m_nOutputCodeLength = CVIRTUALMACHINE_BINARY_SCRIPT_HEADER;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::FinalizeFinalCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/16/2001
// Description: Finishes off the data structures for the development of
//              the final game code.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::FinalizeFinalCode()
{
	m_pchOutputCode[8] = (char) 'B';
	m_pchOutputCode[9] = (char) ((m_nOutputCodeLength >> 24) & 0xff);
	m_pchOutputCode[10] = (char) ((m_nOutputCodeLength >> 16) & 0xff);
	m_pchOutputCode[11] = (char) ((m_nOutputCodeLength >> 8) & 0xff);
	m_pchOutputCode[12] = (char) ((m_nOutputCodeLength) & 0xff);
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::WriteFinalCodeToFile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/16/2001
// Description: Outputs the final code to the file for later use.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::WriteFinalCodeToFile(const CExoString &sFileName)
{

	CExoString sModifiedFileName;
	sModifiedFileName.Format("%s:%s",m_sOutputAlias.CStr(),sFileName.CStr());

    const int32_t ret = m_cAPI.ResManWriteToFile(
        sModifiedFileName.CStr(), m_nResTypeCompiled,
        (const uint8_t*) m_pchOutputCode, m_nOutputCodeLength, true);

    if (ret != 0)
    {
        return ret;
    }

	if (m_bAutomaticCleanUpAfterCompiles == TRUE)
	{
		CExoString sDirectoryFileName;

		sDirectoryFileName.Format("%s:",m_sOutputAlias.CStr());
		m_cAPI.ResManUpdateResourceDirectory(sDirectoryFileName.CStr());

		// Delete the code.
		if (m_pchOutputCode != NULL)
		{
			delete[] m_pchOutputCode;
			m_pchOutputCode = NULL;
		}

		m_nOutputCodeLength = 0;
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ClearUserDefinedIdentifiers()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/26/2000
// Description: Clears out the user defined identifiers.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ClearUserDefinedIdentifiers()
{
	for (int32_t count = m_nOccupiedIdentifiers - 1; count >= m_nMaxPredefinedIdentifierId; --count)
	{
		HashManagerDelete(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, count);

		m_pcIdentifierList[count].m_psIdentifier = "";
		m_pcIdentifierList[count].m_nIdentifierLength = 0;
		m_pcIdentifierList[count].m_nIdentifierHash = 0;
		m_pcIdentifierList[count].m_nIdentifierType = 0;
		m_pcIdentifierList[count].m_nReturnType = 0;
		m_pcIdentifierList[count].m_bImplementationInPlace = FALSE;
		m_pcIdentifierList[count].m_psStructureReturnName = "";

		// For constants ...
		m_pcIdentifierList[count].m_psStringData = "";
		m_pcIdentifierList[count].m_nIntegerData = 0;
		m_pcIdentifierList[count].m_fFloatData = 0.0;
		// For identifiers ..
		m_pcIdentifierList[count].m_nIdIdentifier = -1;
		m_pcIdentifierList[count].m_nParameters = 0;
		m_pcIdentifierList[count].m_nNonOptionalParameters = 0;
		m_pcIdentifierList[count].m_nParameterSpace = 0;

		if (m_pcIdentifierList[count].m_pchParameters)
		{
			delete[] m_pcIdentifierList[count].m_pchParameters;
			m_pcIdentifierList[count].m_pchParameters = NULL;
		}
		if (m_pcIdentifierList[count].m_psStructureParameterNames)
		{
			delete[] m_pcIdentifierList[count].m_psStructureParameterNames;
			m_pcIdentifierList[count].m_psStructureParameterNames = NULL;
		}
		if (m_pcIdentifierList[count].m_pbOptionalParameters)
		{
			delete[] m_pcIdentifierList[count].m_pbOptionalParameters;
			m_pcIdentifierList[count].m_pbOptionalParameters = NULL;
		}
		if (m_pcIdentifierList[count].m_pnOptionalParameterIntegerData)
		{
			delete[] m_pcIdentifierList[count].m_pnOptionalParameterIntegerData;
			m_pcIdentifierList[count].m_pnOptionalParameterIntegerData = NULL;
		}
		if (m_pcIdentifierList[count].m_pfOptionalParameterFloatData)
		{
			delete[] m_pcIdentifierList[count].m_pfOptionalParameterFloatData;
			m_pcIdentifierList[count].m_pfOptionalParameterFloatData = NULL;
		}
		if (m_pcIdentifierList[count].m_psOptionalParameterStringData)
		{
			delete[] m_pcIdentifierList[count].m_psOptionalParameterStringData;
			m_pcIdentifierList[count].m_psOptionalParameterStringData = NULL;
		}
		if (m_pcIdentifierList[count].m_poidOptionalParameterObjectData)
		{
			delete[] m_pcIdentifierList[count].m_poidOptionalParameterObjectData;
			m_pcIdentifierList[count].m_poidOptionalParameterObjectData = NULL;
		}
		if (m_pcIdentifierList[count].m_pfOptionalParameterVectorData)
		{
			delete[] m_pcIdentifierList[count].m_pfOptionalParameterVectorData;
			m_pcIdentifierList[count].m_pfOptionalParameterVectorData = NULL;
		}


		// For user-defined identifiers
		m_pcIdentifierList[count].m_nBinarySourceStart        = -1;
		m_pcIdentifierList[count].m_nBinarySourceFinish       = -1;
		m_pcIdentifierList[count].m_nBinaryDestinationStart   = -1;
		m_pcIdentifierList[count].m_nBinaryDestinationFinish  = -1;

	}

	m_nOccupiedIdentifiers = m_nMaxPredefinedIdentifierId;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ClearAllSymbolLists()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/26/2000
// Description: Clears out the query and label symbol lists.
///////////////////////////////////////////////////////////////////////////////


void CScriptCompiler::ClearAllSymbolLists()
{
	if (m_pSymbolQueryList != NULL)
	{
		delete[] m_pSymbolQueryList;
		m_pSymbolQueryList = NULL;
	}

	m_nSymbolQueryListSize = 0;
	m_nSymbolQueryList     = 0;

	if (m_pSymbolLabelList != NULL)
	{
		delete[] m_pSymbolLabelList;
		m_pSymbolLabelList = NULL;
	}

	m_nSymbolLabelListSize = 0;
	m_nSymbolLabelList     = 0;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CleanUpAfterCompile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/26/2000
//  Description:  This routine will delete all of the data associated with the
//                current compile tree.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::CleanUpAfterCompile(int32_t nReturnValue,CScriptParseTreeNode *pReturnTree)
{
	DeleteParseTree(FALSE, pReturnTree);
	if (nReturnValue < 0)
	{
		if (m_bAutomaticCleanUpAfterCompiles == TRUE)
		{
			ClearCompiledScriptCode();
		}
		else
		{
			m_nOutputCodeLength = 0;
		}
	}
	DeleteParseTree(FALSE, m_pGlobalVariableParseTree);
	m_pGlobalVariableParseTree = NULL;
	ClearUserDefinedIdentifiers();
	ClearAllSymbolLists();
	m_aOutputCodeInstructionBoundaries.resize(0);

	// Reset the state of the ConditionalFile boolean.
	if (m_bCompileConditionalOrMain == TRUE)
	{
		m_bCompileConditionalFile = m_bOldCompileConditionalFile;
	}

	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::OutputWalkTreeError()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/27/99
//  Description:  This routine spews out an error message to the log file when
//                we encounter an error during the semantic phase of the
//                parsing (i.e. we're now walking the tree).
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::OutputWalkTreeError(int32_t nError, CScriptParseTreeNode *pNode)
{
	CExoString strRes = m_cAPI.TlkResolve(-nError);

	CExoString *psFileName;
	if (pNode != NULL && pNode->m_nFileReference != -1)
	{
		psFileName = m_ppsParseTreeFileNames[pNode->m_nFileReference];
	}
	else
	{
		psFileName = &(m_pcIncludeFileStack[m_nCompileFileLevel].m_sCompiledScriptName);
	}

	int32_t nLine;
	if (pNode != NULL)
	{
		nLine = pNode->nLine;
	}
	else
	{
		nLine =  0;
	}

	OutputError(nError,psFileName,nLine,strRes);

	return STRREF_CSCRIPTCOMPILER_ERROR_ALREADY_PRINTED;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InsertGlobalVariablesInParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/09/2001
// Description: Adds the global variable tree into the main compile tree.
///////////////////////////////////////////////////////////////////////////////

CScriptParseTreeNode *CScriptCompiler::InsertGlobalVariablesInParseTree(CScriptParseTreeNode *pOldTree)
{
	// If there's nothing to add, why are we here?
	if (m_pGlobalVariableParseTree == NULL)
	{
		return pOldTree;
	}

	CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTIONAL_UNIT,m_pGlobalVariableParseTree,pOldTree);
	m_pGlobalVariableParseTree = NULL;

	return pNewNode;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InstallLoader()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: A quick utility ... this routine should be run before we
//              start compiling code, because this will add the important
//              JSR FE_main/RET pair that closes out a script.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::InstallLoader()
{
	// Mark instruction boundary before the first JSR instruction.
	// This is immediately after the header and is always at offset 13
	m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	// Verify "main" is a void-returning function that is actually
	// declared within this script.

	int32_t nMainIdentifier;

	if (m_bCompileConditionalOrMain == TRUE)
	{
		// Save the state of the CompileConditionalFile flag.
		// It will be restored in CleanUpAfterCompile!
		m_bOldCompileConditionalFile = m_bCompileConditionalFile;

		nMainIdentifier = GetIdentifierByName("main");
		if (nMainIdentifier >= 0)
		{
			// This is a void main() script, and should compile!
			m_bCompileConditionalFile = FALSE;
		}
		else
		{
			nMainIdentifier = GetIdentifierByName("StartingConditional");
			if (nMainIdentifier >= 0)
			{
				// This is a conditional script, and should compile!
				m_bCompileConditionalFile = TRUE;
			}
			else
			{
				// Neither are present, so we're going to error just as
				// if we are expecting a void main() function!
				m_bCompileConditionalFile = FALSE;
			}
		}
	}

	if (m_bCompileConditionalFile == FALSE)
	{
		nMainIdentifier = GetIdentifierByName("main");
		if (nMainIdentifier < 0)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_NO_FUNCTION_MAIN_IN_SCRIPT;
		}

		if (m_pcIdentifierList[nMainIdentifier].m_nReturnType != CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_MAIN_MUST_HAVE_VOID_RETURN_VALUE;
		}

		if (m_pcIdentifierList[nMainIdentifier].m_nParameters != 0)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_MAIN_MUST_HAVE_NO_PARAMETERS;
		}
	}
	else
	{
		// If m_bCompileConditionalFile == TRUE, then the only possible choice
		// for what to compile is int StartingConditional()

		nMainIdentifier = GetIdentifierByName("StartingConditional");
		if (nMainIdentifier < 0)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_NO_FUNCTION_INTSC_IN_SCRIPT;
		}

		if (m_pcIdentifierList[nMainIdentifier].m_nReturnType != CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_INTSC_MUST_HAVE_VOID_RETURN_VALUE;
		}

		if (m_pcIdentifierList[nMainIdentifier].m_nParameters != 0)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_INTSC_MUST_HAVE_NO_PARAMETERS;
		}
	}


	BOOL bGlobalVariablesPresent = FALSE;
	if (m_pGlobalVariableParseTree != NULL)
	{
		bGlobalVariablesPresent = TRUE;
	}

	m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier = "#loader";
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierHash = HashString("#loader");
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierLength = 7;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceStart = m_nOutputCodeLength;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationStart = -1;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationFinish = -1;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters = 0;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER;
	HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, m_nOccupiedIdentifiers);

	// Add the JSR FE_main OR FE_#globals instruction, depending on whether
	// there are global variables or not.
	//
	// Here, we will need to write a symbol into the code and
	// mark the location for updating during the label generation pass.

	if (m_pcIdentifierList[nMainIdentifier].m_nReturnType == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER;

		++m_nOccupiedVariables;

		++m_nVarStackRecursionLevel;
		++m_nGlobalVariables;


		m_pcVarStackList[m_nOccupiedVariables].m_psVarName = "#retval";
		m_pcVarStackList[m_nOccupiedVariables].m_nVarType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
		m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel = m_nVarStackRecursionLevel;
		m_pcVarStackList[m_nOccupiedVariables].m_nVarRunTimeLocation = m_nStackCurrentDepth * 4;

		int32_t nOccupiedVariables = m_nOccupiedVariables;
		int32_t nStackCurrentDepth = m_nStackCurrentDepth;
		int32_t nGlobalVariableSize = m_nGlobalVariableSize;

		// Now, we can add the variable to the run time stack (to write the code), and then
		// immediately remove it.  This makes NO sense whatsoever, right?  Well, imagine this ...
		// what happens if we already have a spot allocated from the calling function for this
		// return variable?

		AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT, NULL, TRUE);
		AddToSymbolTableVarStack(nOccupiedVariables,nStackCurrentDepth,nGlobalVariableSize);

		--m_nStackCurrentDepth;
	}

	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JSR;
	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

	// There is no point in expressing this yet, because we haven't decided on the
	// locations of any of the final functions in the executable.  So, write
	// the symbol into the table.

	//CExoString sSymbolName;
	int32_t nSymbolSubType1 = 0;
	int32_t nSymbolSubType2 = 0;
	if (bGlobalVariablesPresent)
	{
		//sSymbolName.Format("FE_#globals");
		nSymbolSubType2 = 1;
	}
	else
	{
		nSymbolSubType2 = 2;
		/*
		if (m_bCompileConditionalFile == TRUE)
		{
		    sSymbolName.Format("FE_StartingConditional");
		}
		else
		{
		    sSymbolName.Format("FE_main");
		}
		*/
	}
	AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
	                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
	                     nSymbolSubType1,nSymbolSubType2);

	m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
	m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RET;
	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;
	m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
	m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	// Last, but not least, add a function to the user-defined identifier list
	// that specifies where this code is located.

	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceFinish = m_nOutputCodeLength;

	++m_nOccupiedIdentifiers;
	if (m_nOccupiedIdentifiers >= CSCRIPTCOMPILER_MAX_IDENTIFIERS)
	{
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_IDENTIFIER_LIST_FULL, NULL);
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::DetermineLocationOfCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: This function is responsible for determining which functions
//              are required in the script, and which ones will be left out.
//              Calls ValidateLocationOfIdentifier (recursively) to determine
//              all of this.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::DetermineLocationOfCode()
{
	if (m_nOptimizationFlags & CSCRIPTCOMPILER_OPTIMIZE_DEAD_FUNCTIONS)
	{
		// Here, we have to compress the language into something that
		// we can deal with on a small level.
		m_nFinalBinarySize = CVIRTUALMACHINE_BINARY_SCRIPT_HEADER;
		return ValidateLocationOfIdentifier("#loader");

	}
	else
	{
		m_nFinalBinarySize = m_nOutputCodeLength;

		for (int32_t count2 = m_nMaxPredefinedIdentifierId; count2 < m_nOccupiedIdentifiers; count2++)
		{
			if (m_pcIdentifierList[count2].m_nBinarySourceStart != -1)
			{
				m_pcIdentifierList[count2].m_nBinaryDestinationStart  = m_pcIdentifierList[count2].m_nBinarySourceStart;
				m_pcIdentifierList[count2].m_nBinaryDestinationFinish = m_pcIdentifierList[count2].m_nBinarySourceFinish;
			}
		}

		return 0;
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ValidateLocationOfIdentifier()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: This function is responsible for determining which functions
//              are required in the script, and which ones will be left out.
//              Calls itself recursively on all of the functions that are
//              called within this function to see if they're already in the
//              script, and add them if they aren't.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ValidateLocationOfIdentifier(const CExoString &sFunctionName)
{
	int32_t nIdentifier = GetIdentifierByName(sFunctionName);

	if (nIdentifier < 0)
	{
		return OutputIdentifierError(sFunctionName,nIdentifier,0);
	}

	if (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart != -1)
	{
		return 0;
	}

	int32_t nFunctionSize = m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish -
	                    m_pcIdentifierList[nIdentifier].m_nBinarySourceStart;

	m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart  = m_nFinalBinarySize;
	m_pcIdentifierList[nIdentifier].m_nBinaryDestinationFinish = m_nFinalBinarySize + nFunctionSize;

	m_nFinalBinarySize += nFunctionSize;

	// Now, this is where it gets EXCITING.  We reference all of the
	// functions that this routine could potentially call, and add
	// them to the list, too!

	CExoString sNewFunctionName;
	int32_t nReturnValue;

	for (int32_t count = 0; count < m_nSymbolQueryList; count++)
	{
		if (m_pSymbolQueryList[count].m_nLocationPointer >= m_pcIdentifierList[nIdentifier].m_nBinarySourceStart &&
		        m_pSymbolQueryList[count].m_nLocationPointer < m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish)
		{
			// Make sure the query is for a function label, and NOT a switch or continue statement.
			if (m_pSymbolQueryList[count].m_nSymbolType == CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY)
			{
				sNewFunctionName = GetFunctionNameFromSymbolSubTypes(m_pSymbolQueryList[count].m_nSymbolSubType1,
				                   m_pSymbolQueryList[count].m_nSymbolSubType2);

				// Get the function name!
				//sNewFunctionName = m_pSymbolQueryList[count].m_sSymbolName.Right(m_pSymbolQueryList[count].m_sSymbolName.GetLength() - 3);
				nReturnValue     = ValidateLocationOfIdentifier(sNewFunctionName);
				if (nReturnValue < 0)
				{
					return nReturnValue;
				}
			}
		}
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::OutputIdentifierError()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: Spits out the error when accessing things in the resolution
//              identifiers (nLine and nChar aren't really available at this
//              point, so it makes sense to just refer to the function.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::OutputIdentifierError(const CExoString &sFunctionName, int32_t nError, int32_t nFileStackDrop)
{
	CExoString strRes = m_cAPI.TlkResolve(-nError);

	//g_pTlkTable->Fetch(-nError, strRes);
	int32_t nFileStackEntry = m_nCompileFileLevel - nFileStackDrop;
	if (nFileStackEntry < 0)
	{
		nFileStackEntry = 0;
	}

	CExoString *psFileName = &(m_pcIncludeFileStack[nFileStackEntry].m_sCompiledScriptName);
	CExoString sErrorText;
	sErrorText.Format("%s (%s)",strRes.CStr(),sFunctionName.CStr());
	OutputError(nError,psFileName,0,sErrorText);

	return STRREF_CSCRIPTCOMPILER_ERROR_ALREADY_PRINTED;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ResolveLabels()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: This function will resolve all of the labels, based on the
//              final location of the functions within the script.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ResolveLabels()
{

	CExoString sFunctionName;
	BOOL bFoundLabel;
	BOOL bFoundIdentifier;

	for (int32_t count = 0; count < m_nSymbolQueryList; count++)
	{

		// Resolve the location of where we will be writing the address
		// for the label we're lookin' for.
		int32_t nResolvedLocationOfAddress = m_pSymbolQueryList[count].m_nLocationPointer;

		int32_t nQueryIdentifier = 0;
		int32_t count2;
		bFoundIdentifier = FALSE;
		for (count2 = m_nMaxPredefinedIdentifierId; count2 < m_nOccupiedIdentifiers; count2++)
		{
			if (nResolvedLocationOfAddress >= m_pcIdentifierList[count2].m_nBinarySourceStart &&
			        nResolvedLocationOfAddress < m_pcIdentifierList[count2].m_nBinarySourceFinish)
			{
				bFoundIdentifier = TRUE;
				nQueryIdentifier = count2;
			}
		}

		// If this happens, we're in REAL trouble, but we'll return out of
		// this routine in any case (the query had to be derived from ONE
		// of the functions!)

		if (bFoundIdentifier == FALSE)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER, NULL);
		}

		// Now, check to see if the query even BELONGS in the final file.
		// If it does, follow up and generate a value for it.

		if (m_pcIdentifierList[nQueryIdentifier].m_nBinaryDestinationStart != -1)
		{

			nResolvedLocationOfAddress += (m_pcIdentifierList[nQueryIdentifier].m_nBinaryDestinationStart -
			                               m_pcIdentifierList[nQueryIdentifier].m_nBinarySourceStart);

			// Now, we actually dig out where the "label" has been moved to
			// in the code.

			bFoundLabel = FALSE;
			int32_t nQueryHash = m_pSymbolQueryList[count].m_nSymbolSubType1 & 0x01ff;

			count2 = m_pSymbolLabelStartEntry[nQueryHash];

			while (count2 != -1 && bFoundLabel == FALSE)
			{
				if (m_pSymbolQueryList[count].m_nSymbolSubType1 == m_pSymbolLabelList[count2].m_nSymbolSubType1 &&
				        m_pSymbolQueryList[count].m_nSymbolSubType2 == m_pSymbolLabelList[count2].m_nSymbolSubType2 &&
				        m_pSymbolQueryList[count].m_nSymbolType     == m_pSymbolLabelList[count2].m_nSymbolType)
				{
					int32_t nIdentifier;
					if (m_pSymbolQueryList[count].m_nSymbolType == CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY ||
					        m_pSymbolQueryList[count].m_nSymbolType == CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_EXIT)
					{
						if (m_pSymbolQueryList[count].m_nSymbolSubType2 == 0 &&
						        m_pSymbolQueryList[count].m_nSymbolSubType1 != 0)
						{
							nIdentifier = m_pSymbolQueryList[count].m_nSymbolSubType1;
						}
						else
						{
							// For main, StartingConditional and #globals, we should go through these hoops.
							CExoString sNewFunctionName = GetFunctionNameFromSymbolSubTypes(m_pSymbolQueryList[count].m_nSymbolSubType1,
							                              m_pSymbolQueryList[count].m_nSymbolSubType2);
							nIdentifier = GetIdentifierByName(sNewFunctionName);
							if (nIdentifier < 0)
							{
								if (sNewFunctionName == "")
								{
									// Sorry, dude ... this shouldn't have happened under any circumstance.
									return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER, NULL);
								}

								return OutputIdentifierError(sNewFunctionName,nIdentifier,0);
							}
						}
					}
					else
					{
						// The label does not contain a function name, so it is more than likely within the same function as the query.
						nIdentifier = nQueryIdentifier;
					}

					int32_t nResolvedAddress = m_pSymbolLabelList[count2].m_nLocationPointer + (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart - m_pcIdentifierList[nIdentifier].m_nBinarySourceStart);

					// Now that we have the two, we can subtract the two from
					// one another, and write that relative JMP into the code.

					// DON'T FORGET TO REMOVE THE OPERATION_BASE_SIZE, TOO!
					// Without it, you won't have the true instruction pointer,
					// since the label only stores where the label belongs in
					// the source code!

					int32_t nJmpLength = nResolvedAddress - (nResolvedLocationOfAddress - CVIRTUALMACHINE_OPERATION_BASE_SIZE);

					// ... and write it into its appropriate location.
					m_pchOutputCode[m_pSymbolQueryList[count].m_nLocationPointer]     = (char) (((nJmpLength) >> 24) & 0x0ff);
					m_pchOutputCode[m_pSymbolQueryList[count].m_nLocationPointer + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
					m_pchOutputCode[m_pSymbolQueryList[count].m_nLocationPointer + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
					m_pchOutputCode[m_pSymbolQueryList[count].m_nLocationPointer + 3] = (char) (((nJmpLength)      ) & 0x0ff);

					bFoundLabel = TRUE;
				}

				count2 = m_pSymbolLabelList[count2].m_nNextEntryPointer;
			}

			if (bFoundLabel == FALSE)
			{
				CExoString sNewFunctionName = GetFunctionNameFromSymbolSubTypes(m_pSymbolQueryList[count].m_nSymbolSubType1,
				                              m_pSymbolQueryList[count].m_nSymbolSubType2);
				if (sNewFunctionName == "")
				{
					// Sorry, dude ... this shouldn't have happened under any circumstance.
					return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER, NULL);
				}

				return OutputIdentifierError(sFunctionName,STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER,0);
			}
		}
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InitializeSwitchLabelList()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/25/2000
// Description: This function will resolve the labels within this level of
//              switch statement.
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::InitializeSwitchLabelList()
{
	m_bSwitchLabelDefault = FALSE;
	m_nSwitchLabelNumber = 0;
	m_nSwitchLabelArraySize = 16;
	m_pnSwitchLabelStatements = new int32_t[m_nSwitchLabelArraySize];
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::TraverseTreeForSwitchLabels()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/25/2000
// Description: This function will resolve the labels within this level of
//              switch statement.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::TraverseTreeForSwitchLabels(CScriptParseTreeNode *pNode)
{
	// First, we scan to see if there are multiple labels of the same type.
	int nReturnValue;

	if (pNode == NULL)
	{
		return 0;
	}
	// First of all, if we are about to go into another switch block, abort!
	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK)
	{
		return 0;
	}

	nReturnValue = TraverseTreeForSwitchLabels(pNode->pLeft);
	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DEFAULT)
	{
		if (m_bSwitchLabelDefault == TRUE)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_MULTIPLE_DEFAULT_STATEMENTS_WITHIN_SWITCH, pNode);
		}
		m_bSwitchLabelDefault = TRUE;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CASE)
	{
		int32_t nCaseValue;

		ConstantFoldNode(pNode->pLeft, TRUE);
		// Evaluate the constant value that is contained.
		if (pNode->pLeft != NULL &&
		        pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_NEGATION &&
		        pNode->pLeft->pLeft != NULL &&
		        pNode->pLeft->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
		{
			nCaseValue = -pNode->pLeft->pLeft->nIntegerData;
		}
		else if (pNode->pLeft != NULL &&
		         pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
		{
			nCaseValue = pNode->pLeft->nIntegerData;
		}
		else if (pNode->pLeft != NULL &&
		         pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING)
		{
			nCaseValue = pNode->pLeft->m_psStringData->GetHash();
		}
		else
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_CASE_PARAMETER_NOT_A_CONSTANT_INTEGER,pNode);
		}

		// Now, we have to check if any of the previous case statements have the same value.
		int nCount;

		for (nCount = 0; nCount < m_nSwitchLabelNumber; ++nCount)
		{
			if (m_pnSwitchLabelStatements[nCount] == nCaseValue)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_MULTIPLE_CASE_CONSTANT_STATEMENTS_WITHIN_SWITCH,pNode);
			}
		}

		// Add the case statement to the list.
		if (m_nSwitchLabelNumber >= m_nSwitchLabelArraySize)
		{
			int32_t *pNewIntArray = new int32_t[m_nSwitchLabelArraySize * 2];
			for (nCount = 0; nCount < m_nSwitchLabelNumber; ++nCount)
			{
				pNewIntArray[nCount] = m_pnSwitchLabelStatements[nCount];
			}
			m_nSwitchLabelArraySize *= 2;
			delete[] m_pnSwitchLabelStatements;
			m_pnSwitchLabelStatements = pNewIntArray;
		}

		m_pnSwitchLabelStatements[m_nSwitchLabelNumber] = nCaseValue;
		++m_nSwitchLabelNumber;

		// Now, we add the pseudocode:
		// COPYTOP fffffffc,0004  // copies the switch result so that we can use it.
		// CONSTI  nCaseValue     // adds the constant that we're to compare against.
		// EQUALII                // compares the two, leaving the result on the stack.
		// JNZ    _SC_nCaseValue_nSwitchIdentifier  // result goes away, jump executed.

		// CODE GENERATION
		// Here, we would dump the "appropriate" data from the run-time stack
		// on to the top of the stack, making a copy of it ... that's why
		// we're adding one to the appropriate run time stack.

		int32_t nStackElementsDown = -4;
		int32_t nSize = 4;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY;
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// CODE GENERATION
		// Here, we have a "constant integer" op-code that would be added.
		int32_t nIntegerData = nCaseValue;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;

		// Enter the integer constant.
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nIntegerData)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// CODE GENERATION
		// Write an "condition EQUALII" operation.
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// CODE GENERATION
		// Add the "JNZ _SC_nCaseValue_nSwitchIdentifier" operation.
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JNZ;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		/* CExoString sSymbolName;
		sSymbolName.Format("_SC_%08x_%08x",nCaseValue,m_nSwitchIdentifier); */
		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_CASE,
		                     nCaseValue,m_nSwitchIdentifier);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	}

	nReturnValue = TraverseTreeForSwitchLabels(pNode->pRight);
	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ClearSwitchLabelList()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/25/2000
// Description: This function will resolve the labels within this level of
//              switch statement.
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::ClearSwitchLabelList()
{
	// Finally, don't forget the last piece of code, where we jump to the
	// default label, if it exists.

	if (m_bSwitchLabelDefault == TRUE)
	{
		// There is a default statement ... we jump there immediately.

		// CODE GENERATION
		// Add the "JMP _SC_DEFAULT_nSwitchIdentifier" operation.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		/* CExoString sSymbolName;
		sSymbolName.Format("_SC_DEFAULT_%08x",m_nSwitchIdentifier); */
		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_DEFAULT,
		                     m_nSwitchIdentifier,0);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
	}
	else
	{
		// There is no default statement ... we jump over the entire switch once
		// we've evaded all of the case statements.

		// CODE GENERATION
		// Add the "JMP _BR_nSwitchIdentifier" operation.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		/*CExoString sSymbolName;
		sSymbolName.Format("_BR_%08x",m_nSwitchIdentifier);*/
		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK,
		                     m_nSwitchIdentifier,0);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
	}


	m_bSwitchLabelDefault = FALSE;
	m_nSwitchLabelNumber = 0;
	m_nSwitchLabelArraySize = 16;
	delete[] m_pnSwitchLabelStatements;
	m_pnSwitchLabelStatements = NULL;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GenerateIdentifiersFromConstantVariables()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 27, 2002
// Description: This function will resolve all of the constant declarations
//              into "identifiers" that can be used in case statements.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::GenerateIdentifiersFromConstantVariables(CScriptParseTreeNode *pNode)
{
	if (pNode != NULL)
	{
		if (pNode != NULL &&
		        pNode->pLeft != NULL &&
		        pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION &&
		        pNode->pLeft->pRight != NULL &&
		        pNode->pLeft->pRight->pLeft != NULL)
		{
			int32_t nVariableTypeOperation = pNode->pLeft->pLeft->nOperation;
			CScriptParseTreeNode *pNodeVariableName = pNode->pLeft->pRight->pLeft;

			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierType   = 0;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier      = *(pNodeVariableName->m_psStringData);
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierHash   = HashString(pNodeVariableName->m_psStringData->CStr());
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierLength = pNodeVariableName->m_psStringData->GetLength();

			// MGB - If a previous declaration and implementation match, an identifier
			// gets removed from the stack.  Thus, m_nOccupiedIdentifiers should be cleared.
			// This is the biggest "remaining" bug, since it prevents a future function from
			// compiling.
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters = 0;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nNonOptionalParameters = 0;

			if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER;
			}
			else if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER;
			}
			else if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER;
			}
			else
			{
				// MGB - Nov. 22, 2002 - It should not have been possible to get to here without
				// going through an integer, floating point or string constant, so UNKNOWN_STATE
				// makes perfect sense.
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNodeVariableName);
			}

			// If there is an assignment ... then we should do something about this!
			if (pNode->pRight != NULL &&
			        pNode->pRight->pLeft != NULL &&
			        pNode->pRight->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_ASSIGNMENT &&
			        pNode->pRight->pLeft->pLeft != NULL &&
			        pNode->pRight->pLeft->pLeft->pLeft != NULL)
			{
				CScriptParseTreeNode *pNodeConstant = pNode->pRight->pLeft->pLeft->pLeft;
				ConstantFoldNode(pNodeConstant, TRUE);

				int32_t nConstantOperation = pNodeConstant->nOperation;
				int32_t nSign = 1;

				if (nConstantOperation == CSCRIPTCOMPILER_OPERATION_NEGATION)
				{
					if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INVALID_VALUE_ASSIGNED_TO_CONSTANT,pNodeConstant);
					}
					nSign = -1;
					pNodeConstant = pNodeConstant->pLeft;
					nConstantOperation = pNodeConstant->nOperation;
				}

				if ((nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT &&
				        nConstantOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER) ||
				        (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT &&
				         nConstantOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT) ||
				        (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING &&
				         nConstantOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING))
				{
					return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INVALID_VALUE_ASSIGNED_TO_CONSTANT,pNodeConstant);
				}

				// Fill in data for the constant.
				if (nConstantOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
				{
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIntegerData = nSign * pNodeConstant->nIntegerData;
					(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData).Format("%d",m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIntegerData);
				}
				else if (nConstantOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING)
				{
					(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData).Format("%s",pNodeConstant->m_psStringData->CStr());
				}
				else if (nConstantOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT)
				{
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_fFloatData = (float) nSign * pNodeConstant->fFloatData;
					if (nSign == -1)
					{
						(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData).Format("-%f",pNodeConstant->fFloatData);
					}
					else
					{
						(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData).Format("%f",pNodeConstant->fFloatData);
					}
				}
			}
			else
			{
				// No initialization, or it is so malformed, that the parse tree code
				// doesn't recognize it ... so we're going to set it equal to its default
				// value.
				if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
				{
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIntegerData = 0;
					(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData) = "0";
				}
				else if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
				{
					(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData) = "";
				}
				else if (nVariableTypeOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
				{
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_fFloatData = 0.0f;
					(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStringData) = "0.0f";
				}
			}
			HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, m_nOccupiedIdentifiers);
			++m_nOccupiedIdentifiers;
		}
		int32_t nReturnValue = GenerateIdentifiersFromConstantVariables(pNode->pRight);
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GenerateCodeForSwitchLabels()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/25/2000
// Description: This function will resolve the labels within this level of
//              switch statement.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::GenerateCodeForSwitchLabels(CScriptParseTreeNode *pNode)
{
	int32_t nReturnValue = 0;

	InitializeSwitchLabelList();
	if (pNode != NULL)
	{
		nReturnValue = TraverseTreeForSwitchLabels(pNode->pRight);
	}
	if (nReturnValue < 0)
	{
		return nReturnValue;
	}
	ClearSwitchLabelList();

	// MGB - For Script Debugger
	if (m_nGenerateDebuggerOutput != 0)
	{
		EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::WriteResolvedOutput()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
// Description: This function will resolve all of the labels, based on the
//              final location of the functions within the script.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::WriteResolvedOutput()
{

	if (m_pchResolvedOutputBuffer == NULL ||
	        m_nResolvedOutputBufferSize < m_nFinalBinarySize)
	{
		if (m_pchResolvedOutputBuffer != NULL)
		{
			delete[] m_pchResolvedOutputBuffer;
		}
		// The * 2 is intentional (so we avoid calling this
		// each time the compiled file increases by a few bytes!)
		m_pchResolvedOutputBuffer = new char[m_nFinalBinarySize * 2];
		m_nResolvedOutputBufferSize = m_nFinalBinarySize;
	}

	memset(m_pchResolvedOutputBuffer,0,m_nResolvedOutputBufferSize);

	memcpy(m_pchResolvedOutputBuffer,m_pchOutputCode,CVIRTUALMACHINE_BINARY_SCRIPT_HEADER * sizeof(char));

	for (int32_t count = m_nMaxPredefinedIdentifierId; count < m_nOccupiedIdentifiers; count++)
	{
		if (m_pcIdentifierList[count].m_nBinaryDestinationStart != -1)
		{
			int32_t nSize = (m_pcIdentifierList[count].m_nBinaryDestinationFinish - m_pcIdentifierList[count].m_nBinaryDestinationStart) * sizeof (char);
			memcpy(m_pchResolvedOutputBuffer + m_pcIdentifierList[count].m_nBinaryDestinationStart,
			       m_pchOutputCode           + m_pcIdentifierList[count].m_nBinarySourceStart,
			       nSize);
		}
	}

	// Now, we copy it back into the output code buffer!
	memcpy(m_pchOutputCode,m_pchResolvedOutputBuffer,m_nFinalBinarySize);
	m_nOutputCodeLength = m_nFinalBinarySize;

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PreVisitGenerateCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  This routine will generate code to be spat out into the
//                necessary file.  Will return 0 if the operation is okay,
//                and will return a negative number if it isn't.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::PreVisitGenerateCode(CScriptParseTreeNode *pNode)
{
	// MGB - For Script Debugger
	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT)
	{
		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_NON_VOID_EXPRESSION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION)
	{

		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT)
		{
			m_nVarStackRecursionLevel++;
		}

		// Save the state of the run-time stacks, so that we can check 'em at the
		// end.  This way, we can verify if we're following the code correctly.

		pNode->m_nStackPointer = m_nStackCurrentDepth;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION)
	{
		m_bFunctionImp = FALSE;
		if (pNode->pRight != NULL)
		{
			m_bFunctionImp = TRUE;
		}

		if (m_bFunctionImp == TRUE)
		{

			m_nVarStackRecursionLevel++;

			m_sFunctionImpName = *(pNode->pLeft->pLeft->m_psStringData);

			int32_t nIdentifier = GetIdentifierByName(m_sFunctionImpName);

			if (nIdentifier < 0)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
			}

			m_pcIdentifierList[nIdentifier].m_nBinarySourceStart       = m_nOutputCodeLength;
			m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish      = -1;
			m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart  = -1;
			m_pcIdentifierList[nIdentifier].m_nBinaryDestinationFinish = -1;

			/* CExoString sSymbolName;
			sSymbolName.Format("FE_%s",m_sFunctionImpName.CStr()); */
			AddSymbolToLabelList(m_nOutputCodeLength,
			                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
			                     nIdentifier,0);

			int32_t nIdentifierLength = m_sFunctionImpName.GetLength();

			if (m_bCompileConditionalFile == 0)
			{
				if (m_sFunctionImpName.GetLength() == 4 &&
				        strncmp(m_sFunctionImpName.CStr(),"main",4) == 0)
				{
					AddSymbolToLabelList(m_nOutputCodeLength,
					                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
					                     0,2);
				}
			}
			else
			{
				if (nIdentifierLength == 19 &&
				        strncmp(m_sFunctionImpName.CStr(),"StartingConditional",19) == 0)
				{
					AddSymbolToLabelList(m_nOutputCodeLength,
					                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
					                     0,2);
				}
			}

			//m_bFunctionImpHasReturn = FALSE;
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_GLOBAL_VARIABLES)
	{
		m_bFunctionImp = FALSE;
		if (pNode->pRight != NULL)
		{
			m_bFunctionImp = TRUE;
		}

		if (m_bFunctionImp == TRUE)
		{
			m_nVarStackRecursionLevel++;

			if (m_bGlobalVariableDefinition != FALSE)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
			}

			m_bGlobalVariableDefinition = TRUE;
			// MGB - September 13, 2001 - This can't be called
			// when you are using an integer-returning function.  This is bad.
			/*
			m_nGlobalVariables = 0;
			m_nGlobalVariableSize = 0;
			*/

			m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier = "#globals";
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierHash = HashString("#globals");
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierLength = 8;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceStart = m_nOutputCodeLength;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationStart = -1;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationFinish = -1;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters = 0;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER;
			HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, m_nOccupiedIdentifiers);

			/* CExoString sSymbolName;
			sSymbolName.Format("FE_#globals"); */

			AddSymbolToLabelList(m_nOutputCodeLength,
			                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
			                     m_nOccupiedIdentifiers,0);

			AddSymbolToLabelList(m_nOutputCodeLength,
			                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
			                     0,1);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CASE)
	{
		int32_t nCaseValue;

			ConstantFoldNode(pNode->pLeft, TRUE);
		// Evaluate the constant value that is contained.
		if (pNode->pLeft != NULL &&
		        pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_NEGATION &&
		        pNode->pLeft->pLeft != NULL &&
		        pNode->pLeft->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
		{
			nCaseValue = -pNode->pLeft->pLeft->nIntegerData;
		}
		else if (pNode->pLeft != NULL &&
		         pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
		{
			nCaseValue = pNode->pLeft->nIntegerData;
		}
		else if (pNode->pLeft != NULL &&
		         pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING)
		{
			nCaseValue = pNode->pLeft->m_psStringData->GetHash();
		}
		else
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_CASE_PARAMETER_NOT_A_CONSTANT_INTEGER,pNode);
		}

		// Generate a label for the jump caused by the switch
		/*CExoString sSymbolName;
		sSymbolName.Format("_SC_%08x_%08x",nCaseValue,m_nSwitchIdentifier); */

		AddSymbolToLabelList(m_nOutputCodeLength,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_CASE,
		                     nCaseValue,m_nSwitchIdentifier);

		if (m_nSwitchStackDepth + 1 != m_nStackCurrentDepth)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_JUMPING_OVER_DECLARATION_STATEMENTS_CASE_DISALLOWED,pNode);
		}

		// Do not allow the tree to continue parsing ... we've done everything required.
		return 1;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_DEFINITION)
	{
		// We should be in the variable-processing stage of the strucutre
		// definition at this point.

		if (m_nStructureDefinition != 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		m_nStructureDefinition = 1;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION_PARAMETER)
	{
		// CODE GENERATION
		// This is a "action parameter" instruction.  Thus, we don't intend
		// on running the instruction contained by this part of the compile tree
		// right away.  Therefore, what we're going to do is store the state of
		// the instruction pointer, and keep cruisin'.  This will give us a
		// fighting chance of identifying the start of the action when someone
		// wishes to rerun this action.

		//
		// First, we add the STORE_IP instruction.
		//

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_STORE_STATE;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = (CVIRTUALMACHINE_OPERATION_BASE_SIZE * 2 + 12);

		int32_t nIntegerData = m_nGlobalVariableSize;
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nIntegerData)) & 0x0ff);

		nIntegerData = m_nStackCurrentDepth * 4 - m_nGlobalVariableSize;
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+6] = (char) (((nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+7] = (char) (((nIntegerData)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 8;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		//
		// Next, we add the JMP instruction.
		//

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// Save the current state of the binary code length for the purpose
		// of generating a good jump over the code within this instruction in
		// the PostVisitGenerateCode() call.

		pNode->nIntegerData = m_nOutputCodeLength;

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION)
	{
		//if (m_bGlobalVariableDefinition == TRUE)
		//{
		//    return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		//}

		// Determine, based on the ID of the function, whether we're
		// dealing with a function of the user's creation, or one of our
		// own.  This makes a difference to the code that we generate.

		if (pNode->pRight != NULL)
		{
			int32_t nCount = GetIdentifierByName(*(pNode->pRight->m_psStringData));
			if (nCount == STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
			}

			pNode->pRight->nIntegerData = nCount;
			{
				if (nCount >= m_nMaxPredefinedIdentifierId)
				{
					pNode->nIntegerData = 1;

					// Because this is a user-defined identifier, we
					// have to reserve space on the runtime stack
					// right away for the return type, if it is non-void
					// (of course!)

					int32_t nReturnType = 0;
					CExoString sStructureName = "";

					if (m_pcIdentifierList[nCount].m_nReturnType != CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER)
					{
						if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
						}
						else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
						}
						else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
						}
						else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
						}
						else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
							sStructureName = m_pcIdentifierList[nCount].m_psStructureReturnName;
						}
						else if (m_pcIdentifierList[nCount].m_nReturnType >= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER &&
						         m_pcIdentifierList[nCount].m_nReturnType <= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER)
						{
							nReturnType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 + (m_pcIdentifierList[nCount].m_nReturnType - CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER);
						}
						else
						{
							return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
						}

						AddVariableToStack(nReturnType, &sStructureName, TRUE);
					}
				}
				else
				{
					pNode->nIntegerData = 0;
				}

				// This part of the code attempts to precompile all optional parameters.
				// It is incredibly similar to the code in PostVisit
				CScriptParseTreeNode *pTracePtr;
				int nParameters = 0;

				pTracePtr = pNode->pLeft;

				while (pTracePtr != NULL)
				{
					nParameters++;
					pTracePtr = pTracePtr->pLeft;
				}

				int nCount = pNode->pRight->nIntegerData;
				BOOL bMatch = TRUE;

				if (nParameters > m_pcIdentifierList[nCount].m_nParameters)
				{
					bMatch = FALSE;
				}

				if (nParameters < m_pcIdentifierList[nCount].m_nNonOptionalParameters)
				{
					bMatch = FALSE;
				}

				if (bMatch == TRUE)
				{
					if (nParameters != m_pcIdentifierList[nCount].m_nParameters)
					{
						int32_t nCount2;
						for (nCount2 = m_pcIdentifierList[nCount].m_nParameters - 1; nCount2 >= nParameters; --nCount2)
						{
							if (m_pcIdentifierList[nCount].m_pbOptionalParameters[nCount2] != TRUE)
							{
								return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_DECLARATION_DOES_NOT_MATCH_PARAMETERS,pNode);
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_INT &&
							        m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT &&
							        m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING &&
							        m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT &&
                                    m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2 /* location */ &&
                                    m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7 /* json */ &&
							        (m_pcIdentifierList[nCount].m_pchParameters[nCount2] != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT ||
							         m_pcIdentifierList[nCount].m_psStructureParameterNames[nCount2] != "vector"))
							{
								return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_TYPE_DOES_NOT_HAVE_AN_OPTIONAL_PARAMETER,pNode);
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
							{
								// CODE GENERATION
								// Here, we have a "constant integer" op-code that would be added.
								int32_t nIntegerData = m_pcIdentifierList[nCount].m_pnOptionalParameterIntegerData[nCount2];

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;

								// Enter the integer constant.
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nIntegerData) >> 24) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nIntegerData) >> 16) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nIntegerData) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nIntegerData)) & 0x0ff);

								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
								++m_nStackCurrentDepth;
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
							{
								// CODE GENERATION
								// Here, we have a "constant float" op-code that would be added.

								float fFloatData = m_pcIdentifierList[nCount].m_pfOptionalParameterFloatData[nCount2];

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;

								// Enter the floating point constant.

								///////////////////////////////////////////////////////////////////////////
								// This may need some explaining.  The MacIntosh deals with floating point
								// numbers in the same way as integers ... it reverses the bytes.  Thus, if
								// we want to avoid doing byte swaps, what we should do is write the data
								// out in the specified byte order, and then read it back in with the
								// specified byte order.  However, you can't just "shift left" on floats,
								// so we cast the data to an integer, and then write that out!  Tricky, but
								// it should work.
								//
								// -- Mark Brockington, 01/22/2000
								///////////////////////////////////////////////////////////////////////////


								int32_t *pFloatAsInt = (int32_t *) &fFloatData;
								m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((*pFloatAsInt) >> 24) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((*pFloatAsInt) >> 16) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((*pFloatAsInt) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((*pFloatAsInt)) & 0x0ff);

								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
								++m_nStackCurrentDepth;
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT &&
							        m_pcIdentifierList[nCount].m_psStructureParameterNames[nCount2] == "vector")
							{
								// CODE GENERATION
								// Here, we have a "constant float" op-code that would be added.

								for (int32_t temp = 0; temp < 3; ++temp)
								{
									float fFloatData = m_pcIdentifierList[nCount].m_pfOptionalParameterVectorData[nCount2 * 3 + temp];

									m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
									m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;

									// Enter the floating point constant.

									int32_t *pFloatAsInt = (int32_t *) &fFloatData;
									m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((*pFloatAsInt) >> 24) & 0x0ff);
									m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((*pFloatAsInt) >> 16) & 0x0ff);
									m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((*pFloatAsInt) >> 8) & 0x0ff);
									m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((*pFloatAsInt)) & 0x0ff);

									m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
									m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

									m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
									++m_nStackCurrentDepth;
								}
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
							{
								// CODE GENERATION
								// Here, we have a "constant string" op-code that would be added.

								CExoString sStringData = m_pcIdentifierList[nCount].m_psOptionalParameterStringData[nCount2];
								int nLength = sStringData.GetLength();

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;

								// Enter the string constant.

								m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nLength) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nLength)) & 0x0ff);

								int nCount3;
								for (nCount3 = 0; nCount3 < nLength; nCount3++)
								{
									m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+nCount3+2] = (sStringData.CStr())[nCount3];
								}
								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + nLength + 2;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;
								++m_nStackCurrentDepth;
							}

							if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
							{
								// CODE GENERATION
								// Here, we have a "constant object" op-code that would be added.
								OBJECT_ID oidObjectData = m_pcIdentifierList[nCount].m_poidOptionalParameterObjectData[nCount2];

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;

								// Enter the integer constant.
								int32_t nIntegerData = (int32_t) oidObjectData;

								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nIntegerData) >> 24) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nIntegerData) >> 16) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nIntegerData) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nIntegerData)) & 0x0ff);

								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;
								++m_nStackCurrentDepth;
							}

                            if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2) // location
                            {
                                // Encode the location as a int for now.

                                int32_t nIntegerData = m_pcIdentifierList[nCount].m_pnOptionalParameterIntegerData[nCount2];

                                // only LOCATION_INVALID supported for now
                                if (nIntegerData != 0)
                                {
                                    return OutputWalkTreeError(STRREF_CVIRTUALMACHINE_ERROR_INVALID_EXTRA_DATA_ON_OP_CODE, pNode);
                                }

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST2;

								// Enter the integer constant.
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nIntegerData) >> 24) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nIntegerData) >> 16) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nIntegerData) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nIntegerData)) & 0x0ff);

								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST2;
								++m_nStackCurrentDepth;
                            }

                            if (m_pcIdentifierList[nCount].m_pchParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7) // json
                            {
                                // encode the json as a variable-size payload string

                                CExoString sStringData = m_pcIdentifierList[nCount].m_psOptionalParameterStringData[nCount2];
                                EXOASSERT(sStringData.GetLength() <= 0xffff);
                                if (sStringData.GetLength() > 0xffff)
                                {
                                    return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG,pNode);
                                }

                                const uint16_t nLength = sStringData.GetLength();

								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
								m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST7;

								// Enter the jsonified string constant.

								m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nLength) >> 8) & 0x0ff);
								m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nLength)) & 0x0ff);

								int nCount3;
								for (nCount3 = 0; nCount3 < nLength; nCount3++)
								{
									m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+nCount3+2] = (sStringData.CStr())[nCount3];
								}
								m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + nLength + 2;
								m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

								m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST7;
								++m_nStackCurrentDepth;

                            }



						}
					}


					return 0;
				}
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_DECLARATION_DOES_NOT_MATCH_PARAMETERS,pNode);
			}
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK)
	{

		// Set the label for continue jumps.
		pNode->nIntegerData3 = m_nLoopIdentifier;
		pNode->nIntegerData4 = m_nLoopStackDepth;
		m_nLoopIdentifier = m_nOutputCodeLength;
		m_nLoopStackDepth = m_nStackCurrentDepth;

		// First things first, we may need to jump all the way back to
		// this point in the code, so we should save the location of this
		// part of the code.

		pNode->nIntegerData = m_nOutputCodeLength;

		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK)
	{
		++m_nSwitchLevel;

		// Store the old value of the switch identifier, and then
		// create our own value for the switch identifier.

		pNode->nIntegerData2 = m_nSwitchIdentifier;
		pNode->nIntegerData3 = m_nSwitchStackDepth;
		m_nSwitchIdentifier = m_nOutputCodeLength;
		m_nSwitchStackDepth = m_nStackCurrentDepth;

		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK)
	{

		// Set label for continue/break jumps.
		pNode->nIntegerData3 = m_nLoopIdentifier;
		pNode->nIntegerData4 = m_nLoopStackDepth;
		m_nLoopIdentifier = m_nOutputCodeLength;
		m_nLoopStackDepth = m_nStackCurrentDepth;

		// First things first, we may need to jump all the way back to
		// this point in the code, so we should save the location of this
		// part of the code.

		pNode->nIntegerData = m_nOutputCodeLength;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CHOICE)
	{
		// First things first, we may need to jump all the way back to
		// this point in the code, so we should save the location of this
		// part of the code.

		pNode->nIntegerData = m_nOutputCodeLength;

		if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
		}
		--m_nStackCurrentDepth;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// Save the current state of the binary code length for the purpose
		// of generating a good jump over the code within this instruction in
		// the PostVisitGenerateCode() call.

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COND_CHOICE)
	{
		// First things first, we may need to jump all the way back to
		// this point in the code, so we should save the location of this
		// part of the code.

		pNode->nIntegerData = m_nOutputCodeLength;

		if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
		}
		--m_nStackCurrentDepth;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// Save the current state of the binary code length for the purpose
		// of generating a good jump over the code within this instruction in
		// the PostVisitGenerateCode() call.

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CONDITION)
	{
		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_DECREMENT)
	{
		// Here we write the code for doing a pre-increment or a pre-decrement, and
		// we actually do all the checking (and filling in the address) in the
		// PostVisitGenerateCode() call.  Makes sense?  I sure hope so when I have
		// to look at this four months down the road.  :-)

		// For writing out the code, just store a blank location.
		int32_t nStackElementsDown = 0;

		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_INCREMENT;
		}
		else
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DECREMENT;
		}
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

		// The address for the "blank" address should be stored in pNode->nIntegerData2;
		pNode->nIntegerData2 = m_nOutputCodeLength;

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		return 0;
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::InVisitGenerateCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  This routine will generate code to be spat out into the
//                necessary file.  Will return 0 if the operation is okay,
//                and will return a negative number if it isn't.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::InVisitGenerateCode(CScriptParseTreeNode *pNode)
{

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_DEFINITION)
	{
		// We should be in the variable-processing stage of the strucutre
		// definition at this point.

		if (m_nStructureDefinition != 1)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		m_nStructureDefinition = 2;

		if (pNode->pLeft == NULL || pNode->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		int32_t count;
		for (count = 0; count < m_nMaxStructures; count++)
		{
			if (*(pNode->pLeft->m_psStringData) == m_pcStructList[count].m_psName)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_STRUCTURE_REDEFINED,pNode);
			}
		}

		m_pcStructList[m_nMaxStructures].m_psName = *(pNode->pLeft->m_psStringData);
		m_pcStructList[m_nMaxStructures].m_nByteSize  = 0;
		m_pcStructList[m_nMaxStructures].m_nFieldStart = m_nMaxStructureFields;
		m_pcStructList[m_nMaxStructures].m_nFieldEnd   = -1;

		m_nStructureDefinitionFieldStart = m_nMaxStructureFields;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ASSIGNMENT)
	{
		if (pNode->pRight != NULL && pNode->pLeft != NULL)
		{
			// Is the storage location a valid LValue?
			if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE || pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
			{
				m_bAssignmentToVariable = TRUE;
				return 0;
			}
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INVALID_PARAMETERS_FOR_ASSIGNMENT,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG)
	{

		// Do NOTHING on a normal keyword declaration statement ... leave it as a
		// statement, since this is equivalent to a STATEMENT_VOID.  Also, we can add
		// a whole pile of variables in one statement, and we don't want to remove them.
		// So, we should bail out of the routine right now if we're dealing with a
		// declaration keyword.
		//
		// Note that we also have complex chains of statements within a "statement list"
		// (since we now allow these to be statically initialized).  Hence, the really
		// gruesome looking second condition.

		if ((pNode->pLeft != NULL && pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION) ||
		        //(pNode->pLeft != NULL && pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_RETURN) ||
		        (pNode->pLeft != NULL                             && pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST &&
		         ((pNode->pLeft->pLeft != NULL             && pNode->pLeft->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT) || (pNode->pLeft->pLeft != NULL              && pNode->pLeft->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG)) &&
		         pNode->pLeft->pLeft->pLeft != NULL && pNode->pLeft->pLeft->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION))
		{
			if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT)
			{
				if (m_nGenerateDebuggerOutput != 0)
				{
					EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
				}
			}
			return 0;
		}

		// Update the state of the stack to where it should be.  We will
		// be writing out the code to do this here.
		pNode->nIntegerData = (pNode->m_nStackPointer - m_nStackCurrentDepth) * 4;
		m_nStackCurrentDepth = pNode->m_nStackPointer;

		// CODE GENERATION
		// Move the stack to update the current location of the code.

		if (pNode->nIntegerData != 0)
		{
			EmitModifyStackPointer(pNode->nIntegerData);
		}

		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT)
		{
			if (m_nGenerateDebuggerOutput != 0)
			{
				EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
			}
		}
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK)
	{
		return GenerateCodeForSwitchLabels(pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK)
	{
		//
		// Set up our conditional jump at this point in the code.  We may
		// also need to reference this location at a later time to add the
		// address of where to jump to!

		pNode->nIntegerData2 = m_nOutputCodeLength;

		if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
		}
		--m_nStackCurrentDepth;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// Save the current state of the binary code length for the purpose
		// of generating a good jump over the code within this instruction in
		// the PostVisitGenerateCode() call.

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		if (m_nGenerateDebuggerOutput != 0)
		{
			EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CHOICE)
	{
		pNode->nIntegerData2 = m_nOutputCodeLength;

		// Here, we implement the skip-ahead to _I2_ and install the
		// label at _I1_.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JZ command we gave earlier during
		// the PreVisit() [code located at pNode->nIntegerdata].
		// This is an awfully good thing to do.

		int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData;
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// MGB - For Script Debugger
		if (pNode->pRight != NULL)
		{

			if (m_nGenerateDebuggerOutput != 0)
			{
				StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
			}

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NO_OPERATION;
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			if (m_nGenerateDebuggerOutput != 0)
			{
				EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
			}

		}


	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COND_CHOICE)
	{

		pNode->nIntegerData2 = m_nOutputCodeLength;

		// Here, we implement the skip-ahead to _CH2_ and install the
		// label at _CH1_.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JZ command we gave earlier during
		// the PreVisit() [code located at pNode->nIntegerdata].
		// This is an awfully good thing to do.

		int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData;
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// NOTE:  We've got to get rid of the first thing on the stack here, otherwise, we're
		// TOTALLY boned when using variables in the second part.

		int32_t nElementsToDelete = 4;
		if (pNode->pLeft && pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			nElementsToDelete = GetStructureSize(*(pNode->pLeft->m_psTypeName));
		}

		m_nStackCurrentDepth -= (nElementsToDelete >> 2);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION && m_bFunctionImp == TRUE)
	{
		// Get the current stack pointer, now that we've added fake
		// versions of all of the variables on to the stack.  Woo-hoo!

		pNode->m_nStackPointer = m_nStackCurrentDepth;

		// Store it for use by the RETURN command, too!
		m_nFunctionImpAbortStackPointer = m_nStackCurrentDepth;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_LOGICAL_AND)
	{
		if (pNode->pLeft != NULL)
		{
			// Okay, this is the scoop.  If the top value is zero, we should
			// just ignore the code that does the rest of the "if choice".

			// ... the integer at the top of the stack.

			// CODE GENERATION
			// Here, we would dump the "appropriate" data from the run-time stack
			// on to the top of the stack, making a copy of it ... that's why
			// we're adding one to the appropriate run time stack.

			int32_t nStackElementsDown = -4;
			int32_t nSize = 4;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT, NULL, FALSE);

			//
			// ... and a JZ to skip the right branch.
			//

			pNode->nIntegerData = m_nOutputCodeLength;
			if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
			}
			--m_nStackCurrentDepth;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

			// The jump length is over this instruction and the jmp instruction, both of
			// which are OPERATION_BASE_SIZE + 4 (for the address).

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_LOGICAL_OR)
	{
		if (pNode->pLeft != NULL)
		{
			// Okay, this is the scoop.  If the top value is zero, we should
			// just ignore the code that does the rest of the "if choice".

			// ...  the integer at the top of the stack.

			// CODE GENERATION
			// Here, we would dump the "appropriate" data from the run-time stack
			// on to the top of the stack, making a copy of it ... that's why
			// we're adding one to the appropriate run time stack.

			int32_t nStackElementsDown = -4;
			int32_t nSize = 4;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT, NULL, FALSE);

			//
			// ... and a JZ to skip to the right branch!
			//

			if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
			}
			--m_nStackCurrentDepth;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

			// The jump length is over this instruction and the jmp instruction, and
			// the copy top instruction (an additional 4+6+4 bytes above the BASE_SIZE
			// operations).

			int32_t nJmpLength = (CVIRTUALMACHINE_OPERATION_BASE_SIZE * 3) + 4 + 6 + 4;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION]   = (char) (((nJmpLength) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nJmpLength) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nJmpLength) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nJmpLength)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			// .... the integer at the top of the stack.

			// CODE GENERATION
			// Here, we would dump the "appropriate" data from the run-time stack
			// on to the top of the stack, making a copy of it ... that's why
			// we're adding one to the appropriate run time stack.

			nStackElementsDown = -4;
			nSize = 4;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			// IMPORTANT NOTE:  It is absolutely vital to NOT add this variable to the
			// stack, since this path is completely optional ... and the right branch
			// will be adding an integer anyway!

			pNode->nIntegerData = m_nOutputCodeLength;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

			// The jump length is over this instruction and the jmp instruction, both of
			// which are OPERATION_BASE_SIZE + 4 (for the address).

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);


		}
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
	{
		m_bInStructurePart = TRUE;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK)
	{
		// Generate a label for the continue keyword.

		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}

		/* CExoString sSymbolName;
		sSymbolName.Format("_CN_%08x",m_nLoopIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_CONTINUE,
		                     m_nLoopIdentifier);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT)
	{
		if (m_nGenerateDebuggerOutput != 0)
		{
			EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}
	}


	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PostVisitGenerateCode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  This routine will generate code to be spat out into the
//                necessary file.  Will return 0 if the operation is okay,
//                and will return a negative number if it isn't.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::PostVisitGenerateCode(CScriptParseTreeNode *pNode)
{

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ASSIGNMENT)
	{
		if (pNode->pRight != NULL && pNode->pLeft != NULL)
		{
			// Variable is referred to in an expression.
			// Look for the variable in the list.  When we find it, generate its op-code.

			if (pNode->pRight->nType == pNode->pLeft->nType)
			{
				if (pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT &&
				        *(pNode->pRight->m_psTypeName) != *(pNode->pLeft->m_psTypeName))
				{
					return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_MISMATCHED_TYPES,pNode);
				}

				pNode->nType = pNode->pRight->nType;
				if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}
					(pNode->m_psTypeName) = new CExoString(pNode->pLeft->m_psTypeName->CStr());
				}

				// CODE GENERATION
				// We should generate a op-code that is consistent with the
				// type of assignment that is taking place (i.e. integer,
				// float, string or object).  This operation has no effect
				// on the run time stacks, but copies the code from the top
				// of the stack to the code.

				int32_t nStackElementsDown = pNode->pRight->nIntegerData - (m_nStackCurrentDepth * 4);
				int32_t nSize = 4;
				if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					nSize = GetStructureSize(*(pNode->m_psTypeName));
				}

				// MGB - August 10, 2001 - Determine whether we are going to operate on
				// the stack pointer (for a locally defined variable), or the base pointer
				// (for a global variable).

				int32_t bOperateOnStackPointer = TRUE;
				if (pNode->pRight->nIntegerData < m_nGlobalVariableSize && m_bGlobalVariableDefinition == FALSE)
				{
					bOperateOnStackPointer = FALSE;
					nStackElementsDown = pNode->pRight->nIntegerData - (m_nGlobalVariableSize);
				}

				if (bOperateOnStackPointer == TRUE)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ASSIGNMENT;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ASSIGNMENT_BASE;
				}

				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
				m_bAssignmentToVariable = FALSE;
				return 0;
			}
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_MISMATCHED_TYPES,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
	{
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
	{
		m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
	{
		m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
	{
		m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT)
	{
		m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
		return 0;
	}

	if (pNode->nOperation >= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 &&
	        pNode->nOperation <= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9)
	{
		m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 + (pNode->nOperation - CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0);
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
	{
		// When structure definition is 1, then we're in the
		// process of defining a structure name, and it's not
		// necessary to set these variables ... only when we're
		// actually defining a structure as a variable to be
		// used somewhere else.  Thus, we do it here.

		if (m_nStructureDefinition != 1)
		{
			m_nVarStackVariableType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
			m_sVarStackVariableTypeName = *(pNode->m_psStringData);
		}

		return 0;
	}

	int32_t nCount, nCount2;

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
	{

		// There are only two occasions where we should get a variable as a "terminal"
		// within the compile tree:  as a branch from a variable list node (in the
		// declaration part of the tree) or as a part of an expression.  The first
		// case is determined within this phase by checking to see if m_nVarStackVariableType
		// is not equal to OPERATION_KEYWORD_DECLARATION, because the type in this
		// variable specifies that we're in the middle of handling a declaration list!

		// There is a third case where a variable is handled as a terminal node, but the
		// assignment to a variable is handled in the case just above this one ... so
		// we don't have to worry about generating a value here.

		if (m_nVarStackVariableType != CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION)
		{
			if (m_nStructureDefinition == 0)
			{
				for (nCount = m_nOccupiedVariables; nCount >= 0; --nCount)
				{
					if (m_pcVarStackList[nCount].m_psVarName == *(pNode->m_psStringData) &&
					        m_pcVarStackList[nCount].m_nVarLevel == m_nVarStackRecursionLevel)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_VARIABLE_ALREADY_USED_WITHIN_SCOPE,pNode);
					}
				}

				++m_nOccupiedVariables;
				if (m_bGlobalVariableDefinition)
				{
					++m_nGlobalVariables;
					if (m_nVarStackVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
					{
						m_nGlobalVariableSize += GetStructureSize(m_sVarStackVariableTypeName);
					}
					else
					{
						m_nGlobalVariableSize += 4;
					}

				}

				m_pcVarStackList[m_nOccupiedVariables].m_psVarName = *(pNode->m_psStringData);
				m_pcVarStackList[m_nOccupiedVariables].m_nVarType = m_nVarStackVariableType;
				if (m_nVarStackVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName = m_sVarStackVariableTypeName;

					int32_t count;
					BOOL bFoundStructure = FALSE;
					for (count = 0; count < m_nMaxStructures; count++)
					{
						if (m_sVarStackVariableTypeName == m_pcStructList[count].m_psName)
						{
							bFoundStructure = TRUE;
						}
					}
					if (bFoundStructure == FALSE)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_STRUCTURE,pNode);
					}

				}
				else
				{
					m_sVarStackVariableTypeName = "";
				}

				m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel = m_nVarStackRecursionLevel;
				m_pcVarStackList[m_nOccupiedVariables].m_nVarRunTimeLocation = m_nStackCurrentDepth * 4;



				int32_t nOccupiedVariables = m_nOccupiedVariables;
				int32_t nStackCurrentDepth = m_nStackCurrentDepth;
				int32_t nGlobalVariableSize = m_nGlobalVariableSize;

				// Now, we can add the variable to the stack!
				AddVariableToStack(m_nVarStackVariableType, &m_sVarStackVariableTypeName, TRUE);

				//AddToSymbolTableVarStack(nOccupiedVariables,nStackCurrentDepth,nGlobalVariableSize);
				if (m_bGlobalVariableDefinition)
				{
					// Global variables are always at the bottom of the stack,
					// so we fake out the SymbolTableVarStack to think that this
					// is its own stack context (even though we're in the middle
					// of building it!)
					AddToSymbolTableVarStack(nOccupiedVariables, nStackCurrentDepth, 0);
				}
				else
				{
					AddToSymbolTableVarStack(nOccupiedVariables, nStackCurrentDepth, nGlobalVariableSize);
				}

			}
			else
			{
				// This part checks instantiates variables within a structure
				// definition.  Thus, we really don't need to worry about writing
				// code out at this point ... we're just worried about semantic
				// checking of the various parts.

				// First, we should check to see if this name is used in any other
				// field within this structure
				for (nCount = m_nStructureDefinitionFieldStart; nCount < m_nMaxStructureFields; nCount++)
				{
					if (m_pcStructFieldList[nCount].m_psVarName == *(pNode->m_psStringData))
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_VARIABLE_USED_TWICE_IN_SAME_STRUCTURE,pNode);
					}
				}

				// Okay, now we're done ... store the structure field in its
				// proper location.

				m_pcStructFieldList[m_nMaxStructureFields].m_pchType = (char) m_nVarStackVariableType;
				if (m_nVarStackVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					m_pcStructFieldList[m_nMaxStructureFields].m_psStructureName = m_sVarStackVariableTypeName;
				}
				m_pcStructFieldList[m_nMaxStructureFields].m_psVarName = *(pNode->m_psStringData);
				m_pcStructFieldList[m_nMaxStructureFields].m_nLocation = 0;

				++m_nMaxStructureFields;
			}
		}
		else
		{
			// Variable is referred to in an expression.

			// Look for the variable in the list.  When we find it, generate its op-code.
			// The first part of this handles the case where the variable is used within
			// an expression.  In some cases, (i.e. an assignment to a variable), one
			// does not want this copy to happen.  Thus, we actually avoid writing out
			// any code in the case where we don't have to copy data up.

			if (m_bInStructurePart == TRUE)
			{
				return 0;
			}

			for (nCount = m_nOccupiedVariables; nCount >= 0; --nCount)
			{
				if (m_pcVarStackList[nCount].m_psVarName == *(pNode->m_psStringData))
				{
					// Now, we can get rid of the data.
					delete (pNode->m_psStringData);
					pNode->m_psStringData = NULL;

					pNode->nType = m_pcVarStackList[nCount].m_nVarType;

					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}

					if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
					{
						pNode->m_psTypeName = new CExoString(m_pcVarStackList[nCount].m_sVarStructureName.CStr());
					}
					else
					{
						pNode->m_psTypeName = NULL;
					}

					// For the purposes of writing out code, we need to do this operation.
					pNode->nIntegerData = m_pcVarStackList[nCount].m_nVarRunTimeLocation;


					if (m_bAssignmentToVariable == FALSE)
					{

						// CODE GENERATION
						// Here, we would dump the "appropriate" data from the run-time stack
						// on to the top of the stack, making a copy of it ... that's why
						// we're adding one to the appropriate run time stack.

						int32_t nStackElementsDown = pNode->nIntegerData - (m_nStackCurrentDepth * 4);
						int32_t nSize = 4;
						if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
						{
							nSize = GetStructureSize(*(pNode->m_psTypeName));
						}

						// MGB - August 10, 2001 - Determine whether we are going to operate on
						// the stack pointer (for a locally defined variable), or the base pointer
						// (for a global variable).

						int32_t bOperateOnStackPointer = TRUE;
						if (pNode->nIntegerData < m_nGlobalVariableSize && m_bGlobalVariableDefinition == FALSE)
						{
							bOperateOnStackPointer = FALSE;
							nStackElementsDown = pNode->nIntegerData - (m_nGlobalVariableSize);
						}

						if (bOperateOnStackPointer == TRUE)
						{
							m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY;
						}
						else
						{
							m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY_BASE;
						}

						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

						m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

						m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
						m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);


						// Add variable on to the stack, too.
						AddVariableToStack(pNode->nType, pNode->m_psTypeName, FALSE);

					}

					return 0;
				}
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_VARIABLE_DEFINED_WITHOUT_TYPE,pNode);

		}
		return 0;

	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
	{
		// CODE GENERATION
		// Here, we have a "constant integer" op-code that would be added.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;

		// Enter the integer constant.
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((pNode->nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((pNode->nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((pNode->nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((pNode->nIntegerData)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_OBJECT)
	{
		// CODE GENERATION
		// Here, we have a "constant object" op-code that would be added.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;

		// Enter the integer constant, since that is where we stored
		// the value.  :-)
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((pNode->nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((pNode->nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((pNode->nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((pNode->nIntegerData)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT)
	{
		// CODE GENERATION
		// Here, we have a "constant float" op-code that would be added.
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;

		// Enter the floating point constant.

		///////////////////////////////////////////////////////////////////////////
		// This may need some explaining.  The MacIntosh deals with floating point
		// numbers in the same way as integers ... it reverses the bytes.  Thus, if
		// we want to avoid doing byte swaps, what we should do is write the data
		// out in the specified byte order, and then read it back in with the
		// specified byte order.  However, you can't just "shift left" on floats,
		// so we cast the data to an integer, and then write that out!  Tricky, but
		// it should work.
		//
		// -- Mark Brockington, 01/22/2000
		///////////////////////////////////////////////////////////////////////////

		int32_t *pFloatAsInt = (int32_t *) &pNode->fFloatData;
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((*pFloatAsInt) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((*pFloatAsInt) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((*pFloatAsInt) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((*pFloatAsInt)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_VECTOR)
	{
		// CODE GENERATION
		// Here, we have a "constant float" op-code that would be added.

		for (int32_t nCount = 0; nCount < 3; nCount++)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;

			// Enter the floating point constant.

			///////////////////////////////////////////////////////////////////////////
			// This may need some explaining.  The MacIntosh deals with floating point
			// numbers in the same way as integers ... it reverses the bytes.  Thus, if
			// we want to avoid doing byte swaps, what we should do is write the data
			// out in the specified byte order, and then read it back in with the
			// specified byte order.  However, you can't just "shift left" on floats,
			// so we cast the data to an integer, and then write that out!  Tricky, but
			// it should work.
			//
			// -- Mark Brockington, 01/22/2000
			///////////////////////////////////////////////////////////////////////////

			int32_t *pFloatAsInt = (int32_t *) &(pNode->fVectorData[nCount]);
			m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((*pFloatAsInt) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((*pFloatAsInt) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((*pFloatAsInt) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((*pFloatAsInt)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
			m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
			++m_nStackCurrentDepth;
		}

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
		pNode->m_psTypeName = new CExoString("vector");

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING)
	{
		// CODE GENERATION
		// Here, we have a "constant string" op-code that would be added.

		int nLength = pNode->m_psStringData->GetLength();

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;

		// Enter the string constant.

		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nLength) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nLength)) & 0x0ff);

		for (nCount = 0; nCount < nLength; nCount++)
		{
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+nCount+2] = (pNode->m_psStringData->CStr())[nCount];
		}
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + nLength + 2;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_LOCATION)
	{
		// CODE GENERATION
		// Here, we have a "constant location" op-code that would be added.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST2;

		// Enter the integer constant.
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((pNode->nIntegerData) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((pNode->nIntegerData) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((pNode->nIntegerData) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((pNode->nIntegerData)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST2;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_JSON)
	{
		// CODE GENERATION
		// Here, we have a "constant json" op-code that would be added.

		int nLength = pNode->m_psStringData->GetLength();

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_CONSTANT;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST7;

		// Enter the string constant.

		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nLength) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nLength)) & 0x0ff);

		for (nCount = 0; nCount < nLength; nCount++)
		{
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+nCount+2] = (pNode->m_psStringData->CStr())[nCount];
		}
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + nLength + 2;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7;
		m_pchStackTypes[m_nStackCurrentDepth] = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST7;
		++m_nStackCurrentDepth;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION)
	{
		// This is simply for the purposes of "declaring" that we're out of this
		// one for defining variables.  This doesn't need to be carried over into
		// code, since each of the variables has the type appended on to it, but
		// the name isn't stored anywhere.

		m_nVarStackVariableType = CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION;
		pNode->nType = 0;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE_LIST ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST)
	{
		pNode->nType = 0;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION_ARG_LIST)
	{
		// FOR TESTING PURPOSES
		// Transfer the type of the argument up to this level, so that when
		// we test the action's parameters, we need only travel down "left"
		// branches of ACTION_ARG_LIST calls.
		if (pNode->pRight != NULL)
		{
			pNode->nType = pNode->pRight->nType;

			if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				if (pNode->m_psTypeName != NULL)
				{
					delete pNode->m_psTypeName;
				}

				(pNode->m_psTypeName) = new CExoString(pNode->pRight->m_psTypeName->CStr());
			}
		}
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION_PARAMETER)
	{
		// CODE GENERATION

		// The first instruction that we need to run is a RETURN command.
		// since we have to abort out of whatever statement we're in the middle
		// of.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RET;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JMP command we gave earlier.  This is an awfully good
		// thing to do.

		int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData;
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// FOR TESTING PURPOSES
		// Transfer the type of the argument through the node, so that we can
		// pass it up to the ACTION_ARG_LIST call.

		if (pNode->pLeft != NULL)
		{
			pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION;
		}

		// ++m_nRunTimeActions;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION_ID)
	{
		pNode->nIntegerData = GetIdentifierByName(*(pNode->m_psStringData));

		if (pNode->nIntegerData < 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ACTION)
	{
		// FOR TESTING PURPOSES
		// This code is responsible for checking the types of the parameters
		// and verifying that we've got a viable parameter list for the given
		// ID.

		if (pNode->pRight != NULL)
		{
			CScriptParseTreeNode *pTracePtr;
			int nParameters = 0;

			pTracePtr = pNode->pLeft;

			while (pTracePtr != NULL)
			{
				if (pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8 ||
				        pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
				{
					m_pchActionParameters[nParameters] = (char) pTracePtr->nType;

					if (pTracePtr->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
					{
						CExoString sTypeName = *(pTracePtr->m_psTypeName);
						m_pchActionParameterStructureNames[nParameters] = sTypeName;
						int32_t nSize = GetStructureSize(sTypeName) >> 2;
						m_nStackCurrentDepth -= nSize;
					}
					else if (pTracePtr->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION)
					{
						--m_nStackCurrentDepth;
					}
				}
				else
				{
					return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
				}

				nParameters++;
				pTracePtr = pTracePtr->pLeft;
			}

			int nCount = pNode->pRight->nIntegerData;
			BOOL bMatch = TRUE;

			if (nParameters > m_pcIdentifierList[nCount].m_nParameters)
			{
				bMatch = FALSE;
			}

			if (nParameters < m_pcIdentifierList[nCount].m_nNonOptionalParameters)
			{
				bMatch = FALSE;
			}

			for (nCount2 = 0; nCount2 < nParameters; nCount2++)
			{
				if ((m_pchActionParameters[nCount2] != m_pcIdentifierList[nCount].m_pchParameters[nCount2]) ||
				        (m_pchActionParameters[nCount2] == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT &&
				         m_pchActionParameterStructureNames[nCount2] != m_pcIdentifierList[nCount].m_psStructureParameterNames[nCount2]))
				{
					bMatch = FALSE;
				}
			}

			if (bMatch == TRUE)
			{
				// Remove all of the optional parameters that haven't been specified,
				// but were added the PreVisitGenerateCode.

				if (nParameters < m_pcIdentifierList[nCount].m_nParameters)
				{
					for (int32_t cnt = nParameters; cnt < m_pcIdentifierList[nCount].m_nParameters; cnt++)
					{
						if (m_pcIdentifierList[nCount].m_pchParameters[cnt] == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
						{
							m_pchActionParameterStructureNames[nParameters] = m_pcIdentifierList[nCount].m_psStructureParameterNames[cnt];
							int32_t nSize = GetStructureSize(m_pcIdentifierList[nCount].m_psStructureParameterNames[cnt]) >> 2;
							m_nStackCurrentDepth -= nSize;
						}
						else if (m_pcIdentifierList[nCount].m_pchParameters[cnt] != CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION)
						{
							--m_nStackCurrentDepth;
						}
					}
				}

				// pNode->pRight->nIntegerData = nCount;
				// Based on the return type, add a value to the stack.

				// We've already added the return value to the stack ... so
				// why do we need to do it here?


				if (m_pcIdentifierList[nCount].m_nReturnType != CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER)
				{
					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}
					pNode->m_psTypeName = NULL;

					if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
					}
					else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
					}
					else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
					}
					else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
					}
					else if (m_pcIdentifierList[nCount].m_nReturnType >= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER &&
					         m_pcIdentifierList[nCount].m_nReturnType <= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 + (m_pcIdentifierList[nCount].m_nReturnType - CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER);
					}
					else if (m_pcIdentifierList[nCount].m_nReturnType == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER)
					{
						pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
						pNode->m_psTypeName = new CExoString(m_pcIdentifierList[nCount].m_psStructureReturnName.CStr());
					}

					if (pNode->nIntegerData == 0)
					{
						AddVariableToStack(pNode->nType,pNode->m_psTypeName,FALSE);
					}
				}


				// CODE GENERATION
				// Generate "execute action" code here, now that we know the id.

				if (pNode->nIntegerData == 0)
				{
					int32_t nIdentifierOrder = m_pcIdentifierList[nCount].m_nIdIdentifier;

					// Write the command that calls a predefined function.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EXECUTE_COMMAND;
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

					// Enter the integer constant.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) ((nIdentifierOrder >> 8) & 0x0ff);
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (nIdentifierOrder & 0x0ff);
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (m_pcIdentifierList[nCount].m_nParameters & 0x0ff);

					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 3;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
				}
				else
				{
					// Write the command that calls a user-defined function.

					// Here, we will need to write a symbol into the code and
					// mark the location for updating during the label generation pass.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JSR;
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

					// There is no point in expressing this yet, because we haven't decided on the
					// locations of any of the final functions in the executable.  So, write
					// the symbol into the table.

					/* CExoString sSymbolName;
					sSymbolName.Format("FE_%s",m_pcIdentifierList[nCount].m_psIdentifier.CStr()); */
					AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
					                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,
					                     nCount,0);

					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
				}

				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_DECLARATION_DOES_NOT_MATCH_PARAMETERS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG)
	{
		// Handled in the InVisit call, so we don't need to do anything
		// here to handle this case.
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK)
	{
		// This instruction is a placeholder for script debugging when
		// we don't include compound statements on the inside of FOR loops.
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT)
	{

		// We keep track of all of the variables added at this recursion level, and
		// peel them off one by one.  This is actually done within the script itself
		// as well, since we need to keep track of what's happening.  However, we
		// don't need to worry about the address of a variable.

		int32_t nStackAtStart = m_nStackCurrentDepth;

		while (m_nOccupiedVariables >= 0 &&
		        m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel == m_nVarStackRecursionLevel)
		{
			if (m_pcVarStackList[m_nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				int32_t nSize = GetStructureSize(m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName) >> 2;
				m_nStackCurrentDepth -= nSize;
			}
			else
			{
				--m_nStackCurrentDepth;
			}
			RemoveFromSymbolTableVarStack(m_nOccupiedVariables, m_nStackCurrentDepth, m_nGlobalVariableSize);
			--m_nOccupiedVariables;
		}

		--m_nVarStackRecursionLevel;

		// Code Generation

		int32_t nStackModifier = (m_nStackCurrentDepth - nStackAtStart) * 4;

		if (nStackModifier != 0)
		{
			EmitModifyStackPointer(nStackModifier);
		}

		// At this point we should have had the same state that we saved earlier.  If we
		// don't, there's a big problem, and we should be alerted to it.  This is really
		// a compiler error, rather than something the user has done.

		if (pNode->m_nStackPointer != m_nStackCurrentDepth)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INCORRECT_VARIABLE_STATE_LEFT_ON_STACK,pNode);
		}

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CONDITION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COND_CONDITION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_CONDITION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_CONDITION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_CONDITION)
	{
		if (pNode->pLeft != NULL)
		{
			pNode->nType = pNode->pLeft->nType;
			// I *HOPE* this is not a structure, but just in case.
			if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				if (pNode->m_psTypeName != NULL)
				{
					delete pNode->m_psTypeName;
				}

				(pNode->m_psTypeName) = new CExoString(pNode->pLeft->m_psTypeName->CStr());
			}
		}

		// If we're a switch condition, confirm that we're an integer at this stage!
		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_CONDITION)
		{
			if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_SWITCH_MUST_EVALUATE_TO_AN_INTEGER,pNode);
			}

			// MGB - 12/06/2004 - START FIX
			//
			// Why didn't anyone tell me that the debugger was screwed when
			// entering/leaving case statements.  It's been broken for nearly 18 months!
			//
			// Okay, stop ranting ... we know it's a problem NOW.  The fix is as follows:
			//
			// Here, we must add the code to hang a "#switcheval" parameter on to the
			// variable stack.  However, the integer is already on the stack (what do
			// you think we're checking above?), so we simply have to delude the variable
			// stack to add the variable at this point (and hand it to the Symbol Table).
			// At the end of the SWITCH_BLOCK, we will remove the "#switcheval"
			// variable from the Symbol Table.

			++m_nOccupiedVariables;

			m_pcVarStackList[m_nOccupiedVariables].m_psVarName = "#switcheval";
			m_pcVarStackList[m_nOccupiedVariables].m_nVarType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
			m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel = m_nVarStackRecursionLevel;

			// Note we must subtract four from the current top, since the variable is really at
			// (m_nStackCurrentDepth - 1), instead of the top of the list.
			m_pcVarStackList[m_nOccupiedVariables].m_nVarRunTimeLocation = (m_nStackCurrentDepth - 1) * 4;

			// Now it has been added to the list
			AddToSymbolTableVarStack(m_nOccupiedVariables, m_nStackCurrentDepth - 1, m_nGlobalVariableSize);

			// MGB - 12/06/2004 - END FIX
		}


		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CONDITION)
		{
			if (m_nGenerateDebuggerOutput != 0)
			{
				EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
			}
		}

		return 0;
	}


	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK)
	{
		// MGB - 12/06/2004 - START FIX
		//
		// If you look a few lines up, I rant about the need to put in this
		// "#switcheval" variable for a switch statement, since the game
		// will proceed to emit fiery chunks by running a case through the
		// debugger when there is a string (or other deferencable object)
		// as the top thing on the stack.  It basically screws the stack
		// by one.  This is our attempt to undo the hack at this point!
		//
		// At the end of the SWITCH_BLOCK, we will remove the "#switcheval"
		// variable from the Symbol Table.

		RemoveFromSymbolTableVarStack(m_nOccupiedVariables, m_nStackCurrentDepth - 1, m_nGlobalVariableSize);
		--m_nOccupiedVariables;

		// MGB - 12/06/2004 - END FIX

		// Generate a label for the end of the function (used by the break keyword)
		/* CExoString sSymbolName;
		sSymbolName.Format("_BR_%08x",m_nSwitchIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK,
		                     m_nSwitchIdentifier);

		// Restore the old values of switch level and the switch identifier.
		--m_nSwitchLevel;
		m_nSwitchIdentifier = pNode->nIntegerData2;
		m_nSwitchStackDepth = pNode->nIntegerData3;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK)
	{

		// Here, we implement the loop back to location _W1_ and insert
		// the information on jumping to _W2_ at this point.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		int32_t nJmpLength = pNode->nIntegerData - m_nOutputCodeLength;
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nJmpLength) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nJmpLength)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JZ command we gave earlier during
		// the InVisit() [code located at pNode->nIntegerdata2].
		// This is an awfully good thing to do.

		nJmpLength = m_nOutputCodeLength - pNode->nIntegerData2;
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// Generate a label for the end of the function (used by the break keyword)
		/* CExoString sSymbolName;
		sSymbolName.Format("_BR_%08x",m_nLoopIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK,m_nLoopIdentifier,0);


		pNode->nType = pNode->pLeft->nType;
		if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			if (pNode->m_psTypeName != NULL)
			{
				delete pNode->m_psTypeName;
			}

			pNode->m_psTypeName = new CExoString(pNode->pLeft->m_psTypeName->CStr());
		}

		// Reset the loop identifier.
		m_nLoopIdentifier = pNode->nIntegerData3;
		m_nLoopStackDepth = pNode->nIntegerData4;

		return 0;

	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_CHOICE)
	{
		// FOR TESTING PURPOSES
		// We do nothing.  Why?  It's all done by WHILE_BLOCK
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK)
	{
		// CODE GENERATION
		// Here, we implement a JZ to _DW2_, which clears the JMP back to _DW1_.

		//
		// First, let's deal with the JZ instruction.
		//

		if (m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INTEGER_NOT_AT_TOP_OF_STACK,pNode);
		}
		--m_nStackCurrentDepth;

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JZ;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// The jump length is over this instruction and the jmp instruction, both of
		// which are OPERATION_BASE_SIZE + 4 (for the address).

		int32_t nJmpLength = (CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4) << 1;
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nJmpLength) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nJmpLength)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		//
		// And now, the JMP instruction.
		//

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// The jmp length is back to the beginning of the do/while loop,
		// which is stored in pNode->nIntegerData;
		// which are OPERATION_BASE_SIZE + 4 (for the address).

		nJmpLength = pNode->nIntegerData - m_nOutputCodeLength;
		m_pchOutputCode[m_nOutputCodeLength+ CVIRTUALMACHINE_EXTRA_DATA_LOCATION ] = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nJmpLength) >> 8) & 0x0ff);
		m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nJmpLength)) & 0x0ff);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Generate a label for the end of the function (used by the break keyword)
		/* CExoString sSymbolName;
		sSymbolName.Format("_BR_%08x",m_nLoopIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK,m_nLoopIdentifier);

		if (m_nGenerateDebuggerOutput != 0)
		{
			EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,pNode->nLine,m_nOutputCodeLength);
		}

		pNode->nType = pNode->pRight->nType;
		if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			if (pNode->m_psTypeName != NULL)
			{
				delete pNode->m_psTypeName;
			}

			pNode->m_psTypeName = new CExoString(pNode->pRight->m_psTypeName->CStr());
		}

		// Reset the loop identifier.
		m_nLoopIdentifier = pNode->nIntegerData3;
		m_nLoopStackDepth = pNode->nIntegerData4;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CHOICE)
	{
		// Here, we implement the loop back to location _W1_ and insert
		// the information on jumping to _W2_ at this point.

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JMP command we gave earlier during
		// the InVisit() [code located at pNode->nIntegerdata2].
		// This is an awfully good thing to do.

		int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData2;
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// FOR TESTING PURPOSES
		// We do nothing.  Why?  It's been done in pregenerate code
		// (to reflect where the variable will be removed from the
		// stack during the run-time execution!)
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK)
	{
		pNode->nType = pNode->pLeft->nType;
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COND_CHOICE)
	{
		// Here, we implement the loop back to location _CH1_ and insert
		// the information on jumping to _CH2_ at this point.

		// Here, we go back and add the relative offset to get beyond this return
		// statement to the JMP command we gave earlier during
		// the InVisit() [code located at pNode->nIntegerdata2].
		// This is an awfully good thing to do.

		int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData2;
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
		m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

		// FOR TESTING PURPOSES
		// Check to see if the types are the same.

		if (pNode->pLeft->nType != pNode->pRight->nType ||
		        (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT &&
		         *(pNode->pLeft->m_psTypeName) != *(pNode->pRight->m_psTypeName)))
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_CONDITIONAL_MUST_HAVE_MATCHING_RETURN_TYPES,pNode);
		}

		pNode->nType = pNode->pLeft->nType;
		if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			if (pNode->m_psTypeName != NULL)
			{
				delete pNode->m_psTypeName;
			}

			pNode->m_psTypeName = new CExoString(pNode->pLeft->m_psTypeName->CStr());
		}

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COND_BLOCK)
	{
		// Type of the conditional block is the same as the type of the conditional choice
		// underneath it (pRight).
		pNode->nType = pNode->pRight->nType;
		if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			if (pNode->m_psTypeName != NULL)
			{
				delete pNode->m_psTypeName;
			}

			pNode->m_psTypeName = new CExoString(pNode->pRight->m_psTypeName->CStr());
		}
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_NON_VOID_EXPRESSION ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION)
	{

		// MGB - October 29, 2002 - START CHANGE
		// Code changed to properly account for "action" variables (which aren't
		// actually stored on the stack) as non-void expressions.

		int32_t nTargetRemovedTokens = 1;
		if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION)
		{
			nTargetRemovedTokens = 0;
		}
		if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			nTargetRemovedTokens = (GetStructureSize(*(pNode->pLeft->m_psTypeName)) >> 2);
		}

		int nActualRemovedTokens = m_nStackCurrentDepth - pNode->m_nStackPointer;

		if (nActualRemovedTokens == 0 && nTargetRemovedTokens != 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_VOID_EXPRESSION_WHERE_NON_VOID_REQUIRED,pNode);
		}

		if (nActualRemovedTokens != nTargetRemovedTokens)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_INCORRECT_VARIABLE_STATE_LEFT_ON_STACK,pNode);
		}

		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION &&
		        m_pchStackTypes[m_nStackCurrentDepth-1] != CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_NON_INTEGER_EXPRESSION_WHERE_INTEGER_REQUIRED,pNode);
		}

		// Now, that we've "verified" the type, we should be able to set the value
		// of the type of the expression underneath it.
		pNode->nType = pNode->pLeft->nType;

		if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			if (pNode->m_psTypeName != NULL)
			{
				delete pNode->m_psTypeName;
			}

			pNode->m_psTypeName = new CExoString(pNode->pLeft->m_psTypeName->CStr());
		}

		// MGB - October 29, 2002 - END CHANGE

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_LOGICAL_AND)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a "logical AND of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_LOGICAL_AND;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				// Now, we insert the label _ILA_ to indicate this is where we jump
				// to on a "short cut".
				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;

				// Here, we go back and add the relative offset to get beyond this return
				// statement to the JZ command we gave earlier during
				// the InVisit() [code located at pNode->nIntegerData].
				// This is an awfully good thing to do.

				int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData;
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LOGICAL_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_LOGICAL_OR)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// First, we insert the label _ILO_ to indicate this is where we jump
				// to on a "short cut".
				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;

				// Here, we go back and add the relative offset to get beyond this return
				// statement to the JMP command we gave earlier during
				// the InVisit() [code located at pNode->nIntegerData].
				// This is an awfully good thing to do.

				int32_t nJmpLength = m_nOutputCodeLength - pNode->nIntegerData;
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nJmpLength) >> 24) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nJmpLength) >> 16) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nJmpLength) >> 8 ) & 0x0ff);
				m_pchOutputCode[pNode->nIntegerData + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nJmpLength)      ) & 0x0ff);

				// CODE GENERATION
				// Write a "logical OR of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_LOGICAL_OR;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LOGICAL_OPERATION_HAS_INVALID_OPERANDS,pNode);

		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_INCLUSIVE_OR)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "inclusive OR of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_INCLUSIVE_OR;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LOGICAL_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_EXCLUSIVE_OR)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "exclusive OR of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EXCLUSIVE_OR;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LOGICAL_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_BOOLEAN_AND)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "boolean AND of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_BOOLEAN_AND;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LOGICAL_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_NOT_EQUAL)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "condition EQUAL/NOT EQUAL of two ints" operation.
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
				}
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				// CODE GENERATION
				// Write an "condition EQUAL/NOT EQUAL of two floats" operation.
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
				}
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_FLOAT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove two floats, add an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
			{
				// CODE GENERATION
				// Write an "condition EQUAL/NOT EQUAL of two objects" operation.
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
				}
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_OBJECT_OBJECT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove two objects, add an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
			{
				// CODE GENERATION
				// Write an "condition EQUAL/NOT EQUAL of two strings" operation.
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
				}
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_STRING_STRING;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
			        pNode->pLeft->nType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9 &&
			        pNode->pRight->nType == pNode->pLeft->nType)
			{

				uint8_t nEngineStructureNumber = (uint8_t) (pNode->pLeft->nType - CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0);

				// CODE GENERATION
				// Write an "condition EQUAL/NOT EQUAL of two strings" operation.
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
				}
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = (char) (CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST0_ENGST0 + nEngineStructureNumber);
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;

			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				if (*(pNode->pLeft->m_psTypeName) == *(pNode->pRight->m_psTypeName))
				{
					int32_t nSize = GetStructureSize(*(pNode->pLeft->m_psTypeName));

					// CODE GENERATION
					// Write an "condition EQUAL/NOT EQUAL of two strings" operation.
					if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL)
					{
						m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_EQUAL;
					}
					else
					{
						m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NOT_EQUAL;
					}
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_STRUCT_STRUCT;

					m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+0] = (char) (((nSize) >> 8) & 0x0ff);
					m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nSize)) & 0x0ff);

					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 2;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);


					// FOR TESTING PURPOSES
					// Remove the two structures, and add an INT.

					// Why remove half of the size?  We're actually removing two structures, but
					// the size reported is actually in bytes, not in the number of entries the
					// stack is measured in.  Thus, nSize * 2 / 4 = nSize >> 1.

					m_nStackCurrentDepth -= (nSize >> 1);
					AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

					pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
					return 0;
				}
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_EQUALITY_TEST_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_GEQ ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_GT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_LT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_LEQ)
	{

		// CODE GENERATION
		// Write the base of the arithmetic operation.

		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_GEQ)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_GEQ;
		}
		else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_GT)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_GT;
		}
		else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONDITION_LT)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_LT;
		}
		else
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_LEQ;
		}

		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "condition GEQ/GT/LT/LEQ of two ints" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				// CODE GENERATION
				// Write an "condition GEQ/GT/LT/LEQ of two floats" operation.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_FLOAT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_COMPARISON_TEST_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SHIFT_LEFT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SHIFT_RIGHT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_UNSIGNED_SHIFT_RIGHT)
	{



		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write an "<</>>/>>> of two ints" operation.

				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SHIFT_LEFT)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_SHIFT_LEFT;
				}
				else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SHIFT_RIGHT)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_SHIFT_RIGHT;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_USHIFT_RIGHT;
				}

				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// FOR TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_SHIFT_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ADD ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SUBTRACT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_MULTIPLY ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DIVIDE)
	{

		// CODE GENERATION
		// Write the base of the arithmetic operation.
		if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ADD)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ADD;
		}
		else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SUBTRACT)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_SUB;
		}
		else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_MULTIPLY)
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_MUL;
		}
		else
		{
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DIV;
		}

		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a +-*/ operation on two ints.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a +-*/ operation on a float and a PROMOTED int.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				// CODE GENERATION
				// Write a +-*/ operation on a PROMOTED int and a float.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_FLOAT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				// CODE GENERATION
				// Write a +-*/ operation on a PROMOTED int and a float.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_FLOAT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove a float.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
			{
				if (pNode->nOperation != CSCRIPTCOMPILER_OPERATION_ADD)
				{       {
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
					}
				}
				// CODE GENERATION
				// Write a s+s operation on two strings.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_STRING_STRING;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove both vectors, and add one back.
				m_nStackCurrentDepth -= 2;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING,NULL,FALSE);
				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				if (*(pNode->pLeft->m_psTypeName) == "vector" && *(pNode->pRight->m_psTypeName) == *(pNode->pLeft->m_psTypeName))
				{
					if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_MULTIPLY ||
					        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DIVIDE)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
					}
					// CODE GENERATION
					// Write a v+-v operation on two vectors.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_VECTOR_VECTOR;
					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

					// For TESTING PURPOSES
					// Remove both vectors, and add one back.
					m_nStackCurrentDepth -= 6;
					AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT,pNode->pLeft->m_psTypeName,FALSE);
					pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}
					pNode->m_psTypeName = new CExoString(pNode->pLeft->m_psTypeName->CStr());
					return 0;

				}
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				if (*(pNode->pLeft->m_psTypeName) == "vector")
				{
					if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ADD ||
					        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SUBTRACT)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
					}
					// CODE GENERATION
					// Write a v*/f operation on two vectors.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_VECTOR_FLOAT;
					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

					// For TESTING PURPOSES
					// Remove the vector and scalar, and add the back back.
					m_nStackCurrentDepth -= 4;
					AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT,pNode->pLeft->m_psTypeName,FALSE);
					pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}
					pNode->m_psTypeName = new CExoString(pNode->pLeft->m_psTypeName->CStr());
					return 0;
				}
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				if (*(pNode->pRight->m_psTypeName) == "vector")
				{
					if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ADD ||
					        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_SUBTRACT ||
					        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DIVIDE)
					{
						return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
					}

					// CODE GENERATION
					// Write a f*v operation.
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_VECTOR;
					m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
					m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

					// For TESTING PURPOSES
					// Remove the vector and scalar, and add the vector back.
					m_nStackCurrentDepth -= 4;
					AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT,pNode->pRight->m_psTypeName,FALSE);
					pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
					if (pNode->m_psTypeName != NULL)
					{
						delete pNode->m_psTypeName;
					}
					pNode->m_psTypeName = new CExoString(pNode->pRight->m_psTypeName->CStr());
					return 0;
				}
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_MODULUS)
	{
		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT && pNode->pRight->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a % operation on two ints.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_MODULUS;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Remove an integer.
				--m_nStackCurrentDepth;
				--m_nStackCurrentDepth;
				AddVariableToStack(CSCRIPTCOMPILER_TOKEN_KEYWORD_INT,NULL,FALSE);

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_NEGATION)
	{
		if (pNode->pLeft != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a negation operation on an int.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NEGATION;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Do nothing.

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				// CODE GENERATION
				// Write a negation operation on a float.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_NEGATION;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
				// For TESTING PURPOSES
				// Do nothing.

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
				return 0;
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_ONES_COMPLEMENT)
	{
		if (pNode->pLeft != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a negation operation on an int.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ONES_COMPLEMENT;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Do nothing.

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_BOOLEAN_NOT)
	{
		if (pNode->pLeft != NULL)
		{
			if (pNode->pLeft->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				// CODE GENERATION
				// Write a negation operation on an int.
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_BOOLEAN_NOT;
				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// For TESTING PURPOSES
				// Do nothing.

				pNode->nType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
				return 0;
			}

			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_ARITHMETIC_OPERATION_HAS_INVALID_OPERANDS,pNode);
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}


	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_DEFINITION)
	{
		// We should be in the variable-processing stage of the strucutre
		// definition at this point.

		if (m_nStructureDefinition != 2)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		// Set where the last field for this structure is located.

		m_pcStructList[m_nMaxStructures].m_nFieldEnd = m_nMaxStructureFields - 1;

		// Count the size of all the components in this structure.

		int32_t nTotalSize = 0;

		int32_t count;
		for (count = m_pcStructList[m_nMaxStructures].m_nFieldStart;
		        count <= m_pcStructList[m_nMaxStructures].m_nFieldEnd;
		        ++count)
		{
			// Since we haven't set the location of the variables within this
			// structure, we might as well do it here.
			m_pcStructFieldList[count].m_nLocation = nTotalSize;

			// All variables are of size "4" (i.e. 4 bytes), unless you've got
			// a structure, which could take a lot more than 4 bytes on the
			// stack.  Thus, one would like to make these into 4 byte values.
			if (m_pcStructFieldList[count].m_pchType != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				nTotalSize += 4;
			}
			else
			{
				int32_t count2;
				for (count2 = 0; count2 < m_nMaxStructures; count2++)
				{
					if (m_pcStructFieldList[count].m_psStructureName == m_pcStructList[count2].m_psName)
					{
						nTotalSize += m_pcStructList[count2].m_nByteSize;
					}
				}
			}
		}

		m_pcStructList[m_nMaxStructures].m_nByteSize = nTotalSize;

		if (nTotalSize == 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		// Clear out the fact that we're in a structure definition ... since
		// we're done this definition.
		m_nStructureDefinition = 0;

		// Finally, add the structure definition to the ones that we can look at.
		++m_nMaxStructures;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
	{
		m_bInStructurePart = FALSE;

		if (pNode->pLeft != NULL && pNode->pRight != NULL)
		{
			if (pNode->pLeft->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_LEFT_OF_STRUCTURE_PART_NOT_STRUCTURE,pNode);
			}
			/*
			if (pNode->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_VARIABLE)
			{
			    return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_RIGHT_OF_STRUCTURE_PART_NOT_FIELD_IN_STRUCTURE,pNode);
			}
			*/

			// Now that we have verified we have a structure on the left,
			// and a variable on the right ... we can determine if we've
			// got a field within the specified structure.
			int32_t nValue = GetStructureField(*(pNode->pLeft->m_psTypeName), *(pNode->pRight->m_psStringData));
			if (nValue < 0)
			{
				return OutputWalkTreeError(nValue,pNode);
			}

			// Yes, we have a valid structure field.  Fetch the type,
			// and structure name (if necessary) out of the structure field.
			pNode->nType = m_pcStructFieldList[nValue].m_pchType;
			if (pNode->nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				pNode->m_psTypeName = new CExoString(m_pcStructFieldList[nValue].m_psStructureName.CStr());
			}

			// Now, we update the pointer to the location of the variable.  In
			// all cases, we should still have a pointer into the stack that will
			// help us determine the location of the structure part.
			pNode->nIntegerData = pNode->pLeft->nIntegerData + m_pcStructFieldList[nValue].m_nLocation;

			if (m_bAssignmentToVariable == FALSE)
			{
				// Let's do some code down here!  We want to be able to remove
				// the structure at the top of the stack and bust it down to
				// the current thing on the stack.  Thus, we create a new
				// opcode for handling the division of a structure.  It will
				// have three parameters.  (1) Size Of Original Structure
				// (2) Start Location of New Component (3) Size of New
				// Component.  All of these will be with respect to the run-time
				// stack.

				int32_t nSizeOriginal = GetStructureSize(*(pNode->pLeft->m_psTypeName));

				int32_t nSize = 4;
				if (m_pcStructFieldList[nValue].m_pchType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					nSize = GetStructureSize(*(pNode->m_psTypeName));
				}

				int32_t nStartComponent = m_pcStructFieldList[nValue].m_nLocation;

				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DE_STRUCT;
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

				m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nSizeOriginal) >> 8) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nSizeOriginal)) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStartComponent) >> 8) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStartComponent)) & 0x0ff);

				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
				m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

				m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

				// Okay, now we have to actually apply the de-struct information.
				int32_t nCutSizeOriginal   = (nSizeOriginal >> 2);
				int32_t nCutSize           = (nSize >> 2);
				int32_t nCutStartComponent = (nStartComponent >> 2);

				// Let's see what we want ...
				//
				//
				// C C C C C C C
				//
				//     B
				//     A A A
				//
				// nCutSize = A;
				// nCutStartComponent = B;
				// nCutSizeOriginal = C;
				//
				// StackPointer = Base + C;
				// if (A+B < C)
				// {
				//    StackPointer = Base + A + B;  (Thus, subtract
				// }
				//
				// Copy To Base ... Base+A-1 from Base+B to Base+A+B-1
				//
				// StackPointer = Base + A; // Remove B

				if (nCutSize + nCutStartComponent < nCutSizeOriginal)
				{
					m_nStackCurrentDepth -= nCutSizeOriginal;
					m_nStackCurrentDepth += nCutSize + nCutStartComponent;
				}

				for (int32_t count = m_nStackCurrentDepth - nCutSize - nCutStartComponent; count < m_nStackCurrentDepth - nCutStartComponent; ++count)
				{
					m_pchStackTypes[count] = m_pchStackTypes[count + nCutStartComponent];
				}

				m_nStackCurrentDepth -= nCutStartComponent;
			}

			return 0;
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTIONAL_UNIT)
	{
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION )
	{
		// If there's no function implementation, we do not need to do anything.
		if (m_bFunctionImp == FALSE)
		{
			return 0;
		}

		// Remove all variables, aside from #retval (only save #retval if the
		// function is non-void).

		int32_t nReturnValueLevel = m_nGlobalVariables;

		if (m_nFunctionImpReturnType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
		{
			++nReturnValueLevel;
		}

		while (m_nOccupiedVariables >= nReturnValueLevel)
		{

			if (m_pcVarStackList[m_nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				int32_t nSize = GetStructureSize(m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName) >> 2;
				m_nStackCurrentDepth -= nSize;
			}
			else
			{
				--m_nStackCurrentDepth;
			}
			RemoveFromSymbolTableVarStack(m_nOccupiedVariables, m_nStackCurrentDepth, m_nGlobalVariableSize);
			--m_nOccupiedVariables;
		}

		// MGB - August 14, 2002 - For Scripting Debugger
		// The COMPOUND_STATEMENT on the inside of the function declaration contains
		// the placement of the final bracket and, hence, where the final line of
		// code in the function belongs.
		int32_t nLineEndOfFunction = pNode->nLine;
		if (pNode->pRight != NULL)
		{
			nLineEndOfFunction = pNode->pRight->nLine;
		}


		// MGB - August 9, 2002 - Final Bracket Debugging
		if (m_nGenerateDebuggerOutput != 0)
		{
			StartLineNumberAtBinaryInstruction(pNode->m_nFileReference,nLineEndOfFunction,m_nOutputCodeLength);
		}

		// At this point we should have the state with just the return value
		// on the stack.  We should use this opportunity to generate the shift
		// in the run-time stack.

		// Generate a label for the end of the function (used by the RETURN keyword)
		/* CExoString sSymbolName;
		sSymbolName.Format("FX_%s",m_sFunctionImpName.CStr()); */
		int32_t nIdentifier = GetIdentifierByName(m_sFunctionImpName);
		if (nIdentifier == STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		AddSymbolToLabelList(m_nOutputCodeLength, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_EXIT, nIdentifier, 0);

		// Move the stack to update the current location of the code.

		int32_t nStackModifier = (m_nStackCurrentDepth - pNode->m_nStackPointer) * 4;

		if (nStackModifier != 0)
		{
			EmitModifyStackPointer(nStackModifier);
		}

		// MGB - August 22, 2002 - For Scripting Debugger
		if (nReturnValueLevel != m_nGlobalVariables)
		{
			// Remove the variable from the StackCurrentDepth before
			// handing it off to the code to get rid of!
			int32_t nStackCurrentDepth = m_nStackCurrentDepth;

			if (m_pcVarStackList[m_nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				int32_t nSize = GetStructureSize(m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName) >> 2;
				nStackCurrentDepth -= nSize;
			}
			else
			{
				--nStackCurrentDepth;
			}

			RemoveFromSymbolTableVarStack(m_nOccupiedVariables, nStackCurrentDepth, m_nGlobalVariableSize);
		}

		// Add the RET statement
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RET;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE ;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Remove the last variable (#retval), and reset the state of the
		// variable stack.

		if (m_nFunctionImpReturnType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
		{
			// Check the function using our custom function to handle this.
			if (FoundReturnStatementOnAllBranches(pNode->pRight) == FALSE)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_NOT_ALL_CONTROL_PATHS_RETURN_A_VALUE,pNode);
			}
		}

		// If the function is non-void, remove #retval from the stack.
		// The way we know the function is non-void can be found above.


		if (nReturnValueLevel != m_nGlobalVariables)
		{
			if (m_pcVarStackList[m_nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				int32_t nSize = GetStructureSize(m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName) >> 2;
				m_nStackCurrentDepth -= nSize;
			}
			else
			{
				--m_nStackCurrentDepth;
			}
			--m_nOccupiedVariables;
		}

		--m_nVarStackRecursionLevel;

		nIdentifier = GetIdentifierByName(m_sFunctionImpName);

		if (nIdentifier < 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish = m_nOutputCodeLength;

		m_bFunctionImp = FALSE;

		// MGB - August 9, 2002 - Final Bracket Debugging
		if (m_nGenerateDebuggerOutput != 0)
		{
			EndLineNumberAtBinaryInstruction(pNode->m_nFileReference,nLineEndOfFunction,m_nOutputCodeLength);
		}
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_GLOBAL_VARIABLES)
	{
		m_bGlobalVariableDefinition = FALSE;

		// Add the SAVE_BASE_POINTER statement so that these globals can be used.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_SAVE_BASE_POINTER;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		////////////////////////////////////////////////////
		// MGB - September 13, 2001 - Start of added chunk.
		////////////////////////////////////////////////////

		if (m_bCompileConditionalFile == TRUE)
		{
			// Write the integer that we're going to store the return value into!
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_ADD;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
		}

		//////////////////////////////////////////////////
		// MGB - September 13, 2001 - End of added chunk.
		//////////////////////////////////////////////////

		// Write the JSR FE_main instruction that is guaranteed to be successful
		// because of the checks in InstallLoader().

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JSR;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// There is no point in expressing this yet, because we haven't decided on the
		// locations of any of the final functions in the executable.  So, write
		// the symbol into the table.

		/*
		CExoString sSymbolName;
		if (m_bCompileConditionalFile == FALSE)
		{
		    sSymbolName.Format("FE_main");
		}
		else
		{
		    sSymbolName.Format("FE_StartingConditional");
		}
		*/

		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION,
		                     CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY,0,2);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);


		////////////////////////////////////////////////////
		// MGB - September 13, 2001 - Start of added chunk.
		////////////////////////////////////////////////////

		if (m_bCompileConditionalFile == TRUE)
		{
			// We need to assign the return value to the first value on the stack (which is the return value
			// of the full function).

			// Set up a "write to #retval" instruction.

			// Must move beyond Global Variables + [#retval + basepointer (on stack) + RSADDI = 12]
			int32_t nStackElementsDown = -(m_nGlobalVariableSize + 12);
			int32_t nSize = 4;
			if (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				nSize = GetStructureSize(m_sFunctionImpReturnStructureName);
			}

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ASSIGNMENT;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);


			// Add the "modify stack pointer" statement so that the return value is never used again.
			EmitModifyStackPointer(-4);
		}

		//////////////////////////////////////////////////
		// MGB - September 13, 2001 - End of added chunk.
		//////////////////////////////////////////////////

		// Add the RESTORE_BASE_POINTER statement so that these globals can be popped off.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RESTORE_BASE_POINTER;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		////////////////////////////////////////////////////
		// MGB - September 13, 2001 - Start of added chunk.
		////////////////////////////////////////////////////

		// Add the "modify stack pointer" statement so that these globals are never used again

		int32_t nStackPointer = -m_nGlobalVariableSize;

		// MGB - April 12, 2002 - Removing a bug where this instruction is added needlessly
		// (causing great grief to the virtual machine) when the stack pointer doesn't need
		// to be moved at all!
		if (nStackPointer != 0)
		{
			EmitModifyStackPointer(nStackPointer);
		}

		//////////////////////////////////////////////////
		// MGB - September 13, 2001 - End of added chunk.
		//////////////////////////////////////////////////



		// Finally, add the RET statement so that we can bail out of this routine.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RET;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;
		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		// Last, but not least, add a function to the user-defined identifier list
		// that specifies where this code is located.

		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceFinish = m_nOutputCodeLength;

		++m_nOccupiedIdentifiers;
		if (m_nOccupiedIdentifiers >= CSCRIPTCOMPILER_MAX_IDENTIFIERS)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_IDENTIFIER_LIST_FULL,pNode);
		}

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION_IDENTIFIER)
	{
		// We've just read a "type", but we really don't need to propogate this type to
		// anyone ... we'll simply feed it
		m_nVarStackVariableType = CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION;

		if (m_bFunctionImp == FALSE)
		{
			return 0;
		}

		if (pNode->pLeft == NULL)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		//
		// We want to add #retval to the run-time stack, and record the
		// return type.
		//

		// We know the "operation" of the type via the left branch, but
		// we don't actually know the "token" type.
		int32_t nTokenType;
		CExoString sTokenStructureName = "";

		if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
			sTokenStructureName = *(pNode->pLeft->m_psStringData);
		}
		else if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
		}
		else if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
		}
		else if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
		}
		else if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
		}
		else if (pNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID;
		}
		else if (pNode->pLeft->nOperation >= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 &&
		         pNode->pLeft->nOperation <= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 +
			             (pNode->pLeft->nOperation - CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0);
		}
		else
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		// Add the variable "#retval" to the occupied variables list.

		if (nTokenType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
		{
			++m_nOccupiedVariables;
			if (m_bGlobalVariableDefinition)
			{
				++m_nGlobalVariables;
				if (nTokenType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					m_nGlobalVariableSize += GetStructureSize(sTokenStructureName);
				}
				else
				{
					m_nGlobalVariableSize += 4;
				}
			}

			m_pcVarStackList[m_nOccupiedVariables].m_psVarName = "#retval";
			m_pcVarStackList[m_nOccupiedVariables].m_nVarType = nTokenType;
			if (nTokenType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName = sTokenStructureName;
			}
			m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel = m_nVarStackRecursionLevel;
			m_pcVarStackList[m_nOccupiedVariables].m_nVarRunTimeLocation = m_nStackCurrentDepth * 4;

			// Now, we can add the variable to the run time stack!

			int32_t nOccupiedVariables = m_nOccupiedVariables;
			int32_t nStackCurrentDepth = m_nStackCurrentDepth;
			int32_t nGlobalVariableSize = m_nGlobalVariableSize;
			AddVariableToStack(nTokenType, &sTokenStructureName, FALSE);
			AddToSymbolTableVarStack(nOccupiedVariables,nStackCurrentDepth,nGlobalVariableSize);
		}

		m_nFunctionImpReturnType = nTokenType;
		m_sFunctionImpReturnStructureName = sTokenStructureName;

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION_PARAM_NAME)
	{

		m_nVarStackVariableType = CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION;

		if (m_bFunctionImp == FALSE)
		{
			// This is required here, since we've just discovered that we're
			// actually parsing a function and not a series of declarations.
			return 0;
		}

		if (pNode->pRight == NULL)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		for (nCount = m_nOccupiedVariables; nCount >= 0; --nCount)
		{
			if (m_pcVarStackList[nCount].m_psVarName == *(pNode->m_psStringData) &&
			        m_pcVarStackList[nCount].m_nVarLevel == m_nVarStackRecursionLevel)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_VARIABLE_ALREADY_USED_WITHIN_SCOPE,pNode);
			}
		}

		// We know the "operation" of the type via the left branch, but
		// we don't actually know the "token" type.
		int32_t nTokenType;
		CExoString sTokenStructureName = "";

		if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
			sTokenStructureName = *(pNode->pRight->m_psStringData);
		}
		else if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
		}
		else if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
		}
		else if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
		}
		else if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
		}
		else if (pNode->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID;
		}
		else if (pNode->pRight->nOperation >= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 &&
		         pNode->pRight->nOperation <= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9)
		{
			nTokenType = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 +
			             (pNode->pRight->nOperation - CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0);
		}

		else
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		// Add the variable named at this node to the occupied variables list.

		if (nTokenType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
		{
			++m_nOccupiedVariables;
			if (m_bGlobalVariableDefinition)
			{
				++m_nGlobalVariables;
				if (nTokenType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					m_nGlobalVariableSize += GetStructureSize(sTokenStructureName);
				}
				else
				{
					m_nGlobalVariableSize += 4;
				}

			}

			m_pcVarStackList[m_nOccupiedVariables].m_psVarName = *(pNode->m_psStringData);
			m_pcVarStackList[m_nOccupiedVariables].m_nVarType = nTokenType;
			if (nTokenType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				m_pcVarStackList[m_nOccupiedVariables].m_sVarStructureName = sTokenStructureName;
			}
			m_pcVarStackList[m_nOccupiedVariables].m_nVarLevel = m_nVarStackRecursionLevel;
			m_pcVarStackList[m_nOccupiedVariables].m_nVarRunTimeLocation = m_nStackCurrentDepth * 4;

			// Now, we can add the variable to the run time stack!
			int32_t nOccupiedVariables = m_nOccupiedVariables;
			int32_t nStackCurrentDepth = m_nStackCurrentDepth;
			int32_t nGlobalVariableSize = m_nGlobalVariableSize;
			AddVariableToStack(nTokenType, &sTokenStructureName, FALSE);
			AddToSymbolTableVarStack(nOccupiedVariables,nStackCurrentDepth,nGlobalVariableSize);
		}

		// This is required here, since we've just discovered that we're
		// actually parsing a function and not a series of declarations.



		return 0;

	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_FUNCTION_DECLARATION)
	{
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_RETURN)
	{

		if (m_bFunctionImp == FALSE)
		{
			return 0;
		}

		if ((m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID && pNode->pRight != NULL) ||
		        (m_nFunctionImpReturnType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID && pNode->pRight == NULL))
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_RETURN_TYPE_AND_FUNCTION_TYPE_MISMATCHED,pNode);
		}

		if ((m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT    && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_INT) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT  && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9 && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_RETURN_TYPE_AND_FUNCTION_TYPE_MISMATCHED,pNode);
		}

		if ((m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT && pNode->pRight->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT) ||
		        (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT && m_sFunctionImpReturnStructureName != *(pNode->pRight->m_psTypeName)))
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_RETURN_TYPE_AND_FUNCTION_TYPE_MISMATCHED,pNode);
		}

		// Okay, now we've got fun!

		if (m_nFunctionImpReturnType != CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
		{
			// Set up a "write to #retval" instruction.

			int32_t nStackElementsDown = m_nGlobalVariableSize - m_nStackCurrentDepth * 4;
			int32_t nSize = 4;
			if (m_nFunctionImpReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				nSize = GetStructureSize(m_sFunctionImpReturnStructureName);
			}

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_ASSIGNMENT;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_VOID;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+4] = (char) (((nSize) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+5] = (char) (((nSize)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 6;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
		}

		// Write the MODIFY_STACK_POINTER instruction to modify the stack.

		pNode->nIntegerData = (m_nFunctionImpAbortStackPointer - m_nStackCurrentDepth) * 4;
		//m_nStackCurrentDepth = m_nFunctionImpAbortStackPointer;

		if (pNode->nIntegerData != 0)
		{
			EmitModifyStackPointer(pNode->nIntegerData);
		}

		// And, finally, write the JMP statement.

		// Here, we will need to write a symbol into the code and
		// mark the location for updating during the label generation pass.
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		// There is no point in expressing this yet, because we haven't decided on the
		// locations of any of the final functions in the executable.  So, write
		// the symbol into the table.

		/* CExoString sSymbolName;
		sSymbolName.Format("FX_%s",m_sFunctionImpName.CStr()); */
		int32_t nIdentifier = GetIdentifierByName(m_sFunctionImpName);
		if (nIdentifier == STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
		}

		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_EXIT, nIdentifier, 0);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		return 0;

	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_DECREMENT)
	{
		if (pNode->pLeft != NULL)
		{
			if (pNode->pLeft->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_OPERAND_MUST_BE_AN_INTEGER_LVALUE,pNode);
			}

			// Is pNode->pLeft actually a valid LValue?
			if (pNode->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_VARIABLE &&
			        pNode->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_OPERAND_MUST_BE_AN_INTEGER_LVALUE,pNode->pLeft);
			}

			pNode->nType = pNode->pLeft->nType;

			// Current location of the variable is stored in pNode->pLeft->nIntegerData because
			// it is a valid LValue.

			int32_t nStackElementsDown = pNode->pLeft->nIntegerData - m_nStackCurrentDepth * 4;

			// MGB - August 10, 2001 - Determine whether we should be operating on the base
			// pointer or the stack pointer.

			int32_t bOperateOnStackPointer;
			if (pNode->pLeft->nIntegerData < m_nGlobalVariableSize && m_bGlobalVariableDefinition == FALSE)
			{
				bOperateOnStackPointer = FALSE;
				nStackElementsDown = pNode->pLeft->nIntegerData - (m_nGlobalVariableSize);
			}
			else
			{
				bOperateOnStackPointer = TRUE;
				// And don't forget to add the ADDITIONAL integer that is now sitting on top of the stack!
				nStackElementsDown += 4;
			}

			// And now, fill in the appropriate code (pNode->nIntegerData2 points to the location
			// of the EXTRA_DATA that we reserved for the data pointer!)

			// MGB - August 10, 2001
			// NOTE that we only write data into the opcode if we are not using the stack pointer,
			// since the code has already been written for using the stack pointer in the PreIncrement
			// call.
			if (bOperateOnStackPointer == FALSE)
			{
				if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT)
				{
					m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_INCREMENT_BASE;
				}
				else
				{
					m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DECREMENT_BASE;
				}
			}

			m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION]     = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[pNode->nIntegerData2 + CVIRTUALMACHINE_EXTRA_DATA_LOCATION + 3] = (char) (((nStackElementsDown)) & 0x0ff);

			return 0;
		}
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_POST_INCREMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_POST_DECREMENT)
	{
		if (pNode->pLeft != NULL)
		{
			if (pNode->pLeft->nType != CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_OPERAND_MUST_BE_AN_INTEGER_LVALUE,pNode);
			}

			// Is pNode->pLeft actually a valid LValue?
			if (pNode->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_VARIABLE &&
			        pNode->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
			{
				return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_OPERAND_MUST_BE_AN_INTEGER_LVALUE,pNode->pLeft);
			}

			pNode->nType = pNode->pLeft->nType;

			// Current location of the variable is stored in pNode->pLeft->nIntegerData because
			// it is a valid LValue.

			int32_t nStackElementsDown = pNode->pLeft->nIntegerData - m_nStackCurrentDepth * 4;

			int32_t bOperateOnStackPointer = TRUE;
			if (pNode->pLeft->nIntegerData < m_nGlobalVariableSize && m_bGlobalVariableDefinition == FALSE)
			{
				bOperateOnStackPointer = FALSE;
				nStackElementsDown = pNode->pLeft->nIntegerData - (m_nGlobalVariableSize);
			}

			if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_POST_INCREMENT)
			{
				if (bOperateOnStackPointer == TRUE)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_INCREMENT;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_INCREMENT_BASE;
				}
			}
			else
			{
				if (bOperateOnStackPointer == TRUE)
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DECREMENT;
				}
				else
				{
					m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_DECREMENT_BASE;
				}
			}
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;

			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION] = (char) (((nStackElementsDown) >> 24) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+1] = (char) (((nStackElementsDown) >> 16) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+2] = (char) (((nStackElementsDown) >> 8) & 0x0ff);
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_EXTRA_DATA_LOCATION+3] = (char) (((nStackElementsDown)) & 0x0ff);

			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

			return 0;
		}

		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER,pNode);
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CASE)
	{

		return 0;
	}


	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_DEFAULT)
	{
		// Generate a label for the jump caused by the switch
		/* CExoString sSymbolName;
		sSymbolName.Format("_SC_DEFAULT_%08x",m_nSwitchIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_DEFAULT,m_nSwitchIdentifier,0);

		if (m_nSwitchStackDepth + 1 != m_nStackCurrentDepth)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_JUMPING_OVER_DECLARATION_STATEMENTS_DEFAULT_DISALLOWED,pNode);
		}

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_BREAK)
	{
		// CODE GENERATION
		// Add the "JMP _BR_nIdentifierBreak" operation, where nIdentifierBreak
		// represents the innermost for/while/dowhile/case statement!

		// Compute the location of the innermost loop that we are allowed
		// to break out of.

		int32_t nIdentifierBreak;

		// MGB - December 6, 2004 - START FIX
		// The line below fixes a bug where a
		// do/while loop is immediately followed by a switch statement;
		// both the loop and the switch will be equal, causing the break
		// in the switch to jump out of the do loop.  This is a bad thing.
		// The if used to simply be greater than (>).  Note that this fix
		// is safe because only do/while loops emit no code before they
		// execute interior code.  switch statements always emit code if they
		// are the "outer" function, so it is safe to assign equality always
		// to the switch statement.

		if (m_nSwitchIdentifier >= m_nLoopIdentifier)
		{
			nIdentifierBreak = m_nSwitchIdentifier;
		}
		else
		{
			nIdentifierBreak = m_nLoopIdentifier;
		}

		// MGB - December 6, 2004 - END FIX

		if (nIdentifierBreak == 0)
		{
			return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_BREAK_OUTSIDE_OF_LOOP_OR_CASE_STATEMENT,pNode);
		}

		// MGB - October 15, 2002 - Start Change
		// End-User reported bug:  break/continue do not modify stack properly.
		// We must ditch any/all stack values that weren't there at the start of the loop ...
		// MGB - December 8, 2004 - FIX Attempt 2.
		if (nIdentifierBreak != m_nSwitchIdentifier)
		{
			if (m_nLoopStackDepth != m_nStackCurrentDepth)
			{
				int32_t nStackChange = (m_nLoopStackDepth - m_nStackCurrentDepth) * 4;
				EmitModifyStackPointer(nStackChange);
			}
		}
		// MGB - November 8, 2002 - Start Change
		// Apparently, we forgot to deal with break statements in case statements as well!
		// MGB - December 8, 2004 - FIX Attempt 2.
		else
		{
			if ((m_nSwitchStackDepth + 1) != m_nStackCurrentDepth)
			{
				int32_t nStackChange = ((m_nSwitchStackDepth + 1) - m_nStackCurrentDepth) * 4;
				EmitModifyStackPointer(nStackChange);
			}
		}
		// MGB - November 8, 2002 - End Change
		// MGB - October 15, 2002 - End Change

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		/* CExoString sSymbolName;
		sSymbolName.Format("_BR_%08x",nIdentifierBreak); */
		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK,nIdentifierBreak,0);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONTINUE)
	{
		// MGB - October 15, 2002 - Start Change
		// End-User reported bug:  break/continue do not modify stack properly.
		// We must ditch any/all stack values that weren't there at the start of the loop ...
		if (m_nLoopStackDepth != m_nStackCurrentDepth)
		{
			int32_t nStackChange = (m_nLoopStackDepth - m_nStackCurrentDepth) * 4;
			EmitModifyStackPointer(nStackChange);
		}
		// MGB - October 15, 2002 - End Change

		// CODE GENERATION
		// Add the "JMP _CN_nLoopIdentifier" operation.

		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_JMP;
		m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = 0;

		/* CExoString sSymbolName;
		sSymbolName.Format("_CN_%08x",m_nLoopIdentifier); */
		AddSymbolToQueryList(m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_CONTINUE,m_nLoopIdentifier,0);

		m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + 4;
		m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_CONTINUE)
	{
		// Generate a label for the continue keyword.for a while loop.
		/* CExoString sSymbolName;
		sSymbolName.Format("_CN_%08x",m_nLoopIdentifier); */
		AddSymbolToLabelList(m_nOutputCodeLength, CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_CONTINUE, m_nLoopIdentifier, 0);
		return 0;
	}

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_CONST_DECLARATION)
	{
		return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_CONST_KEYWORD_CANNOT_BE_USED_ON_NON_GLOBAL_VARIABLES,pNode);
	}

	// Finally, if we've gone through *all* of these checks, we should abort immediately, because
	// it's not in the list of operations that I understand.

	return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_OPERATION_IN_SEMANTIC_CHECK,pNode);

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::FoundReturnStatementOnAllBranches()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/24/2000
//
//  This routine attempts to determine whether there is a RETURN statement on
//  all control paths.  Note that it will only follow if/else choices.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::FoundReturnStatementOnAllBranches(CScriptParseTreeNode *pNode)
{

	// Clearly, if the NODE is NULL, then we don't need to
	if (pNode == NULL)
	{
		return FALSE;
	}

	// Here, we want to verify that BOTH paths have a RETURN statement
	// before letting people know that both sides of it are protected.

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_RETURN)
	{
		return TRUE;
	}

	// Here, we want to verify that BOTH paths have a RETURN statement
	// before letting people know that both sides of it are protected.

	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_CHOICE)
	{
		if (FoundReturnStatementOnAllBranches(pNode->pLeft) == TRUE)
		{
			if (FoundReturnStatementOnAllBranches(pNode->pRight) == TRUE)
			{
				return TRUE;
			}
		}
		return FALSE;
	}

	// We want to pass through these functions, and if either side reports that
	// they have a RETURN statement in them, that's good enough for me.
	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST ||
	        pNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK)
	{
		if (FoundReturnStatementOnAllBranches(pNode->pLeft) == TRUE)
		{
			return TRUE;
		}

		if (FoundReturnStatementOnAllBranches(pNode->pRight) == TRUE)
		{
			return TRUE;
		}

		return FALSE;
	}

	// We don't want to scan through any other part of the tree, so we
	// should return FALSE here.

	return FALSE;

}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetStructureSize()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/21/2000
//  Description:  This routine will get a field from a strucutre, based on the
//                name of the structure and the field.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GetStructureSize(const CExoString &sStructureName)
{

	int32_t count;

	for (count = 0; count < m_nMaxStructures; count++)
	{
		if (sStructureName == m_pcStructList[count].m_psName)
		{
			return m_pcStructList[count].m_nByteSize;
		}
	}

	return 0;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetIdentifierByName()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/25/2000
//  Description:  This routine will get the information on an identifier, based
//                on the name of the identifier.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::GetIdentifierByName(const CExoString &sIdentifierName)
{
	BOOL bInfiniteLoop = TRUE;
	uint32_t nOriginalHash = HashString(sIdentifierName);

	// Search for the exact entry.
	uint32_t nHash = nOriginalHash % CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE;
	uint32_t nEndHash = nHash + (CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE - 1) & CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE;

	while (bInfiniteLoop)
	{
		// If we're at the correct entry, confirm that the strings are identical and then
		// return to the main routine.
		if (m_pIdentifierHashTable[nHash].m_nHashValue == nOriginalHash &&
		        m_pIdentifierHashTable[nHash].m_nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
		{
			int32_t count = m_pIdentifierHashTable[nHash].m_nIdentifierIndex;
			if (m_pcIdentifierList[count].m_psIdentifier == sIdentifierName)
			{
				return count;
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
//  CScriptCompiler::GetStructureField()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/20/2000
//  Description:  This routine will get a field from a strucutre, based on the
//                name of the structure and the field.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GetStructureField(const CExoString &sStructureName, const CExoString &sFieldName)
{

	int32_t count, count2;

	for (count = 0; count < m_nMaxStructures; count++)
	{
		if (sStructureName == m_pcStructList[count].m_psName)
		{
			for (count2 = m_pcStructList[count].m_nFieldStart; count2 <= m_pcStructList[count].m_nFieldEnd; count2++)
			{
				if (sFieldName == m_pcStructFieldList[count2].m_psVarName)
				{
					return count2;
				}
			}
			return STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_FIELD_IN_STRUCTURE;
		}
	}

	return STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_STRUCTURE;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddVariableToStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/22/2000
//  Description:  This routine will add a variable to the run-time stack
//                based on the type (handing off to AddStructureToStack if
//                it is too complicated for me to handle).
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::AddVariableToStack(int32_t nVariableType, CExoString *psVariableTypeName, BOOL bGenerateCode)
{
	if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
	        nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
	        nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
	        nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
	        (nVariableType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
	         nVariableType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
	{

		int32_t nAuxCodeType = 0;

		if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
		{
			nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
		}
		else if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
		{
			nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
		}
		else if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
		{
			nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;
		}
		else if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
		{
			nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;
		}
		else if (nVariableType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
		         nVariableType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
		{
			nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST0 + (nVariableType - CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0);
		}

		m_pchStackTypes[m_nStackCurrentDepth] = (char) nAuxCodeType;
		++m_nStackCurrentDepth;

		if (bGenerateCode == TRUE)
		{
			// CODE GENERATION
			m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_ADD;
			m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = (char) nAuxCodeType;
			m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
			m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
		}
	}
	else if (nVariableType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
	{
		// Function to recursively do all structures within the structure on the stack.
		AddStructureToStack(*psVariableTypeName, bGenerateCode);
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddStructureToStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/22/2000
//  Description:  This routine will add the strucutre to the run-time stack,
//                based on the name of the structure.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::AddStructureToStack(const CExoString &sStructureName, BOOL bGenerateCode)
{
	int32_t count, count2;

	for (count = 0; count < m_nMaxStructures; count++)
	{
		if (sStructureName == m_pcStructList[count].m_psName)
		{
			for (count2 = m_pcStructList[count].m_nFieldStart; count2 <= m_pcStructList[count].m_nFieldEnd; count2++)
			{
				int32_t nFieldType = m_pcStructFieldList[count2].m_pchType;

				if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
				        nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
				        nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
				        nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
				        (nFieldType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
				         nFieldType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
				{

					int32_t nAuxCodeType = 0;

					if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
					{
						nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER;
					}
					else if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
					{
						nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT;
					}
					else if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
					{
						nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_STRING;
					}
					else if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
					{
						nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT;
					}
					else if (nFieldType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
					         nFieldType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
					{
						nAuxCodeType = CVIRTUALMACHINE_AUXCODE_TYPE_ENGST0 + (nFieldType - CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0);
					}

					m_pchStackTypes[m_nStackCurrentDepth] = (char) nAuxCodeType;
					++m_nStackCurrentDepth;

					// CODE GENERATION
					if (bGenerateCode == TRUE)
					{
						m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = CVIRTUALMACHINE_OPCODE_RUNSTACK_ADD;
						m_pchOutputCode[m_nOutputCodeLength+CVIRTUALMACHINE_AUXCODE_LOCATION] = (char) nAuxCodeType;
						m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE;
						m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
					}
				}
				else if (nFieldType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					// Function to recursively do all structures within the structure on the stack.
					AddStructureToStack(m_pcStructFieldList[count2].m_psStructureName, bGenerateCode);
				}

			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetFunctionNameFromSymbolSubTypes()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 21, 2002
// Description: A utility function to return a function name from the symbol
//              subtypes you've passed in.
///////////////////////////////////////////////////////////////////////////////
CExoString CScriptCompiler::GetFunctionNameFromSymbolSubTypes(int32_t nSubType1,int32_t nSubType2)
{
	CExoString sNewFunctionName;

	if (nSubType1 == 0 &&
	        nSubType2 != 0)
	{
		// Starting functions, need to be handled with kid gloves.
		if (nSubType2 == 2)
		{
			if (m_bCompileConditionalFile == 0)
			{
				sNewFunctionName = "main";
			}
			else
			{
				sNewFunctionName = "StartingConditional";
			}
		}
		else
		{
			sNewFunctionName = "#globals";
		}

	}
	else if (nSubType1 != 0 &&
	         nSubType2 == 0)
	{
		// These can be looked up on the Occupied Identifiers list.
		uint32_t nNewFunctionIdentifier = nSubType1;
		sNewFunctionName = m_pcIdentifierList[nNewFunctionIdentifier].m_psIdentifier;
	}
	else
	{
		// Sorry, dude ... this shouldn't have happened under any circumstance.
		sNewFunctionName = "";
	}

	return sNewFunctionName;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddSymbolToLabelList()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/22/2000
// Description: Adds information to the symbol label list for examination at
//              a later date.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::AddSymbolToLabelList(int32_t nLocationPointer, int32_t nSymbolType, int32_t nSymbolSubType1, int32_t nSymbolSubType2)
{
	if (m_nSymbolLabelListSize == m_nSymbolLabelList)
	{
		CScriptCompilerSymbolTableEntry *m_pNewLabelList;

		// Create a new list.

		m_nSymbolLabelListSize += 8192;
		m_pNewLabelList = new CScriptCompilerSymbolTableEntry[m_nSymbolLabelListSize];

		if (m_pSymbolLabelList != NULL)
		{
			for (int32_t count = 0; count < m_nSymbolLabelList; ++count)
			{
				m_pNewLabelList[count].m_nSymbolType       = m_pSymbolLabelList[count].m_nSymbolType;
				m_pNewLabelList[count].m_nSymbolSubType1   = m_pSymbolLabelList[count].m_nSymbolSubType1;
				m_pNewLabelList[count].m_nSymbolSubType2   = m_pSymbolLabelList[count].m_nSymbolSubType2;
				m_pNewLabelList[count].m_nLocationPointer  = m_pSymbolLabelList[count].m_nLocationPointer;
				m_pNewLabelList[count].m_nNextEntryPointer = m_pSymbolLabelList[count].m_nNextEntryPointer;
			}
			delete[] m_pSymbolLabelList;
		}
		m_pSymbolLabelList = m_pNewLabelList;
	}

	m_pSymbolLabelList[m_nSymbolLabelList].m_nSymbolType      = nSymbolType;
	m_pSymbolLabelList[m_nSymbolLabelList].m_nSymbolSubType1  = nSymbolSubType1;
	m_pSymbolLabelList[m_nSymbolLabelList].m_nSymbolSubType2  = nSymbolSubType2;
	m_pSymbolLabelList[m_nSymbolLabelList].m_nLocationPointer = nLocationPointer;
	m_pSymbolLabelList[m_nSymbolLabelList].m_nNextEntryPointer = -1;

	uint32_t nLabelHash = (nSymbolSubType1 & 0x01ff);
	if (m_pSymbolLabelStartEntry[nLabelHash] == -1)
	{
		// First entry in list.
		m_pSymbolLabelStartEntry[nLabelHash] = m_nSymbolLabelList;
	}
	else
	{
		// Chain the new entry to the tail of the list ...
		int32_t nCurrentPtr = m_pSymbolLabelStartEntry[nLabelHash];
		while (m_pSymbolLabelList[nCurrentPtr].m_nNextEntryPointer != -1)
		{
			nCurrentPtr = m_pSymbolLabelList[nCurrentPtr].m_nNextEntryPointer;
		}
		m_pSymbolLabelList[nCurrentPtr].m_nNextEntryPointer = m_nSymbolLabelList;
	}

	// Advance the symbol label list pointer.
	++m_nSymbolLabelList;

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddSymbolToQueryList()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/22/2000
// Description: Adds information to the symbol query list for examination at
//              a later date.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::AddSymbolToQueryList(int32_t nLocationPointer, int32_t nSymbolType, int32_t nSymbolSubType1, int32_t nSymbolSubType2)
{
	if (m_nSymbolQueryListSize == m_nSymbolQueryList)
	{
		CScriptCompilerSymbolTableEntry *m_pNewQueryList;

		// Create a new list.

		m_nSymbolQueryListSize += 8192;
		m_pNewQueryList = new CScriptCompilerSymbolTableEntry[m_nSymbolQueryListSize];

		if (m_pSymbolQueryList != NULL)
		{
			for (int32_t count = 0; count < m_nSymbolQueryList; ++count)
			{
				m_pNewQueryList[count].m_nSymbolType      = m_pSymbolQueryList[count].m_nSymbolType;
				m_pNewQueryList[count].m_nSymbolSubType1  = m_pSymbolQueryList[count].m_nSymbolSubType1;
				m_pNewQueryList[count].m_nSymbolSubType2  = m_pSymbolQueryList[count].m_nSymbolSubType2;
				m_pNewQueryList[count].m_nLocationPointer = m_pSymbolQueryList[count].m_nLocationPointer;
				m_pNewQueryList[count].m_nNextEntryPointer = m_pSymbolQueryList[count].m_nNextEntryPointer;
			}
			delete[] m_pSymbolQueryList;
		}
		m_pSymbolQueryList = m_pNewQueryList;
	}

	m_pSymbolQueryList[m_nSymbolQueryList].m_nSymbolType      = nSymbolType;
	m_pSymbolQueryList[m_nSymbolQueryList].m_nSymbolSubType1  = nSymbolSubType1;
	m_pSymbolQueryList[m_nSymbolQueryList].m_nSymbolSubType2  = nSymbolSubType2;
	m_pSymbolQueryList[m_nSymbolQueryList].m_nLocationPointer = nLocationPointer;
	// m_nNextEntryPointer is not valid for query list.
	++m_nSymbolQueryList;

	return 0;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::WalkParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  This routine will walk the compile tree, generating a postfix
//                listing of the nodes (if necessary).
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::WalkParseTree(CScriptParseTreeNode *pNode)
{
	if (pNode != NULL)
	{
		//INT bPrinted = 0;


		int nReturnCode;

		ConstantFoldNode(pNode);
		nReturnCode = PreVisitGenerateCode(pNode);

		if (nReturnCode == 0)
		{
			nReturnCode = WalkParseTree(pNode->pLeft);
		}

		if (nReturnCode == 0)
		{
			ConstantFoldNode(pNode);
			nReturnCode = InVisitGenerateCode(pNode);
		}

		if (nReturnCode == 0)
		{
			nReturnCode = WalkParseTree(pNode->pRight);
		}

		if (nReturnCode == 0)
		{
			ConstantFoldNode(pNode);
			nReturnCode = PostVisitGenerateCode(pNode);
		}

		if (nReturnCode > 0)
		{
			nReturnCode = 0;
		}

		// Oh, dear.  If there is not enough room, we should probably grow the
		// output buffer by a bit!
		// [36628] We make this check AFTER the data has been written without
		// boundary checks. 200 bytes was not enough to protect from buffer
		// overflows, raising to 16K. -virusman 2018/04/13
		if (nReturnCode == 0 && m_nOutputCodeLength >= m_nOutputCodeSize - 16384)
		{
			m_nOutputCodeSize += CSCRIPTCOMPILER_MAX_CODE_SIZE;
			char *pNewArray = new char[m_nOutputCodeSize];
			memcpy(pNewArray,m_pchOutputCode,m_nOutputCodeLength);
			delete[] m_pchOutputCode;
			m_pchOutputCode = pNewArray;
			// return OutputWalkTreeError(STRREF_CSCRIPTCOMPILER_ERROR_SCRIPT_TOO_LARGE,pNode);
		}

		return nReturnCode;
	}

	// A Null pointer is not an error.
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::StartLineNumberAtBinaryInstruction()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 29, 2002
//  Description:  This routine will attempt to deal with line number
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::StartLineNumberAtBinaryInstruction(int32_t nFileReference, int32_t nLineNumber, int32_t nBinaryInstruction)
{
	if (m_nCurrentLineNumber != nLineNumber ||
	        m_nCurrentLineNumberFileReference != nFileReference)
	{
		m_nCurrentLineNumber = nLineNumber;
		m_nCurrentLineNumberFileReference = nFileReference;
		m_nCurrentLineNumberReferences = 1;
		m_nCurrentLineNumberBinaryStartInstruction = nBinaryInstruction;
	}
	else
	{
		m_nCurrentLineNumberReferences += 1;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::EndLineNumberAtBinaryInstruction()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 29, 2002
//  Description:  This routine will attempt to deal with line number
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::EndLineNumberAtBinaryInstruction(int32_t nFileReference, int32_t nLineNumber, int32_t nBinaryInstruction)
{
	// If we've received an end of line for something that we haven't started,
	// this is a bug, so let's not write anything into the table.
	if (m_nCurrentLineNumber != nLineNumber ||
	        m_nCurrentLineNumberFileReference != nFileReference)
	{
		m_nCurrentLineNumber = -1;
		m_nCurrentLineNumberFileReference = -1;
		m_nCurrentLineNumberReferences = 0;
		return;
	}

	// If you have had multiple references for the same line, just subtract
	// one of them away.
	if (m_nCurrentLineNumberReferences > 1)
	{
		m_nCurrentLineNumberReferences -= 1;
		return;
	}

	// We're at the last reference for a line, so we can write the information
	// into the table.

	// Fetch the file name reference.
	CExoString *psCurrentLineNumberFileName = m_ppsParseTreeFileNames[m_nCurrentLineNumberFileReference];

	int32_t nFileNameReference = -1;
	for (int32_t nCount=0; nFileNameReference == -1 && nCount < m_nTableFileNames; ++nCount)
	{
		if (strcmp(m_psTableFileNames[nCount].CStr(),psCurrentLineNumberFileName->CStr()) == 0)
		{
			nFileNameReference = nCount;
		}
	}

	if (nFileNameReference == -1)
	{
		if (m_nTableFileNames >= CSCRIPTCOMPILER_MAX_TABLE_FILENAMES)
		{
			return;
		}
		m_psTableFileNames[m_nTableFileNames] = *psCurrentLineNumberFileName;
		nFileNameReference = m_nTableFileNames;
		++m_nTableFileNames;
	}

	if (m_pnTableInstructionFileReference.size() == m_nLineNumberEntries)
	{
		int32_t nSize = m_pnTableInstructionFileReference.size() * 2;
		if (nSize <= 16)
		{
			nSize = 16;
		}

		m_pnTableInstructionFileReference.resize(nSize);
		m_pnTableInstructionLineNumber.resize(nSize);
		m_pnTableInstructionBinaryStart.resize(nSize);
		m_pnTableInstructionBinaryEnd.resize(nSize);
		m_pnTableInstructionBinaryFinal.resize(nSize);
		m_pnTableInstructionBinarySortedOrder.resize(nSize);

	}

	// Write all of the information for this line into the table.
	m_pnTableInstructionFileReference[m_nLineNumberEntries] =  nFileNameReference;
	m_pnTableInstructionLineNumber[m_nLineNumberEntries]    =  nLineNumber;
	m_pnTableInstructionBinaryStart[m_nLineNumberEntries]   =  m_nCurrentLineNumberBinaryStartInstruction;
	m_pnTableInstructionBinaryEnd[m_nLineNumberEntries]     =  nBinaryInstruction;
	m_pnTableInstructionBinaryFinal[m_nLineNumberEntries]   =  FALSE;
	m_pnTableInstructionBinarySortedOrder[m_nLineNumberEntries] = -1;

	m_nLineNumberEntries++;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddToSymbolTableVarStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 21, 2002
//  Description:  This routine will add an occupied variable to the symbol
//                table.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::AddToSymbolTableVarStack(int32_t nOccupiedVariables, int32_t nStackCurrentDepth, int32_t nGlobalVariableSize)
{
	if (m_nGenerateDebuggerOutput != 0)
	{
		if (m_pnSymbolTableVarType.size() == m_nSymbolTableVariables)
		{
			int32_t nSize = m_pnSymbolTableVarType.size() * 2;
			if (nSize <= 16)
			{
				nSize = 16;
			}

			m_pnSymbolTableVarType.resize(nSize);
			m_psSymbolTableVarName.resize(nSize);
			m_psSymbolTableVarStructureName.resize(nSize);
			m_pnSymbolTableVarStackLoc.resize(nSize);
			m_pnSymbolTableVarBegin.resize(nSize);
			m_pnSymbolTableVarEnd.resize(nSize);
			m_pnSymbolTableBinaryFinal.resize(nSize);
			m_pnSymbolTableBinarySortedOrder.resize(nSize);
		}

		m_pnSymbolTableVarType[m_nSymbolTableVariables] = m_pcVarStackList[nOccupiedVariables].m_nVarType;
		m_psSymbolTableVarName[m_nSymbolTableVariables] = m_pcVarStackList[nOccupiedVariables].m_psVarName;
		if (m_pcVarStackList[nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			m_psSymbolTableVarStructureName[m_nSymbolTableVariables] = (m_pcVarStackList[nOccupiedVariables].m_sVarStructureName);
		}
		m_pnSymbolTableVarStackLoc[m_nSymbolTableVariables]       = nStackCurrentDepth * 4 - nGlobalVariableSize;
		m_pnSymbolTableVarBegin[m_nSymbolTableVariables]          = m_nOutputCodeLength;
		m_pnSymbolTableVarEnd[m_nSymbolTableVariables]            = -1;
		m_pnSymbolTableBinaryFinal[m_nSymbolTableVariables]       = FALSE;
		m_pnSymbolTableBinarySortedOrder[m_nSymbolTableVariables] = -1;
		m_nSymbolTableVariables                                  += 1;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::RemoveFromSymbolTableVarStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 21, 2002
//  Description:  This routine will add an occupied variable to the symbol
//                table.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::RemoveFromSymbolTableVarStack(int32_t nOccupiedVariables, int32_t nStackCurrentDepth, int32_t nGlobalVariableSize)
{
	if (m_nGenerateDebuggerOutput != 0)
	{

		int32_t nVarCount = m_nSymbolTableVariables - 1;
		while (nVarCount >= 0)
		{
			BOOL bMatch = TRUE;
			if (m_pnSymbolTableVarType[nVarCount] != m_pcVarStackList[nOccupiedVariables].m_nVarType)
			{
				bMatch = FALSE;
			}
			if (bMatch == TRUE &&
			        m_psSymbolTableVarName[nVarCount] != m_pcVarStackList[nOccupiedVariables].m_psVarName)
			{
				bMatch = FALSE;
			}
			if (bMatch == TRUE &&
			        m_pnSymbolTableVarStackLoc[nVarCount] != nStackCurrentDepth * 4 - nGlobalVariableSize)
			{
				bMatch = FALSE;
			}

			if (bMatch == TRUE &&
			        m_pcVarStackList[nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT &&
			        m_psSymbolTableVarStructureName[nVarCount] != (m_pcVarStackList[nOccupiedVariables].m_sVarStructureName))
			{
				bMatch = FALSE;
			}

			if (bMatch == TRUE && m_pnSymbolTableVarEnd[nVarCount] == -1)
			{
				m_pnSymbolTableVarEnd[nVarCount] = m_nOutputCodeLength;
				return;
			}

			--nVarCount;
		}

		/////////////////////////////////////////////////////////////////
		//
		// Once we get past this point, we are actually deleting an entry
		// that we haven't found in the list ... this is usually a bad
		// thing.  However, to cover over the problem, we're just going
		// to add an additional entry.
		//
		/////////////////////////////////////////////////////////////////

		if (m_pnSymbolTableVarType.size() == m_nSymbolTableVariables)
		{
			int32_t nSize = m_pnSymbolTableVarType.size() * 2;
			if (nSize <= 16)
			{
				nSize = 16;
			}

			m_pnSymbolTableVarType.resize(nSize);
			m_psSymbolTableVarName.resize(nSize);
			m_psSymbolTableVarStructureName.resize(nSize);
			m_pnSymbolTableVarStackLoc.resize(nSize);
			m_pnSymbolTableVarBegin.resize(nSize);
			m_pnSymbolTableVarEnd.resize(nSize);
			m_pnSymbolTableBinaryFinal.resize(nSize);
			m_pnSymbolTableBinarySortedOrder.resize(nSize);
		}

		m_pnSymbolTableVarType[m_nSymbolTableVariables]           = m_pcVarStackList[nOccupiedVariables].m_nVarType;
		m_psSymbolTableVarName[m_nSymbolTableVariables]           = m_pcVarStackList[nOccupiedVariables].m_psVarName;
		if (m_pcVarStackList[nOccupiedVariables].m_nVarType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
		{
			m_psSymbolTableVarStructureName[m_nSymbolTableVariables] = (m_pcVarStackList[nOccupiedVariables].m_sVarStructureName);
		}
		m_pnSymbolTableVarStackLoc[m_nSymbolTableVariables]       = nStackCurrentDepth * 4 - nGlobalVariableSize;
		m_pnSymbolTableVarBegin[m_nSymbolTableVariables]          = -1;
		m_pnSymbolTableVarEnd[m_nSymbolTableVariables]            = m_nOutputCodeLength;
		m_pnSymbolTableBinaryFinal[m_nSymbolTableVariables]       = FALSE;
		m_pnSymbolTableBinarySortedOrder[m_nSymbolTableVariables] = -1;
		m_nSymbolTableVariables                                  += 1;
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ResolveDebuggingInformation()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 29, 2002
//  Description:  This routine will take the binary source locations for
//                line numbers and variables stored in the .ndb and moves
//                them to their correct final location.
///////////////////////////////////////////////////////////////////////////////
void CScriptCompiler::ResolveDebuggingInformation()
{
	// m_nFinalLineNumberEntries contains the number of entries that
	// will eventually be written into the file.  Only those entries
	// where m_pnTableInstructionBinaryFinal[] == TRUE will be included
	// in this total.
	m_nFinalLineNumberEntries = 0;

	{
		int32_t nCurrentBinarySize = CVIRTUALMACHINE_BINARY_SCRIPT_HEADER;
		while (nCurrentBinarySize < m_nFinalBinarySize)
		{
			BOOL bFoundIdentifier = FALSE;
			int32_t nCount2 = m_nMaxPredefinedIdentifierId;
			while (bFoundIdentifier == FALSE && nCount2 <= m_nOccupiedIdentifiers)
			{
				if (nCurrentBinarySize == m_pcIdentifierList[nCount2].m_nBinaryDestinationStart)
				{
					ResolveDebuggingInformationForIdentifier(nCount2);
					nCurrentBinarySize = m_pcIdentifierList[nCount2].m_nBinaryDestinationFinish;
					bFoundIdentifier = TRUE;
				}
				nCount2++;
			}

			if (bFoundIdentifier == FALSE)
			{
				// This is bad, since we have a discontinuity
				// in the binary functions.
				nCurrentBinarySize = m_nFinalBinarySize;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ResolveDebuggingInformationForIdentifier()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: August 29, 2002
//  Description:  The routine that actually resolves line numbers and
//                variables on a per-identifier (function) basis.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ResolveDebuggingInformationForIdentifier(int32_t nIdentifier)
{
	int32_t nCount;

	// Loop through all of the line number pairs that we have accumulated.
	for (nCount = 0; nCount < m_nLineNumberEntries; nCount++)
	{

		// Has the entry been resolved?
		if (m_pnTableInstructionBinaryFinal[nCount] == FALSE)
		{
			// Resolve the location of where we will be writing the address
			// for the start of the line number we're lookin' for.
			int32_t nLineBinaryInstructionStart = m_pnTableInstructionBinaryStart[nCount];

			if (nLineBinaryInstructionStart >= m_pcIdentifierList[nIdentifier].m_nBinarySourceStart &&
			        nLineBinaryInstructionStart < m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish)
			{
				// Now, check to see if the query even BELONGS in the final file.
				// (The function may not be reachable through a call to main(),
				// so we don't need to store information about it!)
				//
				// If it does belong in the final file, generate its change in
				// location and let it be "printed" to the file.
				if (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart != -1)
				{
					int32_t nBinaryLocationChange = (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart -
					                             m_pcIdentifierList[nIdentifier].m_nBinarySourceStart);

					m_pnTableInstructionBinaryStart[nCount] += nBinaryLocationChange;
					m_pnTableInstructionBinaryEnd[nCount]   += nBinaryLocationChange;
					m_pnTableInstructionBinaryFinal[nCount] = TRUE;
					m_pnTableInstructionBinarySortedOrder[m_nFinalLineNumberEntries] = nCount;
					m_nFinalLineNumberEntries += 1;
				}
			}
		}
	}

	// Loop through all of the symbol table entries we have accumulated.
	for (nCount = 0; nCount < m_nSymbolTableVariables; nCount++)
	{
		// Has the entry been resolved?
		if (m_pnSymbolTableBinaryFinal[nCount] == FALSE)
		{
			int32_t nInstruction = m_pnSymbolTableVarBegin[nCount];
			if (nInstruction == -1)
			{
				nInstruction = m_pnSymbolTableVarEnd[nCount];
			}

			if (nInstruction >= m_pcIdentifierList[nIdentifier].m_nBinarySourceStart &&
			        nInstruction < m_pcIdentifierList[nIdentifier].m_nBinarySourceFinish)
			{
				if (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart != -1)
				{
					int32_t nBinaryLocationChange = (m_pcIdentifierList[nIdentifier].m_nBinaryDestinationStart -
					                             m_pcIdentifierList[nIdentifier].m_nBinarySourceStart);

					if (m_pnSymbolTableVarBegin[nCount] != -1)
					{
						m_pnSymbolTableVarBegin[nCount] += nBinaryLocationChange;
					}

					if (m_pnSymbolTableVarEnd[nCount] != -1)
					{
						m_pnSymbolTableVarEnd[nCount]   += nBinaryLocationChange;
					}

					m_pnSymbolTableBinaryFinal[nCount] = TRUE;
					m_pnSymbolTableBinarySortedOrder[m_nFinalSymbolTableVariables] = nCount;
					m_nFinalSymbolTableVariables += 1;
				}
			}
		}
	}
}

CExoString CScriptCompiler::GenerateDebuggerTypeAbbreviation(int32_t nType, CExoString sStructureName)
{
	CExoString sReturnValue = "?";

	if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID ||
	        nType == CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER)
	{
		sReturnValue = "v";
	}
	else if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
	         nType == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER)
	{
		sReturnValue = "f";
	}
	else if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
	         nType == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
	{
		sReturnValue = "i";
	}
	else if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
	         nType == CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER)
	{
		sReturnValue = "o";
	}
	else if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
	         nType == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER)
	{
		sReturnValue = "s";
	}
	else if ((nType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
	          nType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9) ||
	         (nType >= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER &&
	          nType <= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER))
	{
		if (nType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
		        nType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
		{
			sReturnValue.Format("e%01d",nType - CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0);
		}
		else
		{
			sReturnValue.Format("e%01d",nType - CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER);
		}
	}
	else if (nType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT ||
	         nType == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER)
	{
		for (int32_t count = 0; count < m_nMaxStructures; count++)
		{
			if (m_pcStructList[count].m_psName == sStructureName)
			{
				sReturnValue.Format("t%04d",count);
			}
		}
	}

	return sReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::WriteOutDebuggerOutput()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: September 3, 2002
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::WriteDebuggerOutputToFile(CExoString sFileName)
{
	if (m_nGenerateDebuggerOutput != 0)
	{
		if (m_pchDebuggerCode == NULL)
		{
			m_nDebuggerCodeSize = CSCRIPTCOMPILER_MAX_DEBUG_OUTPUT_SIZE;
			m_pchDebuggerCode = new char[m_nDebuggerCodeSize];
		}

		if (m_pchDebuggerCode == NULL)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_UNABLE_TO_OPEN_FILE_FOR_WRITING;
		}

		// MGB - February 14, 2003
		// Evaluate the size of the debugger output.  If the debugger output is larger
		// than the buffer, we should increase the size of the buffer by a bit (double it!)

		{
			int32_t nMaxSize = 9 + 40; // NDB Header + Section sizes.
			int32_t nMaxTypeNameSize = 5;
			int32_t count;
			for (count = 0; count < m_nTableFileNames; count++)
			{
				nMaxSize += m_psTableFileNames[count].GetLength() + 5;
			}
			for (count = 0; count < m_nMaxStructures; count++)
			{
				nMaxSize += m_pcStructList[count].m_psName.GetLength() + 6;
				int32_t countField;
				for (countField = m_pcStructList[count].m_nFieldStart; countField <= m_pcStructList[count].m_nFieldEnd; countField++)
				{
					// sTypeName can be at most size 5.
					nMaxSize += nMaxTypeNameSize + m_pcStructFieldList[countField].m_psVarName.GetLength() + 5;
				}
			}
			for (count = m_nMaxPredefinedIdentifierId; count < m_nOccupiedIdentifiers; count++)
			{
				nMaxSize += nMaxTypeNameSize + m_pcIdentifierList[count].m_psIdentifier.GetLength() + 26;
				int32_t countParams;
				for (countParams = 0; countParams < m_pcIdentifierList[count].m_nParameters; countParams++)
				{
					nMaxSize += nMaxTypeNameSize + 4;
				}
			}
			for (count = 0; count < m_nFinalSymbolTableVariables; count++)
			{
				int32_t nSTEntry = m_pnSymbolTableBinarySortedOrder[count];
				if (m_pnSymbolTableBinaryFinal[nSTEntry] == TRUE)
				{
					nMaxSize += nMaxTypeNameSize + m_psSymbolTableVarName[nSTEntry].GetLength() + 31;
				}
			}
			for (count = 0; count < m_nFinalLineNumberEntries; count++)
			{
				int32_t nLNEntry = m_pnTableInstructionBinarySortedOrder[count];
				if (m_pnTableInstructionBinaryFinal[nLNEntry] == TRUE)
				{
					nMaxSize += 30;
				}
			}

			if (nMaxSize >= m_nDebuggerCodeSize)
			{
				if (nMaxSize < m_nDebuggerCodeSize * 2)
				{
					m_nDebuggerCodeSize *= 2;
				}
				else
				{
					m_nDebuggerCodeSize = nMaxSize * 2;
				}

				delete[] m_pchDebuggerCode;
				m_pchDebuggerCode = new char[m_nDebuggerCodeSize];

				if (m_pchDebuggerCode == NULL)
				{
					return STRREF_CSCRIPTCOMPILER_ERROR_UNABLE_TO_OPEN_FILE_FOR_WRITING;
				}
			}
		}


		sprintf(m_pchDebuggerCode,"NDB V1.0\n");
		m_nDebuggerCodeLength = 9;
		sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"%07d %07d %07d %07d %07d\n",
		        m_nTableFileNames, m_nMaxStructures,
		        m_nOccupiedIdentifiers - m_nMaxPredefinedIdentifierId,
		        m_nFinalSymbolTableVariables,m_nFinalLineNumberEntries);
		m_nDebuggerCodeLength += 40;

		int32_t count;

		for (count = 0; count < m_nTableFileNames; count++)
		{
			if (m_psTableFileNames[count] == sFileName)
			{
				// Capital F indicates the base file.
				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"N%02d %s\n",count,m_psTableFileNames[count].CStr());
			}
			else
			{
				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"n%02d %s\n",count,m_psTableFileNames[count].CStr());
			}
			m_nDebuggerCodeLength += m_psTableFileNames[count].GetLength() + 5;
		}

		for (count = 0; count < m_nMaxStructures; count++)
		{
			sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"s %02d %s\n",
			        (m_pcStructList[count].m_nFieldEnd - m_pcStructList[count].m_nFieldStart + 1),
			        m_pcStructList[count].m_psName.CStr());
			m_nDebuggerCodeLength += m_pcStructList[count].m_psName.GetLength() + 6;

			int32_t countField;
			for (countField = m_pcStructList[count].m_nFieldStart; countField <= m_pcStructList[count].m_nFieldEnd; countField++)
			{
				CExoString sTypeName = GenerateDebuggerTypeAbbreviation(m_pcStructFieldList[countField].m_pchType,m_pcStructFieldList[countField].m_psStructureName);
				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"sf %s %s\n",
				        sTypeName.CStr(), m_pcStructFieldList[countField].m_psVarName.CStr());
				m_nDebuggerCodeLength += sTypeName.GetLength() + m_pcStructFieldList[countField].m_psVarName.GetLength() + 5;
			}
		}

		for (count = m_nMaxPredefinedIdentifierId; count < m_nOccupiedIdentifiers; count++)
		{
			CExoString sTypeName = GenerateDebuggerTypeAbbreviation(m_pcIdentifierList[count].m_nReturnType,m_pcIdentifierList[count].m_psStructureReturnName);
			sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"f %08x %08x %03d %s %s\n",
			        m_pcIdentifierList[count].m_nBinaryDestinationStart,
			        m_pcIdentifierList[count].m_nBinaryDestinationFinish,
			        m_pcIdentifierList[count].m_nParameters,
			        sTypeName.CStr(), m_pcIdentifierList[count].m_psIdentifier.CStr());
			m_nDebuggerCodeLength += sTypeName.GetLength() + m_pcIdentifierList[count].m_psIdentifier.GetLength() + 26;

			int32_t countParams;
			for (countParams = 0; countParams < m_pcIdentifierList[count].m_nParameters; countParams++)
			{
				CExoString sTypeName = (GenerateDebuggerTypeAbbreviation(m_pcIdentifierList[count].m_pchParameters[countParams],
				                        m_pcIdentifierList[count].m_psStructureParameterNames[countParams]));
				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"fp %s\n",sTypeName.CStr());
				m_nDebuggerCodeLength += sTypeName.GetLength() + 4;
			}
		}

		for (count = 0; count < m_nFinalSymbolTableVariables; count++)
		{
			int32_t nSTEntry = m_pnSymbolTableBinarySortedOrder[count];
			if (m_pnSymbolTableBinaryFinal[nSTEntry] == TRUE)
			{
				CExoString sTypeName = GenerateDebuggerTypeAbbreviation(m_pnSymbolTableVarType[nSTEntry],
				                       m_psSymbolTableVarStructureName[nSTEntry]);

				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"v %08x %08x %08x %s %s\n",
				        m_pnSymbolTableVarBegin[nSTEntry],
				        m_pnSymbolTableVarEnd[nSTEntry],
				        m_pnSymbolTableVarStackLoc[nSTEntry],
				        sTypeName.CStr(), m_psSymbolTableVarName[nSTEntry].CStr());
				m_nDebuggerCodeLength += sTypeName.GetLength() + m_psSymbolTableVarName[nSTEntry].GetLength() + 31;
			}
		}

		for (count = 0; count < m_nFinalLineNumberEntries; count++)
		{
			int32_t nLNEntry = m_pnTableInstructionBinarySortedOrder[count];
			if (m_pnTableInstructionBinaryFinal[nLNEntry] == TRUE)
			{
				sprintf(m_pchDebuggerCode + m_nDebuggerCodeLength,"l%02d %07d %08x %08x\n",
				        m_pnTableInstructionFileReference[nLNEntry],m_pnTableInstructionLineNumber[nLNEntry],
				        m_pnTableInstructionBinaryStart[nLNEntry],m_pnTableInstructionBinaryEnd[nLNEntry]);
				m_nDebuggerCodeLength += 30;
			}
		}

		// Now that the debugger information has been written into a buffer,
		// we can write it out in one operation to disk!
		CExoString sModifiedFileName;
		sModifiedFileName.Format("%s:%s",m_sOutputAlias.CStr(),sFileName.CStr());

        const int32_t ret = m_cAPI.ResManWriteToFile(
            sModifiedFileName.CStr(), m_nResTypeDebug,
            (const uint8_t*) m_pchDebuggerCode, m_nDebuggerCodeLength, false);

        if (ret != 0)
        {
            return ret;
        }

		if (m_bAutomaticCleanUpAfterCompiles == TRUE)
		{
			CExoString sDirectoryFileName;

			sDirectoryFileName.Format("%s:",m_sOutputAlias.CStr());
			m_cAPI.ResManUpdateResourceDirectory(sDirectoryFileName.CStr());

			// Delete the Debugger code buffer
			delete[] m_pchDebuggerCode;
			m_pchDebuggerCode = NULL;
			m_nDebuggerCodeSize = 0;
		}

		// This must always happen.
		m_nDebuggerCodeLength = 0;
	}
	return 0;
}

char *CScriptCompiler::InstructionLookback(uint32_t last)
{
	if (last == 0 || last > m_aOutputCodeInstructionBoundaries.size())
		return NULL;

	return &m_pchOutputCode[m_aOutputCodeInstructionBoundaries[m_aOutputCodeInstructionBoundaries.size() - 1 - last]];
}

void CScriptCompiler::WriteByteSwap32(char *buffer, int32_t value)
{
	buffer[0] = (char)((value >> 24) & 0xff);
	buffer[1] = (char)((value >> 16) & 0xff);
	buffer[2] = (char)((value >> 8)  & 0xff);
	buffer[3] = (char)((value)       & 0xff);
}
int32_t CScriptCompiler::ReadByteSwap32(char *buffer)
{
	return ((int32_t)buffer[0] << 24) | ((int32_t)buffer[1] << 16) | ((int32_t)buffer[2] << 8) | (int32_t)buffer[3];
}

char *CScriptCompiler::EmitInstruction(uint8_t nOpCode, uint8_t nAuxCode, int32_t nDataSize)
{
	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_OPCODE_LOCATION] = nOpCode;
	m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_AUXCODE_LOCATION] = nAuxCode;

	char *ret = &m_pchOutputCode[m_nOutputCodeLength + CVIRTUALMACHINE_EXTRA_DATA_LOCATION];

	m_nOutputCodeLength += CVIRTUALMACHINE_OPERATION_BASE_SIZE + nDataSize;
	m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);

	return ret;
}

void CScriptCompiler::EmitModifyStackPointer(int32_t nModifyBy)
{
	if (m_nOptimizationFlags & CSCRIPTCOMPILER_OPTIMIZE_MELD_INSTRUCTIONS)
	{
		char *last = InstructionLookback(1);

		// Temporarily disabled. Compiler is generating dead MOVSP instructions
		// in some cases when returning from a function, and merging a live one
		// with a dead one causes issues, unsurprisingly.
#if 0
		// Multiple MODIFY_STACK_POINTER instructions can always be merged into a single one
		if (last[CVIRTUALMACHINE_OPCODE_LOCATION] == CVIRTUALMACHINE_OPCODE_MODIFY_STACK_POINTER)
		{
			int32_t mod = ReadByteSwap32(&last[CVIRTUALMACHINE_EXTRA_DATA_LOCATION]);
			mod += nModifyBy;
			WriteByteSwap32(&last[CVIRTUALMACHINE_EXTRA_DATA_LOCATION], mod);
			return;
		}
#endif
		// The nwscript construct `int n = 3;` gets compiled into the following:
		//     RUNSTACK_ADD, TYPE_INTEGER
		//     CONSTANT, TYPE_INTEGER, 3
		//     ASSIGNMENT, TYPE_VOID, -8, 4
		//     MODIFY_STACK_POINTER, -4
		// This ends up with just the CONSTI 3 on the top of stack, but the
		// dance is necessary as `n = 3` is also an expression which returns 3.
		// Then, the last MODSP discards the result of the expression.
		// Here, we detect the pattern when it is discarded, and replace the
		// whole set of instructions with just CONSTI 3
		if (last[CVIRTUALMACHINE_OPCODE_LOCATION] == CVIRTUALMACHINE_OPCODE_ASSIGNMENT)
		{
			char *instConstant    = InstructionLookback(2);
			char *instRunstackAdd = InstructionLookback(3);

			if (instConstant    && instConstant[CVIRTUALMACHINE_OPCODE_LOCATION]    == CVIRTUALMACHINE_OPCODE_CONSTANT &&
			    instRunstackAdd && instRunstackAdd[CVIRTUALMACHINE_OPCODE_LOCATION] == CVIRTUALMACHINE_OPCODE_RUNSTACK_ADD &&
			    instConstant[CVIRTUALMACHINE_AUXCODE_LOCATION] == instRunstackAdd[CVIRTUALMACHINE_AUXCODE_LOCATION] &&
			    ReadByteSwap32(&last[CVIRTUALMACHINE_EXTRA_DATA_LOCATION]) == -8
			   )
			{
				// Move the CONST instruction up to where runstack add is..
				const int32_t instConstantSize = (last - instConstant);
				memmove(instRunstackAdd, instConstant, instConstantSize);
				// Roll back output code length to where the old instConstant started..
				m_nOutputCodeLength = (instRunstackAdd - m_pchOutputCode) + instConstantSize;
				// Pop the last two instruction boundaries (CONSTANT, ASSIGNMENT) since those don't exist anymore
				m_aOutputCodeInstructionBoundaries.pop_back();
				m_aOutputCodeInstructionBoundaries.pop_back();
				m_aOutputCodeInstructionBoundaries.pop_back();
				m_aOutputCodeInstructionBoundaries.push_back(m_nOutputCodeLength);
				return;
			}
		}
	}

	char *buf = EmitInstruction(CVIRTUALMACHINE_OPCODE_MODIFY_STACK_POINTER, 0, 4);
	WriteByteSwap32(buf, nModifyBy);
}
