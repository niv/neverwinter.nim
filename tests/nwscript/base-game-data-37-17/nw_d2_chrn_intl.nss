//::///////////////////////////////////////////////
//:: Check Charisma Normal & Intelligence Low
//:: NW_D2_CHRH
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a normal charisma
    and low int
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    if (CheckIntelligenceLow())
    {
        return CheckCharismaNormal();
    }
    return FALSE;
}
