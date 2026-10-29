//::///////////////////////////////////////////////
//:: Check Arcane, Normal Intelligence
//:: NW_D2_Arcane
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC is a Wizard, Sorcerer or Bard
    and if they have normal intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    if(GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) ||
       GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) ||
       GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker())
      )
    {
        if(CheckIntelligenceNormal())
        {
            return TRUE;
        }
    }
	return FALSE;
}


