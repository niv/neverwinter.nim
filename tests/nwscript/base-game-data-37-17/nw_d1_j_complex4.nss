#include "NW_I0_Plot"
#include "NW_J_COMPLEX"

void main()
{
  object oItem = GetItemPossessedBy(GetPCSpeaker(), GetComplexItem());
    if (GetIsObjectValid(oItem))
    ActionTakeItem( oItem, GetPCSpeaker());

}
