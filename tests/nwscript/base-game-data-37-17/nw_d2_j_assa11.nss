#include "NW_I0_Plot"
#include "NW_J_ASSASSIN"

int StartingConditional()
{
    return CheckIntelligenceLow() && VictimDeadButNoItems(GetPCSpeaker());
}

