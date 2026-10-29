//::///////////////////////////////////////////////
//:: x2_OnEquip
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script is the global XP2
    OnEquip script that fires wheneever
    an item is equipped.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
#include "x2_inc_intweapon"
void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();
    string sItemTag = GetTag(oItem);

    /*
      *******************************
      Intelligent Weapon System
      *******************************
    */
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC,oItem);
        // prevent players from reequipping their weapon in
        if (IWGetIsInIntelligentWeaponConversation(oPC))
        {
                object oConv =   GetLocalObject(oPC,"X2_O_INTWEAPON_SPIRIT");
                IWEndIntelligentWeaponConversation(oConv, oPC);
        }
        else
        {
            //------------------------------------------------------------------
            // Trigger Drain Health Event
            //------------------------------------------------------------------
            if (GetLocalInt(oPC,"X2_L_ENSERRIC_ASKED_Q3")==1)
            {
                ExecuteScript ("x2_ens_dodrain",oPC);
            }
            else
            {
                IWPlayRandomEquipComment(oPC,oItem);
            }
        }
    }



    // *****************************
    // * GLOBAL
    // *****************************
       // SpawnScriptDebugger();

    // * When wearing Nasher's set of items, get special (Brent)
    // * benefits
    if (sItemTag == "x2_nash_boot" || sItemTag == "x2_nash_cloak" || sItemTag == "x2_nash_glove" || sItemTag == "x2_nash_ring")
    {
        effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);

        // * Do I have them all on?
        object oBoot =  GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
        object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
        object oGlove = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
        object oRing1 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
        object oRing2 = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);

        string sBoot = GetTag(oBoot);
        string sCloak = GetTag(oCloak);
        string sGlove = GetTag(oGlove);
        string sRing1 = GetTag(oRing1);
        string sRing2 = GetTag(oRing2);
        if (sBoot == "x2_nash_boot" && sCloak == "x2_nash_cloak" && sGlove == "x2_nash_glove"
            && (sRing1 == "x2_nash_ring" || sRing2 == "x2_nash_ring"))
        {
            itemproperty itProp = ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 7);
            IPSafeAddItemProperty(oBoot, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

            itProp = ItemPropertyACBonus(7);
            IPSafeAddItemProperty(oCloak, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

            itProp = ItemPropertySkillBonus(SKILL_DISCIPLINE, 10);
            IPSafeAddItemProperty(oGlove, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);


            itProp = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 7);
            if (sRing1 == "x2_nash_ring")
            {
                IPSafeAddItemProperty(oRing1, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            }
            else
            {
                IPSafeAddItemProperty(oRing2, itProp , 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            }

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        }

    }
    // *****************************
    // * SPECIFIC
    // *****************************

    //Helm of Shielding - for the Slaves to The Overmind areas
    if (GetTag(oItem) == "q2dmentalshield")
    {
        SetLocalInt(oPC, "X2_Q2DMindShielded", 1);
    }
    if (GetTag(oItem) == "x2_dreamrobe")
    {
       if  (GetLocalInt(GetModule(), "X2_ValsharessCurseActive") == 1)
       {
           FloatingTextStrRefOnCreature(85588,oPC);
           IPRemoveAllItemProperties(oItem,DURATION_TYPE_PERMANENT);
           effect eCurse1 = EffectCurse(0,0,0,5,5,5);
           effect eCurse2 = SupernaturalEffect(eCurse1);
           effect eCurse = ExtraordinaryEffect(eCurse2);
           ApplyEffectToObject(DURATION_TYPE_PERMANENT,eCurse, oPC);
       }
    }

    //check for equipping an item with the true seeing property on it in the Rakshasa area
    //Area
    object oArea = GetArea(oPC);

    //must be in the area
    if (GetTag(oArea) != "q2c_um2east")
        return;
    //Have the Rakshasa already transformed
    if (GetLocalInt(oArea, "X2_RakTransformed") == 1)
        return;

    //Make sure PC was in the back half of the area when casting
    object oTriggerArea = GetObjectByTag("q2ctrg_truesight");
    if (GetIsInSubArea(oPC, oTriggerArea) == FALSE)
        return;

    ExecuteScript("act_q2rakattack", oArea);


}
