//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "x2_inc_intweapon"

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();

   if (GetIsObjectValid(oItem))
   {
       //-----------------------------------------------------------------------
       // we only care for creatures
       //-----------------------------------------------------------------------
       if (GetObjectType(oSpellTarget) != OBJECT_TYPE_CREATURE)
       {
           return;
       }

       //-----------------------------------------------------------------------
       // Only if this weapon is an intelligent weapon, fire up interj. code
       //-----------------------------------------------------------------------
       if (IPGetIsIntelligentWeapon(oItem))
       {
          IWPlayRandomHitQuote(oSpellOrigin,oItem,oSpellTarget);
       }
   }
}
