//::///////////////////////////////////////////////
//:: Check Charisma Middle and Int Normal
//:: NW_D2_CHRHO_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a middle charisma and
    normal intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: Nov 17, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
        return CheckIntelligenceNormal() & CheckCharismaMiddle();
}
