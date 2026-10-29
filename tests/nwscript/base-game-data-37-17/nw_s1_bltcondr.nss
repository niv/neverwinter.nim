//::///////////////////////////////////////////////
//:: Bolt: Constitution Drain
//:: NW_S1_BltConDr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  Fort save is
    needed to avoid effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eBolt;
    int nDC = 10 + (nHD/2);
    int nCount = (nHD /3);
    if (nCount == 0)
    {
        nCount = 1;
    }
    int nDamage = d6(nCount);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
        eBolt = EffectAbilityDecrease(ABILITY_CONSTITUTION, nCount);
        eBolt = SupernaturalEffect(eBolt);
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBolt, oTarget, RoundsToSeconds(nHD));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
