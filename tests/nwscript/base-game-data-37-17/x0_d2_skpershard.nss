//::///////////////////////////////////////////////
//:: Persuade Check Hard
//:: X0_D2_SKPERSHARD
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_HARD, SKILL_PERSUADE, GetPCSpeaker());
}
