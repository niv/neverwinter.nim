//::///////////////////////////////////////////////
//:: Sea Hag : Evil Eye
//:: NW_S1_EvilEye
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the target must succeed a fortitude save
    (DC 11).  Creatures who fail have a 25%
    chance of temporarily losing 5 points in all
    abilities others loose 5 point to their STR
    and CON abilities for the casters CR times
    six rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Hayward
//:: Created On: January 15, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
//:://////////////////////////////////////////////
// GAME_DIFFICULTY_VERY_EASY = quarter duration (25%)
// GAME_DIFFICULTY_EASY = half duration (50%)
// GAME_DIFFICULTY_NORMAL = no change in duration (100%)
// GAME_DIFFICULTY_CORE_RULES = one and a half duration (150%)
// GAME_DIFFICULTY_DIFFICULT = double duration (200%)
//:://////////////////////////////////////////////
void main()
{
    // Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDC = 11;
    int nDifficulty = GetGameDifficulty();
    int iDuration;     // Duration in rounds
    float fDuration;

    // Declare all the required effects
    effect eGaze1;
    effect eGaze2;
    effect eGaze3;
    effect eGaze4;
    effect eGaze5;
    effect eGaze6;
    effect eVis1;
    effect eVis2;

    // Make sure the target is a valid creature
    if ((GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    && (GetIsObjectValid(oTarget)))
    {
        // Make sure the target isn't an ally or its self and is visible
        if ((!GetIsReactionTypeFriendly(oTarget))
        && (oTarget != OBJECT_SELF))
        {
            // Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_SEAHAG_EVILEYE));

            // Determine Distance between the Gazer and the target
            float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);

            // Check the distance between self and target object
            if ((fDistance <= FeetToMeters(30.0f))
            && (LineOfSightObject(OBJECT_SELF, oTarget)))
            {
                // Show the Fortitude save visual effect
                eVis1 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);

                // Make a saving throw
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF))
                {
                    // Set up the visual and ability reducing effects
                    eVis2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
                    eGaze1 = EffectAbilityDecrease(ABILITY_STRENGTH, 5);
                    eGaze2 = EffectAbilityDecrease(ABILITY_DEXTERITY, 5);
                    eGaze3 = EffectAbilityDecrease(ABILITY_CONSTITUTION, 5);
                    eGaze4 = EffectAbilityDecrease(ABILITY_WISDOM, 5);
                    eGaze5 = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 5);
                    eGaze6 = EffectAbilityDecrease(ABILITY_CHARISMA, 5);

                    // Make the effects super natural so they can be dispelled
                    eGaze1 = SupernaturalEffect(eGaze1);
                    eGaze2 = SupernaturalEffect(eGaze2);
                    eGaze3 = SupernaturalEffect(eGaze3);
                    eGaze4 = SupernaturalEffect(eGaze4);
                    eGaze5 = SupernaturalEffect(eGaze5);
                    eGaze6 = SupernaturalEffect(eGaze6);

                    // Create the duration based off of the game difficulty
                    fDuration = GetChallengeRating(OBJECT_SELF) * 3.0f;
                    iDuration = FloatToInt(fDuration);

                    if (nDifficulty == GAME_DIFFICULTY_VERY_EASY)
                    {
                        fDuration = RoundsToSeconds(iDuration) / 4.0f;
                    }
                    else if (nDifficulty == GAME_DIFFICULTY_EASY)
                    {
                        fDuration = RoundsToSeconds(iDuration) / 2.0f;;
                    }
                    else if (nDifficulty == GAME_DIFFICULTY_NORMAL)
                    {
                        fDuration = RoundsToSeconds(iDuration);
                    }
                    else if (nDifficulty == GAME_DIFFICULTY_CORE_RULES)
                    {
                        fDuration = RoundsToSeconds(iDuration) * 1.5f;
                    }
                    else // GAME_DIFFICULTY_DIFFICULT
                    {
                        fDuration = RoundsToSeconds(iDuration) * 2.0f;
                    }

                    // Apply the visual effect for ability loss
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

                    // One in four times do extremely bad supernatural things to the player
                    if (Random(4) == 0)
                    {
                        // Weaken one in four players by five to all abilities
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze2, oTarget, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze4, oTarget, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze5, oTarget, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze6, oTarget, fDuration);
                    }

                    // Weaken strength and constitution by five
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze1, oTarget, fDuration);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze3, oTarget, fDuration);
                }
            }
        }
    }
    return;
}

