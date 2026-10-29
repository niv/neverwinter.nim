// Dorna is on sixth story, must be Interlude

#include "x0_i0_henchman"

int StartingConditional()
{
    int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Dorna_Story");
    if ((nStory == 5) && (GetChapter() > 1))
    {
        return TRUE;
    }
    return FALSE;
}
