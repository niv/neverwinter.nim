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
//::  ScriptCompLexical.cpp
//::
//::  Implementation of parsing a stream of characters into tokens that can
//::  either be handed to GenerateIdentifierFile() or GenerateParseTree().
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
//  CScriptCompiler::ParseFloatFromTokenString()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 10/17/2000
//  Description: Parses a floating point number from the m_pchToken that has
//               been read in (i.e. a TOKEN_FLOAT).
///////////////////////////////////////////////////////////////////////////////

float CScriptCompiler::ParseFloatFromTokenString()
{
	float fReturnValue = 0.0f;
	int32_t   nMode = 0;
	float fDecimalConstant = 1.0f;
	float fSign = 1.0f;

	for (int32_t nCount = 0; nCount < m_nTokenCharacters; nCount++)
	{
		if (m_pchToken[nCount] == '-' && nCount == 0)
		{
			fSign = -1.0f;
		}

		if (m_pchToken[nCount] >= '0' &&
		        m_pchToken[nCount] <= '9')
		{
			if (nMode == 0)
			{
				fReturnValue *= 10.0f;
				fReturnValue += (m_pchToken[nCount] - '0');
			}
			if (nMode == 1)
			{
				fDecimalConstant /= 10.0f;
				fReturnValue += ((m_pchToken[nCount] - '0') * fDecimalConstant);
			}

		}
		if (m_pchToken[nCount] == '.')
		{
			nMode = 1;
		}
	}

	// If the constant is negative, apply the sign to it.
	if (fSign < 0.0f)
	{
		fReturnValue = fSign * fReturnValue;
	}

	return fReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterNumeric()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a numeric character for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterNumeric(int32_t ch)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_INTEGER;
		m_nTokenCharacters = 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_HEX_INTEGER ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT   ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING  ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_IDENTIFIER)
	{
		m_pchToken[m_nTokenCharacters] = (char) ch;
		++m_nTokenCharacters;
		if (m_nTokenCharacters > CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}

	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterPeriod()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a period for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterPeriod(int32_t chNext)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_FLOAT;
		m_pchToken[m_nTokenCharacters] = '.';
		++m_nTokenCharacters;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}

	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_IDENTIFIER)
	{
		// Cut off the current identifier, and then pass the
		// period in as a token!
		int nReturnValue = HandleIdentifierToken();
		if (nReturnValue >= 0)
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_STRUCTURE_PART_SPECIFY;
			nReturnValue = HandleToken();
		}
		return nReturnValue;
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		// If our token starts with a dot, and next one is a digit, it's a float
		// in the form of ".42", meaning 0.42
		if (chNext >= '0' && chNext <= '9')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_FLOAT;
			m_pchToken[m_nTokenCharacters++] = '0';
			m_pchToken[m_nTokenCharacters++] = '.';
		}
		else // Otherwise, assume struct field
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_STRUCTURE_PART_SPECIFY;
			return HandleToken();
		}
	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterAlphabet()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a alphabetic character for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterAlphabet(int32_t ch)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_IDENTIFIER;
		m_nTokenCharacters = 0;
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER && (ch == 'x' || ch == 'X') &&
	        m_nTokenCharacters == 1 && m_pchToken[0] == '0')
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_HEX_INTEGER;
		m_pchToken[m_nTokenCharacters] = (char) ch;
		++m_nTokenCharacters;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}

	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_HEX_INTEGER &&
	         ((ch >= 'a' && ch <='f') ||
	          (ch >= 'A' && ch <='F')))
	{
		if (ch <= 'F')
		{
			m_pchToken[m_nTokenCharacters] = (char) (ch + 32);
		}
		else
		{
			m_pchToken[m_nTokenCharacters] = (char) ch;
		}
		++m_nTokenCharacters;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}

	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_IDENTIFIER || m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
	{
		m_pchToken[m_nTokenCharacters] = (char) ch;
		++m_nTokenCharacters;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}
	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterSlash()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a slash for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterSlash(int32_t chNext)
{
	int32_t nReturnValue = 1;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '*')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_CCOMMENT;
			nReturnValue = 1;
		}
		else if (chNext == '/')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_CPLUSCOMMENT;
			nReturnValue = 1;
		}
		else if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_DIVIDE;
			int32_t nReturnHandle = HandleToken();
			if (nReturnHandle < 0)
			{
				return nReturnHandle;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_DIVIDE;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterAmpersand()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles an ampersand for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterAmpersand(int32_t chNext)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '&')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_LOGICAL_AND;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			return 1;
		}
		else if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_AND;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			return 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_BOOLEAN_AND;
			return HandleToken();
		}
	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterVerticalBar()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a vertical bar for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterVerticalBar(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '|')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_LOGICAL_OR;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_OR;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_INCLUSIVE_OR;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterAsterisk()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles an asterisk for use by tokens
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterAsterisk(int32_t chNext)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MULTIPLY;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			return 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_MULTIPLY;
			return HandleToken();
		}
	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		return nError;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCommentedOutCharacter()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Determies whether or not the COMMENT token ends.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCommentedOutCharacter(int32_t ch)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_CPLUSCOMMENT)
	{
		if (ch == '\n')
		{

#ifndef NWN
			// For other projects, this is useful for keeping the scripting
			// commands straight.
			if (m_bCompileIdentifierList == TRUE)
			{
				if (m_nTokenCharacters >= 2 &&
				        m_pchToken[0] == '!')
				{
					m_pchToken[m_nTokenCharacters] = 0;
					int32_t nProperFunctionIdentifier = atoi(m_pchToken + 1);

					if (nProperFunctionIdentifier != m_nPredefinedIdentifierOrder)
					{
						BOOL bAlwaysFalse = FALSE;
						EXOASSERTSTR(bAlwaysFalse,"Language Definition File Is Misordered!");
					}
				}
			}
#endif // !NWN

			TokenInitialize();
		}
		else if (m_bCompileIdentifierList == TRUE)
		{

#ifndef NWN
			m_pchToken[m_nTokenCharacters] = (char) ch;
			++m_nTokenCharacters;
			if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
			{
				return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
			}
#endif // !NWN

		}

	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_CCOMMENT)
	{
		// If the last character we have seen is an asterisk, then
		// m_nTokenCharacters == 1.  Only when we see ch == '/' and
		// we see m_nTokenCharacters == 1 should we bother to unset
		// CCOMMENT mode.

		if (ch == '*')
		{
			if (m_nTokenCharacters == 0)
			{
				m_nTokenCharacters = 1;
			}
		}
		else if (ch == '/')
		{
			if (m_nTokenCharacters == 1)
			{
				TokenInitialize();
			}
		}
		else
		{
			m_nTokenCharacters = 0;
		}
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseStringCharacter()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a character for a TOKEN_STRING token.  Need to compile
//                stuff like \n into a single character (\n).  Wow.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseStringCharacter(int32_t ch, int32_t chNext, char *pScript, int32_t nScriptLength)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
	{
		if (ch == '\n')
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_UNTERMINATED_STRING_CONSTANT;
		}
		else if (ch == '"')
		{
			return ParseCharacterQuotationMark();
		}
		else if (ch == '\\')
		{
			BOOL escapedChar = true;
			// Handle the "\n" type characters in a string constant.
			if (chNext == 'n')
			{
				m_pchToken[m_nTokenCharacters] = '\n';
			}
			else if (chNext == '\\')
			{
				m_pchToken[m_nTokenCharacters] = '\\';
			}
			else if (chNext == '"')
			{
				m_pchToken[m_nTokenCharacters] = '"';
			}
			else if (chNext == 'x')
			{
			    // This is bit of a hack; but we can just grab the next characters from
			    // the source data and return what we ate.
			    if (nScriptLength < 2)
			        return STRREF_CSCRIPTCOMPILER_ERROR_UNTERMINATED_STRING_CONSTANT;
			    const char hex[3] = { pScript[0], pScript[1], '\0'};
			    char* ptr = nullptr;
			    // can never be >byte, we only parse two bytes
			    m_pchToken[m_nTokenCharacters++] = (char) strtol(hex, &ptr, 16);
			    return 3; // eat "xXX"
			}
			else
			{
				escapedChar = false;
			}

			if (escapedChar)
			{
				++m_nTokenCharacters;
				if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
				{
					return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
				}
				return 1;
			}
		}
		else
		{
			m_pchToken[m_nTokenCharacters] = (char) ch;
			++m_nTokenCharacters;
			if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
			{
				return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
			}

			return 0;
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}

	return nReturnValue;
}

