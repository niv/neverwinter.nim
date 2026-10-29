//::///////////////////////////////////////////////
//:: x2_con_ws_attkok
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if its okay to add the
    Attack property to the item. RANGED ONLY

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    int iResult;

    if (IsOkToAdd(GetPCSpeaker(), IP_CONST_WS_MIGHTY_10) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

