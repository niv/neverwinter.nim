//DaelanC2story is 3.  Module is Chapter 2.  This only shows up if the player has heard the third part of the story (story global set to 3).  The player's level doesn't matter.

#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetStoryVar(2) == 3 ;
    return iResult;
}

