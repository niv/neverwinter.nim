//::///////////////////////////////////////////////
//:: x2_con_ban_dae13
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Try to start a conversation with 13
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  August 2003
//:://////////////////////////////////////////////
#include "x2_inc_banter"

int StartingConditional()
{
    if (TryBanterWith("x2_hen_daelan", 13            ) == TRUE)
    {
        return TRUE;
    }
    return FALSE;


}