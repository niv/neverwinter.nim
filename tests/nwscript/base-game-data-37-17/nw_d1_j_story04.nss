////////////////
//Job completed, take item away
////////////////

#include "NW_J_STORY"
#include "nw_i0_plot"

void main()
{

   object oItem = GetItemPossessedBy(GetPCSpeaker(), GetStoryItem());
    if (GetIsObjectValid(oItem))
    ActionTakeItem( oItem, GetPCSpeaker());

    SetPLocalInt(GetPCSpeaker(),"NW_STORY"+GetTag(OBJECT_SELF),99);
    SetLocalInt(OBJECT_SELF, "NW_STORY"+GetTag(OBJECT_SELF),99);
}

