//::///////////////////////////////////////////////
//:: Check Charisma High and Int Normal
//:: NW_D2_CHRHO_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a high charisma and
    normal intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
    if (CheckIntelligenceNormal())
    {
        return CheckCharismaHigh();
    }
    return FALSE;
}
