// * DaelanWork is 1. This starting condition shows up if Daelan was killed.
// The player needs to have the item 'daelanpersonal'.
// If the player doesn't have this, then Daelan will simply treat the player
// like any other player (probably his second time talked to dialogue).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetWorkingForPlayer(GetPCSpeaker()) == TRUE &&
        GetDidDie() == TRUE &&
        HasPersonalItem(GetPCSpeaker()) == TRUE ; ;
    return iResult;
}

