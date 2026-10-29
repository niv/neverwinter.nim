//::///////////////////////////////////////////////
//:: Valid Item  16
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the VALID ITEM is
    the first item in the array.
*/
//:://////////////////////////////////////////////
//:: Created By: Drew (standing on the shoulders of giants)
//:: Created On: November 23 2001
//:://////////////////////////////////////////////
#include "nw_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;
    // * Note this script can only be run after checking for a valid item!
    iResult = GetForgeMatch(16);
    return iResult;
}

