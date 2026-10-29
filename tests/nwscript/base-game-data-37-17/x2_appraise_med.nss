//::///////////////////////////////////////////////
//:: Appraise Check Medium
//:: x2_appraise_med
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a medium
    appraise check. (#20 in the skills.2da)
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 24/03
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_MEDIUM, SKILL_APPRAISE, GetPCSpeaker());
}
