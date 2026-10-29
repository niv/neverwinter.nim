//::///////////////////////////////////////////////
//:: Minor Acid Blob
//:: NW_T1_AcidMinoC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is hit with a blob of acid that does
    3d6 Damage and holds the target for 2 rounds.
    Can make a Reflex save to avoid the hold effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th , 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eDam = EffectDamage(d6(3), DAMAGE_TYPE_ACID);;
    effect eHold = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eHold, eDur);
    
    int nDamage;
    
    //Make Reflex Save
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_TRAP))
    {
        //Apply Hold and Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
    }
    else
    {
        //Apply Hold
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
