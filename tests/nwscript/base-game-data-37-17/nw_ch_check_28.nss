// * DaelanC1greet is 0.  DaelanWork is 0.  Initial greeting.  When the player first meets him in chapter 1.  Set DaelanC1greet to 1.  Do this later on in the dialogue, about 3 dialogue nodes in (I have marked those as well). Have I ever been hired is 0
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 1 && GetBeenHired() == FALSE && GetGreetingVar(1, GetPCSpeaker()) == FALSE;
    return iResult;
}
