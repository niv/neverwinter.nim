//::///////////////////////////////////////////////
//:: Persuade Check High
//:: NW_D2_PEREASY
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a high
    persuade check.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_PERSUADE, GetPCSpeaker());
}

