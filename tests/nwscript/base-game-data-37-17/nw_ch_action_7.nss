// * DaelanC2story is set to 2 if player has ChapterRewardItem1, else is set to 4
#include "nw_i0_henchman"
void main()
{
    if (HasChapterRewardItem(1, GetPCSpeaker()))
        SetStoryVar(2,2);
    else
        SetStoryVar(2,4);
}
