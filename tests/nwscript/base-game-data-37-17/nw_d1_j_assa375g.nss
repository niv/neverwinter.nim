#include "nw_i0_plot"
#include "NW_J_ASSASSIN"

void main()
{
    RewardGP(375,GetPCSpeaker(),FALSE);
    RewardXP(GetPlotTag(),100,GetPCSpeaker(),ALIGNMENT_EVIL);
    SetLocalInt(OBJECT_SELF,"NW_ASSA_PLOT",1);
}
