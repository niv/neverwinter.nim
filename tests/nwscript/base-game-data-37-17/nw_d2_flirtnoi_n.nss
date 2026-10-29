//::///////////////////////////////////////////////
//:: No Flirt, Charisma Low, Intelligence Normal
//:: NW_D2_FlirtNOI_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Is Charisma Low or
            Is Gender the same and
            Is Intelligence Normal
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    int nGender = GetGender(GetPCSpeaker());
    if(CheckCharismaLow() || nGender == GetGender(OBJECT_SELF))
    {
        if(CheckIntelligenceNormal())
        {
           return TRUE;
        }
    }
    return FALSE;
}
