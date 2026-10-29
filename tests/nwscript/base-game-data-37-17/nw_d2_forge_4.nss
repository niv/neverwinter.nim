//::///////////////////////////////////////////////
//:: Valid Item   4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the VALID ITEM is
    the first item in the array.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
#include "nw_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;
    // * Note this script can only be run after checking for a valid item!
    iResult = GetForgeMatch(4);
    return iResult;
}




