#include "nw_i0_plot"

void main()
{
    SetPLocalInt(GetPCSpeaker(),"NW_Theft_Plot_Accepted"+GetTag(OBJECT_SELF),1);
}

