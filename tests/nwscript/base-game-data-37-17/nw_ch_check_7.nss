#include "nw_i0_henchman"
/*
DaelanC1story is 3.  Module is Chapter 1.  This only shows up if the player has heard the third part of the story (story global set to 3).  The player's level doesn't matter.
*/
int StartingConditional()
{
    int iResult;

    iResult = GetStoryVar(1) == 3;
    return iResult;
}
