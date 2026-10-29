// DaelanC3story is 2.  Module is Chapter 3.  Player is greater than level 12.
// Player has item 'Daelanchaptertwo'.  This only shows up if the player has heard the second part of the story (story global set to 2) and the player is greater than level 15.  The player also needs the item 'Daelanchaptertwo'.
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = HasChapterRewardItem(2, GetPCSpeaker()) && GetHitDice(GetPCSpeaker()) > 14 && GetChapter() == 3 && GetStoryVar(3) == 2;
    return iResult;
}

