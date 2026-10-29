#include "NW_J_ASSASSIN"
#include "nw_i0_plot"

void main()
{
    SetPLocalInt(GetPCSpeaker(),"NW_ASSA_DOUBLE_CROSS",1);
    SetLocalInt(OBJECT_SELF,"NW_ASSA_DOUBLE_CROSS",1);
    SetDoubleCrosserName(GetPCSpeaker());
}

