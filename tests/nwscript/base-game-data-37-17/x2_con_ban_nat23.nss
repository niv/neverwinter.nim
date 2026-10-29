//::///////////////////////////////////////////////
//:: x2_con_ban_nat23
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Try to start a conversation with Nathyra.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  August 2003
//:://////////////////////////////////////////////
#include "x2_inc_banter"

int StartingConditional()
{
    if (TryBanterWith("x2_hen_nathyra", 23    ) == TRUE)
    {
        return TRUE;
    }
    return FALSE;


}