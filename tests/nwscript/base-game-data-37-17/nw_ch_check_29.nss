// * DaelanC1greet is 1.  DaelanWork is 0.  Default greeting in chapter 1 (the player has already talked to him once).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 1 && GetBeenHired() == FALSE && GetGreetingVar(1, GetPCSpeaker()) == TRUE;
    return iResult;
}

