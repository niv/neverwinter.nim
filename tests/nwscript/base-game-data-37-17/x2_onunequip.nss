//::///////////////////////////////////////////////
//:: x2_OnUnEquip
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script is the global XP2
    OnUnEquip script that fires wheneever
    an item is unequipped.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


#include "x2_inc_itemprop"
#include "x2_inc_intweapon"
void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
    string sItemTag = GetTag(oItem);

    /*
      *******************************
      Intelligent Weapon System
      *******************************
    */
    if (IPGetIsIntelligentWeapon(oItem))
    {
            IWSetIntelligentWeaponEquipped(oPC,OBJECT_INVALID);
            IWPlayRandomUnequipComment(oPC,oItem);
    }

    // * When wearing Nasher's set of items, get special (Brent)
    // * benefits
    if (sItemTag == "x2_nash_boot" || sItemTag == "x2_nash_cloak" || sItemTag == "x2_nash_glove" || sItemTag == "x2_nash_ring")
    {
        effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

        // * Do I have them all on?
        object oBoot =  GetItemPossessedBy(oPC, "x2_nash_boot");
        object oCloak = GetItemPossessedBy(oPC, "x2_nash_cloak");
        object oGlove = GetItemPossessedBy(oPC, "x2_nash_glove");
        object oRing = GetItemPossessedBy(oPC, "x2_nash_ring");

        string sBoot = GetTag(oBoot);
        string sCloak = GetTag(oCloak);
        string sGlove = GetTag(oGlove);
        string sRing = GetTag(oRing);

        itemproperty itProp = ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 3);

        if (GetIsObjectValid(oBoot))
            IPSafeAddItemProperty(oBoot, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

        itProp = ItemPropertyACBonus(3);

        if (GetIsObjectValid(oCloak))
            IPSafeAddItemProperty(oCloak, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

        itProp = ItemPropertySkillBonus(SKILL_DISCIPLINE, 5);
        if (GetIsObjectValid(oGlove))
            IPSafeAddItemProperty(oGlove, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

        itProp = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 3);
        if (GetIsObjectValid(oRing))
            IPSafeAddItemProperty(oRing, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    }
    
    /*
      *******************************
      SPECIFIC ITEMS
      *******************************
    */
    //Helm of Shielding - used in the Slaves to the Overmind Area
    if (GetTag(oItem) == "q2dmentalshield")
    {
        SetLocalInt(oPC, "X2_Q2DMindShielded", 0);
    }

}
