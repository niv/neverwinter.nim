//::///////////////////////////////////////////////
//:: Persuade Check Easy
//:: X0_D2_SKPEREASY
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_EASY, SKILL_PERSUADE, GetPCSpeaker());
}
