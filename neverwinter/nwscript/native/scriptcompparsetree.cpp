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
//::  ScriptCompParseTree.cpp
//::
//::  Implementation of conversion from scripting language source to a parse
//::  tree that we can use to generate final code.  Because this includes the
//::  lexical analysis of tokens, the code to parse the identifier file is
//::  also included within this file.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Mark Brockington
//::  Created On: Oct. 8, 2002
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
//  CScriptCompiler::TokenInitialize()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Sets up parsing routine to be ready to accept a new token.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::TokenInitialize()
{
	m_nTokenStatus = 0; // TOKEN_UNKNOWN;
	m_nTokenCharacters = 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PushSRStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Code to place another context on to the Shift-Reduce stack.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::PushSRStack(int32_t nState, int32_t nRule, int32_t nTerm,
                                  CScriptParseTreeNode *pCurrentTree)
{
	if (m_nSRStackStates+1 >= m_nSRStackEntries)
	{
		CScriptCompilerStackEntry *pNewSRStack = new CScriptCompilerStackEntry[m_nSRStackEntries * 2];
		for (int nCount = 0; nCount < m_nSRStackEntries; nCount++)
		{
			pNewSRStack[nCount].nState       = m_pSRStack[nCount].nState;
			pNewSRStack[nCount].nRule        = m_pSRStack[nCount].nRule;
			pNewSRStack[nCount].nTerm        = m_pSRStack[nCount].nTerm;
			pNewSRStack[nCount].pCurrentTree = m_pSRStack[nCount].pCurrentTree;
			pNewSRStack[nCount].pReturnTree  = m_pSRStack[nCount].pReturnTree;
		}
		m_nSRStackEntries *= 2;
		delete[] m_pSRStack;
		m_pSRStack = pNewSRStack;
	}

	++m_nSRStackStates;
	m_pSRStack[m_nSRStackStates].nState = nState;
	m_pSRStack[m_nSRStackStates].nRule = nRule;
	m_pSRStack[m_nSRStackStates].nTerm = nTerm;
	m_pSRStack[m_nSRStackStates].pCurrentTree = pCurrentTree;
	m_pSRStack[m_nSRStackStates].pReturnTree = NULL;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PopSRStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Code to remove a context from the Shift-Reduce stack.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::PopSRStack(int32_t *nState, int32_t *nRule, int32_t *nTerm,
                                CScriptParseTreeNode **pCurrentTree,
                                CScriptParseTreeNode **pReturnTree )
{

	if (m_nSRStackStates < 0)
	{
		return FALSE;
	}

	*nState = m_pSRStack[m_nSRStackStates].nState;
	*nRule = m_pSRStack[m_nSRStackStates].nRule;
	*nTerm = m_pSRStack[m_nSRStackStates].nTerm;
	*pCurrentTree = m_pSRStack[m_nSRStackStates].pCurrentTree;
	*pReturnTree = m_pSRStack[m_nSRStackStates].pReturnTree;
	--m_nSRStackStates;

	return TRUE;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ModifySRStackReturnTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Code to hand a compile tree pointer to the next stack pointer
//                level.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::ModifySRStackReturnTree(
    CScriptParseTreeNode *pReturnTree )
{
	if (m_nSRStackStates >= 0)
	{
		m_pSRStack[m_nSRStackStates].pReturnTree = pReturnTree;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GetNewScriptParseTreeNode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 22, 2002
//  Description:  Wrapper to create a ScriptParseTreeNode from the blocks that
//                we have potentially already created
///////////////////////////////////////////////////////////////////////////////
CScriptParseTreeNode *CScriptCompiler::GetNewScriptParseTreeNode()
{
	CScriptParseTreeNode *pParseTreeNode;
	// New Version

	// If we are at the end of the linked list of node blocks, and we don't
	// have any room left in this block (or the block doesn't exist!),
	// we should create a new block to use.
	if (m_nParseTreeNodeBlockEmptyNodes == -1 &&
	        (m_pCurrentParseTreeNodeBlock == NULL || m_pCurrentParseTreeNodeBlock->m_pNextBlock == NULL))
	{
		m_pCurrentParseTreeNodeBlock = new CScriptParseTreeNodeBlock;
		m_nParseTreeNodeBlockEmptyNodes = CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE - 1;

		// Chain it on to the list of currently allocated blocks.
		if (m_pParseTreeNodeBlockTail == NULL)
		{
			m_pParseTreeNodeBlockHead = m_pCurrentParseTreeNodeBlock;
			m_pParseTreeNodeBlockTail = m_pCurrentParseTreeNodeBlock;
		}
		else
		{
			m_pParseTreeNodeBlockTail->m_pNextBlock = m_pCurrentParseTreeNodeBlock;
			m_pParseTreeNodeBlockTail = m_pCurrentParseTreeNodeBlock;
		}
	}

	// We are guaranteed that we have a block that exists with nodes in it
	// or we have a block that is full that has a connected block that has
	// nodes in it!

	if (m_nParseTreeNodeBlockEmptyNodes >= 0)
	{
		// This block has spots in it ... so we do nothing but let it
		// fall through and use the blank spot!
	}
	else
	{
		// So our current block doesn't have spots; that's fine ... the next
		// one is guaranteed to have spots in it!
		m_pCurrentParseTreeNodeBlock = m_pCurrentParseTreeNodeBlock->m_pNextBlock;
		m_pCurrentParseTreeNodeBlock->CleanBlockEntries();
		m_nParseTreeNodeBlockEmptyNodes = CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE - 1;
	}

	// ... and finally, return the connected node!
	pParseTreeNode = &(m_pCurrentParseTreeNodeBlock->m_pNodes[m_nParseTreeNodeBlockEmptyNodes]);
	--m_nParseTreeNodeBlockEmptyNodes;

	return pParseTreeNode;

	// Old Version
	//return new CScriptParseTreeNode();
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::DeleteScriptParseTreeNode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: Nov. 22, 2002
//  Description:  Wrapper to "deallocate" a CScriptParseTreeNode.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::DeleteScriptParseTreeNode(CScriptParseTreeNode *pParseTreeNode)
{
	// MGB - March 21, 2003 - Big bug in the handling of compiled scripts.
	pParseTreeNode->Clean();
	// MGB - March 21, 2003 - End Change.

	// DO NOT DEALLOCATE MEMORY, FOR THE LOVE OF PETE.  Let the blocks
	// delete themselves.
	pParseTreeNode = NULL;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CreateScriptParseTreeNode()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/18/2001
//  Description:  Wrapper to create a ScriptParseTreeNode quickly without
//                having to change the code in a hundred places.
///////////////////////////////////////////////////////////////////////////////

CScriptParseTreeNode *CScriptCompiler::CreateScriptParseTreeNode(
    int32_t nNodeOperation,
    CScriptParseTreeNode *pNodeLeft,
    CScriptParseTreeNode *pNodeRight)
{
	CScriptParseTreeNode *pNewNode = GetNewScriptParseTreeNode();
	pNewNode->nOperation = nNodeOperation;
	pNewNode->pLeft = pNodeLeft;
	pNewNode->pRight = pNodeRight;
	pNewNode->nLine = m_nLines;
	pNewNode->nChar = m_nCharacterOnLine;

	if (m_nCompileFileLevel >= 1)
	{
		if (m_nNextParseTreeFileName != 0)
		{
			// Check the current entry.
			if (m_nCurrentParseTreeFileName >= 0 &&
			        m_nCurrentParseTreeFileName < m_nNextParseTreeFileName)
			{
				if (*(m_ppsParseTreeFileNames[m_nCurrentParseTreeFileName]) == m_pcIncludeFileStack[m_nCompileFileLevel-1].m_sCompiledScriptName)
				{
					pNewNode->m_nFileReference = m_nCurrentParseTreeFileName;
					return pNewNode;
				}
			}

			// It's not the current entry, search through all defined values.
			int32_t nCount;
			for (nCount = 0; nCount < m_nNextParseTreeFileName; nCount++)
			{
				if (m_ppsParseTreeFileNames[nCount]->CompareNoCase(m_pcIncludeFileStack[m_nCompileFileLevel-1].m_sCompiledScriptName) == TRUE)
				{
					m_nCurrentParseTreeFileName = nCount;
					pNewNode->m_nFileReference = nCount;
					return pNewNode;
				}
			}
		}

		// Can't find it in the currently defined values ... make a new one.
		int32_t nNewEntry = m_nNextParseTreeFileName;
		//(m_nNextParseTreeFileName is 0 ... add the first entry.
		pNewNode->m_nFileReference = nNewEntry;
		m_ppsParseTreeFileNames[nNewEntry] = new CExoString(m_pcIncludeFileStack[m_nCompileFileLevel-1].m_sCompiledScriptName.CStr());
		++m_nNextParseTreeFileName;
		m_nCurrentParseTreeFileName = nNewEntry;
	}

	return pNewNode;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::DuplicateScriptParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/20/2001
//  Description:  Duplicates a parse tree.for use in an assignment.
///////////////////////////////////////////////////////////////////////////////

CScriptParseTreeNode *CScriptCompiler::DuplicateScriptParseTree(CScriptParseTreeNode *pNode)
{
	if (pNode == NULL)
	{
		return NULL;
	}

	CScriptParseTreeNode *pNewNode = GetNewScriptParseTreeNode();

	pNewNode->nOperation     = pNode->nOperation;
	pNewNode->nIntegerData   = pNode->nIntegerData;
	pNewNode->nIntegerData2  = pNode->nIntegerData2;
	pNewNode->fFloatData     = pNode->fFloatData;
	pNewNode->fVectorData[0] = pNode->fVectorData[0];
	pNewNode->fVectorData[1] = pNode->fVectorData[1];
	pNewNode->fVectorData[2] = pNode->fVectorData[2];
	pNewNode->nLine          = pNode->nLine;
	pNewNode->nChar          = pNode->nChar;
	pNewNode->nType          = pNode->nType;
	pNewNode->m_nStackPointer= pNode->m_nStackPointer;
	pNewNode->m_nFileReference = pNode->m_nFileReference;

	if (pNode->m_psStringData != NULL)
	{
		pNewNode->m_psStringData = new CExoString(pNode->m_psStringData->CStr());
	}


	if (pNode->m_psTypeName != NULL)
	{
		pNewNode->m_psTypeName   = new CExoString(pNode->m_psTypeName->CStr());
	}

	pNewNode->pLeft  = DuplicateScriptParseTree(pNode->pLeft);
	pNewNode->pRight = DuplicateScriptParseTree(pNode->pRight);

	return pNewNode;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CheckForBadLValue()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/20/2001
//  Description:  Checks a branch of a tree to determine if this is a
//                suitable LValue for an assignment statement.
///////////////////////////////////////////////////////////////////////////////

BOOL CScriptCompiler::CheckForBadLValue(CScriptParseTreeNode *pNode)
{
	BOOL bBadLValue = TRUE;
	if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
	{
		bBadLValue = FALSE;
	}
	else if (pNode->nOperation == CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART)
	{
		CScriptParseTreeNode *pTraceBranch = pNode->pLeft;
		while (pTraceBranch != NULL && bBadLValue == TRUE)
		{
			if (pTraceBranch->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
			{
				bBadLValue = FALSE;
			}
			pTraceBranch = pTraceBranch->pLeft;
		}
	}

	return bBadLValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::GenerateParseTree()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  The main guts of the first pass of the parsing routine.
//                This routine takes a token and determines how it should be
//                connected to the rest of the tree.  This is all done based
//                on the 32 case grammar that was determined earlier.  Each
//                part of the 32-case grammar is listed beside the case
//                statement, and this will hopefully make the system as clear
//                as mud.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::GenerateParseTree()
{
	int32_t nTopStackState;
	int32_t nTopStackRule;
	int32_t nTopStackTerm;
	CScriptParseTreeNode *pTopStackCurrentNode;
	CScriptParseTreeNode *pTopStackReturnNode;

	BOOL bAlwaysTrue = TRUE;

	while (bAlwaysTrue)
	{
		// Remove the topmost state from the stack.
		if (PopSRStack(&nTopStackState, &nTopStackRule,
		               &nTopStackTerm, &pTopStackCurrentNode,
		               &pTopStackReturnNode) == FALSE)
		{
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_FATAL_COMPILER_ERROR;
			return nError;
		}


		// Now, the giant case statement.  Based on the State, Rule, Term and Token,
		// we either create some new nodes, link the existing nodes to the new nodes,
		// push some states on to the stack, install a "return" tree on to the stack
		// et cetera.

		switch (nTopStackState)
		{

			///////////////////////////////////////////////////////////////////////////////
			// case 35:
			// constant:
			// (1) integer-constant
			// (2) string-constant
			// (3) floating-point-constant
			// (4) OBJECT_SELF
			// (5) OBJECT_INVALID
			// (6) [ {{{float_opt} , float_opt} , float_opt} ]  (for declaring a vector).
            // (7) JSON_* for declaring json default ctor constants.
			///////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_CONSTANT:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				int32_t nCount;

				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_SQUARE_BRACKET)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_VECTOR,NULL,NULL);
					pNewNode->fVectorData[0] = 0.0f;
					pNewNode->fVectorData[1] = 0.0f;
					pNewNode->fVectorData[2] = 0.0f;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,2,pNewNode);
					return 0;
				}
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER,NULL,NULL);
					pNewNode->nIntegerData = 0;
					int32_t nSign = 1;
					for (nCount = 0; nCount < m_nTokenCharacters; nCount++)
					{
						// Account for a negative constant from the language definition file.
						if (m_pchToken[nCount] == '-' && nCount == 0)
						{
							nSign = -1;
						}
						else
						{
							pNewNode->nIntegerData *= 10;
							pNewNode->nIntegerData += (m_pchToken[nCount] - '0');
						}
					}
					// Apply the negative of the integer, if required.
					if (nSign == -1)
					{
						pNewNode->nIntegerData *= nSign;
					}
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_HEX_INTEGER)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->nIntegerData = 0;
					for (nCount = 2; nCount < m_nTokenCharacters; nCount++)
					{
						if (m_pchToken[nCount] >= '0' &&
						        m_pchToken[nCount] <= '9')
						{
							pNewNode->nIntegerData *= 16;
							pNewNode->nIntegerData += (m_pchToken[nCount] - '0');
						}
						else
						{
							pNewNode->nIntegerData *= 16;
							pNewNode->nIntegerData += 10 + (m_pchToken[nCount] - 'a');
						}
					}
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT,NULL,NULL);
					pNewNode->fFloatData = ParseFloatFromTokenString();

					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->m_psStringData = new CExoString(m_pchToken);
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_SELF)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_OBJECT,NULL,NULL);
					// ??? m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->nIntegerData = 0;
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_INVALID)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_OBJECT,NULL,NULL);
					// ??? m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->nIntegerData = 1;
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_LOCATION_INVALID)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_LOCATION,NULL,NULL);
					// ??? m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->nIntegerData = 0;
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL   ||
                         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE  ||
                         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE   ||
                         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT ||
                         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY  ||
                         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING)
                {
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_JSON,NULL,NULL);

                    if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL)
                        pNewNode->m_psStringData = new CExoString("null");
                    else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE)
                        pNewNode->m_psStringData = new CExoString("false");
                    else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE)
                        pNewNode->m_psStringData = new CExoString("true");
                    else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT)
                        pNewNode->m_psStringData = new CExoString("{}");
                    else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY)
                        pNewNode->m_psStringData = new CExoString("[]");
                    else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING)
                        pNewNode->m_psStringData = new CExoString("\"\"");
                    else
                        EXOASSERTNCSTR("missing impl");

					ModifySRStackReturnTree(pNewNode);
					return 0;
                }
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
				{
					pTopStackCurrentNode->fVectorData[0] = ParseFloatFromTokenString();
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,3,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,4,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
				{
					pTopStackCurrentNode->fVectorData[1] = ParseFloatFromTokenString();
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,5,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 5)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,6,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 6)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
				{
					pTopStackCurrentNode->fVectorData[2] = ParseFloatFromTokenString();
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,6,7,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}
			if (nTopStackRule == 6 && nTopStackTerm == 7)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_CONSTANT_VECTOR;
					return nError;
				}
			}

			break;

			//////////////////////////////////////////////////////////
			// case 34:
			// primary-expression:
			// (1) non-void-identifier ( argument-expression-list )
			// (2) constant
			// (3) ( expression )
			// (4) variable
			// (5) void-identifier ( argument-expression-list )
			//     treated as an action argument ONLY!
			/////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_HEX_INTEGER ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_SELF ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_INVALID ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_LOCATION_INVALID ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY ||
                        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_SQUARE_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,2,1,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONSTANT,0,0,NULL);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode2->m_psStringData = new CExoString(m_pchToken);
					ModifySRStackReturnTree(pNewNode2);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,3,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER ||
				         (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER &&
				          m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER))
				{
					// Do somethin' with the identifier.

					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION_ID,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode2->m_psStringData = new CExoString(m_pchToken);
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION,NULL,pNewNode2);

					if ( m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER )
					{
						CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION_PARAMETER,pNewNode,NULL);
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,5,2,pNewNode3);
					}
					else
					{
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,1,2,pNewNode);
					}
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,1,3,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft = pTopStackReturnNode;
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 5 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,5,3,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 5 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft->pLeft = pTopStackReturnNode;
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 1)
			{
				ModifySRStackReturnTree(pTopStackReturnNode);
			}
			if (nTopStackRule == 3 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					ModifySRStackReturnTree(pTopStackReturnNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}
			break;

			///////////////////////////////////////////
			// case 33:
			// post-expression:
			// (1) primary-expression
			// (2) primary-expression . variable
			// (3) primary_expression ++
			// (4) primary_expression --
			//////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,1,2,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 2) ||
			        (nTopStackTerm == 4))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRUCTURE_PART_SPECIFY)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART,NULL,NULL);
					if (nTopStackTerm == 4)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}
					else if (pTopStackCurrentNode != NULL && pTopStackReturnNode == NULL)
					{
						// This came in when we realized there was a structure part in
						// the variable specified in an assignment statement.  For the
						// love of god, this is getting complicated.
						pNewNode->pLeft = pTopStackCurrentNode;
					}
					else
					{
						// The standard method of receiving a structure part ... from
						// a FREAKIN' return node.  (Is that *SO* wrong?)
						pNewNode->pLeft = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,2,4,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,2,3,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INCREMENT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_POST_INCREMENT,NULL,NULL);
					if (nTopStackTerm == 4)
					{
						// Adding a post increment to a structure part.
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}
					else
					{
						// Adding a post increment to a standalone variable.
						pNewNode->pLeft = pTopStackReturnNode;
					}
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_DECREMENT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_POST_DECREMENT,NULL,NULL);
					if (nTopStackTerm == 4)
					{
						// Adding a post increment to a structure part.
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}
					else
					{
						// Adding a post increment to a standalone variable.
						pNewNode->pLeft = pTopStackReturnNode;
					}
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else
				{
					// It's not one of our magic three operators?
					// Well, then!  That doesn't bode well.  We have
					// to report what we've constructed up the stack.

					if (nTopStackTerm == 4)
					{
						// We are processing a structure part.
						// We have a variable hanging around in pTopStackReturnNode.
						// This should be reattached.
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						// This is just a standard primary-expression, so
						// let's just send it up the stack.
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 3)
			{
				CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE,NULL,NULL);
				m_pchToken[m_nTokenCharacters] = 0;
				pNewNode2->m_psStringData = new CExoString(m_pchToken);
				ModifySRStackReturnTree(pNewNode2);
				return 0;
			}

			break;

			////////////////////////////////////
			// case 32:
			// unary-expression:
			// (1) - post-expression
			// (2) ~ post-expression
			// (3) ! post-expression
			// (4) ++ post-expression
			// (5) -- post_expression
			// (6) post-expression
			////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MINUS)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_NEGATION,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,1,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_TILDE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ONES_COMPLEMENT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,2,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_BOOLEAN_NOT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_BOOLEAN_NOT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,3,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INCREMENT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,4,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_DECREMENT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_PRE_DECREMENT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,5,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,6,1,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION,0,0,NULL);
				}
			}
			if ((nTopStackRule >= 1 && nTopStackRule <= 5) && nTopStackTerm == 1)
			{
				pTopStackCurrentNode->pLeft = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			if (nTopStackRule == 6 && nTopStackTerm == 1)
			{
				ModifySRStackReturnTree(pTopStackReturnNode);
			}
			break;

			//////////////////////////////////////////////////////
			// case 31:
			// multiplicative-expression
			// (1) unary-expression
			// (2) multiplicative-expression * unary-expression
			// (3) multiplicative-expression / unary-expression
			// (4) multiplicative-expression % unary-expression
			//////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MULTIPLY)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_MULTIPLY,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_DIVIDE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_DIVIDE,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,3,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MODULUS)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_MODULUS,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,4,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			//////////////////////////////////////////////////////////
			// case 30:
			// additive-expression
			// (1) multiplicative-expression
			// (2) additive-expression + multiplicative-expression
			// (3) additive-expression - multiplicative-expression
			//////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_PLUS)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ADD,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MINUS)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SUBTRACT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,3,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			////////////////////////////////////////////////////
			// case 29:
			// shift-expression
			// (1) additive-expression
			// (2) shift-expression >> additive-expression
			// (3) shift-expression << additive-expression
			// (4) shift-expression >>> additive-expression
			////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SHIFT_LEFT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SHIFT_LEFT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SHIFT_RIGHT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SHIFT_RIGHT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,3,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNSIGNED_SHIFT_RIGHT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_UNSIGNED_SHIFT_RIGHT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,4,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			////////////////////////////////////////////////////
			// case 28:
			// relational-expression:
			// (1) shift-expression
			// (2) relational-expression >= shift-expression
			// (3) relational-expression >  shift-expression
			// (4) relational-expression <  shift-expression
			// (5) relational-expression <= shift-expression
			////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_GREATER_EQUAL)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_GEQ,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_LESS_EQUAL)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_LEQ,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,3,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_LESS_THAN)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_LT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,4,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_GREATER_THAN)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_GT,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,5,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			/////////////////////////////////////////////////////////
			// case 27:
			// equality-expression
			// (1) relational-expression
			// (2) equality-expression == relational-expression
			// (3) equality-expression != relational-expression
			/////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_NOT_EQUAL)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_NOT_EQUAL,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COND_EQUAL)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,3,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			////////////////////////////////////////////////////////
			// case 26:
			// boolean-AND-expression
			// (1) equality-expression
			// (2) boolean-AND-expression & equailty-expression
			////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_BOOLEAN_AND)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_BOOLEAN_AND,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			//////////////////////////////////////////////////////////
			// case 25:
			// exclusive-OR-expression
			// (1) boolean-AND-expression
			// (2) exclusive-OR-expression ^ boolean-AND-expression
			//////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_EXCLUSIVE_OR)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_EXCLUSIVE_OR,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			/////////////////////////////////////////////////////////////////////////////
			// case 24:
			// inclusive-OR-expression:
			// (1) exclusive-OR-expression
			// (2) inclusive-OR-expression | exclusive-OR-expression
			/////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INCLUSIVE_OR)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_INCLUSIVE_OR,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			///////////////////////////////////////////////////////////////
			// case 23:
			// logical-AND-expression:
			// (1) inclusive-OR-expression
			// (2) logical-AND-expression && inclusive-OR-expression
			///////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LOGICAL_AND)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_LOGICAL_AND,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			//////////////////////////////////////////////////////////////////////////////////
			// case 22:
			// logical-OR-expression:
			// (1) logical-AND-expression
			// (2) logical-OR-expression || logical-AND-expression
			//////////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION,0,0,NULL);
			}
			if ((nTopStackRule == 1 && nTopStackTerm == 1) ||
			        (nTopStackTerm == 3))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LOGICAL_OR)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_LOGICAL_OR,pTopStackReturnNode,NULL);
					if (nTopStackTerm == 3)
					{
						pNewNode->pLeft = pTopStackCurrentNode;
						pNewNode->pLeft->pRight = pTopStackReturnNode;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION,2,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (nTopStackTerm == 3)
					{
						pTopStackCurrentNode->pRight = pTopStackReturnNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pTopStackReturnNode);
					}
				}
			}
			break;

			//////////////////////////////////////////////////////////////////////////////////
			// case 21:
			// conditional-expression:
			// (1) logical-OR-expression
			// (2) logical-OR-expression ? conditional_expression : conditional_expression
			//////////////////////////////////////////////////////////////////////////////////
		case CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION:
			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_QUESTION_MARK)
				{
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_COND_CONDITION,pTopStackReturnNode,NULL);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_COND_CHOICE,NULL,NULL);
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_COND_BLOCK,pNewNode2,pNewNode3);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,2,3,pNewNode1);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					ModifySRStackReturnTree(pTopStackReturnNode);
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_COLON)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_CONDITIONAL_REQUIRES_SECOND_EXPRESSION;
					return nError;
				}
				pTopStackCurrentNode->pRight->pLeft = pTopStackReturnNode;
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,2,5,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,0,0,NULL);
				return 0;
			}
			if (nTopStackRule == 2 && nTopStackTerm == 5)
			{
				pTopStackCurrentNode->pRight->pRight = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			break;
			/////////////////////////////////////////////////////////////////////
			// case 20:
			// assignment-expression:
			// (1) conditional-expression
			// (2) variable_lvalue = conditional_expression
			// (3) variable_lvalue -= conditional_expression
			// (4) variable_lvalue += conditional_expression
			// (5) variable_lvalue *= conditional_expression
			// (6) variable_lvalue /= conditional_expression
			// (7) variable_lvalue %= conditional_expression
			// (8) variable_lvalue &= conditional_expression
			// (9) variable_lvalue ^= conditional_expression
			// (10) variable_lvalue |= conditional_expression
			// (11) variable_lvalue <<= conditional_expression
			// (12) variable_lvalue >>= conditional_expression
			// (13) variable_lvalue >>>= conditional_expression
			// variable_lvalue is a variable or a structure part of a variable.
			////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				// MGB - Feb 11, 2003 - BEGIN CHANGE
				// To speed up compiling, what's the point in pushing
				// and popping all of this when we know we are on a
				// greased pole directly to the unary expression?
				// It saves about 2 seconds (in debug mode) by losing
				// approximately 20% of all the Push and Pop operations.
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION,0,0,NULL);
				// MGB - Feb 11, 2003 - END CHANGE
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				if (m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MINUS &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_PLUS &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MULTIPLY &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_DIVIDE &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MODULUS &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_AND &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_XOR &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_OR &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_LEFT &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_RIGHT &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_USHIFT_RIGHT)

				{
					ModifySRStackReturnTree(pTopStackReturnNode);
				}
				else
				{
					if (CheckForBadLValue(pTopStackReturnNode) == TRUE)
					{
						int nError = STRREF_CSCRIPTCOMPILER_ERROR_BAD_LVALUE;
						return nError;
					}

					if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL)
					{
						CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ASSIGNMENT,NULL,pTopStackReturnNode);
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION,2,3,pNewNode);
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,0,0,NULL);
					}
					else
					{
						CScriptParseTreeNode *pDupTree = DuplicateScriptParseTree(pTopStackReturnNode);
						int32_t nNewTerm = 0;
						CScriptParseTreeNode *pNewNode2 = NULL;

						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MINUS)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SUBTRACT,pDupTree,NULL);
							nNewTerm = 3;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_PLUS)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ADD,pDupTree,NULL);
							nNewTerm = 4;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MULTIPLY)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_MULTIPLY,pDupTree,NULL);
							nNewTerm = 5;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_DIVIDE)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_DIVIDE,pDupTree,NULL);
							nNewTerm = 6;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MODULUS)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_MODULUS,pDupTree,NULL);
							nNewTerm = 7;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_AND)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_BOOLEAN_AND,pDupTree,NULL);
							nNewTerm = 8;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_XOR)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_EXCLUSIVE_OR,pDupTree,NULL);
							nNewTerm = 9;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_OR)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_INCLUSIVE_OR,pDupTree,NULL);
							nNewTerm = 10;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_LEFT)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SHIFT_LEFT,pDupTree,NULL);
							nNewTerm = 11;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_RIGHT)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SHIFT_RIGHT,pDupTree,NULL);
							nNewTerm = 12;
						}
						if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_USHIFT_RIGHT)
						{
							pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_UNSIGNED_SHIFT_RIGHT,pDupTree,NULL);
							nNewTerm = 13;
						}

						CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ASSIGNMENT,pNewNode2,pTopStackReturnNode);
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION,nNewTerm,3,pNewNode);
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,0,0,NULL);

					}
					return 0;
				}
			}
			if (nTopStackTerm == 3)
			{

				// Mmmm ... creamy goodness.  If we've managed to screw up the assignment because this
				// is a variable, and there's a left bracket right after it ... then we've probably got
				// an undefined identifier and we should do something about it.
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					if (pTopStackReturnNode != NULL)
					{
						if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
						{
							m_sUndefinedIdentifier = *(pTopStackReturnNode->m_psStringData);
							int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
							return nError;
						}
					}
				}

				if (nTopStackRule == 2)
				{
					// For this rule (a plain assignment) attach the operand to the left of the assignment.
					pTopStackCurrentNode->pLeft = pTopStackReturnNode;
				}
				else
				{
					// For other rules, attach the second operand to the operation instead of the assignment.
					pTopStackCurrentNode->pLeft->pRight = pTopStackReturnNode;
				}

				ModifySRStackReturnTree(pTopStackCurrentNode);
			}

			break;

			////////////////////////////////
			// case 19:
			// expression:
			// (1) assignment-expression
			////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				ModifySRStackReturnTree(pTopStackReturnNode);
			}
			break;

			////////////////////////////////////////////////////////////////
			// case 18:
			// non-void-expression:
			// (1) expression, then ensure there is a single-return-value.
			////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				// MGB - October 29, 2002
				// Here, we would check to see if there is a single-return-value
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_NON_VOID_EXPRESSION,pTopStackReturnNode,NULL);
				ModifySRStackReturnTree(pNewNode);
			}
			break;

			/////////////////////////////////////////////////////////////////////////////
			// case 17:
			// boolean-expression:
			// (1) non-void-expression, then Ensure there is a single integer returned.
			/////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,1,1,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION,pTopStackReturnNode,NULL);
				ModifySRStackReturnTree(pNewNode);
			}
			break;

			/////////////////////////////////////////////////////////////////
			// case 16:
			// after-argument-expression:
			// (1) )  // the end of the list ... hand it to previous level.
			// (2) , non-void-expression after-argument-expression
			/////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					ModifySRStackReturnTree(NULL);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION,2,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					if (m_pSRStack[m_nSRStackStates].pCurrentTree != NULL)
					{
						if (m_pSRStack[m_nSRStackStates].pCurrentTree->pRight != NULL)
						{
							if (m_pSRStack[m_nSRStackStates].pCurrentTree->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
							{
								m_sUndefinedIdentifier = *(m_pSRStack[m_nSRStackStates].pCurrentTree->pRight->m_psStringData);
								int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
								return nError;
							}
							if (m_pSRStack[m_nSRStackStates].pCurrentTree->pRight->pLeft != NULL)
							{
								if (m_pSRStack[m_nSRStackStates].pCurrentTree->pRight->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
								{
									m_sUndefinedIdentifier = *(m_pSRStack[m_nSRStackStates].pCurrentTree->pRight->pLeft->m_psStringData);
									int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
									return nError;
								}

							}
						}
					}
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 2)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION_ARG_LIST,NULL,pTopStackReturnNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION,2,3,pNewNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 2 && nTopStackTerm == 3)
			{
				pTopStackCurrentNode->pLeft = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			break;

			///////////////////////////////////////////////////////////////////////////////
			// case 15:
			// argument-expression-list:
			// (1) )  // You see the end of the list ... can pop back to previous level if
			//        // when you've cross-checked the types of the return values, you see
			//        // that everything is kosher.
			// (2) non-void-expression after-argument-expression
			///////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
				else if (m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST,2,1,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,0,0,NULL);
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 1)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION_ARG_LIST,NULL,pTopStackReturnNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST,2,2,pNewNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION,0,0,NULL);
			}
			if (nTopStackRule == 2 && nTopStackTerm == 2)
			{
				pTopStackCurrentNode->pLeft = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			break;

			//////////////////////////////////////////
			// case 14:
			// declaration-variable-list-separator
			// (1) ;
			// (2) , declaration-variable-list
			//////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST_SEPARATOR:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					// Create a new statement that we can link to.
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(0,NULL,NULL);
					if (pTopStackCurrentNode != NULL &&
					        pTopStackCurrentNode->pLeft != NULL &&
					        pTopStackCurrentNode->pLeft->pLeft != NULL)
					{
						pNewNode3->nOperation = pTopStackCurrentNode->pLeft->pLeft->nOperation;
						if (pNewNode3->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
						{
							pNewNode3->m_psStringData = new CExoString(pTopStackCurrentNode->pLeft->pLeft->m_psStringData->CStr());
						}
					}

					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION,pNewNode3,NULL);
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pNewNode2,NULL);

					// Point back to the new statement ...
					if (pTopStackCurrentNode->pRight == NULL)
					{
						// There is no assignment statement added to the list, so we
						// can attach directly to pTopStackCurrentNode->pRight.
						pTopStackCurrentNode->pRight = pNewNode1;
						// Update the line number.
						pTopStackCurrentNode->pRight->nLine = pTopStackCurrentNode->nLine;
					}
					else
					{
						// We've also added an assignment statement to the list, so we
						// have to attach to pTopStackCurrentNode->pRight->pRight instead.
						pTopStackCurrentNode->pRight->pRight = pNewNode1;
						// Update the line number.
						pTopStackCurrentNode->pRight->pRight->nLine = pTopStackCurrentNode->nLine;

					}
					// ... and feed it back to the main routine.
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST,0,0,pNewNode1);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}
			}
			else
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
				return nError;
			}
			break;

			////////////////////////////////////////////////////////////////////////////
			// case 13:
			// declaration-variable-list
			// (1) variable declaration-variable-list-separator
			// (2) variable = non-void-expression declaration-variable-list-separator
			////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode2->m_psStringData = new CExoString(m_pchToken);

					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE_LIST,pNewNode2,NULL);

					if (pTopStackCurrentNode != NULL &&
					        pTopStackCurrentNode->pLeft != NULL)
					{
						pTopStackCurrentNode->pLeft->pRight = pNewNode;
					}
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST,1,2,pTopStackCurrentNode);

					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}
			}
			else if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL)
				{
					CScriptParseTreeNode *pNewNode0 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE,NULL,NULL);
					if (pTopStackCurrentNode != NULL &&
					        pTopStackCurrentNode->pLeft != NULL &&
					        pTopStackCurrentNode->pLeft->pRight != NULL &&
					        pTopStackCurrentNode->pLeft->pRight->pLeft != NULL)
					{
						pNewNode0->m_psStringData = new CExoString(pTopStackCurrentNode->pLeft->pRight->pLeft->m_psStringData->CStr());
					}

					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ASSIGNMENT,NULL,pNewNode0);
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pNewNode1,NULL);
					pTopStackCurrentNode->pRight = pNewNode2;
					pTopStackCurrentNode->pRight->nLine = pTopStackCurrentNode->nLine;

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST,2,2,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST_SEPARATOR,0,0,pTopStackCurrentNode);
				}
			}
			else if (nTopStackRule == 2 && nTopStackTerm == 2)
			{
				pTopStackCurrentNode->pRight->pLeft->pLeft = pTopStackReturnNode;
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST_SEPARATOR,0,0,pTopStackCurrentNode);
			}

			break;

			///////////////////////////////////////////////////////////////////////
			// case 12:
			// non-void-type-specifier:
			// (1) [const] int
			// (2) [const] float
			// (3) [const] string
			// (4) object
			// (5) struct variable
			// (6) one of the ENGINE_STRUCTURE defined variables passed in from
			//     the language definition!
			// (7) vector   -- treated as a structure.
			///////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_CONST)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONST_DECLARATION,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,0,0,pNewNode);
					return 0;
				}

				if (pTopStackCurrentNode != NULL &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_KEYWORD_INT &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT &&
				        m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_INVALID_TYPE_FOR_CONST_KEYWORD;
					return nError;
				}

				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR)
				{
					// Treat "vector" as a "struct vector" token.
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->m_psStringData = new CExoString(m_pchToken);
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,5,1,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
				         (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
				          m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(0,NULL,NULL);
					if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
					{
						pNewNode->nOperation = CSCRIPTCOMPILER_OPERATION_KEYWORD_INT;
					}
					else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
					{
						pNewNode->nOperation = CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT;
					}
					else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
					{
						pNewNode->nOperation = CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING;
					}
					else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
					{
						pNewNode->nOperation = CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT;
					}
					else if (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 && m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9)
					{
						pNewNode->nOperation = CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 + (m_nTokenStatus - CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0);
					}

					if (pTopStackCurrentNode != NULL)
					{
						// We've already checked to see if this is a valid type ... so we only need to
						// put the const declaration operation above this type so that we can interpret
						// it at the right time.
						pTopStackCurrentNode->pLeft = pNewNode;
						ModifySRStackReturnTree(pTopStackCurrentNode);
					}
					else
					{
						ModifySRStackReturnTree(pNewNode);
					}

					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_INVALID_DECLARATION_TYPE;
					return nError;
				}
			}
			if (nTopStackRule == 5 && nTopStackTerm == 1)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					m_pchToken[m_nTokenCharacters] = 0;
					pTopStackCurrentNode->m_psStringData = new CExoString(m_pchToken);
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_INVALID_DECLARATION_TYPE;
					return nError;
				}
			}

			break;

			////////////////////////////////////////////////////////////////////////
			// case 11:
			// any-type-specifier:
			// (1) void
			// (2) non-void-type-specifier
			////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_ANY_TYPE_SPECIFIER:
			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID,NULL,NULL);
					ModifySRStackReturnTree(pNewNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,0,0,NULL);
				}
			}
			break;

			////////////////////////////////////////////////////////////////////////
			// case 10:
			// Within-a-statement:
			// (1) { within-a-compound-statement }
			// (2) void-returning-identifier(argument-expression-list);
			// (3) if (boolean-expression) statement
			// (4) if (boolean-expression) statement else statement
			// (5) switch ( boolean-expression ) statement
			// (6) return non-void-expression(opt) ;
			// (7) while (boolean-expression) statement
			// (8) do statement while (boolean-expression);
			// (9) for (expression_opt; expression_opt; expression_opt) statement
			// (10) non-void-type-specifier declaration-list ;
			// (11) expression(opt) ;
			// (12) default :
			// (13) case conditional_expression :
			// (14) break ;
			// (15) continue ;
			/////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACE)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,1,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_COMPOUND_STATEMENT,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_RETURN)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_RETURN,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,6,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_SWITCH)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,5,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFAULT)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_DEFAULT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,12,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_CASE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CASE,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,13,3,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_BREAK)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_BREAK,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,14,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_CONTINUE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONTINUE,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,15,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER)
				{
					// Do somethin' with the identifier.

					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION_ID,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode2->m_psStringData = new CExoString(m_pchToken);

					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_ACTION,NULL,pNewNode2);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,2,2,pNewNode);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_IF)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,3,2,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ELSE)
				{
					int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_ELSE_WITHOUT_CORRESPONDING_IF;
					return nError;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_WHILE)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,7,2,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_DO)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,8,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FOR)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,2,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_CONST ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR ||
				         (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
				          m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,10,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,0,0,NULL);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,11,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,0,0,NULL);
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT,pTopStackReturnNode,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,1,3,pNewNode);
				}
				else
				{
					int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_END_COMPOUND_STATEMENT;
					return nError;
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_END_COMPOUND_STATEMENT;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,2,3,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,2,4,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_ARG_LIST;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 3 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_IF_CHOICE,NULL,NULL);
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_IF_CONDITION,NULL,NULL);
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_IF_BLOCK,pNewNode2,pNewNode3);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,3,3,pNewNode1);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 3 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,3,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 3 && nTopStackTerm == 5)
			{
				// Link up the "if expression true" statement.
				if (pTopStackReturnNode == NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_IF_CONDITION_CANNOT_BE_FOLLOWED_BY_A_NULL_STATEMENT;
					return nError;
				}

				// MGB - For Script Debugger.
				CScriptParseTreeNode *pNewNode2;

				if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK )
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pTopStackReturnNode,NULL);
				}
				else
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pTopStackReturnNode,NULL);
					pNewNode2->nLine = pTopStackReturnNode->nLine;
				}
				// MGB - !For Script Debugger

				pTopStackCurrentNode->pRight->pLeft = pNewNode2;

				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_ELSE)
				{
					// MGB - For Script Debugger.
					// When we process an else branch, we need a line
					// number for the code!
					pTopStackCurrentNode->pRight->nLine = m_nLines;
					// MGB - !For Script Debugger

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,3,7,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
					return 0;
				}
				else
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
				}
			}
			if (nTopStackRule == 3 && nTopStackTerm == 7)
			{
				if (pTopStackReturnNode == NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_ELSE_CANNOT_BE_FOLLOWED_BY_A_NULL_STATEMENT;
					return nError;
				}

				// Link up the "if expression false" statement.
				CScriptParseTreeNode *pNewNode2;

				if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK)
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pTopStackReturnNode,NULL);
				}
				else
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pTopStackReturnNode,NULL);
					pNewNode2->nLine = pTopStackReturnNode->nLine;
				}

				// MGB - August 10, 2001 - Fixed bug where else expression was actually linking
				// directly to the returned parse tree without linking the operation_statement in place.
				pTopStackCurrentNode->pRight->pRight = pNewNode2;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			if (nTopStackRule == 5 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,5,4,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 5 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_SWITCH_CONDITION,pTopStackReturnNode,NULL);
					pTopStackCurrentNode->pLeft = pNewNode;
					// MGB - February 5, 2003 - Removed pTopStackReturnNode from left branch of this
					// tree node, since it didn't really make a lot of sense.
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,NULL,NULL);
					pTopStackCurrentNode->pRight = pNewNode2;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,5,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 5 && nTopStackTerm == 5)
			{
				if (pTopStackReturnNode == NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_SWITCH_CONDITION_CANNOT_BE_FOLLOWED_BY_A_NULL_STATEMENT;
					return nError;
				}

				pTopStackCurrentNode->pRight->pLeft = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			if (nTopStackRule == 6 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,6,3,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION,0,0,NULL);
				}
			}

			if (nTopStackRule == 6 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					pTopStackCurrentNode->pRight = pTopStackReturnNode;
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_RETURN_STATEMENT;
					return nError;
				}
			}

			if (nTopStackRule == 7 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,7,3,pNewNode1);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 7 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CONDITION,pTopStackReturnNode,NULL);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CHOICE,NULL,NULL);
					pTopStackCurrentNode->pLeft = pNewNode2;
					pTopStackCurrentNode->pRight = pNewNode3;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,7,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
					return 0;
				}
				else
				{
					if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
					{
						if (pTopStackReturnNode != NULL)
						{
							if (pTopStackReturnNode->pLeft != NULL)
							{
								if (pTopStackReturnNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
								{
									m_sUndefinedIdentifier = *(pTopStackReturnNode->pLeft->m_psStringData);
									int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
									return nError;
								}
							}
						}
					}
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 7 && nTopStackTerm == 5)
			{
				// Link up the "if expression true" statement.
				CScriptParseTreeNode *pNewNode4 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CONTINUE,NULL,NULL);
				CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pNewNode4,NULL);

				if (pTopStackReturnNode == NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_WHILE_CONDITION_CANNOT_BE_FOLLOWED_BY_A_NULL_STATEMENT;
					return nError;
				}

				// MGB - For Script Debugger.
				CScriptParseTreeNode *pNewNode2;

				if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK)
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pTopStackReturnNode,pNewNode3);
				}
				else
				{
					pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pTopStackReturnNode,pNewNode3);
					pNewNode2->nLine = pTopStackReturnNode->nLine;
				}
				// MGB - !For Script Debugger

				pTopStackCurrentNode->pRight->pLeft = pNewNode2;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			if (nTopStackRule == 8 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_WHILE)
				{
					//CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pTopStackReturnNode,NULL);
					CScriptParseTreeNode *pNewNode2;

					if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK )
					{
						pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pTopStackReturnNode,NULL);
					}
					else
					{
						pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pTopStackReturnNode,NULL);
						pNewNode2->nLine = pTopStackReturnNode->nLine;
					}
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_DOWHILE_CONDITION,NULL,NULL);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK,pNewNode2,pNewNode1);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,8,3,pNewNode3);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_WHILE_AFTER_DO_KEYWORD;
					return nError;
				}
			}
			if (nTopStackRule == 8 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,8,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 8 && nTopStackTerm == 5)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pRight->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,8,6,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_RIGHT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 8 && nTopStackTerm == 6)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					CScriptParseTreeNode *pNewNode8 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CONTINUE,NULL,NULL);
					CScriptParseTreeNode *pNewNode9 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,NULL,NULL);
					CScriptParseTreeNode *pNewNode1 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,NULL,NULL);
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pNewNode8,pNewNode9);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CHOICE,pNewNode1,pNewNode2);
					CScriptParseTreeNode *pNewNode4 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_CONDITION,NULL,NULL);
					CScriptParseTreeNode *pNewNode5 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK,pNewNode4,pNewNode3);
					CScriptParseTreeNode *pNewNode6 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG,pNewNode5,NULL);
					CScriptParseTreeNode *pNewNode7 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,NULL,pNewNode6);

					CScriptParseTreeNode *pNewNode10 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FOR_BLOCK,pNewNode7,NULL);

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,3,pNewNode10);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_LEFT_BRACKET_ON_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,5,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,4,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,0,0,NULL);
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					// Create a node and stick the expression on to it.
					pTopStackCurrentNode->pLeft->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,5,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 5)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER,NULL,NULL);
					pNewNode->nIntegerData = 1;
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_NON_VOID_EXPRESSION,pNewNode,NULL);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION,pNewNode2,NULL);

					pTopStackCurrentNode->pLeft->pRight->pLeft->pLeft->pLeft = pNewNode3;

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,7,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,6,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION,0,0,NULL);
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 6)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					// Create a node and stick the expression on to it.
					pTopStackCurrentNode->pLeft->pRight->pLeft->pLeft->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,7,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 7)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,9,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,8,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_EXPRESSION,0,0,NULL);
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 8)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft->pRight->pLeft->pRight->pRight->pRight->pLeft = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,9,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 9 && nTopStackTerm == 9)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,9,10,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
			}
			if (nTopStackRule == 9 && nTopStackTerm == 10)
			{
				if (pTopStackReturnNode == NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_FOR_STATEMENT_CANNOT_BE_FOLLOWED_BY_A_NULL_STATEMENT;
					return nError;
				}

				pTopStackCurrentNode->pLeft->pRight->pLeft->pRight->pLeft->pLeft = pTopStackReturnNode;

				if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
				        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK)
				{
					pTopStackCurrentNode->pLeft->pRight->pLeft->pRight->pLeft->nOperation = CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG;
				}
				else
				{
					// It's already a STATEMENT, so set the line correctly.
					pTopStackCurrentNode->pLeft->pRight->pLeft->pRight->pLeft->nLine = pTopStackReturnNode->nLine;
				}

				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			if (nTopStackRule == 10 && nTopStackTerm == 2)
			{
				// Create a node.
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION,pTopStackReturnNode,NULL);
				CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pNewNode,NULL);
				CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST,pNewNode2,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,10,3,pNewNode3);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST,0,0,pNewNode2);
			}
			if (nTopStackRule == 10 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 11 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackReturnNode);
					return 0;
				}
				else
				{
					if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
					{
						if (pTopStackReturnNode != NULL)
						{
							if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_VARIABLE)
							{
								m_sUndefinedIdentifier = *(pTopStackReturnNode->m_psStringData);
								int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER;
								return nError;
							}
						}
					}
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 12 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_COLON_AFTER_DEFAULT_LABEL;
					return nError;
				}
			}
			if (nTopStackRule == 13 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COLON)
				{
					pTopStackCurrentNode->pLeft = pTopStackReturnNode;
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_COLON_AFTER_CASE_LABEL;
					return nError;
				}
			}
			if ((nTopStackRule == 14 && nTopStackTerm == 2) ||
			        (nTopStackRule == 15 && nTopStackTerm == 2))
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_STATEMENT;
					return nError;
				}
			}

			break;

			/////////////////////////////////////////////////////////////
			// case 9:
			// Within-a-statement-list
			// (1) within-a-statement within-a-statement-list
			/////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_EOF)
				{
					// Jump up to previous level.
					ModifySRStackReturnTree(NULL);
				}
				else
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,NULL,NULL);
					if (pTopStackCurrentNode != NULL)
					{
						pTopStackCurrentNode->pRight = pNewNode;
					}
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST,1,1,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,0,0,NULL);
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				pTopStackCurrentNode->pLeft = pTopStackReturnNode;

				// MGB - Stuff - For Debugging!
				// IF_BLOCK will take care of its own addressing for conditionals.
				if (pTopStackReturnNode != NULL)
				{
					if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_IF_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK ||
					        pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_FOR_BLOCK)
					{
						pTopStackCurrentNode->nOperation = CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG;
					}

				}
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST,1,2,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST,0,0,pTopStackCurrentNode);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			break;

			/////////////////////////////////////////////////////////////
			// case 8:
			// within-a-compound-statement:
			// (1) <void>  (right brace returns up higher in the tree)
			// (2) Within-a-statement-list
			/////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_WITHIN_COMPOUND_STATEMENT:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_COMPOUND_STATEMENT,2,1,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST,0,0,NULL);
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 1)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST,pTopStackReturnNode,NULL);
				ModifySRStackReturnTree(pNewNode);
			}
			break;

			/////////////////////////////////////////////////////////////
			// case 7:
			// non-initialized-decl-variable-list-separator
			// (1) ;
			// (2) , variable non-initialized-decl-variable-list
			//
			// A semi-colon should pass back up the stack so that the
			// rule containing the right brace can compile it.
			//////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST_SEPARATOR:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST,0,0,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}
			}
			else
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
				return nError;
			}
			break;

			//////////////////////////////////////////////////////////////////
			// case 6:
			// non-initialized-decl-variable-list
			// (1) variable non-initialized-decl-variable-list-separator
			//
			// A semi-colon should pass back up the stack so that the
			// rule containing the right brace can compile it.
			//////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST:
			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE,NULL,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode2->m_psStringData = new CExoString(m_pchToken);

					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE_LIST,pNewNode2,NULL);

					if (pTopStackCurrentNode != NULL)
					{
						pTopStackCurrentNode->pRight = pNewNode;
					}
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST,1,2,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST_SEPARATOR,0,0,pNewNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}
			}
			else if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}
			}
			break;

			////////////////////////////////////////////////////////////////////////////////////////////////
			// case 5:
			// non-initialized-decl-list:
			// (1) <void>
			// (2) non-void-type-specifier non-initialized-decl-variable-list ; non-initialized-decl-list
			//
			// A right brace should pass back up the stack so that the
			// rule containing the right brace can compile it.
			////////////////////////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT ||
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR ||
				        (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
				         m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,NULL,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST,2,2,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,0,0,NULL);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					ModifySRStackReturnTree(pTopStackCurrentNode);
					//return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_BAD_TYPE_SPECIFIER;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 2)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION,pTopStackReturnNode,NULL);
				pTopStackCurrentNode->pLeft = pNewNode;

				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST,2,3,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST,0,0,NULL);
			}
			if (nTopStackRule == 2 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					// Attach variable list.
					pTopStackCurrentNode->pLeft->pRight = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST,2,4,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}
			if (nTopStackRule == 2 && nTopStackTerm == 4)
			{
				pTopStackCurrentNode->pRight = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}

			break;

			//////////////////////////////////////////////////////////////////////
			// case 4:
			// after-function-parameter:
			// (1) <void>
			// (2) , function-parameter-list
			//
			// A right bracket should pass back up the stack so that the
			// rule containing the right bracket can compile it.
			//////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_AFTER_FUNCTION_PARAM:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					ModifySRStackReturnTree(NULL);
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}
			break;

			//////////////////////////////////////////////////////////////////////
			// case 3:
			// function-parameter-list:
			// (1) non-void-type-specifier variable after-function-parameter
			// (2) non-void-type-specifier variable = constant after-function-parameter
			// (3) non-void-type-specifier variable = - constant after-function-parameter
			//
			// Note: the right bracket should return to the previous rule.
			//////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,1,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER,0,0,NULL);
					//return 0;
				}
			}
			if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTION_PARAM_NAME,NULL,pTopStackReturnNode);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->m_psStringData = new CExoString(m_pchToken);

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,1,3,pNewNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_BAD_VARIABLE_NAME;
					return nError;
				}
			}
			else if (nTopStackRule == 1 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,2,4,pTopStackCurrentNode);
					//PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,0,1,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_FUNCTION_PARAM,0,0,NULL);
				}
			}
			else if (nTopStackRule == 2 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_MINUS)
				{
					// Constants can be negated in the function declaration, so allow them to be negated!
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_NEGATION,NULL,NULL);
					pTopStackCurrentNode->pRight->pRight = pNewNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,3,6,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,0,0,NULL);
					return 0;
				}
				else
				{
					// This should be a constant, hand it off to parsing by the primary expression rule.
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,2,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION,0,0,NULL);
				}
			}
			else if (nTopStackRule == 2 && nTopStackTerm == 5)
			{
				// Add the constant on to the food chain.
				pTopStackCurrentNode->pRight->pRight = pTopStackReturnNode;
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,0,1,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_FUNCTION_PARAM,0,0,NULL);
			}
			else if (nTopStackRule == 3 && nTopStackTerm == 6)
			{
				// Add the constant right after the potential negation.
				pTopStackCurrentNode->pRight->pRight->pRight = pTopStackReturnNode;
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,0,1,pTopStackCurrentNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_FUNCTION_PARAM,0,0,NULL);
			}

			// 3,0,1 deals with after-function-parameter
			if (nTopStackRule == 0 && nTopStackTerm == 1)
			{
				pTopStackCurrentNode->pLeft = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}
			break;

			//////////////////////////////////////////////////////////////////////
			// case 2:
			// after-program:
			// (1) <EOF>
			//////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_AFTER_PROGRAM:
			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_EOF)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_PROGRAM,1,1,pTopStackReturnNode);
					ModifySRStackReturnTree(pTopStackReturnNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_AFTER_COMPOUND_STATEMENT_AT_END;
					return nError;
				}
			}

			// This passes the result of the include back to the
			// previous thread of execution.  All of the functional
			// units are linked together.

			if (nTopStackRule == 1 && nTopStackTerm == 1)
			{
				ModifySRStackReturnTree(pTopStackReturnNode);
			}

			break;

			//////////////////////////////////////////////////////////////////////////////////////////
			// case 1:
			// functional-unit:
			// (1) any-type-specifier variable ( parameter-list ) ;
			// (2) any-type-specifier variable ( parameter-list ) { within-a-compound-statement }
			// (3) struct-specifier { non-initialized-decl-list } ;
			// (4) non-void-type-specifier declaration-list ;
			//////////////////////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT:
			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,0,2,NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_ANY_TYPE_SPECIFIER,0,0,NULL);
			}
			if (nTopStackRule == 0 && nTopStackTerm == 2)
			{
				if (pTopStackReturnNode->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT &&
				        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACE)
				{
					// Transfer to rule 3.
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STRUCTURE_DEFINITION,pTopStackReturnNode,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,3,4,pNewNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VARIABLE ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER ||
				         (m_nTokenStatus >= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER &&
				          m_nTokenStatus <= CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER))
				{
					CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTION_IDENTIFIER,pTopStackReturnNode,NULL);
					m_pchToken[m_nTokenCharacters] = 0;
					pNewNode->m_psStringData = new CExoString(m_pchToken);

					CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTION_DECLARATION,pNewNode,NULL);
					CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTION,pNewNode2,NULL);

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,0,3,pNewNode3);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_DEFINITION_MISSING_NAME;
					return nError;
				}
			}
			if (nTopStackRule == 0 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,0,5,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST,0,0,NULL);
					return 0;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_COMMA ||
				         m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL)
				{
					// Move the code to the appropriate spot where we deal with
					// global variables.
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,4,0,pTopStackCurrentNode);
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_DEFINITION_MISSING_PARAMETER_LIST;
					return nError;
				}

			}

			if (nTopStackRule == 0 && nTopStackTerm == 5)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET)
				{
					pTopStackCurrentNode->pLeft->pRight = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,0,6,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_MALFORMED_PARAMETER_LIST;
					return nError;
				}

			}

			// Here, we finally decide between a function declaration and
			// a function implementation!

			if (nTopStackRule == 0 && nTopStackTerm == 6)
			{
				// At this point we have access to a full declaration of a
				// function.  Thus, we should make use of this, and write
				// the identifier on to the list.
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					int32_t nReturnValue = AddUserDefinedIdentifier(pTopStackCurrentNode, FALSE);
					ModifySRStackReturnTree(pTopStackCurrentNode);
					return nReturnValue;
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_LEFT_BRACE)
				{
					int32_t nReturnValue = AddUserDefinedIdentifier(pTopStackCurrentNode, TRUE);
					if (nReturnValue < 0)
					{
						return nReturnValue;
					}

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,2,8,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT,1,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_WITHIN_COMPOUND_STATEMENT,0,0,NULL);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
					return nError;
				}
			}

			if (nTopStackRule == 2 && nTopStackTerm == 8)
			{
				pTopStackCurrentNode->pRight = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}

			if (nTopStackRule == 3 && nTopStackTerm == 4)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE)
				{
					pTopStackCurrentNode->pRight = pTopStackReturnNode;
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,3,5,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_BAD_TYPE_SPECIFIER;
					return nError;
				}

			}

			if (nTopStackRule == 3 && nTopStackTerm == 5)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					AddToGlobalVariableList(pTopStackCurrentNode);
					//ModifySRStackReturnTree(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_STRUCTURE;
					return nError;
				}
			}

			if (nTopStackRule == 4 && nTopStackTerm == 0)
			{
				// Break the current tree, and build our own tree based on the fact
				// that this is a declaration.

				// Create the nodes for specifying a declaration.

				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION,NULL,NULL);
				CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pNewNode,NULL);
				CScriptParseTreeNode *pNewNode3 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST,pNewNode2,NULL);

				if (pTopStackCurrentNode->pLeft->pLeft->pLeft->nOperation != CSCRIPTCOMPILER_OPERATION_CONST_DECLARATION)
				{
					// A variable type is at pTopStackCurrentNode->pLeft->pLeft->pLeft;
					// Now, we attach the type declaration from the old branch.
					pNewNode->pLeft = pTopStackCurrentNode->pLeft->pLeft->pLeft;
					pTopStackCurrentNode->pLeft->pLeft->pLeft = NULL;

				}
				else
				{
					// The const_declaration is at pTopStackCurrentNode->pLeft->pLeft->pLeft;

					// Remove the "const_declaration" operand from the type, and move it
					// to the top of the statement list!

					// First attach the "proper" type to the keyword declaration object.
					pNewNode->pLeft = pTopStackCurrentNode->pLeft->pLeft->pLeft->pLeft;
					// Detach the const_declaration operand from its type.
					pTopStackCurrentNode->pLeft->pLeft->pLeft->pLeft = NULL;
					// Attach the const_declaration operand between the statement list and
					// the first statement node. (Following the left chains ...
					// pNewNode3->const_declaration->pNewNode2)
					pNewNode3->pLeft = pTopStackCurrentNode->pLeft->pLeft->pLeft;
					pNewNode3->pLeft->pLeft = pNewNode2;
				}

				// Hand the statement list up the food chain.
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,4,3,pNewNode3);

				// Do not allow a void parameter.
				if (pNewNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_INVALID_DECLARATION_TYPE;
					return nError;
				}

				int32_t nStartOfDeclarationLine = pNewNode->pLeft->nLine;
				pNewNode3->nLine = nStartOfDeclarationLine;
				pNewNode2->nLine = nStartOfDeclarationLine;

				// If we have placed a const_declaration in place, give it the same
				// line number, too!
				if (pNewNode3->pLeft != pNewNode2)
				{
					pNewNode3->pLeft->nLine = nStartOfDeclarationLine;
				}

				// Now, let's get the variable name from the old tree.
				pNewNode->m_psStringData = new CExoString(pTopStackCurrentNode->pLeft->pLeft->m_psStringData->CStr());

				// Let's verify that this is, in fact, a variable (see rule 13).
				int32_t m_nCurrentTokenStatus = m_nTokenStatus;

				m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_IDENTIFIER;
				m_nTokenCharacters = pNewNode->m_psStringData->GetLength();
				memcpy(m_pchToken, pNewNode->m_psStringData->CStr(), m_nTokenCharacters);
				int32_t nReturnValue = TestIdentifierToken();
				if (nReturnValue != 0)
				{
					return nReturnValue;
				}

				if (m_nTokenStatus != CSCRIPTCOMPILER_TOKEN_VARIABLE)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_VARIABLE_LIST;
					return nError;
				}

				CScriptParseTreeNode *pNewNode5 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE, NULL, NULL);
				m_pchToken[m_nTokenCharacters] = 0;
				pNewNode5->m_psStringData = new CExoString(m_pchToken);

				CScriptParseTreeNode *pNewNode6 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_VARIABLE_LIST, pNewNode5, NULL);

				pNewNode->pRight = pNewNode6;

				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST,1,2,pNewNode2);

				// Restore the token, and delete the compile tree associated with
				// the old branch.
				m_nTokenStatus = m_nCurrentTokenStatus;

				DeleteScriptParseTreeNode(pTopStackCurrentNode->pLeft->pLeft);
				DeleteScriptParseTreeNode(pTopStackCurrentNode->pLeft);
				DeleteScriptParseTreeNode(pTopStackCurrentNode);
			}

			if (nTopStackRule == 4 && nTopStackTerm == 3)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SEMICOLON)
				{
					// Store the result into the global variable array.

					// If we have global variables, we should be dealing with
					// them immediately by adding them to the identifier list.
					if (pTopStackCurrentNode->pLeft != NULL &&
					        pTopStackCurrentNode->pLeft->nOperation == CSCRIPTCOMPILER_OPERATION_CONST_DECLARATION)
					{
						int32_t nReturnValue = GenerateIdentifiersFromConstantVariables(pTopStackCurrentNode->pLeft->pLeft);
						DeleteParseTree(FALSE, pTopStackCurrentNode);
						if (nReturnValue < 0)
						{
							return nReturnValue;
						}
						return 0;
					}

					AddToGlobalVariableList(pTopStackCurrentNode);
					return 0;
				}
				else
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_NO_SEMICOLON_AFTER_EXPRESSION;
					return nError;
				}
			}

			break;

			/////////////////////////////////////////////////////////////////////////
			// case 0:
			// program:
			// (1) after-program
			// (2) functional-unit program
			// (3) #include string program
			//////////////////////////////////////////////////////////////////////////

		case CSCRIPTCOMPILER_GRAMMAR_PROGRAM:

			if (nTopStackRule == 0 && nTopStackTerm == 0)
			{
				if (pTopStackCurrentNode == NULL  && m_nCompileFileLevel <= 1)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_AFTER_PROGRAM,0,0,NULL);
				}

				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_EOF)
				{
					ModifySRStackReturnTree(NULL);

					// If we're in an included file ... we actually
					// leave the routine here, instead of trying
					// to hunt down the TOKEN_EOF in rule 1 ... we
					// would have to pillage the entire stack of the
					// file that called this routine to get to that
					// one!

					if (m_nCompileFileLevel > 1)
					{
						return 0;
					}
				}
				else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_KEYWORD_INCLUDE)
				{
					// Note that this is at this level so that we
					// can avoid giving a functional unit
					// to an included file.  This is the ONLY time
					// that we really violate the structure of the
					// grammar in this way.
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,3,1,pTopStackCurrentNode);
					return 0;
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,1,2,NULL);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT,0,0,NULL);
				}
			}

			if (nTopStackRule == 1 && nTopStackTerm == 2)
			{
				CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_FUNCTIONAL_UNIT, pTopStackReturnNode, NULL);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,1,3,pNewNode);
				PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,0,0,pNewNode);
			}
			if (nTopStackRule == 1 && nTopStackTerm == 3)
			{
				pTopStackCurrentNode->pRight = pTopStackReturnNode;
				ModifySRStackReturnTree(pTopStackCurrentNode);
			}

			if (nTopStackRule == 3 && nTopStackTerm == 1)
			{
				if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
				{

					CExoString sStringToCompile;
					m_pchToken[m_nTokenCharacters] = 0;
					(sStringToCompile).Format("%s",m_pchToken);

					// First things first, let's check to see if the file has
					// already been included.  If it has, ignore the directive
					// completely!
					BOOL bFileAlreadyIncluded = FALSE;
					int32_t nCount = 0;
					for (nCount = 0; nCount < m_nNextParseTreeFileName; nCount++)
					{
						if (m_ppsParseTreeFileNames[nCount]->CompareNoCase(sStringToCompile) == TRUE)
						{
							bFileAlreadyIncluded = TRUE;
						}
					}

					if (bFileAlreadyIncluded == TRUE)
					{
						PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,0,0,pTopStackCurrentNode);
						return 0;
					}

					// If we have got to here, the file hasn't already been included,
					// and we should prepare to load it in!

					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,3,2,pTopStackCurrentNode);
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,0,0,pTopStackCurrentNode);

					// Want a TokenInitialize() here, since that is the
					// state we'll be returning to once we've finished
					// parsing this file.
					TokenInitialize();
					return CompileFile(sStringToCompile);
				}
			}

			if (nTopStackRule == 3 && nTopStackTerm == 2)
			{
				// This is where we have to handle the reacquisition of
				// the code from the previous script.  pTopStackReturnNode
				// points to a series of FUNCTIONAL_UNIT nodes.  These
				// have to be added to the queue as (0,1,3) units that
				// are all detached from one another to allow the code
				// for this script to operate correctly.

				CScriptParseTreeNode *pRunnerNode;
				CScriptParseTreeNode *pNextNode;
				CScriptParseTreeNode *pLastNode;

				pLastNode = NULL;
				pRunnerNode = pTopStackReturnNode;

				while (pRunnerNode != NULL)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,1,3,pRunnerNode);
					pLastNode = pRunnerNode;
					pNextNode = pRunnerNode->pRight;
					pRunnerNode->pRight = NULL;
					pRunnerNode = pNextNode;
				}

				// Now that we've inserted everything in place, set up
				// to read the next functional unit!
				if (pLastNode == NULL)
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,0,0,pTopStackCurrentNode);
				}
				else
				{
					PushSRStack(CSCRIPTCOMPILER_GRAMMAR_PROGRAM,0,0,pLastNode);
				}

			}
			break;
		default:
			int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNKNOWN_STATE_IN_COMPILER;
			return nError;
		} // case
	}

	// To alleviate warnings from Warning Level 4.
	return 0;
}


