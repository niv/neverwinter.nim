// * returns true if the right hand weapon on a creature already has 8 enchantments
#include "x2_inc_ws_smith"

int StartingConditional()
{

    object oItem = GetRightHandWeapon(GetPCSpeaker());
    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    if (IPGetNumberOfItemProperties (oItem) >= X2_IP_MAX_ITEM_PROPERTIES)
    {
        return TRUE;
    }
    return FALSE;

}
