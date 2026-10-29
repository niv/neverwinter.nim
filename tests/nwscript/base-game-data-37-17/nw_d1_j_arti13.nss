#include "nw_i0_plot"

void main()
{
    SetPLocalInt(GetPCSpeaker(),"NW_ARTI_PLOT_TOLD"+GetTag(OBJECT_SELF),1);
}

