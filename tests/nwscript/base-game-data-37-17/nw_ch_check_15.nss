//DaelanC2story is 2.  Module is Chapter 2.  Player is greater than level 10.
//Player has item 'Daelanchapterone'.
//This only shows up if the player has heard the second part of the story (story global set to 2) and the player is greater than level 8.  The player also needs the item 'Daelanchapterone'.

#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = HasChapterRewardItem(1, GetPCSpeaker()) && GetStoryVar(2) == 2 && GetHitDice(GetPCSpeaker()) > 9;
    return iResult;
}
