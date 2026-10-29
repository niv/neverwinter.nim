//:: x2_con_ws_hastok
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if its okay to add the
    haste property to the item.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    int iResult;

    if (IsOkToAdd(GetPCSpeaker(), IP_CONST_WS_HASTE) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}


