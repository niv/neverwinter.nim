// * Normal IQ + Is able to level up
#include "nw_i0_plot"
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;
    // * April 20. this option should not even come up if the henchman is at max levels
    if (GetHitDice(OBJECT_SELF) < 14)
    {
        iResult = CheckIntelligenceLow() && GetCanLevelUp(GetPCSpeaker());
    }
    else
    {
        iResult = FALSE;
    }
    return iResult;
}
