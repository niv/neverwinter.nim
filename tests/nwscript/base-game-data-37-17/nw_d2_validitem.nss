//::///////////////////////////////////////////////
//:: Valid Item
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if a valid item can be made.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;

    iResult = GetIsValidCombination(FALSE) == TRUE;
    return iResult;
}



