//::///////////////////////////////////////////////
//:: x2_con_ban_tom12
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Try to start a conversation with Tomi.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  August 2003
//:://////////////////////////////////////////////
#include "x2_inc_banter"

int StartingConditional()
{
    if (TryBanterWith("x2_hen_tomi", 12    ) == TRUE)
    {
        return TRUE;
    }
    return FALSE;


}