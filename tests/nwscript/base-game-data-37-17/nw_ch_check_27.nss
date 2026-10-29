//This only shows up if the player has the item (Daelanspear).
#include "nw_i0_henchman"
#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = HasChapterQuestItem(3, GetPCSpeaker()) && CheckIntelligenceLow() ;
    return iResult;
}
