//::///////////////////////////////////////////////
//:: OnHitCastSpell Misc Effects
//:: x2_s3_misceffect
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/* 
    Used for Aribeth in Hell...

    Based on Spell ID, has different effects

    791 - knockdown, DC = 10 + Caster Level
          will not work on PCs

    792 - freeze, DC = 10 + Caster Level,
                  Slow Creature hit or hitting for d3() rounds
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
      if (!GetHasSpellEffect(GetSpellId(),oSpellTarget)  )
      {

            if (GetSpellId() == 791) // OnHitKnockDown
            {
                  if (!GetIsPC(oSpellOrigin))    // This does not work on PCs
                  {
                     int nDC = GetCasterLevel(oSpellOrigin)+10;  ;
                     if  (GetIsSkillSuccessful(oSpellTarget,SKILL_DISCIPLINE,nDC) == 0)
                     {
                         effect eKnock = EffectKnockdown();
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnock,oSpellTarget,RoundsToSeconds(1));
                     }
                  }
                 return;
            }
            else if (GetSpellId() == 792) // OnHitFreeze
            {
                 int nDC = GetCasterLevel(oSpellOrigin)+10;  ;
                 if  (MySavingThrow(SAVING_THROW_FORT,oSpellTarget,nDC,SAVING_THROW_TYPE_COLD,oSpellOrigin) == 0)
                 {
                     effect eDur= EffectVisualEffect(VFX_DUR_ICESKIN);
                     effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
                     effect eSlow = EffectSlow();
                     effect eLink = EffectLinkEffects(eDur,eSlow);
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oSpellTarget,RoundsToSeconds(d3()));
                     ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget,RoundsToSeconds(d3()));
                 }
                 return;
            }

      }

   }
}
