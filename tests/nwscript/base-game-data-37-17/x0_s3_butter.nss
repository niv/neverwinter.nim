//::///////////////////////////////////////////////
//:: x0_s3butter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
For Wand of Wonder
creates butterflies

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


#include "x0_i0_spells"
// Do a blindness spell on all in the given radius of a cone for the given
// number of rounds in duration.
void DoBlindnessEffect(object oCaster, location lTarget, float fRadius, int nDuration)
{
    vector vOrigin = GetPosition(oCaster);

    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectBlindness();
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_CONE,
                                           fRadius,
                                           lTarget,
                                           TRUE,
                                           OBJECT_TYPE_CREATURE,
                                           vOrigin);

    while (GetIsObjectValid(oTarget)) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    SPELL_BLINDNESS_AND_DEAFNESS));

        //Do SR check
        if ( !MyResistSpell(OBJECT_SELF, oTarget)) {
            // Make Fortitude save to negate
            if (! MySavingThrow(SAVING_THROW_FORT, oTarget, 13)) {
                //Apply visual and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                    RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_CONE,
                                           fRadius,
                                           lTarget,
                                           TRUE,
                                           OBJECT_TYPE_CREATURE,
                                           vOrigin);
    }
}
void main ()
{
            DoBlindnessEffect(OBJECT_SELF, GetSpellTargetLocation(), 20.0, d4());

}
