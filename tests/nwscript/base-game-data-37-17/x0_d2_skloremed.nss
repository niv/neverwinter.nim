//::///////////////////////////////////////////////
//:: Lore Check Medium
//:: NW_D2_LOREMED
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_MEDIUM, SKILL_LORE, GetPCSpeaker());
}
