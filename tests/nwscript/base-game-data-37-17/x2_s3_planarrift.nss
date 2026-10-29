//::///////////////////////////////////////////////
//:: OnHit CastSpell: Planarrift
//:: x2_s3_planarrift
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "x0_i0_spells"
void main()
{


   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();
   object oFeedback = GetMaster(OBJECT_SELF);

    if (!GetIsObjectValid(oFeedback))
    {
        oFeedback = OBJECT_SELF;
    }

   if (GetIsPC(OBJECT_SELF))
   {
        // NONONO, player's are not supposed to use this
         effect eDeath = EffectDeath(TRUE);
         ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,OBJECT_SELF);
   }

   int nDC = 10+GetCasterLevel(oSpellOrigin);

   if (GetIsObjectValid(oItem))
   {
        if (GetIsObjectValid(oSpellTarget))
        {

           if (MyResistSpell(oFeedback,oSpellTarget) == 0)
           {
               if( FortitudeSave(oSpellTarget,nDC,SAVING_THROW_TYPE_DEATH,oFeedback) == 0)
               {
                    effect eDeath = EffectDeath(TRUE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oSpellTarget);
               }
           }
        }
   }
}
