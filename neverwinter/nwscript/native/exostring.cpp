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

// This file is a reduced variant taken from the base game.
// Do not port changes here back to the game unless needed for script compiler functionality.

///////////////////////////////////////////////////////////////////////////////
//                 BIOWARE CORP. CONFIDENTIAL INFORMATION.                   //
//               COPYRIGHT BIOWARE CORP. ALL RIGHTS RESERVED                 //
///////////////////////////////////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////////
//::
//::  ExoBase
//::
//::  Copyright (c) 1999, BioWare Corp.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  ExoString.cpp
//::
//::  String Class
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Don Yakielashek
//::  Created On: 04/26/99
//::
//::///////////////////////////////////////////////////////////////////////////
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <time.h>
#include <math.h>

#include <vector>
#include <string>
#include <sstream>
#include <iterator>

// external header files
#include "exobase.h"

// We include xxhash.c transitively through other libs which aren't always present (hello borland and macos ARM)
// So rather than wrangling with the build system, we'll just inline the XXH32 function here. It's small enough.
#define XXH_INLINE_ALL
#include "xxhash.h"

//::///////////////////////////////////////////////////////////////////////////
//::
//::  class CExoString
//::
//::///////////////////////////////////////////////////////////////////////////

const char* CExoString::Whitespace   = " \t\v\r\n\f";
const char* CExoString::Letters      = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
const char* CExoString::Numbers      = "0123456789";
const char* CExoString::Alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

///////////////////////////////////////////////////////////////////////////////
//  CExoString::CExoString()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/26/99
//  Description:Constructor
///////////////////////////////////////////////////////////////////////////////

// Creates an empty CExoString
CExoString::CExoString()
{
	m_sString = NULL;
	m_nBufferLength = 0;
}

// Creates a CExsoString from a null terminated character array
CExoString::CExoString(const char *source)
{
	if (source && ( strlen( source ) > 0 ))
	{
        m_nBufferLength = (uint32_t)strlen(source) + 1;
		m_sString = new char[m_nBufferLength];
		strcpy(m_sString, source);
	}
	else
	{
		m_sString = NULL;
		m_nBufferLength = 0;
	}
}

//Creates a copy of a CExoString
CExoString::CExoString(const CExoString &source)
{
	int32_t nSize = 1;
	if (source.m_sString && ( strlen( source.m_sString ) > 0 ) )
	{
        m_nBufferLength = (uint32_t)strlen(source.m_sString) + 1;
		m_sString = new char[m_nBufferLength];
		strcpy(m_sString, source.m_sString);
	}
	else
	{
		m_sString = NULL;
		m_nBufferLength = 0;
	}
}

// Creates a CExoString that contains the first len characters of a CExoString
CExoString::CExoString(const char *source, int32_t length)
{
	if ( length > 0 )
	{
		m_nBufferLength = length + 1;
		m_sString = new char[m_nBufferLength];
		strncpy(m_sString, source, length);
		m_sString[length] = '\0';
	}
	else
	{
		m_sString = NULL;
		m_nBufferLength = 0;
	}
}

// Creates a CExoString representing the int value
CExoString::CExoString(int32_t value)
{
	char buffer[33];

	sprintf( buffer, "%i", value );

    m_nBufferLength = (uint32_t)strlen(buffer) + 1;
	m_sString = new char[m_nBufferLength];
	strcpy(m_sString, buffer);

}


///////////////////////////////////////////////////////////////////////////////
//  CExoString::~CExoString()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/26/99
//  Description:Destructor
///////////////////////////////////////////////////////////////////////////////
CExoString::~CExoString()
{
	Clear();
}

CExoString::CExoString(const std::string& other)
{
    if (!other.empty())
    {
        m_nBufferLength = other.size() + 1;
        m_sString = new char[m_nBufferLength];
        memmove(m_sString, other.data(), m_nBufferLength - 1);
        m_sString[m_nBufferLength - 1] = '\0';
    }
    else
    {
        m_sString = NULL;
        m_nBufferLength = 0;
    }
}

CExoString& CExoString::operator=(const std::string& other)
{
    if (other.size() > m_nBufferLength - 1)
    {
        delete[] m_sString;
        m_sString = NULL;
    }

    if (!other.empty())
    {
        m_nBufferLength = other.size() + 1;
        m_sString = new char[m_nBufferLength];
        memmove(m_sString, other.data(), m_nBufferLength - 1);
        m_sString[m_nBufferLength - 1] = '\0';
    }
    else
    {
        m_sString = NULL;
        m_nBufferLength = 0;
    }

    return *this;
}

