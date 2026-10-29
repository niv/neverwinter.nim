//::///////////////////////////////////////////////
//:: Check Charisma Low, NON Master
//:: NW_CH_CHRLM
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a low charisma
    Master must be a valid object
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
	return (CheckCharismaLow() & (GetMaster() != GetPCSpeaker()) & (GetIsObjectValid(GetMaster())));
}


