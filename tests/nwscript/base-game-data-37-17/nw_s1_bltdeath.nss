//::///////////////////////////////////////////////
//:: Bolt: Death
//:: NW_S1_BltDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  
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
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eBolt = EffectDeath();
    int nDC = 10 + (nHD/2);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_DEATH));
    //Make a saving throw check
    if(TouchAttackRanged(oTarget))
    {
           //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
           //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

