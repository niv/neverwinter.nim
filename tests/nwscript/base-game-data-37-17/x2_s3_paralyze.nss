//::///////////////////////////////////////////////
//:: OnHitCastSpell Misc Effects
//:: x2_s3_misceffect
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Gelatinous cube paralzye
     DC 10 + CasterLevel

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-18
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "x2_inc_switches"
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

   if (GetIsObjectValid(oItem))
   {

      // you can not be deafened if you already can not hear.
      if (!GetHasSpellEffect(GetSpellId(),oSpellTarget)  )
      {
             int nDC = GetCasterLevel(oSpellOrigin)+10;  ;
             if (DoCubeParalyze(oSpellTarget, oSpellOrigin,nDC))
             {
                         FloatingTextStrRefOnCreature(84609,oSpellTarget);
             }
             else
             {
                effect eSave = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oSpellTarget);
              }
             return;
         }
    }
}

