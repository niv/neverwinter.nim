//::///////////////////////////////////////////////
//:: Can combo 1 be made?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Searchs backpack of PC speaker and sees if they
   can build the #1 combo
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"


int StartingConditional()
{
    int iResult;

    iResult = GetBackpackMatch(1, GetPCSpeaker());
    return iResult;
}
