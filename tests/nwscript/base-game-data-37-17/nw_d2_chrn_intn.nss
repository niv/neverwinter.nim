//:: Check Charisma Normal & Intelligence Normal
//:: NW_D2_CHRH
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a normal charisma
    and normal int
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
        return CheckCharismaNormal();
    }
    return FALSE;
}

