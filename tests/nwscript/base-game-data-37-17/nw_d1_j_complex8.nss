#include "NW_J_COMPLEX"
#include "nw_i0_plot"

void main()
{
    SetLocalInt(OBJECT_SELF,"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF),100);
    SetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF),100);
    TakeComplexItem(GetPCSpeaker());
}
