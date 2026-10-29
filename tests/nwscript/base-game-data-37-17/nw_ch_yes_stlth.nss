//::///////////////////////////////////////////////
//:: Check if Stealth Enabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently use stealth when
    moving.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
//:: Brent: May 2002: Disabled this option

#include "NW_I0_GENERIC"

int StartingConditional()
{
    return FALSE;
/*
    if(GetAssociateState(NW_ASC_AGGRESSIVE_STEALTH))
    {
        return TRUE;
    }
    return FALSE;   */
}
