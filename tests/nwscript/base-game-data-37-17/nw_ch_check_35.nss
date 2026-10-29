// DaelanC3greet is 1.  DaelanWork is 0. Default greeting in chapter 3 (the player has already talked to him once).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 3 && GetBeenHired() == FALSE && GetGreetingVar(3, GetPCSpeaker()) == TRUE;
    return iResult;
}

