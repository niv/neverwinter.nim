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
//::  ScriptCompIdentSpec.cpp
//::
//::  Implementation of parsing the identifier specification file.
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
//  CScriptCompiler::GenerateIdentifierList()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/24/99
//  Description:  Takes the output from the lexical analysis to generate a
//                list of indentifiers.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GenerateIdentifierList()
{

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9 ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_TYPE_DECLARATION;
			m_nIdentifierListReturnType = m_nTokenStatus;
			return 0;
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST)
		{
			// Use the keywords to add the parameter into the list.

			int32_t nValue = m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nParameters;

			if (nValue == m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nParameterSpace)
			{
				int nReturnValue = m_pcIdentifierList[m_nOccupiedIdentifiers-1].ExpandParameterSpace();
				if (nReturnValue < 0)
				{
					return nReturnValue;
				}
			}

			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_pchParameters[nValue] = (char) m_nTokenStatus;

			if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_pchParameters[nValue] = (char) CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
				m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_psStructureParameterNames[nValue] = "vector";
			}

			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_pbOptionalParameters[nValue] = FALSE;
			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nParameters = nValue+1;
			return 0;
		}
		else
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFINE)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_DEFINE_STATEMENT;
			return 0;
		}
		else
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_NUM_STRUCTURES_DEFINITION)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_DEFINE_STATEMENT)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_DEFINE_NUM_ENGINE_STRUCTURE;
			return 0;
		}
		else
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_DEFINE_STATEMENT)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_DEFINE_SINGLE_ENGINE_STRUCTURE;
			m_nIdentifierListEngineStructure = (int32_t) (m_pchToken[17] - '0');

			if (m_nIdentifierListEngineStructure < 0 || m_nIdentifierListEngineStructure >= 10)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
				return nError;
			}
			return 0;
		}
		else
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_FUNCTION_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER;
			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nIdentifierType = 0;
			return 0;
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT;
			return 0;
		}
		else
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
	{

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_DEFINE_SINGLE_ENGINE_STRUCTURE)
		{
			m_pbEngineDefinedStructureValid[m_nIdentifierListEngineStructure] = TRUE;
			m_pchToken[m_nTokenCharacters] = 0;
			(m_psEngineDefinedStructureName[m_nIdentifierListEngineStructure]).Format("%s",(char *) m_pchToken);

			HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE, m_nIdentifierListEngineStructure);

			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE;
			return 0;
		}

		// There are many identifiers in the list, the only one we
		// want to deal with is the name of the function.  The names
		// of the parameters are irrelevant (hence, the transfer from
		// state 1 to state 2.

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_TYPE_DECLARATION)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_FUNCTION_IDENTIFIER;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierType = 1;

			if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE1_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE2_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE3_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE4_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE5_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE6_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE7_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE8_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER;
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER;
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStructureReturnName = "vector";
			}
			else if (m_nIdentifierListReturnType == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER;
			}
			else
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
				return nError;
			}

			// Copy the token name, MINUS the return type, into the code.
			m_pchToken[m_nTokenCharacters] = 0;
			(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier).Format("%s",(char *) m_pchToken);
			(m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierHash) = HashString(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier);
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierLength = m_nTokenCharacters;

			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceStart = -1;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinarySourceFinish = -1;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationStart = -1;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nBinaryDestinationFinish = -1;
			HashManagerAdd(CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER, m_nOccupiedIdentifiers);

			m_nOccupiedIdentifiers++;
			if (m_nOccupiedIdentifiers >= CSCRIPTCOMPILER_MAX_IDENTIFIERS)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_IDENTIFIER_LIST_FULL;
				return nError;
			}

			return 0;
		}
		else if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST)
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST)
		{
			return 0;
		}

		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
		return nError;

	}

	// This one is tough.  Bail at the end of the file.

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_EOF)
	{
		return 0;
	}

	// This one is *really* tough.  We should signify that we should take
	// the negative of the constant when we deal with the next token.

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MINUS)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nIntegerData = -1;
		}
		// We also store the data here if we are in a parameter list.
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			m_pcIdentifierList[m_nOccupiedIdentifiers-1].m_nIntegerData = -1;
		}
		return 0;
	}

	int32_t nCount;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_DEFINE_NUM_ENGINE_STRUCTURE)
		{
			// Fetch the value.
			int nValue = 0;
			for (nCount = 0; nCount < m_nTokenCharacters; nCount++)
			{
				nValue = nValue * 10 + (m_pchToken[nCount] - '0');
			}

			if (nValue >= 10)
			{
				nValue = 10;
			}

			if (nValue < 0)
			{
				nValue = 1;
			}

			m_nNumEngineDefinedStructures = nValue;

			if (m_pbEngineDefinedStructureValid)
			{
				delete[] m_pbEngineDefinedStructureValid;
			}

			m_pbEngineDefinedStructureValid = new BOOL[nValue];
			for (int32_t cnt = 0; cnt < nValue; cnt++)
			{
				m_pbEngineDefinedStructureValid[cnt] = FALSE;
			}

			if (m_psEngineDefinedStructureName)
			{
				delete[] m_psEngineDefinedStructureName;
			}
			m_psEngineDefinedStructureName = new CExoString[nValue];

			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE;
			return 0;

		}

		if (m_bCompileIdentifierConstants == FALSE &&
		        m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			return 0;
		}

		int nLoc = m_nOccupiedIdentifiers - 1;

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER;

			if(m_pcIdentifierList[nLoc].m_nReturnType!=CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER ||
			        m_pcIdentifierList[nLoc].m_nIdentifierType != 0)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_INTEGER_ID_FOR_INTEGER_CONSTANT;
				return nError;
			}
		}
		else if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		int nSign = 1;
		if (m_pcIdentifierList[nLoc].m_nIntegerData == -1)
		{
			m_pcIdentifierList[nLoc].m_nIntegerData = 0;
			nSign = -1;
		}

		int nValue = 0;

		// MGB - June 3, 2002
		// Most of the time, the minus sign has already been removed
		// from the integer constant.  However, if we specify a negative
		// constant and THEN use it as a default parameter, it can sneak
		// into this function via the back door.  This is the ultimate
		// final trap for it.
		nCount = 0;
		if (m_pchToken[nCount] == '-')
		{
			nSign *= -1;
			++nCount;
		}

		for (; nCount < m_nTokenCharacters; nCount++)
		{
			nValue = nValue * 10 + (m_pchToken[nCount] - '0');
		}

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER)
		{
			m_pcIdentifierList[nLoc].m_nIntegerData = nSign * nValue;
			m_pchToken[m_nTokenCharacters] = 0;

			// MGB - September 14, 2001 - Negative constants will have to be stored
			// into the string.
			if (nSign == -1)
			{
				(m_pcIdentifierList[nLoc].m_psStringData).Format("-%s",m_pchToken);
			}
			else
			{
				(m_pcIdentifierList[nLoc].m_psStringData).Format("%s",m_pchToken);
			}
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
			int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
			m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
			m_pcIdentifierList[nLoc].m_pnOptionalParameterIntegerData[nLoc2] = nSign * nValue;
		}

		return 0;
	}
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
	{
		if (m_bCompileIdentifierConstants == FALSE && m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			return 0;
		}

		int nLoc = m_nOccupiedIdentifiers - 1;

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER;
			if(m_pcIdentifierList[nLoc].m_nReturnType != CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER ||
			        m_pcIdentifierList[nLoc].m_nIdentifierType != 0)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_FLOAT_ID_FOR_FLOAT_CONSTANT;
				return nError;
			}
		}
		else if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER &&
		         m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_CONSTANT &&
		         m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		float fSign = 1.0f;
		if (m_pcIdentifierList[nLoc].m_nIntegerData == -1)
		{
			m_pcIdentifierList[nLoc].m_nIntegerData = 0;
			fSign = -1.0f;
		}

		float fValue = ParseFloatFromTokenString();

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER)
		{
			m_pcIdentifierList[nLoc].m_fFloatData = fSign * fValue;
			m_pchToken[m_nTokenCharacters] = 0;

			// MGB - September 14, 2001 - Negative constants will have to be stored
			// into the string.
			if (fSign < 0.0f)
			{
				(m_pcIdentifierList[nLoc].m_psStringData).Format("-%s",m_pchToken);
			}
			else
			{
				(m_pcIdentifierList[nLoc].m_psStringData).Format("%s",m_pchToken);
			}
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
			int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
			m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
			m_pcIdentifierList[nLoc].m_pfOptionalParameterFloatData[nLoc2] = fSign * fValue;
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_CONSTANT)
		{
			m_pcIdentifierList[nLoc].m_fVectorData[m_nIdentifierListVector] = fSign * fValue;
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER)
		{
			int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
			m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
			m_pcIdentifierList[nLoc].m_pfOptionalParameterVectorData[nLoc2 * 3 + m_nIdentifierListVector] = fSign * fValue;
		}

		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
	{
		if (m_bCompileIdentifierConstants == FALSE && m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			return 0;
		}

		int nLoc = m_nOccupiedIdentifiers - 1;

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER;

			if(m_pcIdentifierList[nLoc].m_nReturnType != CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER ||
			        m_pcIdentifierList[nLoc].m_nIdentifierType != 0)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_STRING_ID_FOR_STRING_CONSTANT;
				return nError;
			}
		}
		else if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER)
		{
			m_pchToken[m_nTokenCharacters] = 0;
			(m_pcIdentifierList[nLoc].m_psStringData).Format("%s",m_pchToken);
		}
		else if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
			int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
			m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
			m_pchToken[m_nTokenCharacters] = 0;
			(m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2]).Format("%s",m_pchToken);
		}
		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_SELF)
	{
		if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
		int32_t nLoc = m_nOccupiedIdentifiers - 1;
		int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
		m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
		m_pcIdentifierList[nLoc].m_poidOptionalParameterObjectData[nLoc2] = (OBJECT_ID) 0;
		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_INVALID)
	{
		if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
		int32_t nLoc = m_nOccupiedIdentifiers - 1;
		int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
		m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
		m_pcIdentifierList[nLoc].m_poidOptionalParameterObjectData[nLoc2] = (OBJECT_ID) 1;
		return 0;
	}
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_LOCATION_INVALID)
	{
		if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
		int32_t nLoc = m_nOccupiedIdentifiers - 1;
		int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
		m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
        // LOCATION_INVALID is reusing the integer data field
        m_pcIdentifierList[nLoc].m_pnOptionalParameterIntegerData[nLoc2] = 0;
		return 0;
	}

    if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL   ||
        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE  ||
        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE   ||
        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT ||
        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY  ||
        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING)
    {
        if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
		int32_t nLoc = m_nOccupiedIdentifiers - 1;
		int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
		m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;

        if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "null";
        else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "false";
        else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "true";
        else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "{}";
        else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "[]";
        else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING)
            m_pcIdentifierList[nLoc].m_psOptionalParameterStringData[nLoc2] = "\"\"";
        else
            EXOASSERTNCSTR("missing impl");

		return 0;
    }

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_SQUARE_BRACKET)
	{
		if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT &&
		        m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}
		m_nIdentifierListVector = 0;
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_CONSTANT;
		}
		else
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER;
		}

		int32_t nLoc = m_nOccupiedIdentifiers - 1;
		int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;
		m_pcIdentifierList[nLoc].m_pbOptionalParameters[nLoc2] = TRUE;
		for (int32_t nLoc3 = 0; nLoc3 < 3; nLoc3++)
		{
			m_pcIdentifierList[nLoc].m_pfOptionalParameterVectorData[nLoc2 * 3 + nLoc3] = (float) 0.0f;
		}
		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET)
	{
		if (m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER &&
		        m_nIdentifierListState != CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_CONSTANT)
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;
			return nError;
		}

		m_nIdentifierListVector = 0;
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
		}
		else
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER;
		}

		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
	{
		// Semicolon resets the state of the identifier list parsing.
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST)
		{
			int32_t nLoc = m_nOccupiedIdentifiers - 1;
			int32_t nLoc2 = m_pcIdentifierList[nLoc].m_nParameters - 1;

			m_pcIdentifierList[nLoc].m_nIdIdentifier = m_nPredefinedIdentifierOrder;
			++m_nPredefinedIdentifierOrder;
			m_pcIdentifierList[nLoc].m_bImplementationInPlace = TRUE;


			// Find the last non-optional parameter so that we know the size of the list
			// of non-optional parameters!
			m_pcIdentifierList[nLoc].m_nNonOptionalParameters = 0;
			for (int32_t cnt = nLoc2; cnt >= 0 && m_pcIdentifierList[nLoc].m_nNonOptionalParameters == 0; cnt--)
			{
				if (m_pcIdentifierList[nLoc].m_pbOptionalParameters[cnt] == FALSE)
				{
					m_pcIdentifierList[nLoc].m_nNonOptionalParameters = cnt+1;
				}
			}

		}
		++m_nMaxPredefinedIdentifierId;

		m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE;
		return 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
	{
		if (m_nIdentifierListState == CSCRIPTCOMPILER_IDENT_STATE_AFTER_FUNCTION_IDENTIFIER)
		{
			m_nIdentifierListState = CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST;
			return 0;
		}
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
	{
		return 0;
	}

	return STRREF_CSCRIPTCOMPILER_ERROR_PARSING_IDENTIFIER_LIST;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PrintParseIdentifierFileError()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/24/99
//  Description:  This routine will parse the identifier file.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::PrintParseIdentifierFileError(int32_t nParsingError)
{
	CExoString strRes = m_cAPI.TlkResolve(-nParsingError);

	CExoString *psFileName = &(m_pcIncludeFileStack[0].m_sCompiledScriptName);
	OutputError(nParsingError,psFileName,m_nLines,strRes);
	m_pcIncludeFileStack[0].m_sSourceScript = "";
	return STRREF_CSCRIPTCOMPILER_ERROR_ALREADY_PRINTED;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseIdentifierFile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/24/99
//  Description:  This routine will parse the identifier file.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseIdentifierFile()
{

	char *pScript;
	uint32_t nScriptLength;
	uint32_t i;
	int32_t ch;
	int32_t chNext;

	int32_t nParseCharacterReturn;

	// Initialize();

	m_nPredefinedIdentifierOrder = 0;

    const char* sTest = m_cAPI.ResManLoadScriptSourceFile(m_sLanguageSource.CStr(), m_nResTypeSource);
	if (!sTest)
	{
		return PrintParseIdentifierFileError(STRREF_CSCRIPTCOMPILER_ERROR_FILE_NOT_FOUND);
	}

    m_pcIncludeFileStack[0].m_sSourceScript = sTest;
    pScript = m_pcIncludeFileStack[0].m_sSourceScript.CStr();
    nScriptLength = m_pcIncludeFileStack[0].m_sSourceScript.GetLength();

	if ( nScriptLength < 1 )
	{
		ch = -1;
	}
	else
	{
		ch = pScript[0];
	}

	if ( nScriptLength < 2 )
	{
		chNext = -1;
	}
	else
	{
		chNext = pScript[1];
	}

	i = 2;

	while (ch != -1)
	{
		nParseCharacterReturn = ParseNextCharacter(ch,chNext, pScript + i, nScriptLength - i);
		if (nParseCharacterReturn < 0)
		{
			m_pcIncludeFileStack[0].m_sSourceScript = "";
			return PrintParseIdentifierFileError(nParseCharacterReturn);
		}

		while (nParseCharacterReturn >= 0)
		{
			// Process the location of the next character.
			if (ch == '\n')
			{
				++m_nLines;
				m_nCharacterOnLine = 1;
			}
			else
			{
				++m_nCharacterOnLine;
			}

			// Fetch the "next" character and update the status
			// of the current character that we are looking at.
			ch = chNext;

			if ( i >= nScriptLength )
			{
				chNext = -1;
			}
			else
			{
				chNext = (unsigned char) pScript[i];
			}

			--nParseCharacterReturn;

			++i;
		}
	}

	nParseCharacterReturn = ParseNextCharacter(-1,-1, nullptr, 0);

	m_pcIncludeFileStack[0].m_sSourceScript = "";

	if (nParseCharacterReturn < 0)
	{
		return PrintParseIdentifierFileError(nParseCharacterReturn);
	}

	return 0;

}
