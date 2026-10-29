//::///////////////////////////////////////////////
//:: Compare Classes, Normal Intelligence
//:: NW_D2_CLASSNOI_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Makes sure none of the PC classes are
            the same as the NPC classes AND
            Is Intelligence Normal
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    int nIdx, nClass;

    if(CheckIntelligenceNormal() == TRUE)
    {
        for(nIdx = 1; nIdx < 3; nIdx++)
        {
            nClass = GetClassByPosition(nIdx, GetPCSpeaker());
            if(GetLevelByClass(nClass) > 0)
            {
                return FALSE;
            }
        }
        return TRUE;
    }
    return FALSE;
}

