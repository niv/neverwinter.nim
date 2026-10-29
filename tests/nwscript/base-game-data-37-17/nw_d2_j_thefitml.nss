#include "NW_I0_Plot"
#include "NW_J_THEFT"
int StartingConditional()
{
    if(PlayerHasFetchItem(GetPCSpeaker()) == TRUE)
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}

