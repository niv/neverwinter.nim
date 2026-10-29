//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

void main()
{

    //Declare major variables including Area of Effect Object
    effect eDur1 = EffectVisualEffect(VFX_IMP_SILENCE);

    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eSilence = EffectSilence();
    effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eDur2, eSilence);
    eLink = EffectLinkEffects(eLink, eImmune);

    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
          int bHostile;
          if(!MyResistSpell(oCaster,oTarget))
          {
                bHostile = GetIsEnemy(oTarget);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE,bHostile));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
          }
     }

}

