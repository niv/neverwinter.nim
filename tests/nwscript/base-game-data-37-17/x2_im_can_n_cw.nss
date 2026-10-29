//------------------------------------------------------------------------------
// Starting Condition
//------------------------------------------------------------------------------
/*
    Return TRUE if
        No weapon is equipped OR
        The current weapon is marked as plot OR
        The current weapon is a sling or whip as plot OR
        Craft Weapon has been deactivated by a global variable
*/
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oW = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,GetPCSpeaker());

    iResult = !GetIsObjectValid(oW);
    iResult = iResult || GetPlotFlag(oW) || (!IPGetIsMeleeWeapon(oW)&& !IPGetIsRangedWeapon(oW));
    iResult = iResult || GetBaseItemType(oW) == BASE_ITEM_WHIP || GetBaseItemType(oW) == BASE_ITEM_SLING;
    iResult = iResult || GetLocalInt(GetModule(),"X2_L_DO_NOT_ALLOW_MODIFY_WEAPON");
    return iResult;
}
