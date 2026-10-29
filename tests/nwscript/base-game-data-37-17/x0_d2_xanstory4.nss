// Xanos is on fourth story, must be Interlude

#include "x0_i0_henchman"

int StartingConditional()
{
    int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story");
    if ((nStory == 3) && (GetChapter() > 1))
    {
        return TRUE;
    }
    return FALSE;
}
