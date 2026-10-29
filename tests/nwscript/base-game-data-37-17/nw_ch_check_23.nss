// DaelanC3story is 1.  Module is Chapter 3.  Player greater than level 11.
//This only shows up if the player has heard the first part of the story (story global set to 1)
//and the player is level 13 or higher.
// At the end of the story DaelanC3story is set to 2 (I have marked this in the comments).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetHitDice(GetPCSpeaker()) > 13 && GetChapter() == 3 && GetStoryVar(3) == 1;
    return iResult;
}
