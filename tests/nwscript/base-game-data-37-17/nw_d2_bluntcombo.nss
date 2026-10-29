//::///////////////////////////////////////////////
//:: Can any Blunt comb be made?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Searchs backpack of PC speaker and sees if they
   can build any of the Blunt combos
*/
//:://////////////////////////////////////////////
//:: Created By: Drew
//:: Created On: November 26, 2001
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"


int StartingConditional()
{
    int iResult;

    iResult = GetBackpackMatch(5, GetPCSpeaker()) ||
GetBackpackMatch(6, GetPCSpeaker()) ||
GetBackpackMatch(12, GetPCSpeaker()) ||
GetBackpackMatch(15, GetPCSpeaker()) ||
GetBackpackMatch(16, GetPCSpeaker()) ||
GetBackpackMatch(17, GetPCSpeaker()) ||
GetBackpackMatch(18, GetPCSpeaker()) ||
GetBackpackMatch(26, GetPCSpeaker());

    return iResult;
}