int32_t CScriptCompiler::ParseRawStringCharacter(int32_t ch, int32_t chNext)
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RAW_STRING)
	{
		if (ch == '"')
		{
			if (chNext == '"')
			{
				// "" in a raw string means single "
				m_pchToken[m_nTokenCharacters++] = '"';
				if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
				{
					return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
				}
				return 1; // consume 1 more
			}

			// Otherwise, terminate string literal.
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_STRING;
			return HandleToken();
		}

		m_pchToken[m_nTokenCharacters++] = (char) ch;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			return STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}

		return 0;
	}

	return STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterQuotationMark()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a quotation mark for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterQuotationMark()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_STRING;
		m_nTokenCharacters = 0;
		nReturnValue = 0;
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
	{
		// Quotation Mark terminates the string.
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterHyphen()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a hyphen for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterHyphen(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MINUS;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else if (chNext == '-')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_DECREMENT;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_MINUS;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}

	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterLeftBrace()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a left brace for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterLeftBrace()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_LEFT_BRACE;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterRightBrace()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a right brace for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterRightBrace()
{
	int32_t nReturnValue = 0;
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterLeftBracket()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a left bracket for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterLeftBracket()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterRightBracket()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a right bracket for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterRightBracket()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterLeftSquareBracket()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 10/16/2000
//  Description:  Compiles a left bracket for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterLeftSquareBracket()
{
	int32_t nReturnValue = 0;
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_LEFT_SQUARE_BRACKET;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterRightSquareBracket()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 10/16/2000
//  Description:  Compiles a left bracket for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterRightSquareBracket()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterRightAngle()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a right angle for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterRightAngle(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			// Token is >=
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_GREATER_EQUAL;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else if (chNext == '>')
		{
			// Token is at least >> ... so keep going.
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_SHIFT_RIGHT;
			nReturnValue = 0;
		}
		else
		{
			// Token is >
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_GREATER_THAN;
			nReturnValue = HandleToken();
		}
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SHIFT_RIGHT)
	{

		if (chNext == '>')
		{
			// Token is at least >>> ... so keep going.
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_UNSIGNED_SHIFT_RIGHT;
			nReturnValue = 0;
		}
		else if (chNext == '=')
		{
			// Token is >>=
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_RIGHT;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			// Token is >>
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_SHIFT_RIGHT;
			nReturnValue = HandleToken();
		}
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNSIGNED_SHIFT_RIGHT)
	{
		if (chNext == '=')
		{
			// Token is >>>=
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_USHIFT_RIGHT;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			// Token is >>>
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_UNSIGNED_SHIFT_RIGHT;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterLeftAngle()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a left angle for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterLeftAngle(int32_t chNext)
{
	int32_t nReturnValue = 0;
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_LESS_EQUAL;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else if (chNext == '<')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_SHIFT_LEFT;
			return 0;  // DO NOT REMOVE THE NEXT CHARACTER OR CALL HANDLETOKEN().
			// That guarantees we visit the code later on in this function!
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_LESS_THAN;
			nReturnValue = HandleToken();
		}
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_SHIFT_LEFT)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_LEFT;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_SHIFT_LEFT;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterExclamationPoint()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles an exclamation point for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterExclamationPoint(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_NOT_EQUAL;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_BOOLEAN_NOT;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterEqualSign()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles an equal sign for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterEqualSign(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COND_EQUAL;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterPlusSign()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles an plus sign for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterPlusSign(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_PLUS;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else if (chNext == '+')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_INCREMENT;
			int nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_PLUS;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterPercentSign()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a percent sign for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterPercentSign(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MODULUS;
			int32_t nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			nReturnValue = 1;
		}
		else
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_MODULUS;
			nReturnValue = HandleToken();
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterSemicolon()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a semicolon for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterSemicolon()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_SEMICOLON;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;

}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterCarat()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a carat for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterCarat(int32_t chNext)
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		if (chNext == '=')
		{
			m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_XOR;
			int32_t nHandleReturn = HandleToken();
			if (nHandleReturn < 0)
			{
				return nHandleReturn;
			}
			return 1;
		}

		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_EXCLUSIVE_OR;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterTilde()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 08/13/99
//  Description:  Compiles a tilde for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterTilde()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_TILDE;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterComma()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Compiles a comma for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterComma()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COMMA;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterEllipsis()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/14/2000
//  Description:  Compiles an ellipsis for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterEllipsis()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_IDENTIFIER;
		m_nTokenCharacters = 0;
		m_pchToken[m_nTokenCharacters] = '#';
		++m_nTokenCharacters;
		if (m_nTokenCharacters >= CSCRIPTCOMPILER_MAX_TOKEN_LENGTH)
		{
			nReturnValue = STRREF_CSCRIPTCOMPILER_ERROR_TOKEN_TOO_LONG;
		}
		else
		{
			nReturnValue = 0;
		}
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterQuestionMark()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/23/2001
//  Description:  Compiles a question mark for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterQuestionMark()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_QUESTION_MARK;
		nReturnValue = HandleToken();
	}
	else
	{
		int nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseCharacterColon()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 02/23/2001
//  Description:  Compiles a colon for use by tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseCharacterColon()
{
	int32_t nReturnValue = 0;

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_UNKNOWN)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_COLON;
		nReturnValue = HandleToken();
	}
	else
	{
		int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_UNEXPECTED_CHARACTER;
		nReturnValue = nError;
	}
	return nReturnValue;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::HandleToken()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Determines what to do with a "complete" token.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::HandleToken()
{
	// Do something with the token.
	int32_t nReturnValue;

	if (m_bCompileIdentifierList == TRUE)
	{
		nReturnValue = GenerateIdentifierList();
	}
	else
	{
		nReturnValue = GenerateParseTree();
	}

	if (m_nNextParseTreeFileName >= CSCRIPTCOMPILER_MAX_TABLE_FILENAMES)
	{
		nReturnValue = STRREF_CSCRIPTCOMPILER_ERROR_INCLUDE_TOO_MANY_LEVELS;
	}

	if (nReturnValue < 0)
	{
		return nReturnValue;
	}

	TokenInitialize();
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::TestIdentifierToken()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 01/09/2001
//  Description:  Tests the token and determines what the correct state for
//                the node is.  (This was removed from HandleIdentifierToken()
//                because we need to make use of this during the handling
//                of global variable declarations).
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::TestIdentifierToken()
{

	char cTemp = m_pchToken[m_nTokenCharacters];
	m_pchToken[m_nTokenCharacters] = 0;
	int32_t nHashLocation = GetHashEntryByName(m_pchToken);
	m_pchToken[m_nTokenCharacters] = cTemp;

	if (nHashLocation == STRREF_CSCRIPTCOMPILER_ERROR_UNDEFINED_IDENTIFIER)
	{
		if (m_pchToken[0] == '#')
		{
			int32_t nError = STRREF_CSCRIPTCOMPILER_ERROR_ELLIPSIS_IN_IDENTIFIER;
			return nError;
		}
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_VARIABLE;
		return 0;
	}

	int32_t nIdentifierType = m_pIdentifierHashTable[nHashLocation].m_nIdentifierType;
	int32_t nIdentifierIndex = m_pIdentifierHashTable[nHashLocation].m_nIdentifierIndex;

	if (nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER)
	{
		if (m_pcIdentifierList[nIdentifierIndex].m_nIdentifierType == 1)
		{
			// We just need to set the right type, based on the "return type" of
			// the identifier, to allow the code to compile this properly.
			m_nTokenStatus = m_pcIdentifierList[nIdentifierIndex].m_nReturnType;
		}
		else
		{
			if (m_pcIdentifierList[nIdentifierIndex].m_nReturnType == CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER)
			{
				m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_INTEGER;
			}
			else if (m_pcIdentifierList[nIdentifierIndex].m_nReturnType == CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER)
			{
				m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_FLOAT;
			}
			else if (m_pcIdentifierList[nIdentifierIndex].m_nReturnType == CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER)
			{
				m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_STRING;
			}
			// Copy from the "defined" constant to m_pcIdentifierList
			int32_t nSize = m_pcIdentifierList[nIdentifierIndex].m_psStringData.GetLength();
			int32_t nCount2;
			for (nCount2 = 0; nCount2 < nSize; nCount2++)
			{
				m_pchToken[nCount2] = ((m_pcIdentifierList[nIdentifierIndex].m_psStringData).CStr())[nCount2];
			}
			m_nTokenCharacters = nSize;
		}
	}
	else if (nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD)
	{
		m_nTokenStatus = m_pcKeyWords[nIdentifierIndex].GetTokenToTranslate();
	}
	else  // if (nIdentifierType == CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0 + nIdentifierIndex;
	}

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::HandleIdentifierToken()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  Deals with identifier tokens.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::HandleIdentifierToken()
{
	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_IDENTIFIER)
	{
		int32_t nReturnValue = TestIdentifierToken();
		if (nReturnValue != 0)
		{
			return nReturnValue;
		}
	}

	return HandleToken();
}

///////////////////////////////////////////////////////////////////////////////
//  CScriptCompiler::ParseNextCharacter()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Mark Brockington
//  Created On: 07/22/99
//  Description:  With a "one-character look ahead" (chNext), determine what
//                type of token is expressed by the character in ch and the
//                character in chNext.
///////////////////////////////////////////////////////////////////////////////

int32_t CScriptCompiler::ParseNextCharacter(int32_t ch, int32_t chNext, char *pScript, int32_t nScriptLength)
{

	if (ch == -1)
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_EOF;
		int nHandleTokenReturn = HandleToken();
		if (nHandleTokenReturn < 0)
		{
			return nHandleTokenReturn;
		}
		return 0;
	}


	// Deal with commented out code.

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_CPLUSCOMMENT ||
	        m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_CCOMMENT)
	{
		// Deal with next character.
		return ParseCommentedOutCharacter(ch);
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_STRING)
	{
		return ParseStringCharacter(ch,chNext, pScript, nScriptLength);
	}

	if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_RAW_STRING)
	{
		return ParseRawStringCharacter(ch, chNext);
	}

	if ((ch == 'r' || ch == 'R') && chNext == '"')
	{
		m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_RAW_STRING;
		m_nTokenCharacters = 0;
		return 1; // consume r"
	}

	// Handle the tokens associated with integer and real numbers.
	// Note that we terminate the current token if we are currently
	// building an integer or a real number, and we've received a non
	// numeric token.  This is VERY important.

	if (ch >= '0' && ch <= '9')
	{
		return ParseCharacterNumeric(ch);
	}
	else if (ch == '.')
	{
		return ParseCharacterPeriod(chNext);
	}
	else if ((ch == 'x' || ch == 'X') &&
	         m_nTokenCharacters == 1 &&
	         m_pchToken[0] == '0')
	{
		return ParseCharacterAlphabet(ch);
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER || m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_FLOAT)
	{
		int32_t nCompiledCharacters = 0;
		// Compile all suffixes that make sense.
		if (ch == 'f')
		{
			if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_INTEGER)
			{
				m_nTokenStatus = CSCRIPTCOMPILER_TOKEN_FLOAT;
			}
			nCompiledCharacters = 1;
		}

		int nReturnValue = HandleToken();
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
		else if (nCompiledCharacters > 0)
		{
			return nCompiledCharacters - 1;
		}
	}

	// For similar reasons, we deal with alphabetic characters and then
	// we deal with the abrupt termination of a letter.

	if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_')
	{
		return ParseCharacterAlphabet(ch);
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_IDENTIFIER)
	{
		int nReturnValue = HandleIdentifierToken();
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
	}
	else if (m_nTokenStatus == CSCRIPTCOMPILER_TOKEN_HEX_INTEGER)
	{
		int nReturnValue = HandleToken();
		if (nReturnValue < 0)
		{
			return nReturnValue;
		}
	}

	if (ch == '/')
	{
		return ParseCharacterSlash(chNext);
	}
	else if (ch == '*')
	{
		return ParseCharacterAsterisk(chNext);
	}
	else if (ch == '&')
	{
		return ParseCharacterAmpersand(chNext);
	}
	else if (ch == '|')
	{
		return ParseCharacterVerticalBar(chNext);
	}

	// Toss out blank space.
	if (ch == ' ' || ch == '\n' || ch == '\t')
	{
		return 0;
	}

	if (ch == '"')
	{
		return ParseCharacterQuotationMark();
	}
	if (ch == '-')
	{
		return ParseCharacterHyphen(chNext);
	}
	if (ch == '{')
	{
		return ParseCharacterLeftBrace();
	}
	if (ch == '}')
	{
		return ParseCharacterRightBrace();
	}
	if (ch == '(')
	{
		return ParseCharacterLeftBracket();
	}
	if (ch == ')')
	{
		return ParseCharacterRightBracket();
	}

	if (ch == '[')
	{
		return ParseCharacterLeftSquareBracket();
	}
	if (ch == ']')
	{
		return ParseCharacterRightSquareBracket();
	}

	if (ch == '<')
	{
		return ParseCharacterLeftAngle(chNext);
	}
	if (ch == '>')
	{
		return ParseCharacterRightAngle(chNext);
	}
	if (ch == '!')
	{
		return ParseCharacterExclamationPoint(chNext);
	}
	if (ch == '=')
	{
		return ParseCharacterEqualSign(chNext);
	}
	if (ch == '+')
	{
		return ParseCharacterPlusSign(chNext);
	}
	if (ch == '%')
	{
		return ParseCharacterPercentSign(chNext);
	}
	if (ch == ';')
	{
		return ParseCharacterSemicolon();
	}
	if (ch == ',')
	{
		return ParseCharacterComma();
	}
	if (ch == '^')
	{
		return ParseCharacterCarat(chNext);
	}
	if (ch == '~')
	{
		return ParseCharacterTilde();
	}
	if (ch == '#')
	{
		return ParseCharacterEllipsis();
	}
	if (ch == '?')
	{
		return ParseCharacterQuestionMark();
	}
	if (ch == ':')
	{
		return ParseCharacterColon();
	}

	return 0;
}
