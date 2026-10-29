//::///////////////////////////////////////////////
//:: inValid Item
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if a NO valid item can be made.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;

    iResult = GetIsValidCombination(FALSE) == FALSE;
    return iResult;
}


