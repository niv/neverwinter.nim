//::///////////////////////////////////////////////
//:: x2_con_ban_ari7
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Try to start a conversation with Aribeth.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  August 2003
//:://////////////////////////////////////////////
#include "x2_inc_banter"

int StartingConditional()
{
    if (TryBanterWith("H2_Aribeth", 7   ) == TRUE)
    {
        return TRUE;
    }
    return FALSE;


}