///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddUserDefinedIdentifier()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/17/2000
//  Description: Adds a user-defined identifier that has been compiled into the
//               list.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::AddUserDefinedIdentifier(CScriptParseTreeNode *pFunctionDeclaration, BOOL bFunctionImplementation)
{

	// First, get the identifier name which should be in
	// pLeft->pLeft->pcStringData;
	(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier) = *(pFunctionDeclaration->pLeft->pLeft->m_psStringData);
	(m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierHash) = HashString(*(pFunctionDeclaration->pLeft->pLeft->m_psStringData));
	(m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierLength) = pFunctionDeclaration->pLeft->pLeft->m_psStringData->GetLength();

	// Return Type is in pLeft->pLeft->pLeft ... read the
	// operation to see the type of variable.
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdentifierType = 1;

	int32_t nOperationReturnType = pFunctionDeclaration->pLeft->pLeft->pLeft->nOperation;

	if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER;
	}
	else if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER;
	}
	else if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER;
	}
	else if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER;
	}
	else if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER;
	}
	else if (nOperationReturnType == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER;
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStructureReturnName = *(pFunctionDeclaration->pLeft->pLeft->pLeft->m_psStringData);
	}
	else if (nOperationReturnType >= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 &&
	         nOperationReturnType <= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_nReturnType = CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER + (nOperationReturnType - CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0);
	}

	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_FUNCTION_DECLARATION;
		return nError;
	}

	// User defined functions NEVER have a list here.

	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nIdIdentifier = -1;

	// The list of function types is availble via pLeft->pRight.
	// The list of "parameter names" spawns off to the left ...
	// This allows us to pull the variables off of the list in
	// reverse stack order (i.e. 3rd parameter, 2nd parameter,
	// first parameter) when executing this as a linked list!
	// Thus, you're going to want to count the number of
	// parameter names first, and then trace through them and
	// discover the variable names.

	CScriptParseTreeNode *pNode = pFunctionDeclaration->pLeft->pRight;
	int32_t nTotalParameters = 0;

	while (pNode != NULL)
	{
		++nTotalParameters;
		pNode = pNode->pLeft;
	}

	while (nTotalParameters > m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameterSpace)
	{
		int nReturnValue = m_pcIdentifierList[m_nOccupiedIdentifiers].ExpandParameterSpace();
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
	}

	pNode = pFunctionDeclaration->pLeft->pRight;
	int32_t nCurrentParameters = 0;
	int32_t nParameterType;
	BOOL bOptionalParametersStarted = FALSE;

	// MGB - If a previous declaration and implementation match, an identifier
	// gets removed from the stack.  Thus, m_nOccupiedIdentifiers should be cleared.
	// This is the biggest "remaining" bug, since it prevents a future function from
	// compiling.
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters = 0;
	m_pcIdentifierList[m_nOccupiedIdentifiers].m_nNonOptionalParameters = 0;

	if (pNode != NULL)
	{
		while (pNode != NULL)
		{
			nParameterType = pNode->pRight->nOperation;
			char nNewParameterType;

			if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_INT)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_INT;
			}
			else if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT;
			}
			else if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT;
			}
			else if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING;
			}
			else if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID;
			}
			else if (nParameterType == CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT)
			{
				nNewParameterType = CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT;
			}
			else if (nParameterType >= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 &&
			         nParameterType <= CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9)
			{
				nNewParameterType = (char) (CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 + (nParameterType - CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0));
			}
			else
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_PARSING_FUNCTION_DECLARATION;
				return nError;
			}

			m_pcIdentifierList[m_nOccupiedIdentifiers].m_pchParameters[nCurrentParameters] = nNewParameterType;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = FALSE;

			// If we've started processing optional parameters for this function
			// declaration, all further parameters MUST be optional.  So sayeth Mark.

			if (bOptionalParametersStarted == TRUE && pNode->pRight->pRight == NULL)
			{
				int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_OPTIONAL_PARAMETER_CANNOT_FOLLOW_OPTIONAL_PARAMETER;
				return nError;
			}

			if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStructureParameterNames[nCurrentParameters] = *(pNode->pRight->m_psStringData);
				if (pNode->pRight->pRight != NULL && *(pNode->pRight->m_psStringData) != "vector")
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_TYPE_DOES_NOT_HAVE_AN_OPTIONAL_PARAMETER;
					return nError;
				}
				if (pNode->pRight->pRight != NULL && *(pNode->pRight->m_psStringData) == "vector")
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					if (pNode->pRight->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_VECTOR)
					{
						pNode->pRight->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);
						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pfOptionalParameterVectorData[nCurrentParameters * 3] = pNode->pRight->pRight->fVectorData[0];
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pfOptionalParameterVectorData[nCurrentParameters * 3 + 1] = pNode->pRight->pRight->fVectorData[1];
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pfOptionalParameterVectorData[nCurrentParameters * 3 + 2] = pNode->pRight->pRight->fVectorData[2];
					bOptionalParametersStarted = TRUE;
					pNode->pRight->pRight = NULL;
					DeleteScriptParseTreeNode(pNodeToDelete);

				}
			}
			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_INT)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					// MGB - March 25, 2003 - May have a constant or a constant with a negation attached to
					// its right hand branch.  This piece of code should be able to handle both for integers.
					BOOL bValidConstant = FALSE;

					// Are we a valid constant?
					if (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER ||
					        (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_NEGATION &&
					         pNode->pRight->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER))
					{
						bValidConstant = TRUE;
					}

					// Delete things if we are not a valid constant, and error out.
					if (bValidConstant == FALSE)
					{
						pNode->pRight->pRight = NULL;
						if (pNodeToDelete->pRight != NULL)
						{
							DeleteScriptParseTreeNode(pNodeToDelete->pRight);
						}
						pNodeToDelete->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);
						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}

					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;

					if (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER)
					{
						// Store the fetched value.
						m_pcIdentifierList[m_nOccupiedIdentifiers].m_pnOptionalParameterIntegerData[nCurrentParameters] = pNode->pRight->pRight->nIntegerData;
					}
					else
					{
						// Negate the fetched value, since we have a negation at the front of the constant.
						m_pcIdentifierList[m_nOccupiedIdentifiers].m_pnOptionalParameterIntegerData[nCurrentParameters] = -(pNode->pRight->pRight->pRight->nIntegerData);
					}

					bOptionalParametersStarted = TRUE;

					// Delete the appropriate nodes!
					pNode->pRight->pRight = NULL;
					if (pNodeToDelete->pRight != NULL)
					{
						DeleteScriptParseTreeNode(pNodeToDelete->pRight);
					}
					DeleteScriptParseTreeNode(pNodeToDelete);

				}
			}
			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					if (pNode->pRight->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_OBJECT)
					{
						pNode->pRight->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);

						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_poidOptionalParameterObjectData[nCurrentParameters] = pNode->pRight->pRight->nIntegerData;
					bOptionalParametersStarted = TRUE;
					pNode->pRight->pRight = NULL;
					DeleteScriptParseTreeNode(pNodeToDelete);


				}

			}
			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					// MGB - March 25, 2003 - May have a constant or a constant with a negation attached to
					// its right hand branch.  This piece of code should be able to handle both for floating points.
					BOOL bValidConstant = FALSE;

					// Are we a valid constant?
					if (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT ||
					        (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_NEGATION &&
					         pNode->pRight->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT))
					{
						bValidConstant = TRUE;
					}

					// Delete things if we are not a valid constant, and error out.
					if (bValidConstant == FALSE)
					{
						pNode->pRight->pRight = NULL;
						if (pNodeToDelete->pRight != NULL)
						{
							DeleteScriptParseTreeNode(pNodeToDelete->pRight);
						}
						pNodeToDelete->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);
						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}

					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;

					if (pNode->pRight->pRight->nOperation == CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT)
					{
						// Store the fetched value.
						m_pcIdentifierList[m_nOccupiedIdentifiers].m_pfOptionalParameterFloatData[nCurrentParameters] = pNode->pRight->pRight->fFloatData;
					}
					else
					{
						// Negate the fetched value, since we have a negation at the front of the constant.
						m_pcIdentifierList[m_nOccupiedIdentifiers].m_pfOptionalParameterFloatData[nCurrentParameters] = -(pNode->pRight->pRight->pRight->fFloatData);
					}

					bOptionalParametersStarted = TRUE;

					// Delete the appropriate nodes!
					pNode->pRight->pRight = NULL;
					if (pNodeToDelete->pRight != NULL)
					{
						DeleteScriptParseTreeNode(pNodeToDelete->pRight);
					}
					DeleteScriptParseTreeNode(pNodeToDelete);
				}
			}
			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					if (pNode->pRight->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING)
					{
						pNode->pRight->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);


						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_psOptionalParameterStringData[nCurrentParameters] = *(pNode->pRight->pRight->m_psStringData);
					bOptionalParametersStarted = TRUE;
					pNode->pRight->pRight = NULL;
					DeleteScriptParseTreeNode(pNodeToDelete);


				}
			}

			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2 /* location */)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					if (pNode->pRight->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_LOCATION)
					{
						pNode->pRight->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);

						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;
                    // LOCATION constants reusing the integer data because i'm lazy. If you ever add more than LOCATION_INVALID
                    // you will probably have to expand that to carry actual locations. While you're at that, move the
                    // CScriptLocation out of sharedcore and into include/ somewhere.
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pnOptionalParameterIntegerData[nCurrentParameters] = pNode->pRight->pRight->nIntegerData;
					bOptionalParametersStarted = TRUE;
					pNode->pRight->pRight = NULL;
					DeleteScriptParseTreeNode(pNodeToDelete);
				}
            }

			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7 /* json */)
			{
				if (pNode->pRight->pRight != NULL)
				{
					CScriptParseTreeNode *pNodeToDelete = pNode->pRight->pRight;

					if (pNode->pRight->pRight->nOperation != CSCRIPTCOMPILER_OPERATION_CONSTANT_JSON)
					{
						pNode->pRight->pRight = NULL;
						DeleteScriptParseTreeNode(pNodeToDelete);

						int nError = STRREF_CSCRIPTCOMPILER_ERROR_NON_CONSTANT_IN_FUNCTION_DECLARATION;
						return nError;
					}
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_pbOptionalParameters[nCurrentParameters] = TRUE;
                    // Json data is loaded into the string array, same as strings. all json data is kept as raw
                    // strings while living inside the compiler; only when hitting the VM it attempts to parse.
                    // (BORLAND is too simple to understand nlohmann::json)
					m_pcIdentifierList[m_nOccupiedIdentifiers].m_psOptionalParameterStringData[nCurrentParameters] = *pNode->pRight->pRight->m_psStringData;
					bOptionalParametersStarted = TRUE;
					pNode->pRight->pRight = NULL;
					DeleteScriptParseTreeNode(pNodeToDelete);
				}
            }

			else if (nNewParameterType == CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID ||
			         (nNewParameterType >= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 &&
			          nNewParameterType <= CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9))
			{
				if (pNode->pRight->pRight != NULL)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_TYPE_DOES_NOT_HAVE_AN_OPTIONAL_PARAMETER;
					return nError;
				}
			}

			++nCurrentParameters;
			m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters = nCurrentParameters;
			if (bOptionalParametersStarted == FALSE)
			{
				m_pcIdentifierList[m_nOccupiedIdentifiers].m_nNonOptionalParameters = nCurrentParameters;
			}

			pNode = pNode->pLeft;

		}
	}

	// Check to see if the function is already in the list.  If
	// it is, then we don't need to do anything about this one.

	int32_t nHashLocation = GetHashEntryByName(m_pcIdentifierList[m_nOccupiedIdentifiers].m_psIdentifier.CStr());
	BOOL bFoundIdenticalFunction = FALSE;

	if (nHashLocation != STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
	{
		int32_t nIdentifierType = m_pIdentifierHashTable[nHashLocation].m_nIdentifierType;
		int32_t nIdentifierIndex = m_pIdentifierHashTable[nHashLocation].m_nIdentifierIndex;

		if (nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
		{
			if (m_pcIdentifierList[nIdentifierIndex].m_nIdentifierType == 1)
			{
				if (m_pcIdentifierList[nIdentifierIndex].m_nParameters == m_pcIdentifierList[m_nOccupiedIdentifiers].m_nParameters)
				{
					BOOL bParameterListDifferent = FALSE;

					int32_t count2;
					for (count2 = 0; count2 < m_pcIdentifierList[nIdentifierIndex].m_nParameters; count2++)
					{
						if ((m_pcIdentifierList[nIdentifierIndex].m_pchParameters[count2] != m_pcIdentifierList[m_nOccupiedIdentifiers].m_pchParameters[count2]) ||
						        (m_pcIdentifierList[nIdentifierIndex].m_pchParameters[count2] == CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER &&
						         m_pcIdentifierList[nIdentifierIndex].m_psStructureParameterNames[count2] != m_pcIdentifierList[m_nOccupiedIdentifiers].m_psStructureParameterNames[count2]))
						{
							bParameterListDifferent = TRUE;
						}
					}

					if (bParameterListDifferent == FALSE)
					{
						bFoundIdenticalFunction = TRUE;
						if (bFunctionImplementation == TRUE)
						{
							if (m_pcIdentifierList[nIdentifierIndex].m_bImplementationInPlace == TRUE)
							{
								int nError = STRREF_CSCRIPTCOMPILER_ERROR_DUPLICATE_FUNCTION_IMPLEMENTATION;
								// If you don't want the name of the duplicate function.
								//return OutputWalkTreeError(nError, NULL);
								// If you want the name of the duplicate function, use this.
								return OutputIdentifierError(m_pcIdentifierList[nIdentifierIndex].m_psIdentifier,nError,1);
							}
							else
							{
								m_pcIdentifierList[nIdentifierIndex].m_bImplementationInPlace = TRUE;
							}
						}
					}
				}

				// If the function name is the same, it better be identical, or
				// we should gork right here.
				if (bFoundIdenticalFunction == FALSE)
				{
					int nError = STRREF_CSCRIPTCOMPILER_ERROR_FUNCTION_IMPLEMENTATION_AND_DEFINITION_DIFFER;
					return nError;
				}

			}
		}
	}


	if (bFoundIdenticalFunction == FALSE)
	{
		m_pcIdentifierList[m_nOccupiedIdentifiers].m_bImplementationInPlace = bFunctionImplementation;

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
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::AddToGlobalVariableList
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/09/2001
// Description: Adds the current statement to the global variable compile tree.
///////////////////////////////////////////////////////////////////////////////
int32_t CScriptCompiler::AddToGlobalVariableList(CScriptParseTreeNode *pGlobalVariableNode)
{
	if (m_pGlobalVariableParseTree == NULL)
	{
		CScriptParseTreeNode *pNewNode = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_GLOBAL_VARIABLES,NULL,NULL);
		m_pGlobalVariableParseTree = pNewNode;
	}

	// Create a new "statement" for this declaration.
	CScriptParseTreeNode *pNewNode2 = CreateScriptParseTreeNode(CSCRIPTCOMPILER_OPERATION_STATEMENT,pGlobalVariableNode,NULL);

	// This guarantees the connection will be made between the variable
	// declaration and the line it is on, not the line the statement
	// terminates on.
	if (pGlobalVariableNode != NULL)
	{
		pNewNode2->nLine = pGlobalVariableNode->nLine;
	}


	// Look for the last statement in the list of statements and attach
	// this node to them.
	CScriptParseTreeNode *pFindLastStatement = m_pGlobalVariableParseTree;

	while (pFindLastStatement->pRight != NULL)
	{
		pFindLastStatement = pFindLastStatement->pRight;
	}

	pFindLastStatement->pRight = pNewNode2;

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::PrintParseSourceError()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/15/2001
//  Description:  This routine will generate an error log based on the value
//                passed in.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::PrintParseSourceError(int32_t nParsingError)
{
	CExoString strRes = m_cAPI.TlkResolve(-nParsingError);

	CExoString *psFileName = &(m_pcIncludeFileStack[m_nCompileFileLevel-1].m_sCompiledScriptName);
	CExoString sErrorText;

	if (nParsingError != STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
	{
		sErrorText.Format("%s",strRes.CStr());
	}
	else
	{
		sErrorText.Format("%s (%s)",strRes.CStr(),m_sUndefinedIdentifier.CStr());
	}

	OutputError(nParsingError,psFileName,m_nLines,sErrorText);

	nParsingError = STRREF_CSCRIPTCOMPILER_ERROR_ALREADY_PRINTED;

	return CleanUpDuringCompile(nParsingError);
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::DeleteCompileStack()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 08/05/99
//  Description:  This routine will delete all of the nodes that can be
//                accessed from the compiler's run time stack.
///////////////////////////////////////////////////////////////////////////////

void CScriptCompiler::DeleteCompileStack()
{
	int32_t i;
	for (i=0; i <= m_nSRStackStates; i++)
	{
		if (m_pSRStack[i].pCurrentTree != NULL)
		{
			DeleteParseTree(TRUE,m_pSRStack[i].pCurrentTree);
		}
		if (m_pSRStack[i].pReturnTree != NULL)
		{
			DeleteParseTree(TRUE,m_pSRStack[i].pReturnTree);
		}
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::CleanUpDuringCompile()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/26/2000
//  Description:  This routine will delete all of the data associated with the
//                current compile that is going on.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::CleanUpDuringCompile(int32_t nReturnValue)
{
	DeleteCompileStack();
	--m_nCompileFileLevel;
	if (m_nCompileFileLevel > 0)
	{
		ShutdownIncludeFile(m_nCompileFileLevel);
	}
	DeleteParseTree(FALSE, m_pGlobalVariableParseTree);
	m_pGlobalVariableParseTree = NULL;
	ClearUserDefinedIdentifiers();
	ClearAllSymbolLists();
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseSource()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/15/2001
//  Description:  This routine will generate a parse tree from the string
//   specified in pScript (of length nScriptLength).
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseSource(char *pScript, int32_t nScriptLength)
{

	int32_t i;                     // location in the string
	int32_t nParseNextCharReturn;  // returned value from ParseNextCharacter

	int32_t ch;       // character at location pScript[i]
	int32_t chNext;   // character at location pScript[i+1].  Yes, I freakin' cheat and
	// look ahead a character.  Gonna make something out of it, weasel boy?
	// I didn't think so.

	if (m_nOccupiedIdentifiers == 0)
	{
		int32_t nReturnValue = ParseIdentifierFile();
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
	}

	///////////////////////////////////////////////
	//
	// Initialize with the first two characters.
	//
	///////////////////////////////////////////////

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

	///////////////////////////////////////////////
	//
	// Loop through all remaining characters.
	//
	///////////////////////////////////////////////

	while (ch != -1)
	{
		nParseNextCharReturn = ParseNextCharacter(ch,chNext,pScript + i,nScriptLength - i);

		if (nParseNextCharReturn < 0)
		{
			return PrintParseSourceError(nParseNextCharReturn);
		}

		while (nParseNextCharReturn >= 0)
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

			--nParseNextCharReturn;

			++i;
		}

	}

	///////////////////////////////////////////////
	//
	// Parse an EOF.
	//
	///////////////////////////////////////////////

	nParseNextCharReturn = ParseNextCharacter(-1,-1, nullptr, 0);

	if (nParseNextCharReturn < 0)
	{

		return PrintParseSourceError(nParseNextCharReturn);
	}

	return 0;
}
