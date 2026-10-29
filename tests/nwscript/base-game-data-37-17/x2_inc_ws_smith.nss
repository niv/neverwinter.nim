//::///////////////////////////////////////////////
//:: x2_inc_ws_smith
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Main include file for the weapon upgrade smith.
    
    * Nov 5th 2003 (BK)
     - Unlimited ammo property is now +5 not +3
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

//****************************************************
// * Constants
//****************************************************
#include "x2_inc_itemprop"

// Tokens
const int WeaponToken = 9809;
  const int CostOfAcid = 9711;  // All elemental damages use this.
  const int CostOfHaste = 9712;
  const int CostOfKeen = 9713;
  const int CostOfTrueSeeing = 9714;
  const int CostOfSpellResistance = 9715;
  const int CostOfRegeneration2 = 9716;
  const int CostOfEnhancement = 9717;

  // * Ranged
  const int CostOfAttackBonus = 9611;
  const int CostOfMighty5 = 9612;
  const int CostOfMighty10 = 9613;
  const int CostOfUnlimited3 = 9614;

// Prices
const int WS_COST_ACID_PROPERTY = 75000; // All elemental damages use this.
const int WS_COST_ATTACK_BONUS = 30000;
const int WS_COST_ENHANCEMENT_BONUS = 50000;
const int WS_COST_HASTE = 150000;
const int WS_COST_KEEN = 50000;
const int WS_COST_TRUESEEING = 30000;
const int WS_COST_SPELLRESISTANCE = 75000;
const int WS_COST_REGENERATION2 = 75000;
const int WS_COST_MIGHTY_5 = 50000;
const int WS_COST_MIGHTY_10 = 100000;
const int WS_COST_UNLIMITED_3 = 100000;

// * Other Constants -- needed to make "fake" constants for some item property
const int IP_CONST_WS_ATTACK_BONUS = 19000;
const int IP_CONST_WS_ENHANCEMENT_BONUS = 19001;
const int IP_CONST_WS_HASTE = 19002;
const int IP_CONST_WS_KEEN = 19003;
const int IP_CONST_WS_TRUESEEING = 19005;
const int IP_CONST_WS_SPELLRESISTANCE = 19006;
const int IP_CONST_WS_REGENERATION = 19007;
const int IP_CONST_WS_MIGHTY_5 = 19008;
const int IP_CONST_WS_MIGHTY_10 = 19009;
const int IP_CONST_WS_UNLIMITED_3 = 19010;

const int MAX_ENHANCEMENT_BONUS = 10;
const int MAX_ATTACK_BONUS = 10;

//****************************************************
// * Declaration
//****************************************************
void SetWeaponToken(object oPC);
// * Function checks against WS_ properties to
// * see if its okay to add this item property
int IsOkToAdd(object oPC, int nPropertyCode);
object GetRightHandWeapon(object oPC);
// * sets all custom tokens for the prices of services
void wsSetupPrices();
// * A variable has been set earlier to indicate
// * which item property you want to add
// * now it tests to see if you have enough
// * gold for that item property
int wsHaveEnoughGoldForCurrentItemProperty(object oPC);
// * MAJOR
// * Actual function to add the enhancement to the item
void wsEnhanceItem(object oWielder, object oPC);
// * Returns the correct item proeprty based upon nType
// * oItem is passed in to find specific information about the
// * current item
itemproperty ReturnItemPropertyToUse(int nType, object oItem);
// * Returns total attack bonus for the item
int ReturnAttackBonus(object oItem);
// * Returns total enhancement bonus for the item
int ReturnEnhancementBonus(object oItem);

//****************************************************
// * Implementation
//****************************************************

