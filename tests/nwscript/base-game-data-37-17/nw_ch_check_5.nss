#include "nw_i0_henchman"
/*
DaelanC1story is 1.  Module is Chapter 1.  Player greater than level 4.  This only shows up if the player has heard the first part of the story (story global set to 1) and the player is level 5 or higher.  At the end of the story DaelanC1story is set to 2 (I have marked this in the comments).
*/
int StartingConditional()
{
    int iResult;

    iResult = GetHitDice(GetPCSpeaker()) > 4 && GetStoryVar(1) == 1;
    return iResult;
}
