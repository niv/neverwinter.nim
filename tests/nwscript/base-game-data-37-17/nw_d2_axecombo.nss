//::///////////////////////////////////////////////
//:: Can any Axe or Armor comb be made?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Searchs backpack of PC speaker and sees if they
   can build any of the Axe or Armor combos
*/
//:://////////////////////////////////////////////
//:: Created By: Drew
//:: Created On: November 26, 2001
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"


int StartingConditional()
{
    int iResult;

    iResult = GetBackpackMatch(1, GetPCSpeaker()) ||
 GetBackpackMatch(2, GetPCSpeaker()) ||
GetBackpackMatch(3, GetPCSpeaker()) ||
GetBackpackMatch(4, GetPCSpeaker()) ||
GetBackpackMatch(7, GetPCSpeaker()) ||
GetBackpackMatch(8, GetPCSpeaker()) ||
GetBackpackMatch(11, GetPCSpeaker());

    return iResult;
}


