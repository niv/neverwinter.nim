//::///////////////////////////////////////////////
//:: Black Blade of Disaster
//:: X2_S0_BlckBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greatsword to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, July 28 - 2003


#include "x2_inc_intweapon"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCreator, object oBlade, object oSummon)
{

}

#include "x2_inc_spellhook"

void main()
{

    DeleteLocalInt(OBJECT_SELF,"X2_L_IN_INTWEAPON_CONVERSATION");

    object oBlade = GetSpellCastItem();
    object oCreator = OBJECT_SELF;

    IWStartIntelligentWeaponConversation(oCreator,oBlade);

   // ActionUnequipItem(oBlade);
}
