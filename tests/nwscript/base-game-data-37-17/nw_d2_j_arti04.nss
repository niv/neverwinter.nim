//::///////////////////////////////////////////////
//:: Bard Class
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is a bard
    and of low intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker());
    if (nClass > 0)
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}

