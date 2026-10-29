//::///////////////////////////////////////////////
//:: Check Holy Class
//:: NW_D2_Holy_IntN
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the PC is a Paladin or Cleric
    and Intelligence is Normal
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: Nov 14, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    if (nClass > 0)
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}

