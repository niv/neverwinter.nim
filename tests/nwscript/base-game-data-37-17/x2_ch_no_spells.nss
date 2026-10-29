//::///////////////////////////////////////////////
//:: Check Spells No Help
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
    if(GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 10)
    {
        return TRUE;
    }
    return FALSE;
}

