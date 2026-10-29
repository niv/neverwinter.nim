//::///////////////////////////////////////////////////////////////
//:: X0_I0_STRINGLIB
//:: Copyright (c) 2002 Floodgate Entertainment
//::///////////////////////////////////////////////////////////////
/*
This library contains general string-manipulation functions
for convenience.

Currently just has string tokenization.

 */
//::///////////////////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/10/2002
//::///////////////////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS & TYPES
 **********************************************************************/

struct sStringTokenizer {
    int nRemainingLen;
    string sOrig;
    string sRemaining;
    string sDelim;
    string sLastTok;
};

int DELIM_NOT_FOUND = -1;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get a string tokenizer for sString. sDelim may be multiple
// characters in length.
struct sStringTokenizer GetStringTokenizer(string sString, string sDelim);

// Check to see if any more tokens remain. Returns 0 if not, 1 if so.
int HasMoreTokens(struct sStringTokenizer stTok);

// Get next token
struct sStringTokenizer AdvanceToNextToken(struct sStringTokenizer stTok);

// Get the last token retrieved
string GetNextToken(struct sStringTokenizer stTok);

// Get the number of tokens in the string, by delimeter.
int GetNumberTokens(string sString, string sDelim);

// Get the specified token in the string, by delimiter.
// The first string is position 0, the second is position 1, etc.
string GetTokenByPosition(string sString, string sDelim, int nPos);

/**********************************************************************
 * FUNCTIONS
 **********************************************************************/

// Get a string tokenizer for sString. sDelim may be multiple
// characters in length.
struct sStringTokenizer GetStringTokenizer(string sString, string sDelim)
{
    struct sStringTokenizer sNew;

    sNew.sOrig = sString;
    sNew.sRemaining = sString;
    sNew.sDelim = sDelim;
    sNew.sLastTok = "";
    sNew.nRemainingLen = GetStringLength(sString);

    return sNew;
}

// Check to see if any more tokens remain. Returns 0 if not, 1 if so.
int HasMoreTokens(struct sStringTokenizer stTok)
{
    if (stTok.nRemainingLen > 0) {
        return TRUE;
    }
    return FALSE;
}

// Move tokenizer to next token
struct sStringTokenizer AdvanceToNextToken(struct sStringTokenizer stTok)
{
    int nDelimPos = FindSubString(stTok.sRemaining, stTok.sDelim);
    if (nDelimPos == DELIM_NOT_FOUND) {
        // no delimiters in the string
        stTok.sLastTok = stTok.sRemaining;
        stTok.sRemaining = "";
        stTok.nRemainingLen = 0;
    } else {
        stTok.sLastTok = GetSubString(stTok.sRemaining, 0, nDelimPos);
        stTok.sRemaining = GetSubString(stTok.sRemaining,
                                        nDelimPos+1,
                                        stTok.nRemainingLen - (nDelimPos+1));
        stTok.nRemainingLen = GetStringLength(stTok.sRemaining);
    }

    return stTok;
}

// Get the next token
string GetNextToken(struct sStringTokenizer stTok)
{
    return stTok.sLastTok;
}

// Get the number of tokens in the string, by delimeter.
int GetNumberTokens(string sString, string sDelim)
{
    struct sStringTokenizer stTok = GetStringTokenizer(sString, sDelim);
    int nElements = 0;
    while (HasMoreTokens(stTok)) {
        stTok = AdvanceToNextToken(stTok);
        nElements++;
    }
    return nElements;
}

// Get the specified token in the string, by delimiter.
// The first string is position 0, the second is position 1, etc.
string GetTokenByPosition(string sString, string sDelim, int nPos)
{
    struct sStringTokenizer stTok = GetStringTokenizer(sString, sDelim);
    int i=0;
    while (HasMoreTokens(stTok) && i <= nPos) {
        stTok = AdvanceToNextToken(stTok);
        i++;
    }
    if (i != nPos + 1) 
        return "";

    return GetNextToken(stTok);
}




// Only here for debugging -- close the comment right below
// to enable the main routine.
/* 
void main()
{ 

    string sTest = "This|is|a|test";

    // Basic usage: 
    struct sStringTokenizer stTestTok = GetStringTokenizer(sTest, "|");
    while (HasMoreTokens(stTestTok)) {
        stTestTok = AdvanceToNextToken(stTestTok);
        SpeakString("Next token: " + GetNextToken(stTestTok));
    }
    SpeakString("end of tokens");

    // Make sure we don't do something bad when we run out of tokens:
    stTestTok = GetStringTokenizer(sTest, "|");
    int i;
    for (i=0; i < 5; i++) {
        SpeakString("HasMoreTokens: " + IntToString(HasMoreTokens(stTestTok)));
        stTestTok = AdvanceToNextToken(stTestTok);
        SpeakString("Next token: " + GetNextToken(stTestTok));
    } 

    // Get a specific token
    for (i=0; i < 5; i++) {
        SpeakString("In position " + IntToString(i) 
                    + ": " + GetTokenByPosition(sTest, "|", i));
    }
    
}
/* */
