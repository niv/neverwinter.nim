//::///////////////////////////////////////////////
//:: x0_portal_a4nope
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    returns true if this anchor DOES NOT exists
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_portal"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (PortalAnchorExists(4, oPC) == FALSE && PortalHasRogueStone(oPC) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}

