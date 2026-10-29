//::///////////////////////////////////////////////
//:: Bolt: Knockdown
//:: NW_S1_BltKnckD
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  Reflex or Will save is
    needed to halve damage or avoid effect.
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
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eBolt = EffectKnockdown();
    int nDC = 10 + (nHD/2);
    effect eDam = EffectDamage(d6(), DAMAGE_TYPE_BLUDGEONING);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_KNOCKDOWN));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, RoundsToSeconds(3));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}
