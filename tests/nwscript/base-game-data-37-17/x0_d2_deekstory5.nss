// Deekin is on last story, must be chapter 2

#include "x0_i0_henchman"

int StartingConditional()
{
    int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story");
    if ((nStory == 3) && (GetChapter() == 3))
    {
        return TRUE;
    }
    return FALSE;
}
