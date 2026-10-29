//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Inspire Courage
//:: x3_s2_pdk_inspir.nss
//:://////////////////////////////////////////////
//:: Increase attack, damage, saving throws to
//:: friends in area of spell
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////
/*
    Modified By : gaoneng erick
    Modified On : may 6, 2006
    added custom vfx
*/

#include "x0_i0_spells"

void main()
{
    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
     // Not useable when silenced. Floating text to user
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF);
        return;
    }

    //Declare major variables
    int nDuration = 10; //+ nChr;

    effect eAttack = EffectAttackIncrease(1);// Attack effect increased
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING);// Increased damage effect
    effect eLink = EffectLinkEffects(eAttack, eDamage);// link effects

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);// Saving throw increase
    eLink = EffectLinkEffects(eLink, eSave);// link in saving throw
    eLink = ExtraordinaryEffect(eLink);// make effects ExtraOrdinary

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// Get VFX
    eLink = EffectLinkEffects(eLink, eDur);// link VFXs

    effect eImpact = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

    // Apply effect at location
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));

    // Get first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    // Keep processing while oTarget is valid
    while(GetIsObjectValid(oTarget))
    {
         // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
         if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
         {
            if(oTarget == OBJECT_SELF)
            {
                // oTarget is caster, apply effects
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, RoundsToSeconds(nDuration));

            }
            else if(GetIsNeutral(oTarget) || GetIsFriend(oTarget))
            {
                // oTarget is a friend, apply effects
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
        }

        // Get next object in the sphere
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
