//::///////////////////////////////////////////////
//:: x1_con_harper1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if you have enough gold
    to create the Harper Pin.
    
    Also make sure have enough experience points to do this
    without losing a level.
    50 xp
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_plot"
int StartingConditional()
{
    int iResult;

    if ( GetGold(GetPCSpeaker()) >= 100 && plotCanRemoveXP(GetPCSpeaker(), 50) == TRUE )
        return TRUE ;
    return FALSE;
}
