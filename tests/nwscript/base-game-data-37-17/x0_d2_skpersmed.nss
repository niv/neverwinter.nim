//::///////////////////////////////////////////////
//:: Persuade Check Medium
//:: X0_D2_SKPERMED
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_MEDIUM, SKILL_PERSUADE, GetPCSpeaker());
}
