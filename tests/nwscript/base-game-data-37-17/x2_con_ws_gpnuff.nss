//::///////////////////////////////////////////////
//:: x2_con_ws_gpnuff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Do you have enough gold?
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    if (wsHaveEnoughGoldForCurrentItemProperty(GetPCSpeaker()) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
