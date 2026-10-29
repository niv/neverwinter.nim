#include "NW_I0_PLOT"

int StartingConditional()
{
    return CheckIntelligenceLow() && GetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) >=20
                &&  GetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) <100;
}
