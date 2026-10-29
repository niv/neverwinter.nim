//::///////////////////////////////////////////////
//:: Aura of Horrific Appearance On Enter
//:: nw_s1_HorrApprA.nss
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects entering the aura must make a fortitude
    saving throw (DC 11) or suffer 2D8 points of
    Strength Ability Damage for the CR of the cast
    times six rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Hayward
//:: Created On: January 9, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetEnteringObject();
    object oSource =  GetAreaOfEffectCreator();
    int nDC = 11;
    float fDuration;
    int iDuration;

    // Declare all the required effects
    effect eVis1;
    effect eVis2;
    effect eAbility;

    // Is the target a valid creature
    if((GetIsEnemy(oTarget, oSource))
    && (GetIsReactionTypeFriendly(oTarget, oSource) != TRUE))
    {
        // Notify the Player that the are being attacked
        SignalEvent(oTarget, EventSpellCastAt(oSource, AOE_MOB_HORRIFICAPPEARANCE));

        // Set the duration of the effect based on the callers CR
        fDuration = GetChallengeRating(oSource) * 3.0;
        iDuration = FloatToInt(fDuration);
        fDuration = RoundsToSeconds(iDuration);

        // Prepare the visual effect for the casting and saving throw
        eVis1 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        eVis2 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);

        // Create the 2d8 strength reduction effect
        // and make it supernatural so it can be dispelled
        eAbility = EffectAbilityDecrease(ABILITY_STRENGTH, d8(2));
        eAbility = SupernaturalEffect(eAbility);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget, fDuration);

        // Make a Fortitude saving throw, DC 11 and apply the effect if it fails
        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oSource))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbility, oTarget, fDuration);
        }
    }
}

