#include "nw_i0_plot"
#include "NW_J_ARTIFACT"

void main()
{
    TakeArtifactItem(GetPCSpeaker());
    RewardGP(750,GetPCSpeaker(),FALSE);
    RewardXP(GetPlotTag(),100,GetPCSpeaker());
    SetLocalInt(GetModule(),"NW_G_ARTI_PLOT" + GetTag(OBJECT_SELF),2);
}


