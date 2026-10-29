//::///////////////////////////////////////////////
//:: x2_con_ws_israng
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the right hand weapon is NOT melee
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"
#include "x0_i0_match"


int StartingConditional()
{
    // * Thrown weapons cannot be upgrade
    object oItem = GetRightHandWeapon(GetPCSpeaker());
    int nType = GetBaseItemType(oItem);
    if (nType == BASE_ITEM_SHURIKEN || nType == BASE_ITEM_THROWINGAXE || nType == BASE_ITEM_DART)
        return FALSE;
        
    int iResult;

    iResult = GetWeaponRanged(oItem);
    return iResult;
}

