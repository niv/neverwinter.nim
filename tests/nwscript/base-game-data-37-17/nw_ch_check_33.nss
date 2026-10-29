// DaelanC3greet is 0.  DaelanWork is 0.  Initial greeting.
// When the player first meets him in chapter 3.  Set DaelanC3greet to 1.
// Do this later on in the dialogue, about 3 dialogue nodes in (I have marked those as well).
// The player doesn't have the henchman's personal item (daelanpersonal).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = HasPersonalItem(GetPCSpeaker()) == FALSE && GetChapter() == 3 && GetBeenHired() == FALSE && GetGreetingVar(3, GetPCSpeaker()) == FALSE;
    return iResult;
}

