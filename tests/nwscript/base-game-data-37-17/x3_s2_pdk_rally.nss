//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Rallying Cry
//:: x3_s2_pdk_rally.nss
//:://////////////////////////////////////////////
//:: Increase attack & movement for friends in
//:: area of spell
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
    int nDuration = 1; //+ nChr;

    effect eAttack = EffectAttackIncrease(1);// Increase attack by 1
    effect eSpeed = EffectMovementSpeedIncrease(20);// Increase movement
    effect eLink = EffectLinkEffects(eAttack, eSpeed);// Link effects
    eLink = ExtraordinaryEffect(eLink);// Make effects ExtraOrdinary

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// Get VFX
    eLink = EffectLinkEffects(eLink, eDur);// Link effects

    effect eImpact = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

    // Apply effect at a location
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));

    // Get first object in sphere
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    // Keep processing until oTarget is not valid
    while(GetIsObjectValid(oTarget))
    {
         // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
         if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
         {
            if(oTarget == OBJECT_SELF)
            {
                // oTarget is caster, apply effects
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
