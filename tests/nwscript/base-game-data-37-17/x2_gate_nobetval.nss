//::///////////////////////////////////////////////
//:: x2_gatenobetval
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the player did not
    betray Valen
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_globals"
int StartingConditional()
{
    if (PCBetrayedValen() == FALSE)
    {
        return TRUE;
    }
    return FALSE;

}

