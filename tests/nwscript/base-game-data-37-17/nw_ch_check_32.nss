// DaelanC2greet is 1.  DaelanWork is 0.  Default greeting in chapter 2 (the player has already talked to him once).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 2 && GetBeenHired() == FALSE && GetGreetingVar(2, GetPCSpeaker()) == TRUE;
    return iResult;
}
