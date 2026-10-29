////////  Set complex plot to status 20 - accepted or tried to get advance


#include "nw_i0_plot"

void main()
{
    SetPLocalInt(GetPCSpeaker(), "NW_COMPLEXPLOT"+GetTag(OBJECT_SELF), 20);
}

