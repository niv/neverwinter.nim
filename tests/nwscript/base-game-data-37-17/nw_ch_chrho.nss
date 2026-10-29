//::///////////////////////////////////////////////
//:: Check Charisma High, Non -Master
//:: NW_D2_CHRH
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a high charisma
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
	return (CheckCharismaHigh() & (GetMaster() != GetPCSpeaker()) & (GetIsObjectValid(GetMaster())));
}



