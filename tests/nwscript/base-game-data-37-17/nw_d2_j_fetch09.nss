///ITEM CHECK

#include "NW_I0_Plot"
#include "NW_J_FETCH"

int StartingConditional()
{
    int bCondition = PlayerHasFetchItem(GetPCSpeaker()) && CheckIntelligenceNormal();
    return bCondition;
}

