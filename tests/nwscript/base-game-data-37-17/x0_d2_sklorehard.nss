//::///////////////////////////////////////////////
//:: Lore Check Hard
//:: NW_D2_LOREHARD
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
    return AutoDC(DC_HARD, SKILL_LORE, GetPCSpeaker());
}
