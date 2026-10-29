// * Replaces Daelanchapterone with 'Daelanchaptertwo'.  This item will be used in chapter 3 as an indicator that the player finished Daelan's quest.
#include "Nw_i0_henchman"

void main()
{
    SetStoryVar(2, 4);
    GiveChapterRewardItem(2, GetPCSpeaker());
    // * may 24 2002: Destroying Chapter 2 quest item
    DestroyChapterQuestItem(2, GetPCSpeaker());
}


