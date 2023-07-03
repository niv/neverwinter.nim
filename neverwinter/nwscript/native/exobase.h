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
//::  ExoBase.h
//::
//::  Header for machine-specific base class stuff.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Mark Brockington
//::  Created On: 04/26/99
//::
//::///////////////////////////////////////////////////////////////////////////
//:: THIS FILE CONTAINS PORTED CODE
//::///////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include <string>
#include <vector>
#include <stdlib.h>
#include <string.h>
#include <initializer_list>
#include <functional>
#include <type_traits>
#include <assert.h>

#include "exotypes.h"

#define EXOASSERTNC() assert(false)
#define EXOASSERTNCSTR(string) assert(!string)
#define EXOASSERT(cond) assert(cond)
#define EXOASSERTSTR(cond, string) assert(cond && string)

///////////////////////////////////////////////////////////////////////////////
// class CExoString
///////////////////////////////////////////////////////////////////////////////
// Created by: Don Yakielashek
// Date:       04/26/99
//
// Desc: C++ string storage and manipulation class.
//       CExoString contains a flag whether the string is single or double byte.
///////////////////////////////////////////////////////////////////////////////

class CExoString
{

	// *************************************************************************
public:
	// *************************************************************************

    static const char* Whitespace;
    static const char* Letters;
    static const char* Numbers;
    static const char* Alphanumeric;

    ///////////////////////////////////////////////////////////////////////////
	CExoString();
	//-------------------------------------------------------------------------
	// Desc:    Creates an empty CExoString.
	///////////////////////////////////////////////////////////////////////////

    CExoString(CExoString&& other)
    {
        m_sString = other.m_sString;
        m_nBufferLength = other.m_nBufferLength;
        other.m_sString = nullptr;
        other.m_nBufferLength = 0;
    }
    CExoString& operator=(CExoString&& other)
    {
        if (this == &other) return *this;
        if (m_sString)
        {
            delete[] m_sString;
        }
        m_sString = other.m_sString;
        m_nBufferLength = other.m_nBufferLength;
        other.m_sString = nullptr;
        other.m_nBufferLength = 0;
        return *this;
    }

	///////////////////////////////////////////////////////////////////////////
	CExoString(const char *source);
	//-------------------------------------------------------------------------
	// Desc:    Creates a CExsoString from a null terminated char array.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString(const CExoString &source);
	//-------------------------------------------------------------------------
	// Desc:    Creates a copy of a CExoString.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString(const char *source, int32_t length);
	//-------------------------------------------------------------------------
	// Desc:    Creates a CExoString that contains the first length characters
	//          of a CExoString.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString(int32_t value);
	//-------------------------------------------------------------------------
	// Desc:    Creates a CExoString representing the int value.
	///////////////////////////////////////////////////////////////////////////


    // The most rudimentary of std::string interop.
    CExoString(const std::string& other);
    CExoString& operator=(const std::string& other);
	operator std::string() const;

	///////////////////////////////////////////////////////////////////////////
	~CExoString();
	//-------------------------------------------------------------------------
	// Desc:    Destructor.
	///////////////////////////////////////////////////////////////////////////


