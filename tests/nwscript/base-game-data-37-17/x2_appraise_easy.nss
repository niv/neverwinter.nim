//::///////////////////////////////////////////////
//:: Appraise Check Easy
//:: x2_appraise_easy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made an easy
    appraise check. (#20 in the skills.2da)
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 24/03
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_EASY, SKILL_APPRAISE, GetPCSpeaker());
}
