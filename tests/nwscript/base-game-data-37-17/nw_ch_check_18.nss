// * This only shows up if the player has the item (Daelansword).
#include "nw_i0_henchman"
#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = CheckIntelligenceLow() && HasChapterQuestItem(2,GetPCSpeaker());
    return iResult;
}
