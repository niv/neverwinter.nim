//------------------------------------------------------------------------------
// Condition: Can Craft Weapons?
//------------------------------------------------------------------------------
//
// Return TRUE when
//   ... Has a valid weapon in the right hand  AND
//   ... Weapon is NOT plot                    AND
//   ... Weapon is not intelligent             AND
//   ... Weapon is not a whip or sling (1 part item)
//------------------------------------------------------------------------------
// Last Updated: Oct 24, GZ: Can no longer modify an intelligent weapon
//------------------------------------------------------------------------------
#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oW = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,GetPCSpeaker());
    if (!GetIsObjectValid(oW))
    {
        return FALSE;
    }
    else if (GetPlotFlag(oW))
    {
        return FALSE;
    }
    else if (!IPGetIsMeleeWeapon(oW)&& !IPGetIsRangedWeapon(oW))
    {
        return FALSE;
    }
    else if (IPGetIsIntelligentWeapon(oW))
    {
        return FALSE;
    }
    else
    {
        if (!GetHasSkill(SKILL_CRAFT_WEAPON,GetPCSpeaker()))
        {
           return FALSE;
        }

        //----------------------------------------------------------------------
        // Can't Modify Slings or Whips
        //----------------------------------------------------------------------
        if( GetBaseItemType(oW) == BASE_ITEM_WHIP || GetBaseItemType(oW) == BASE_ITEM_SLING )
        {
            return FALSE;
        }

    }
    return TRUE;
}
