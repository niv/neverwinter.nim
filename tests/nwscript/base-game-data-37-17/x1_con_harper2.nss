//::///////////////////////////////////////////////
//:: x1_con_harper2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if you have enough gold
    to create the potion.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 60 && plotCanRemoveXP(GetPCSpeaker(), 5) == TRUE )
        return TRUE ;
    return FALSE;
}
