//::///////////////////////////////////////////////
//:: Intimidate Check Easy
//:: x2_intimdt_easy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a easy
    intimidate check. (#24 in the skills.2da)
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 17/02
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_EASY, 24, GetPCSpeaker());
}
