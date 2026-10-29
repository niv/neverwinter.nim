#include "nw_i0_plot"

void main()
{
    SetLocalInt(OBJECT_SELF,"I_AM_FRIENDLY",1);
    SetPLocalInt(GetPCSpeaker(),"NW_G_TalkTo"+GetTag(OBJECT_SELF),1);
}


