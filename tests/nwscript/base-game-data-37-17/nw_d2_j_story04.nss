#include "NW_I0_PLOT"
#include "NW_J_STORY"

int StartingConditional()
{

   int bCondition = GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(),GetStoryItem()))
                && CheckIntelligenceLow();
    return bCondition;

}
