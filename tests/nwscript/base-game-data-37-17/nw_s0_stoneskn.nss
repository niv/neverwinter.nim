//::///////////////////////////////////////////////
//:: Stoneskin
//:: NW_S0_Stoneskin
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the creature touched 10/+5
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level (100 Max)
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
#include "nw_i0_spells"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    effect eStone;
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink;
    object oTarget = GetSpellTargetObject();
    int nAmount = GetCasterLevel(OBJECT_SELF) * 10;
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));
    //Limit the amount protection to 100 points of damage
    if (nAmount > 100)
    {
        nAmount = 100;
    }
    //Meta Magic
    if(GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //Define the damage reduction effect
    eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
    //Link the effects
    eLink = EffectLinkEffects(eStone, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

    //Apply the linked effects.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}
