//::///////////////////////////////////////////////
//:: Compare Classes, Check Low Int
//:: NW_D2_CLASSMI_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are any of the PC classes the same
            as any of the monster classes AND
            Is Intelligence Low
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
	int nIdx, nClass;

    if(CheckIntelligenceLow() == TRUE)
    {
        for(nIdx = 1; nIdx < 3; nIdx++)
        {
            nClass = GetClassByPosition(nIdx, GetPCSpeaker());
            if(GetLevelByClass(nClass) > 0)
            {
                return TRUE;
            }
        }
    }
	return FALSE;
}
