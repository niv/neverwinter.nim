//::///////////////////////////////////////////////
//:: OnHitCastSpell Deafening Clang
//:: x2_s3_deafclng
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   * OnHit 100% chance to deafen enemy for
     1 round per casterlevel

   * Fort Save DC 10+CasterLevel negates

   * Standard level used by the deafening clang
     spellscript is 5.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-19
//:://////////////////////////////////////////////

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
      if (!GetHasSpellEffect(GetSpellId(),oSpellTarget) &&!GetHasSpellEffect(SPELL_MASS_BLINDNESS_AND_DEAFNESS,oSpellTarget)  && !GetHasSpellEffect(SPELL_BLINDNESS_AND_DEAFNESS,oSpellTarget) )
      {
              if (!ResistSpell(oSpellOrigin,oSpellTarget) == 0)
              {
                  int nDC= GetCasterLevel(oSpellOrigin)+10;
                  if (MySavingThrow(SAVING_THROW_FORT,oSpellTarget, nDC,SAVING_THROW_TYPE_SONIC,oSpellOrigin) ==0)
                  {
                      int nRounds = GetCasterLevel(oSpellOrigin);
                      effect eDeaf = EffectDeaf();
                      effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDeaf,oSpellTarget,RoundsToSeconds(nRounds));
                      ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
                      FloatingTextStrRefOnCreature(85388,oSpellTarget,FALSE);
                }
           }
        }

   }
}
