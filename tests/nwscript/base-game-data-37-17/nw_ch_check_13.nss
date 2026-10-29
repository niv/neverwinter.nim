//DaelanC2story is greater than 0.  Module is Chapter 2.This only shows up in Chapter 2. This shows up if the player HAS heard the henchman's first story.
#include "nw_i0_plot"
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = CheckIntelligenceLow() && GetChapter() == 2 && GetStoryVar(2) > 0 && GetStoryVar(2) <4;
    return iResult;
}

