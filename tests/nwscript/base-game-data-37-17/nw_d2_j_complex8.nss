#include "NW_I0_PLOT"

int StartingConditional()
{
    return CheckIntelligenceNormal() && GetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) <20;
}
