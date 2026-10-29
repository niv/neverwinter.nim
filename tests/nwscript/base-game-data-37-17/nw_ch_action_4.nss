// * Gives the item 'Daelanchapterone'.  This item will be used in chapter 2 as an indicator that the player finished Daelan's quest.
#include "Nw_i0_henchman"

void main()
{
    SetStoryVar(1, 4);
    DestroyChapterQuestItem(1, GetPCSpeaker());
    GiveChapterRewardItem(1, GetPCSpeaker());
}
