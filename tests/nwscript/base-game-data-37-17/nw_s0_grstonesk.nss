//::///////////////////////////////////////////////
//:: Greater Stoneskin
//:: NW_S0_GrStoneSk
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the gives the creature touched 20/+5
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level (150 Max)
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs March 4, 2003
#include "nw_i0_spells"


#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nAmount = GetCasterLevel(OBJECT_SELF);
    int nDuration = nAmount;
    object oTarget = GetSpellTargetObject();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_STONESKIN, FALSE));

    if (nAmount > 15)
    {
        nAmount = 15;
    }
    int nDamage = nAmount * 10;
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    effect eVis2 = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eStone = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, nDamage);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link the texture replacement and the damage reduction effect
    effect eLink = EffectLinkEffects(eVis, eStone);
    eLink = EffectLinkEffects(eLink, eDur);

    //Remove effects from target if they have Greater Stoneskin cast on them already.
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_STONESKIN);

    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}
