// Xanos is on last story, must be Chapter 2

#include "x0_i0_henchman"

int StartingConditional()
{
    int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story");
    if ((nStory == 6) && (GetChapter() == 3))
    {
        return TRUE;
    }
    return FALSE;
}
