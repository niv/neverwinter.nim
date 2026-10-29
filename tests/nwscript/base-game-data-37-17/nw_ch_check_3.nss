//DaelanC1story is greater than 0.  Module is Chapter 1.This only shows up in Chapter 1.
//This shows up if the player HAS heard the henchman's first story.
#include "nw_i0_plot"
#include "NW_i0_HENCHMAN"

int StartingConditional()
{
    int iResult;

    iResult = CheckIntelligenceNormal() && GetChapter() == 1 && GetStoryVar(1) >= 1 && GetStoryVar(1) <4;
    return iResult;
}