void SetWeaponToken(object oPC)
{
    // * Get Name of weapon
    // * Assumption -- a weapon is being held
    // * in the main hand
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    string sWeaponName = "";
    if (GetIsObjectValid(oItem) == TRUE)
    {
        sWeaponName = GetName(oItem);
    }
    else
    {
        return;
    }
    SetCustomToken(WeaponToken, sWeaponName);
}
object GetRightHandWeapon(object oPC)
{
    return  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
}
// * Function checks against WS_ properties to
// * see if its okay to add this item property
int IsOkToAdd(object oPC, int nPropertyCode)
{
    object oItem = GetRightHandWeapon(oPC);

    // * Always okay to add attack or enhancement bonuses, up to +10
    if (nPropertyCode ==  IP_CONST_WS_ATTACK_BONUS)
    {
        if (ReturnAttackBonus(oItem) < MAX_ATTACK_BONUS)
            return TRUE;
        else
            return FALSE;
    }
    else
    if (nPropertyCode == IP_CONST_WS_ENHANCEMENT_BONUS)
    {
        if (ReturnEnhancementBonus(oItem) < MAX_ENHANCEMENT_BONUS)
            return TRUE;
        else
            return FALSE;

    }

    itemproperty ip = ReturnItemPropertyToUse(nPropertyCode, oItem);
    int nMatchSubType = TRUE;


    // * Its okay to add these item properties as long as the subtype does not match
    nMatchSubType = FALSE;

    int bOkToAdd = IPGetItemHasProperty(oItem,ip, -1, TRUE);
    if (bOkToAdd == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
// * this function added to balance out cost of very high magical item
// * modification (so its not super cheat to get a +10 weapon)
int InflateCost(int nGoldNeed)
{
    // * Modifier (November 5 2003 -- Up the price if this item already
    // * has numerous other enchancement bonuses
        object oItem = GetRightHandWeapon(GetPCSpeaker());
        int nBonus = ReturnEnhancementBonus(oItem);
        if (nBonus > 4)
        {
            int nDiff = nBonus - 4;
            nDiff = 20000 * nDiff; // * this is extra cost to add
            nGoldNeed = nGoldNeed + nDiff;
        }
    return nGoldNeed;
}


// * sets all custom tokens for the prices of services
void wsSetupPrices()
{
    SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY)); // * All elemental damages use this
    SetCustomToken(CostOfAttackBonus, IntToString(WS_COST_ATTACK_BONUS));
    SetCustomToken(CostOfEnhancement, IntToString(InflateCost(WS_COST_ENHANCEMENT_BONUS)));

    SetCustomToken(CostOfHaste, IntToString(WS_COST_HASTE));
    SetCustomToken(CostOfKeen, IntToString(WS_COST_KEEN));
    SetCustomToken(CostOfTrueSeeing, IntToString(WS_COST_TRUESEEING));
    SetCustomToken(CostOfSpellResistance, IntToString(WS_COST_SPELLRESISTANCE));
    SetCustomToken(CostOfRegeneration2, IntToString(WS_COST_REGENERATION2));

    SetCustomToken(CostOfMighty5, IntToString(WS_COST_MIGHTY_5));
    SetCustomToken(CostOfMighty10, IntToString(WS_COST_MIGHTY_10));
    SetCustomToken(CostOfUnlimited3, IntToString(WS_COST_UNLIMITED_3));




}


int GetGoldValueForService(int nService)
{
    int nGoldNeed = 0;
    switch (nService)
    {
        case IP_CONST_DAMAGETYPE_ACID:
        case IP_CONST_DAMAGETYPE_FIRE:
        case IP_CONST_DAMAGETYPE_COLD:
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
            nGoldNeed = WS_COST_ACID_PROPERTY; break;

        case IP_CONST_WS_ATTACK_BONUS: nGoldNeed = WS_COST_ATTACK_BONUS; break;
        case IP_CONST_WS_ENHANCEMENT_BONUS:
        {
            nGoldNeed = WS_COST_ENHANCEMENT_BONUS;
            nGoldNeed = InflateCost(nGoldNeed);
            break;
        }
        case IP_CONST_WS_HASTE: nGoldNeed = WS_COST_HASTE; break;
        case IP_CONST_WS_KEEN: nGoldNeed = WS_COST_KEEN;break;
        case IP_CONST_WS_TRUESEEING: nGoldNeed = WS_COST_TRUESEEING;break;
        case IP_CONST_WS_SPELLRESISTANCE: nGoldNeed = WS_COST_SPELLRESISTANCE; break;
        case IP_CONST_WS_REGENERATION: nGoldNeed = WS_COST_REGENERATION2; break;
        case IP_CONST_WS_MIGHTY_5: nGoldNeed = WS_COST_MIGHTY_5; break;
        case IP_CONST_WS_MIGHTY_10: nGoldNeed = WS_COST_MIGHTY_10; break;
        case IP_CONST_WS_UNLIMITED_3: nGoldNeed = WS_COST_UNLIMITED_3; break;



    }
    return nGoldNeed;
}
// * A variable has been set earlier to indicate
// * which item property you want to add
// * now it tests to see if you have enough
// * gold for that item property
int wsHaveEnoughGoldForCurrentItemProperty(object oPC)
{
    int nGoldHave = GetGold(oPC);
    int nCurrentItemProperty = GetLocalInt(OBJECT_SELF, "X2_LAST_PROPERTY");
    int nGoldNeed = GetGoldValueForService(nCurrentItemProperty);
    if (nGoldHave >= nGoldNeed)
    {
        return TRUE;
    }
    return FALSE;
}

