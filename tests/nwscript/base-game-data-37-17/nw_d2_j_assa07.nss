#include "NW_I0_Plot"
#include "NW_J_ASSASSIN"

int StartingConditional()
{
    if (PlayerHasPersonalItem(GetPCSpeaker()) == TRUE)
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}

