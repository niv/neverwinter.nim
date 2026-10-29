//DaelanC2story is 1.  Module is Chapter 2.  Player greater than level 8.  This only shows up if the player has heard the first part of the story (story global set to 1) and the player is level 8 or higher.  At the end of the story DaelanC2story is set to 2 (I have marked this in the comments).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetStoryVar(2) == 1 && GetHitDice(GetPCSpeaker()) > 8;
    return iResult;
}
