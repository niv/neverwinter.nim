//::///////////////////////////////////////////////
//:: No Flirt, Charisma Low, Intelligence Low
//:: NW_D2_FlirtNOI_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Is Charisma Low or
            Is Gender the same and
            Is Intelligence Low
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
        if(CheckIntelligenceLow())
        {
           return TRUE;
        }
    }
    return FALSE;
}
