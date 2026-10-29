//:://////////////////////////////////////////////////
//:: X0_I0_DEBUG
/*
  Small library of debugging functions for nw_i0_generic.
  Included in x0_inc_generic, as that's the first base
  library.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/20/2003
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// * displays debug info added since November 2002.
void newdebug(string sString);

// TYPO! Use DebugPrintTalentID(talent tTalent) instead.
// This function is commented out for release; use PrintString for
// debugging.
void DubugPrintTalentID(talent tTalent);

// Prints a log string with the ID of the passed in talent.
// This function is commented out for release; use PrintString for
// debugging.
void DebugPrintTalentID(talent tTalent);

// Inserts a debug print string into the client log file.
// This function is commented out for release; use PrintString for
// debugging.
void MyPrintString(string sString);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

void newdebug(string sString)
{
    // SpeakString("New debug = " + sString);
}

void DebugPrintTalentID(talent tTalent)
{
    //int nID = GetIdFromTalent(tTalent);
    //MyPrintString("Using Spell ID: " + IntToString(nID));
}

// Misspelled old version, bleah
void DubugPrintTalentID(talent tTalent)
{
    //int nID = GetIdFromTalent(tTalent);
    //MyPrintString("Using Spell ID: " + IntToString(nID));
}

void MyPrintString(string sString)
{
    //PrintString(sString);
    //SpeakString(sString);
}

