////////  Set complex plot to status 10 - mentioned if not already higher



#include "nw_i0_plot"

void main()
{
    if (GetPLocalInt (GetPCSpeaker(), "NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) <= 10)
        SetPLocalInt(GetPCSpeaker(), "NW_COMPLEXPLOT"+GetTag(OBJECT_SELF), 10);
}
