//::///////////////////////////////////////////////
//:: Bluff Check Easy
//:: x2_bluff_easy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a easy
    bluff check. (#23 in the skills.2da)
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 17/02
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_EASY, 23, GetPCSpeaker());
}
