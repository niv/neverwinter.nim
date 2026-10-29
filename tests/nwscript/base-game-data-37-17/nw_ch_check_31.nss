// DaelanC2greet is 0.  DaelanWork is 0.  Initial greeting.  When the player first meets him in chapter 2.  The player DOES have the henchman's personal item (daelanpersonal).  This will always be the greeting that Daelan uses with player's that have his personal item (the DaelanC2greet does NOT get incremented).
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 2 && HasPersonalItem(GetPCSpeaker()) == TRUE && GetBeenHired() == FALSE && GetGreetingVar(2, GetPCSpeaker()) == FALSE;
    return iResult;
}

