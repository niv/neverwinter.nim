// * This only shows up if the player has the item (Daelanbrooch).
#include "NW_I0_HENCHMAN"
#include "NW_I0_PLOT"

int StartingConditional()
{
    int iResult;

    iResult = CheckIntelligenceNormal() && HasChapterQuestItem(1,GetPCSpeaker());
    return iResult;
}
