//:: x2_con_ws_ok
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if its okay to add the
    keen property to the item.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    int iResult;

    if (IsOkToAdd(GetPCSpeaker(), IP_CONST_WS_REGENERATION) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}



