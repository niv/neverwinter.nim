//::///////////////////////////////////////////////
//:: Check Traps No Help
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not help with trapped
    items
*/
//:://////////////////////////////////////////////
//:: Created By:Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

int StartingConditional()
{
    if(!GetAssociateState(NW_ASC_DISARM_TRAPS))
    {
        return TRUE;
    }
    return FALSE;
}
