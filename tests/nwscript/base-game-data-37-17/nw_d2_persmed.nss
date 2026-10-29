//::///////////////////////////////////////////////
//:: Persuade Check Medium
//:: NW_D2_PERSMED
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a medium
    persuade check.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_PERSUADE, GetPCSpeaker());
}
