//::///////////////////////////////////////////////
//:: x2_con_ws_enhandok
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if its okay to add the
    enhancement +1

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    int iResult;

    if (IsOkToAdd(GetPCSpeaker(), IP_CONST_WS_ENHANCEMENT_BONUS) == FALSE)
    {

        return TRUE;
    }
    return FALSE;
}

