// * DaelanC2greet is 0.  DaelanWork is 0.  Initial greeting.  When the player first meets him in chapter 2.  Set DaelanC2greet to 1.  Do this later on in the dialogue, about 3 dialogue nodes in (I have marked those as well).   The player doesn't have the henchman's personal item (daelanpersonal).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 2 && HasPersonalItem(GetPCSpeaker()) == FALSE && GetBeenHired() == FALSE && GetGreetingVar(2, GetPCSpeaker()) == FALSE;
    return iResult;
}
