#include "NW_I0_PLOT"

int StartingConditional()
{
    return (HasGold(250,GetPCSpeaker())) &&  CheckIntelligenceLow();
}
