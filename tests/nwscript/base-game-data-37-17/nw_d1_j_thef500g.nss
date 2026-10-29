#include "nw_i0_plot"
#include "NW_J_THEFT"

void main()
{
    TakeFetchItem(GetPCSpeaker());
    RewardGP(500,GetPCSpeaker(),FALSE);
    RewardXP(GetPlotTag(),100,GetPCSpeaker());
    SetLocalInt(GetModule(),"NW_Theft_Plot"+GetTag(OBJECT_SELF),1);
}

