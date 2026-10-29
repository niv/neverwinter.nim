#include "nw_i0_plot"
#include "NW_J_ARTIFACT"

void main()
{
    TakeArtifactItem(GetPCSpeaker());
    RewardGP(1000,GetPCSpeaker(),FALSE);
    RewardXP(GetPlotTag(),100,GetPCSpeaker());
}
