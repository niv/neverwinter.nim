//::///////////////////////////////////////////////
//:: Can any Sword comb be made?
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

    iResult = GetBackpackMatch(9, GetPCSpeaker()) ||
GetBackpackMatch(13, GetPCSpeaker()) ||
GetBackpackMatch(14, GetPCSpeaker()) ||
GetBackpackMatch(19, GetPCSpeaker()) ||
GetBackpackMatch(20, GetPCSpeaker()) ||
GetBackpackMatch(22, GetPCSpeaker()) ||
GetBackpackMatch(25, GetPCSpeaker());

    return iResult;
}




