// *DaelanC3story is set to 2  if player has ChapterRewardItem2,else is set to 4

#include "nw_i0_henchman"
void main()
{
    if (HasChapterRewardItem(2, GetPCSpeaker()))
        SetStoryVar(3,2);
    else
        SetStoryVar(3,4);
}