CExoString::operator std::string() const
{
    return m_nBufferLength == 0 ? std::string("") : std::string(m_sString, strlen(m_sString));
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString:: = operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/26/99
//  Description:Assign operator
///////////////////////////////////////////////////////////////////////////////

// Assigning one CExoString to another
CExoString & CExoString::operator = (const CExoString& string)
{
	if (this == &string)
	{
		return *this;
	}

	if (m_sString)
	{
		if (!string.m_sString ||
		        strlen(string.m_sString) + 1 > m_nBufferLength)
		{
			Clear();
		}
	}

	if (string.m_sString && ( strlen( string.m_sString ) > 0 ))
	{
		if (m_sString == NULL)
		{
            m_nBufferLength = (uint32_t)strlen(string.m_sString) + 1;
			m_sString = new char[m_nBufferLength];
		}
		strcpy(m_sString, string.m_sString);
	}
	else
	{
		Clear();
	}
	return *this;
}

// Assigning the value of a null terminated character array to a CExoString
CExoString & CExoString::operator = (const char *string)
{
	if (m_sString)
	{
		if (!string ||
		        strlen(string) + 1 > m_nBufferLength)
		{
			Clear();
		}
	}

	if (string && ( strlen( string ) > 0 ))
	{
		if (m_sString == NULL)
		{
            m_nBufferLength = (uint32_t)strlen(string) + 1;
			m_sString = new char[m_nBufferLength];
		}
		strcpy(m_sString, string);
	}
	else
	{
		Clear();
	}
	return *this;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: == operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/26/99
//  Description:Equality operator
///////////////////////////////////////////////////////////////////////////////

// Compares two CExoString's
BOOL CExoString::operator == (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) == 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string.m_sString == NULL ) ) ||
		         ( m_sString && ( m_sString[0] == '\0' ) ) ||
		         ( string.m_sString && ( string.m_sString[0] == '\0' ) ) );
	}
}

// Compares a CExoString to a null terminated character array
BOOL CExoString::operator == (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) == 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string == NULL ) ) ||
		         ( m_sString && ( m_sString[0] == '\0' ) ) ||
		         ( string && ( string[0] == '\0' ) ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: != operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Not Equals operator
///////////////////////////////////////////////////////////////////////////////

// Determines if two CExoString's are not equal
BOOL CExoString::operator != (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) != 0);
	}
	else
	{
		return ( ( m_sString && ( m_sString[0] != '\0' ) ) ||
		         ( string.m_sString && ( string.m_sString[0] != '\0' ) ) );
	}
}

// Determines if CExoString is not equal to a null terminated character array
BOOL CExoString::operator != (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) != 0);
	}
	else
	{
		return ( ( m_sString && ( m_sString[0] != '\0' ) ) ||
		         ( string && ( string[0] != '\0' ) ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: < operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Less than operator
///////////////////////////////////////////////////////////////////////////////

// Determines if CExoString is less than another CExoString
BOOL CExoString::operator < (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) < 0);
	}
	else
	{
		return ( string.m_sString && ( string.m_sString[0] != '\0' ) );
	}
}

// Determines if CExoString is less than a null terminated character array
BOOL CExoString::operator < (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) < 0);
	}
	else
	{
		return ( string && ( string[0] != '\0' ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: > operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Greater than operator
///////////////////////////////////////////////////////////////////////////////

// Determines if CExoString is greater than another CExoString
BOOL CExoString::operator > (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) > 0);
	}
	else
	{
		return ( m_sString && ( m_sString[0] != '\0' ) );
	}
}

// Determines if CExoString is greater than a null terminated character array
BOOL CExoString::operator > (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) > 0);
	}
	else
	{
		return ( m_sString && ( m_sString[0] != '\0' ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: <= operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Less than or equal to operator
///////////////////////////////////////////////////////////////////////////////

// Determines if CExoString is less than or equal to another CExoString
BOOL CExoString::operator <= (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) <= 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string.m_sString == NULL ) ) ||
		         ( m_sString && ( m_sString[0] == '\0' ) ) ||
		         ( string.m_sString ) );
	}
}

// Determines if CExoString is less then or equal to a null terminated character array
BOOL CExoString::operator <= (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) <= 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string == NULL ) ) ||
		         ( m_sString && ( m_sString[0] == '\0' ) ) ||
		         ( string ) );
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString:: >= operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Greater than or equal to operator
///////////////////////////////////////////////////////////////////////////////

