//::///////////////////////////////////////////////
//:: x2_gatenobetnat
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the player did not
    betray Nathyrra
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_globals"
int StartingConditional()
{
    if (PCBetrayedNathyrra() == FALSE)
    {
        return TRUE;
    }
    return FALSE;

}
