//:: x2_con_ws_elecok
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if its okay to add the
    ice property to the item.

    - Item must not have an ice damage bonus property
      already.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

int StartingConditional()
{
    int iResult;

    if (IsOkToAdd(GetPCSpeaker(), IP_CONST_DAMAGETYPE_ELECTRICAL) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

