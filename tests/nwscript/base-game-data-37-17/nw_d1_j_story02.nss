/////////////
//Job accepted (advance no longer available)
////////////
#include "nw_i0_plot"

void main()
{
    SetPLocalInt(GetPCSpeaker(),"NW_STORY"+GetTag(OBJECT_SELF),30);
}

