// DaelanC3story is 0.  Module is Chapter 3.  This only shows up in Chapter 3.
// This only shows up if the player has NOT heard the henchman's first story.  At the very end of the story, DaelanC3story is set to 1 (I have marked this in the comments of his last line).
#include "nw_i0_plot"
#include "NW_i0_HENCHMAN"

int StartingConditional()
{
    int iResult;

    iResult = CheckIntelligenceNormal() && GetChapter() == 3 && GetStoryVar(3) == 0;
    return iResult;
}


