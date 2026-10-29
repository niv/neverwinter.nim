//::///////////////////////////////////////////////
//:: Afford it?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Checks to see if the player can afford the item
*/
//:://////////////////////////////////////////////
//:: Created By:       Brent
//:: Created On:       November 2001
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;

    iResult = CanAfford(GetPCSpeaker()) == TRUE;
    return iResult;
}

