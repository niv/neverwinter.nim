//::///////////////////////////////////////////////
//:: Check Nature Class, Normal Intelligence
//:: NW_D2_NaturI_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the PC is a Ranger,
    or Druid and if they have normal int.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
	int l_iResult =  GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) + GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    if(l_iResult == TRUE && CheckIntelligenceNormal())
    {
        return TRUE;
    }
    else
    {
 	  return FALSE;
    }
	return FALSE;
}
