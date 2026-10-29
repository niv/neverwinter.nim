//::///////////////////////////////////////////////
//:: Check Charisma Middle , Non - Master
//:: NW_D2_CHRM
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a middle charisma
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
	return (CheckCharismaMiddle() & (GetMaster() != GetPCSpeaker()) & (GetIsObjectValid(GetMaster())) );
}


