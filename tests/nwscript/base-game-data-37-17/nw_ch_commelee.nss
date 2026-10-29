//::///////////////////////////////////////////////
//:: Determine Combat Range Preference
//:: nw_ch_commelee
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the Henchmen is in Melee Mode.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 5, 2002
//:://////////////////////////////////////////////
#include "nw_i0_generic"
int StartingConditional()
{
    if(!GetAssociateState(NW_ASC_USE_RANGED_WEAPON))
    {
        return TRUE;
    }
    return FALSE;
}