// Determines if CExoString is greater than or equal to another CExoString
BOOL CExoString::operator >= (const CExoString &string) const
{
	if ( m_sString && string.m_sString )
	{
		return (strcmp(m_sString, string.m_sString) >= 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string.m_sString == NULL ) ) ||
		         ( string.m_sString && ( string.m_sString[0] == '\0' ) ) ||
		         ( m_sString ) );
	}
}

// Determines if CExoString is greater then or equal to a null terminated character array
BOOL CExoString::operator >= (const char *string) const
{
	if ( m_sString && string )
	{
		return (strcmp(m_sString, string) >= 0);
	}
	else
	{
		return ( ( ( m_sString == NULL ) && ( string == NULL ) ) ||
		         ( string && ( string[0] == '\0' ) ) ||
		         ( m_sString ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: [] operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Retuns character at position
///////////////////////////////////////////////////////////////////////////////
char CExoString::operator [] (int32_t position) const
{
	if ((position < 0) || !m_sString || (strlen(m_sString) <= ((uint32_t) position)))
	{
		return '\0';
	}
	else
	{
		return m_sString[position];
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: + operator
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/30/99
//  Description:Joins two strings
///////////////////////////////////////////////////////////////////////////////

// Returns the result of two CExoString joined together
CExoString CExoString::operator + (const CExoString &string) const
{
	CExoString newStr;
	uint32_t stringLength, m_sStringLength;

	if ( string.m_sString )
	{
        stringLength = (uint32_t)strlen(string.m_sString);
	}
	else
	{
		stringLength = 0;
	}

	if ( m_sString )
	{
        m_sStringLength = (uint32_t)strlen(m_sString);
	}
	else
	{
		m_sStringLength = 0;
	}

	if ( ( stringLength == 0 ) && ( m_sStringLength == 0 ) )
	{
		return newStr;
	}

	if (newStr.m_sString)
	{
		// MGB - November 27, 2001 - Should never call this.
		EXOASSERT(FALSE);
		delete[] newStr.m_sString;
		newStr.m_sString = NULL;
		newStr.m_nBufferLength = 0;
	}

	if (stringLength == 0)
	{
		newStr.m_nBufferLength = m_sStringLength + 1;
		newStr.m_sString = new char[newStr.m_nBufferLength];

		strcpy(newStr.m_sString, m_sString);
		return newStr;
	}

	if (m_sStringLength == 0)
	{
		newStr.m_nBufferLength = stringLength + 1;
		newStr.m_sString = new char[newStr.m_nBufferLength];

		strcpy(newStr.m_sString, string.m_sString);
		return newStr;
	}

	newStr.m_nBufferLength = m_sStringLength + stringLength + 1;
	newStr.m_sString = new char[newStr.m_nBufferLength];
	strcpy(newStr.m_sString, m_sString);
	strcat(newStr.m_sString, string.m_sString);
	return newStr;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: AsINT()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Howard Chung
//  Created On: 05/15/2001
//  Desc:       Retuns integer value the string represents.
///////////////////////////////////////////////////////////////////////////////
int32_t CExoString::AsINT() const
{
	if ( m_sString )
	{
		return atoi( m_sString );
	}
	else
	{
		return 0;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString:: AsINT()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Howard Chung
//  Created On: 05/15/2001
//  Desc:       Retuns float value the string represents.
///////////////////////////////////////////////////////////////////////////////
float CExoString::AsFLOAT() const
{
	if ( m_sString )
	{
		return (float)atof( m_sString );
	}
	else
	{
		return 0.0f;
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: CStr()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/27/99
//  Description:Retuns a null terminated character array
///////////////////////////////////////////////////////////////////////////////
static char g_szEmptyString[1] = { 0 };
char* CExoString::CStr() const
{
	//EXOWARNINGSTR( m_sString != NULL, "CExoString::CStr(): Obtaining NULL pointer from CExoString." );

	if ( m_sString == NULL )
	{
		return g_szEmptyString;
	}

	return m_sString;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: Find()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 05/27/99
//  Description:Finds a substring within the string
///////////////////////////////////////////////////////////////////////////////
int32_t CExoString::Find(const CExoString &string, int32_t position) const
{
	int32_t cnt, matchLen;
	char *pChar;

	if ( !m_sString || !string.m_sString || position < 0 )
	{
		return -1;
	}

	pChar = m_sString;
	for (cnt=0; cnt<position; cnt++)
	{
		if (*pChar == 0)    // position is past the end of the string
		{
			return -1;
		}
		pChar++;
	}

	cnt = 0;
	matchLen = string.GetLength();
	while (pChar[cnt] != 0)
	{
		if (string.m_sString[cnt] == 0) // match found
		{
			return (int32_t)(pChar - m_sString);
		}
		if (pChar[cnt] != string.m_sString[cnt])    // not a match, move the start by 1 char
		{
            pChar++;
			cnt = 0;
		}
		else
		{
			cnt++;
		}
	}
	if (string.m_sString[cnt] == 0) // match found at the end of the string
	{
		return (int32_t)(pChar - m_sString);
	}
	return -1;
}


int32_t CExoString::Find(char ch, int32_t position) const
{
	char *pChar;
	int32_t   nPos = position, cnt;

	if ( !m_sString || position < 0 )
	{
		return -1;
	}

	pChar = m_sString;
	for (cnt=0; cnt<position; cnt++)
	{
		if (*pChar == 0)    // position is past the end of the string
		{
			return -1;
		}
		pChar++;
	}

	while (*pChar != 0)
	{
		if (*pChar == ch)
		{
			return nPos;
		}
        nPos++;
        pChar++;
	}

	return -1;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString::FindNot
///////////////////////////////////////////////////////////////////////////////
//  Owned by:   Daniel Morris
//  Created on: Jan/10/2002
//  Description:Finds the first character that is not ch
///////////////////////////////////////////////////////////////////////////////
int32_t CExoString::FindNot(char ch, int32_t position) const
{
	char *pChar;
	int32_t   nPos = position, cnt;

	if ( !m_sString || position < 0  )
	{
		return -1;
	}

	pChar = m_sString;
	for (cnt=0; cnt<position; cnt++)
	{
		if (*pChar == 0)    // position is past the end of the string
		{
			return -1;
		}
		pChar++;
	}

	while (*pChar != 0)
	{
		if (*pChar != ch)
		{
			return nPos;
		}
        nPos++;
        pChar++;
	}

	return -1;
}

CExoString CExoString::RemoveAll(const char* c) const
{
    if (!m_sString) return "";

    CExoString ret = *this;

    size_t j = 0;
    const auto n = strlen(ret.m_sString);
    for (size_t i = j = 0; i < n; i++)
    {
        if (!strchr(c, ret.m_sString[i]))
        {
            ret.m_sString[j++] = ret.m_sString[i];
        }
    }

    ret.m_sString[j] = '\0';
    return ret;
}

CExoString CExoString::RemoveAllExcept(const char* c) const
{
    if (!m_sString) return "";

    CExoString ret = *this;

    size_t j = 0;
    const auto n = strlen(ret.m_sString);
    for (size_t i = j = 0; i < n; i++)
    {
        if (strchr(c, ret.m_sString[i]))
        {
            ret.m_sString[j++] = ret.m_sString[i];
        }
    }

    ret.m_sString[j] = '\0';
    return ret;
}

static thread_local char *CExoStringFormatBuffer = 0;
static thread_local int32_t   CExoStringFormatBufferSize = 0;

///////////////////////////////////////////////////////////////////////////////
//  CExoString:: Format()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 05/4/99
//  Description:Formats a string based on a number of arguments like sprintf does
///////////////////////////////////////////////////////////////////////////////
void CExoString::Format(const char *format,...)
{
	va_list argList;

	va_start(argList, format);
	int32_t requiredSize = vsnprintf( NULL, 0, format, argList ) + 1;
	va_end(argList);

	va_start(argList, format);

#ifdef WIN32
	// ************* NOTE*****************
	// need to determine size of buffer required for sprintf
	// ideally I want to use vsnprintf which returns the required buffer size when
	// a maxsize of 0 is passed in but the Microsoft implementation doesn't do this.
	// The microsoft code returns -1 if the buffer isn't big enough
	// So we have a evil hack.
	//    - going to assume the size is les than 1024 chars and grow it bigger if we need.
	//    - after  successful sprintf we will create a new buffer the exact size and copy

	if (CExoStringFormatBuffer == 0 && CExoStringFormatBufferSize == 0)
	{
		CExoStringFormatBufferSize = 1024;
		CExoStringFormatBuffer = new char[CExoStringFormatBufferSize];
	}

	requiredSize = _vsnprintf(CExoStringFormatBuffer, CExoStringFormatBufferSize, format, argList) + 1;
	if (requiredSize < 0) // error condition
	{
		return;
	}

	while (requiredSize <= 0)
	{
		CExoStringFormatBufferSize += 1024;
		if (CExoStringFormatBuffer)
		{
			delete[] CExoStringFormatBuffer;
		}
		CExoStringFormatBuffer = new char[CExoStringFormatBufferSize];

		requiredSize = _vsnprintf(CExoStringFormatBuffer, CExoStringFormatBufferSize, format, argList) + 1;
	}
#else

#endif // WIN32

	if ((CExoStringFormatBuffer == 0) || (CExoStringFormatBufferSize < requiredSize))
	{
		if (CExoStringFormatBuffer)
		{
			delete[] CExoStringFormatBuffer;
		}
		CExoStringFormatBufferSize = (requiredSize + 256);
		CExoStringFormatBuffer = new char[CExoStringFormatBufferSize];
	}

	if ( !CExoStringFormatBuffer )
	{
		return;
	}

	vsnprintf( CExoStringFormatBuffer, requiredSize, format, argList );

	// copy from CExoStringFormatBuffer to string
	// allocate new string, if necessary.
	if (m_sString == NULL ||
	        (uint32_t)requiredSize + 1 > m_nBufferLength)
	{
		Clear();
		m_nBufferLength = requiredSize + 1;
		m_sString = new char[m_nBufferLength];
	}

	strncpy(m_sString, CExoStringFormatBuffer, requiredSize);
	m_sString[requiredSize] = 0;

	va_end(argList);
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString:: Insert()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Inserts a string at the given position
///////////////////////////////////////////////////////////////////////////////

void CExoString::Insert(const CExoString &string, int32_t position)
{
	char *newStr, *pStr;
	uint32_t stringLength, m_sStringLength;

	if ( !string.m_sString )
	{
		return;
	}

    stringLength = (uint32_t)strlen(string.m_sString);

	if ( m_sString )
	{
        m_sStringLength = (uint32_t)strlen(m_sString);
	}
	else
	{
		m_sStringLength = 0;
	}

	if (stringLength == 0)
	{
		return;
	}

	if ((position < 0) || (m_sStringLength <= ((uint32_t) position)))
	{
		return;
	}

	// allocate new string
    m_nBufferLength = m_sStringLength + stringLength + 1;
	newStr = new char[m_nBufferLength];
	newStr[0] = '\0';

	// swap pointer to existing string with pointer to new string
	pStr        = m_sString;
	m_sString   = newStr;
	newStr      = pStr;

	// insert string
	if ( pStr )
	{
		strncpy(m_sString, pStr, position);
	}
	m_sString[position] = '\0';
	strcat(m_sString, string.m_sString);
	strcat(m_sString, &pStr[position]);

	// delete old string
	if (pStr)
	{
		delete[] pStr;
	}
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: IsEmpty()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Checks if CExoString is a blank string
///////////////////////////////////////////////////////////////////////////////

BOOL CExoString::IsEmpty() const
{
	return ( !m_sString || (m_sString[0] == '\0') );
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: Left()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/28/99
//  Description:Returns Leftmost 'count' characters
///////////////////////////////////////////////////////////////////////////////

CExoString CExoString::Left(int32_t count) const
{
	CExoString newStr;
	int32_t count2;
	uint32_t m_sStringLength;

	if ( !m_sString )
	{
		return newStr;
	}

    m_sStringLength = (uint32_t)strlen(m_sString);

	count2 = count;

	if (count2 < 0)
	{
		return newStr;
	}

	if (m_sStringLength == 0)
	{
		return newStr;
	}
	if (((uint32_t) count2) > m_sStringLength)
	{
		count2 = m_sStringLength;
	}

	if (newStr.m_sString)
	{
		delete[] newStr.m_sString;
	}
	newStr.m_sString = new char[count2+1];
	strncpy(newStr.m_sString, m_sString, count2);
	newStr.m_sString[count2] = '\0';
	return newStr;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: LowerCase()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 05/28/99
//  Description:Returns the string converted to lowsercase
///////////////////////////////////////////////////////////////////////////////
CExoString CExoString::LowerCase() const
{
	CExoString newStr;
	int32_t nPos;

	if ( !m_sString )
	{
		return newStr;
	}

	newStr.m_nBufferLength = GetLength() + 1;
	newStr.m_sString = new char[newStr.m_nBufferLength];
	nPos = 0;
	while (m_sString[nPos] != 0)
	{
        if (m_sString[nPos] >= 'A' && m_sString[nPos] <= 'Z')
        {
            newStr.m_sString[nPos] = m_sString[nPos] - 'A' + 'a';
        }
        else
        {
            newStr.m_sString[nPos] = m_sString[nPos];
        }
        nPos++;
	}
	newStr.m_sString[nPos] = 0;

	return newStr;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: Right()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 04/30/99
//  Description:Returns Rightmost 'count' characters
///////////////////////////////////////////////////////////////////////////////

CExoString CExoString::Right(int32_t count) const
{
	CExoString newStr;
	int32_t count2;
	uint32_t m_sStringLength;

	if ( !m_sString )
	{
		return newStr;
	}

    m_sStringLength = (uint32_t)strlen(m_sString);

	count2 = count;

	if (count2 < 0)
	{
		return newStr;
	}
	if (m_sStringLength == 0)
	{
		return newStr;
	}
	if (((uint32_t) count2) > m_sStringLength)
	{
		count2 = m_sStringLength;
	}

	if (newStr.m_sString)
	{
		delete[] newStr.m_sString;
	}
	newStr.m_sString = new char[count2+1];
	strncpy(newStr.m_sString, &(m_sString[m_sStringLength-count2]), count2);
	newStr.m_sString[count2] = '\0';
	return newStr;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: SubString()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 05/27/99
//  Description:Returns a portion of string consisting of 'count' characters
//              starting at 'start', count<0 means extract to end of string
///////////////////////////////////////////////////////////////////////////////
CExoString CExoString::SubString(int32_t start, int32_t count) const
{
	CExoString newStr;
	int32_t count2;
	uint32_t m_sStringLength;

	if ( !m_sString )
	{
		return newStr;
	}

    m_sStringLength = (uint32_t)strlen(m_sString);

	if ((start < 0) || (((uint32_t)start) >= m_sStringLength) || (count==0))
	{
		return newStr;
	}

	if (count < 0)  // extract to end of string
	{
		count = m_sStringLength - start;
	}

	count2 = count;

	if (((uint32_t) start + count2) > m_sStringLength)
	{
		count2 = m_sStringLength - start;
	}

	if (newStr.m_sString)
	{
		delete[] newStr.m_sString;
	}
	newStr.m_sString = new char[count+1];
	newStr.m_nBufferLength = count+1;

	strncpy(newStr.m_sString, &(m_sString[start]), count);
	newStr.m_sString[count] = '\0';
	return newStr;
}


///////////////////////////////////////////////////////////////////////////////
//  CExoString:: UpperCase()
///////////////////////////////////////////////////////////////////////////////
//  Created By: Don Yakielashek
//  Created On: 05/28/99
//  Description:Returns the string converted to uppercase
///////////////////////////////////////////////////////////////////////////////
CExoString CExoString::UpperCase() const
{
	CExoString newStr;
	int32_t nPos;

	if ( !m_sString )
	{
		return newStr;
	}

	newStr.m_nBufferLength = GetLength() + 1;
	newStr.m_sString = new char[newStr.m_nBufferLength];
	nPos = 0;
	while (m_sString[nPos] != 0)
	{
        if (m_sString[nPos] >= 'a' && m_sString[nPos] <= 'z')
        {
            newStr.m_sString[nPos] = m_sString[nPos] - 'a' + 'A';
        }
        else
        {
            newStr.m_sString[nPos] = m_sString[nPos];
        }
        nPos++;
	}
	newStr.m_sString[nPos] = 0;

	return newStr;
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString::CompareNoCase()
///////////////////////////////////////////////////////////////////////////////
//  Owned By: Mark Brockington
//  Description:Returns whether the two strings are the same, irrespective
//              of case.
///////////////////////////////////////////////////////////////////////////////
BOOL CExoString::CompareNoCase(const CExoString &string) const
{
	char *pStringChar;
	char *pThisStringChar;
	int32_t nLenString, cnt;

	pStringChar = string.m_sString;
	nLenString = string.GetLength();

	pThisStringChar = m_sString;

	if (pStringChar == NULL && pThisStringChar == NULL)
	{
		return TRUE;
	}
	else if (pStringChar == NULL || pThisStringChar == NULL)
	{
		return FALSE;
	}
	else if (nLenString != GetLength())
	{
		return FALSE;
	}

	for (cnt=0; cnt<nLenString; cnt++)
	{
		if (pStringChar[cnt] != pThisStringChar[cnt])
		{
			if (pStringChar[cnt] >= 'A' && pStringChar[cnt] <= 'Z')
			{
				if (pStringChar[cnt] - 'A' + 'a' != pThisStringChar[cnt])
				{
					return FALSE;
				}
			}
			else if (pThisStringChar[cnt] >= 'A' && pThisStringChar[cnt] <= 'Z')
			{
				if (pThisStringChar[cnt] - 'A' + 'a' != pStringChar[cnt])
				{
					return FALSE;
				}
			}
			else
			{
				return FALSE;
			}
		}
	}
	return TRUE;
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString::ComparePrefixNoCase()
///////////////////////////////////////////////////////////////////////////////
//  Owned By: Mark Brockington
//  Description:Returns whether the two strings are the same, irrespective
//              of case.
///////////////////////////////////////////////////////////////////////////////
BOOL CExoString::ComparePrefixNoCase(const CExoString &string, int32_t nSize) const
{
	char *pStringChar = string.CStr();
	char *pThisStringChar = m_sString;

	if (pStringChar == NULL && pThisStringChar == NULL)
	{
		return TRUE;
	}
	else if (pStringChar == NULL || pThisStringChar == NULL)
	{
		return FALSE;
	}

	return !(strnicmp(pStringChar,pThisStringChar,nSize));
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString::StripNonAlphaNumeric
///////////////////////////////////////////////////////////////////////////////
//  Created by: Paul Roffel
//  Created on: April 29, 2002
//  Desc.:      Removes all non-alpha-numeric symbols from the string
///////////////////////////////////////////////////////////////////////////////
BOOL CExoString::StripNonAlphaNumeric( BOOL bFileName, BOOL bEmail, BOOL bMasterServer )
{
	uint32_t cnt, cnt2, max;
	BOOL  bChanged = FALSE;
	char  szTester[128];

	if ( !m_sString )
	{
		return FALSE;
	}

    max = (uint32_t)strlen(m_sString);
	if ( max == 0 )
	{
		return FALSE;
	}

	if ( bFileName )
	{
		strcpy(szTester,
            "abcdefghijklmnopqrstuvwxyz0123456789'"
            "\xdf\xe9\xc9\xe8\xc8\xc7\xe7\xf9\xd9\xf1\xd1\xe0\xc0\xc4\xe4\xdc\xfc\xd6\xf6"
            "_-");
	}
	else
	{
		strcpy( szTester, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" );
	}

	if ( bEmail )
	{
		strcat( szTester, "@." );
	}

	if ( bMasterServer ) // 5/18/02 - PLR - Characters allowed on the master server.
	{
        strcat(szTester,
            ".',"
            "\xdf\xe9\xc9\xe8\xc8\xc7\xe7\xf9\xd9\xf1\xd1\xe0\xc0\xc4\xe4\xdc\xfc\xd6\xf6"
            "_- ");
	}

	for ( cnt = 0; cnt < max ; cnt++ )
	{
		if ( bFileName ) // 5/18/02 - PLR - Filenames must be converted to lowercase now... *sigh*
		{
			if (m_sString[cnt] >= 'A' && m_sString[cnt] <= 'Z')
			{
				m_sString[cnt] = m_sString[cnt] - 'A' + 'a';
			}
		}

        // MGB - August 3, 2016 - Remove all leading spaces and periods.
        if ( (cnt == 0 && (m_sString[cnt] == '.' || m_sString[cnt] == ' ') ) ||
             strchr( szTester, m_sString[cnt] ) == NULL
           )
		{
			for ( cnt2 = cnt ; cnt2 < max ; cnt2++ )
			{
				m_sString[cnt2] = m_sString[cnt2+1];
			}
			cnt--;
			max--;
			bChanged = TRUE;
		}
	}

	return bChanged;
}

CExoString CExoString::Strip(bool leading, bool trailing, const char* set) const
{
    int start = 0;
    int end = GetLength();

	while (leading && start < GetLength() && strchr(set, (*this)[start]))
		start++;

	while (trailing && end > 0 && strchr(set, (*this)[end - 1]))
		end--;

	return SubString(start, end - start);
}

///////////////////////////////////////////////////////////////////////////////
//  CExoString::AsTAG
///////////////////////////////////////////////////////////////////////////////
//  Created by: Paul Roffel
//  Created on: Monday, January 27, 2003
//  Desc.:      Returns the string as a tag.
//              This is directly from code used in the toolset.
//                 TNWGlobal::GetTagFromArbitraryString
///////////////////////////////////////////////////////////////////////////////
CExoString CExoString::AsTAG() const
{
	uint32_t cnt, max;
	CExoString newStr;
	char newBuffer[64];
	int32_t nIndex = 0;

	if ( !m_sString )
	{
		return newStr;
	}

    max = (uint32_t)strlen(m_sString);

	for ( cnt = 0 ; cnt < max ; cnt++ )
	{
		if ( isalnum(m_sString[cnt]) || m_sString[cnt] == '_' )
		{
			newBuffer[nIndex++] = m_sString[cnt];
			if ( nIndex > 62 ) //CNWSTAGNODE_TAG_LENGTH
			{
				break;
			}
		}
	}
	newBuffer[nIndex] = '\0';
	newStr = newBuffer;

#ifdef _DEBUG // 01/27/03 - PLR - Need to debug this properly!
	if ( newStr != m_sString )
	{
		LOGSET("TAG CHANGE ===> (%s) -> (%s)\n", m_sString, newStr.CStr())LOGFLUSH
	}
#endif

	return newStr;
}

int32_t CExoString::GetHash() const
{
	// Having the hash of an empty string return zero is a useful property, so we XOR every
	// hash with the hash of a null string. This has no cryptographic effect since the
	// bit entropy remains the same. Not that XXH is cryptographically secure.
	const static int32_t nullhash = (int32_t)XXH32("", 0, 0);
	return (int32_t)XXH32(CStr(), GetLength(), 0) ^ nullhash;
}


CExoString CExoString::FormatBytes(uint64_t bytes)
{
	CExoString ret;
	const char* suffixes[7];
	suffixes[0] = "B";
	suffixes[1] = "KB";
	suffixes[2] = "MB";
	suffixes[3] = "GB";
	suffixes[4] = "TB";
	suffixes[5] = "PB";
	suffixes[6] = "EB";
	unsigned int s = 0; // which suffix to use
	double count = (double) bytes;
	while (count >= 1024 && s < 7)
	{
		s++;
		count /= 1024;
	}
	if (count - floor(count) == 0.0)
		ret.Format("%d %s", (int)count, suffixes[s]);
	else
		ret.Format("%.1f %s", count, suffixes[s]);
	return ret;
}

CExoString CExoString::FormatDuration(uint64_t span,
                                      int compact_levels,
                                      int min_levels,
                                      bool label_fields,
                                      const char* separator)
{
	const uint64_t days = span / 3600 / 24;
	const uint64_t hours = span / 3600 - (days * 24);
	const uint64_t minutes = span / 60 - (hours * 60) - (days * 24 * 60);
	const uint64_t seconds = span - (minutes * 60) - (hours * 3600) - (days * 24 * 3600);

	//if (compact_less_than_1m && span < 60)
	//{
	//	ret.Format(" <1m");
	//}
	//else

	int levels_shown = 0;

    CExoString ret;

    if ((days > 0 || min_levels > 3) && compact_levels > levels_shown)
    {
        ret.Format("%s%s%llu%s", ret.CStr(), separator, days, label_fields ? "d" : "");
        levels_shown++;
    }
    if ((hours > 0 || min_levels > 2) && compact_levels > levels_shown)
    {
        ret.Format("%s%s%llu%s", ret.CStr(), separator, hours, label_fields ? "h" : "");
        levels_shown++;
    }
    if ((minutes > 0 || min_levels > 1) && compact_levels > levels_shown)
    {
        ret.Format("%s%s%llu%s", ret.CStr(), separator, minutes, label_fields ? "m" : "");
        levels_shown++;
    }
    if ((seconds > 0 || min_levels > 0) && compact_levels > levels_shown)
    {
        ret.Format("%s%s%llu%s", ret.CStr(), separator, seconds, label_fields ? "s" : "");
        levels_shown++;
    }

	return ret.SubString(strlen(separator));
}

CExoString CExoString::FormatUnixTimestamp(uint64_t ts, const char* format)
{
    char buffer[1025] = {0};
    auto t = localtime((time_t*) &ts);
    if (ts > 0 && t)
        strftime(buffer, 1024, format, t);
    else
        sprintf(buffer, "-");

    return buffer;
}

std::vector<CExoString> CExoString::Split(const CExoString& strin, const CExoString& delimiter)
{
    std::vector<CExoString> ret;

    const std::string str = strin;
    const std::string delim = delimiter;

    size_t prev = 0, pos = 0;
    do
    {
        pos = str.find(delim, prev);
        if (pos == std::string::npos)
        {
            pos = str.length();
        }
        std::string token = str.substr(prev, pos-prev);
        if (!token.empty())
        {
            ret.push_back(token);
        }
        prev = pos + delim.length();
    }
    while (pos < str.length() && prev < str.length());

    return ret;
}

std::vector<CExoString> CExoString::Split(const CExoString& delimiter) const
{
    return CExoString::Split(*this, delimiter);
}

CExoString CExoString::Join(const std::vector<CExoString>& arin, const CExoString& delimiter)
{
    std::ostringstream ret;

    for (unsigned i = 0; i < arin.size(); i++)
    {
        if (!arin[1].IsEmpty())
        {
            ret << arin[i].CStr();
            if (i < arin.size() - 1)
            {
                ret << delimiter.CStr();
            }
        }
    }

    return ret.str();
}
