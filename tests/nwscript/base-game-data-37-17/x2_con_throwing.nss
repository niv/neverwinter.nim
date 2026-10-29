// * returns true if right hand weapon is a throwing weapon
#include "x2_inc_ws_smith"

int StartingConditional()
{
    // * Thrown weapons cannot be upgrade
    object oItem = GetRightHandWeapon(GetPCSpeaker());
    int nType = GetBaseItemType(oItem);

    if (nType == BASE_ITEM_SHURIKEN || nType == BASE_ITEM_THROWINGAXE || nType == BASE_ITEM_DART)
        return TRUE;
    return FALSE;
    
}
