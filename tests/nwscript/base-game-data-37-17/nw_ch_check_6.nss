#include "nw_i0_henchman"
/*
DaelanC1story is 2.  Module is Chapter 1.  Player is greater than level 5.  This only shows up if the player has heard the second part of the story (story global set to 2) and the player is greater than level 5.
*/
int StartingConditional()
{
    int iResult;

    iResult = GetHitDice(GetPCSpeaker()) > 5 && GetStoryVar(1) == 2;
    return iResult;
}