// * Returns total attack bonus for the item
int ReturnAttackBonus(object oItem)
{
    itemproperty ipFirst = GetFirstItemProperty(oItem);
    int nBonus = 0;
    while (GetIsItemPropertyValid(ipFirst) == TRUE)
    {
        if (GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ATTACK_BONUS)
        {
            int nSubType = GetItemPropertyCostTableValue(ipFirst);
            //SpeakString("Found an attack bonus! SubType = " + IntToString(nSubType));
            nBonus = nBonus + (nSubType);
            return nBonus; // * Quick exit. Got what I need
        }
        ipFirst = GetNextItemProperty(oItem);
    }
    //SpeakString("Attack Bonus = " + IntToString(nBonus));
    return nBonus;
}
// * Returns total enhancement bonus for the item
int ReturnEnhancementBonus(object oItem)
{
    itemproperty ipFirst = GetFirstItemProperty(oItem);
    int nBonus = 0;
    while (GetIsItemPropertyValid(ipFirst) == TRUE)
    {
        if (GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            int nSubType = GetItemPropertyCostTableValue(ipFirst);
            //SpeakString("Found an attack bonus! SubType = " + IntToString(nSubType));
            nBonus = nBonus + (nSubType);
            return nBonus; // * Quick exit. Got what I need
        }
        ipFirst = GetNextItemProperty(oItem);
    }
    //SpeakString("Attack Bonus = " + IntToString(nBonus));
    return nBonus;
}

// * Returns the correct item proeprty based upon nType
// * oItem is passed in to find specific information about the
// * current item
itemproperty ReturnItemPropertyToUse(int nType, object oItem)
{
    itemproperty ip;
    switch(nType)
    {
        case IP_CONST_DAMAGETYPE_ACID:
        case IP_CONST_DAMAGETYPE_FIRE:
        case IP_CONST_DAMAGETYPE_COLD:
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
        {
            ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_2d6);
            break;
        }
        case IP_CONST_WS_ATTACK_BONUS:
        {
            int nNewBonus = ReturnAttackBonus(oItem) + 1;

            ip = ItemPropertyAttackBonus(nNewBonus);
            break;
        }
        case IP_CONST_WS_ENHANCEMENT_BONUS:
        {

            int nNewBonus = ReturnEnhancementBonus(oItem) + 1;

            ip = ItemPropertyEnhancementBonus(nNewBonus);
            break;
        }
        case IP_CONST_WS_HASTE:
        {
            ip = ItemPropertyHaste();
            break;
        }
        case IP_CONST_WS_KEEN:
        {
            ip = ItemPropertyKeen();
            break;
        }
        case IP_CONST_WS_TRUESEEING:
        {
            ip = ItemPropertyTrueSeeing();
            break;
        }
        case IP_CONST_WS_SPELLRESISTANCE:
        {
            ip = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20);
            break;
        }
        case IP_CONST_WS_REGENERATION:
        {
            ip = ItemPropertyRegeneration(2);
            break;
        }
        case IP_CONST_WS_MIGHTY_5:
        {
            ip = ItemPropertyMaxRangeStrengthMod(5);
            break;
        }
        case IP_CONST_WS_MIGHTY_10:
        {
            ip = ItemPropertyMaxRangeStrengthMod(10);
            break;
        }
        case IP_CONST_WS_UNLIMITED_3:
        {
            ip = ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS5);
            break;
        }

    }
    return ip;

}
// * MAJOR
// * Actual function to add the enhancement to the item
// * Also takes the gold
void wsEnhanceItem(object oWielder, object oPC)
{
    object oItem = GetRightHandWeapon(oWielder);
    int nCurrentItemProperty = GetLocalInt(OBJECT_SELF, "X2_LAST_PROPERTY");
    int nGoldToTake = GetGoldValueForService(nCurrentItemProperty);
//    SpeakString("Enhance " + GetName(oItem));

    // * if player tries to cheat just abort the item creation. (You can only have
    // * this happen by moving your gold out of your inventory as you are talking).
    if (GetGold(oPC) < nGoldToTake)
    {
        return;
    }
    TakeGoldFromCreature(nGoldToTake, oPC, FALSE);
    // * GZ: Remove all temporary item properties from oItem to counter bug #35259
    IPRemoveAllItemProperties(oItem,DURATION_TYPE_TEMPORARY);
    itemproperty ip =  ReturnItemPropertyToUse(nCurrentItemProperty, oItem);
    IPSafeAddItemProperty(oItem, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);


}

