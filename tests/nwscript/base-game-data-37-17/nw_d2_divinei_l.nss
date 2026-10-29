//::///////////////////////////////////////////////
//:: Check Divine Class, Low Intelligence
//:: NW_D2_Divine
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the PC is a Paladin, Ranger,
    Cleric or Druid and if they have low int.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker());
    
    if (nClass > 0 && CheckIntelligenceLow())
    {
        return TRUE;
    }
	return FALSE;
}
