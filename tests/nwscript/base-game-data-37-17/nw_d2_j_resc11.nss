#include "NW_I0_Plot"
#include "NW_J_RESCUE"

int StartingConditional()
{
    int bCondition = !PlayerHasRing(GetPCSpeaker());
    return bCondition;
}