	///////////////////////////////////////////////////////////////////////////
	CExoString & operator =  (const CExoString &string);
	//-------------------------------------------------------------------------
	// Desc:    Assigns one CExoString to another.
	// Params:  string:     CExoString to be assigned to this CExoString.
	// Returns: A reference to this CExoString.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString & operator =  (const char *string);
	//-------------------------------------------------------------------------
	// Desc:    Assigns the value of a null terminated character array to a
	//          CExoString.
	// Params:  string:     A NULL-terminated character string to be assigned
	//                      to this CExoString.
	// Returns: A reference to this CExoString.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator == (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Compares two CExoString's.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  if CExoString's are equal.
	//          FALSE if CExoString's are not equal.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator == (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Compares a CExoString to a null terminated character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  if CExoString's are equal.
	//          FALSE if CExoString's are not equal.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator != (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if two CExoString's are not equal.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  if CExoString's are equal.
	//           FALSE if CExoString's are not equal.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator != (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is not equal to a null terminated
	//          character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  if CExoString's are equal.
	//           FALSE if CExoString's are not equal.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator < (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is less than another CExoString.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  CExoString is less than.
	//          FALSE CExoString is not less than.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator < (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is less than a null terminated
	//          character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  CExoString is less than.
	//          FALSE CExoString is not less than.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator > (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is greater than another CExoString.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  CExoString is greater than.
	//          FALSE CExoString is not greater than.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator > (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is greater than a null terminated
	//          character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  CExoString is greater than.
	//          FALSE CExoString is not greater than.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator <= (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is less than or equal to another
	//          CExoString.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  CExoString is less than or equal to.
	//          FALSE CExoString is not less than or equal to.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator <= (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is less than or equal to a null
	//          terminated character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  CExoString is less than or equal to
	//          FALSE CExoString is not less than or equal to
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator >= (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is greater than or equal to another
	//          CExoString.
	// Params:  string:     CExoString to compare to this CExoString.
	// Returns: TRUE  CExoString is greater than or equal to.
	//          FALSE CExoString is not greater than or equal to.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL operator >= (const char *string) const;
	//-------------------------------------------------------------------------
	// Desc:    Determines if CExoString is greater than or equal toa null
	//          terminated character array.
	// Params:  string:     A NULL-terminated character string to compare to
	//                      this CExoString.
	// Returns: TRUE  CExoString is greater than or equal to.
	//          FALSE CExoString is not greater than or equal to.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	char operator [] (int32_t position) const;
	//-------------------------------------------------------------------------
	// Desc:    Gets character at position.
	// Params:  position:       The position in this CExoString of the
	//                          character desired.
	// Returns: The character at position.
	///////////////////////////////////////////////////////////////////////////
//friend AsiString __fastcall operator +(const char* lhs, const AnsiString& rhs);
//AnsiString __fastcall operator +(const AnsiString& rhs) const;
	///////////////////////////////////////////////////////////////////////////
	CExoString operator + (const CExoString &string) const;
	//-------------------------------------------------------------------------
	// Desc:    Returns the result of two CExoString joined together.
	// Params:  string:     CExoString to add (append) to this CExoString.
	// Returns: CExoString consisting of the two strings added together.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
//    CExoString operator + (const char *string);
	//-------------------------------------------------------------------------
	// Desc: Returns the result of an CExoString joined with a null terminated
	//       character array
	//
	// Return: CExoString consisting of the two strings added together
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	//CExoString operator + (const char *string);
	//-------------------------------------------------------------------------
	// Desc: Returns the result of an CExoString joined with a null terminated
	//       character array
	//
	// Return: CExoString consisting of the two strings added together
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	int32_t AsINT() const;
	//-------------------------------------------------------------------------
	// Desc:    Retuns integer value the string represents.
	// Returns: Integer value the string represents.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	float AsFLOAT() const;
	//-------------------------------------------------------------------------
	// Desc:    Retuns float value the string represents.
	// Returns: Float value the string represents.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	char* CStr()  const;
	//-------------------------------------------------------------------------
	// Desc:    Retuns a null terminated character array.
	// Returns: Null terminated character array.
	///////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////
	int32_t Find(const CExoString &string, int32_t position=0) const;

	int32_t Find(char ch, int32_t position=0) const;
	//-------------------------------------------------------------------------
	// Desc:    Finds a substring within the string.
	// Params:  string:     The substring to find in this CExoString.
	// Returns: Position where substring is.
	//          -1 if string not found.
	///////////////////////////////////////////////////////////////////////////

	int32_t FindNot(char ch, int32_t position=0) const;
	//-------------------------------------------------------------------------
	// Desc:    Finds the first character that is not ch
	// Params:  ch:     The character to not find in this CExoString.
	// Returns: Position where character is.
	//          -1 if string not found.
	///////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
	CExoString RemoveAll(const char* c) const;
    //-------------------------------------------------------------------------
    // Returns: A copy of this string with all characters contained in c
    //          removed, regardless of order.
    ///////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    CExoString RemoveAllExcept(const char* c) const;
    //-------------------------------------------------------------------------
    // Returns: A copy of this string with all characters NOT contained in c
    //          removed, regardless of order.
    ///////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////
	void Format(const char *format,...);
	//-------------------------------------------------------------------------
	// Desc:    Formats a string based on a number of arguments, like sprintf
	//          does.
	// Params:  format:     A character string containing the format of the
	//                      string to put into this CExoString.
	//          ...:        A series of comma-separated variables or constants
	//                      to be inserted into format as a string at the
	//                      appropriate positions.  There can be zero or more
	//                      of these, depending on format.
	///////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////
	inline void DummyFormat(char *format,...) {return;}
	//-------------------------------------------------------------------------
	// Desc:    Does nothing. Takes same parameter list as Format
	// Params:  format:     A character string containing the format of the
	//                      string to put into this CExoString.
	//          ...:        A series of comma-separated variables or constants
	//                      to be inserted into format as a string at the
	//                      appropriate positions.  There can be zero or more
	//                      of these, depending on format.
	///////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////

	template<typename ... T>
	static CExoString F(const char* fmt, T&& ... args)
    {
	    CExoString f;
	    f.Format(fmt, args...);
	    return f;
    }

    // Static formatting helper for cleaner code.
    ///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	inline int32_t GetLength() const
	{
		return m_sString ? (int32_t) strlen(m_sString) : 0;
	}
	//-------------------------------------------------------------------------
	// Desc:    Retuns the length of the CExoString.
	// Returns: The length of the CExoString.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	void Insert(const CExoString &string, int32_t position);
	//-------------------------------------------------------------------------
	// Desc:    Inserts a string at the given position.
	// Params:  string:     The CExoString to insert into this CExoString.
	//          position:   Position in this CExoString where string will be
	//                      inserted.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	BOOL IsEmpty() const;
	//-------------------------------------------------------------------------
	// Desc:    Checks if CExoString is a blank string.
	// Returns: TRUE if this CExoString is blank.
	//          FALSE if this CExoString is not blank.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString Left(int32_t count) const;
	//-------------------------------------------------------------------------
	// Desc:    Returns leftmost 'count' characters.
	// Params:  count:      Number of characters to extract starting from the
	//                      left.
	// Returns: CExoString containing the leftmost 'count' characters.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString LowerCase() const;
	//-------------------------------------------------------------------------
	// Desc:    Returns the string converted to lowercase.
	// Returns: CExoString converted to lowercase.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString Right(int32_t count) const;
	//-------------------------------------------------------------------------
	// Desc:    Returns rightmost 'count' characters.
	// Params:  count:      Number of characters to extract starting from the
	//                      right.
	// Returns: CExoString containing the rightmost 'count' characters.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString SubString(int32_t start, int32_t count=-1) const;
	//-------------------------------------------------------------------------
	// Desc:    Returns a portion of string consisting of 'count' characters
	//          starting at 'start'.
	// Params:  start:      The starting position of the substring within this
	//                      CExoString.
	//          count:      Number of characters to extract into the substring.
	//                      <0 means extract to end of string
	// Returns: CExoString containing the substring.
	///////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////
	CExoString UpperCase() const;
	//-------------------------------------------------------------------------
	// Desc:    Returns the string converted to uppercase.
	// Returns: CExoString converted to uppercase.
	///////////////////////////////////////////////////////////////////////////

	BOOL CompareNoCase(const CExoString &sString) const;
	BOOL ComparePrefixNoCase(const CExoString &sString, int32_t nSize) const;

	///////////////////////////////////////////////////////////////////////////
	BOOL StripNonAlphaNumeric( BOOL bFileName = TRUE, BOOL bEmail = FALSE, BOOL bMasterServer = FALSE );
	//-------------------------------------------------------------------------
	// Desc: Removes all non-alpha-numeric symbols from the string
	///////////////////////////////////////////////////////////////////////////

	// Strip leading and/or trailing characters from this string, returning a
	// new string.
	CExoString Strip(bool leading = true, bool trailing = true, const char* set = Whitespace) const;

	///////////////////////////////////////////////////////////////////////////
	CExoString AsTAG() const;
	//-------------------------------------------------------------------------
	// Desc:    Retuns a proper tag version of the string
	///////////////////////////////////////////////////////////////////////////

	// Returns a cross-platform, stable 32bit hash of the string (xxh32)
	int32_t GetHash() const;

	// Static helper that formats a number of bytes as a human-readable
	// fractional to the nearest magnitude (i.e. "4.1GB").
	static CExoString FormatBytes(uint64_t bytes);

	// Static helper that formats a number of seconds as a human-readable interval.
	static CExoString FormatDuration(uint64_t span,
                                     // Only show the N most significant intervals that aren't zero:
                                     // compact_levels = 1 -> "1d"
                                     // compact_levels = 2 -> "1d 4h"
                                     // compact_levels = 3 -> "1d 4h 2m"
                                     // Note that a compacted value counts as a full "bigger" level.
                                     int compact_levels = 4,
                                     // Minimum number of levels to show, even if zeroes.
                                     int min_level = 1,
                                     // Liberty to abbreviate some values if compaction level and labelling.
                                     // For example, 48s would be abbreviated to "<1m"
                                     //bool abbreviate = true,
                                     // Label fields as "s", "m", "h", "d".
                                     bool label_fields = true,
                                     // Separator between fields
                                     const char* separator = " ");

	// Formats a unix timestamp into a human readable string according to the current locale.
	static CExoString FormatUnixTimestamp(uint64_t ts,
	        // %c      -> Thu Aug 23 14:55:02 2001    (locale-dependent)
	        // %F %T   -> 2001-08-23 14:55:02         (NOT locale-dependent but only numbers)
	        // %x %X   -> 08/23/01 14:55:02           (locale-dependent)
	        // see strftime(3) for more
	        const char* format = "%F %T");

	// Split string by delimiter. Strips out empty values and repeated delimiters.
	static std::vector<CExoString> Split(const CExoString& str, const CExoString& delimiter);
    std::vector<CExoString> Split(const CExoString& delimiter) const;

    // Join string array by delimiter. Will not join in empty strings.
	static CExoString Join(const std::vector<CExoString>& ary, const CExoString& delimiter);

	void Clear()
	{
		delete[] m_sString;
		m_sString = 0;
		m_nBufferLength = 0;
	}
	// Explicit move semantics that don't require new C++ features like &&
	void Steal(CExoString *other)
	{
		m_sString = other->m_sString;
		m_nBufferLength = other->m_nBufferLength;
		other->m_sString = NULL;
		other->m_nBufferLength = 0;
	}
	char *Relinquish()
	{
		char *buf = m_sString;
		m_sString = NULL;
		m_nBufferLength = 0;
		return buf;
	}

	// *************************************************************************
private:
	// *************************************************************************
	char *m_sString;
	uint32_t m_nBufferLength;

	//static char *CExoStringFormatBuffer;
	//static int32_t   CExoStringFormatBufferSize;
};


// Allow CExoString to be used as keys for stl maps.
namespace std {
template <>
struct hash<CExoString>
{
    std::size_t operator()(const CExoString& k) const
    {
        return std::hash<std::string>{}(k.CStr());
    }
};
}
