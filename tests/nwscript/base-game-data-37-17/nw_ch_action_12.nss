// *Gives player an extremely powerful magic item.
#include "nw_i0_henchman"
void main()
{
    SetStoryVar(3,4);
    DestroyChapterQuestItem(3, GetPCSpeaker());
    GiveChapterRewardItem(3, GetPCSpeaker());
}
