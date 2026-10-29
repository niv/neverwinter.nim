//::///////////////////////////////////////////////
//:: Check if Search Enabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not search when
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
    if(GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH))
    {
        return TRUE;
    }
    return FALSE;*/
}
