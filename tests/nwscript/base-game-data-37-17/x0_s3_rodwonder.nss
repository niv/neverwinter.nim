//:://////////////////////////////////////////////////
//:: X0_S2_RODWONDER
/*
Spell script for Rod of Wonder spell.

This spell produces a random spell effect.


 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/25/2002
//:://////////////////////////////////////////////////

#include "x0_i0_petrify"
#include "x0_i0_spells"
#include "x0_i0_common"
#include "x0_i0_position"

/**********************************************************************
 * TEMPORARY CONSTANTS
 **********************************************************************/

const int SPELL_GEM_SPRAY = 504;
const int SPELL_BUTTERFLY_SPRAY = 505;

/**********************************************************************
 * FUNCTION PROTOTYPES
 * These are generally custom variations on various spells.
 **********************************************************************/

// Nothing happens message
void DoNothing(object oCaster);

// Windstorm-force gust of wind effect -- knocks down everyone in the area
void DoWindstorm(location lTarget);

// Give short-term premonition (d4 rounds & up to d4*5 hp damage absorbed)
void DoDetectThoughts(object oCaster);

// Summon a penguin, cow, or rat
void DoSillySummon(object oTarget);

// Do a blindness spell on all in the given radius of a cone for the given
// number of rounds in duration.
void DoBlindnessEffect(object oCaster, location lTarget, float fRadius, int nDuration);



/**********************************************************************
 * MAIN FUNCTION DEFINITION
 **********************************************************************/


void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetAttemptedSpellTarget();
    location lTargetLoc = GetSpellTargetLocation();

    // Create a placeable object to act as the caster
    object oCastingObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                         "x0_rodwonder",
                                         GetLocation(oCaster));

    int nRoll = d100();


        // All the random effects

    //DBG_msg("Rod nRoll: " + IntToString(nRoll));

    // 1 - 5
    if (nRoll < 6) {
        // slow target for 10 rounds
        effect eSlow = EffectSlow();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eSlow, oTarget, RoundsToSeconds(10));

    // 6 - 10
    } else if (nRoll < 11) {
        // faerie fire on target, DC 11
        // replace with polymorph target into chicken
        effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN);
        effect eImp =  EffectVisualEffect(VFX_IMP_POLYMORPH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            ePoly,
                            oTarget,
                            RoundsToSeconds(d4()));

    // 11 - 15
    } else if (nRoll < 16) {
        // delude wielder into thinking it's another effect
        int nFakeSpell;
        effect eFakeEffect;
        if (Random(2) == 0) {
            nFakeSpell = SPELL_FIREBALL;
            eFakeEffect = EffectVisualEffect(VFX_FNF_FIREBALL);
        } else {
            nFakeSpell  = SPELL_LIGHTNING_BOLT;
            eFakeEffect = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
        }

        AssignCommand(oCastingObject,
                      ActionCastFakeSpellAtObject(nFakeSpell, oTarget));

        if (nFakeSpell == SPELL_LIGHTNING_BOLT) {
            effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING,
                                    OBJECT_SELF,
                                    BODY_NODE_HAND);
            AssignCommand(oCastingObject,
                ActionDoCommand(
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLightning,
                                        oTarget,
                                        1.0)));
        }

        AssignCommand(oCastingObject,
            ActionDoCommand(
               ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                   eFakeEffect,
                                   oTarget)));

    // 16 - 20
    } else if (nRoll < 21) {
        // windstorm-force gust of wind
        // knock down everyone in the area and play a wind sound
        DoWindstorm(lTargetLoc);

    // 21 - 25
    } else if (nRoll < 26) {
        // detect thoughts -- give short-term premonition
        DoDetectThoughts(oCaster);

    // 26 - 30
    } else if (nRoll < 31) {
        // stinking cloud, 30 ft range
        effect eAOE = EffectAreaOfEffect(AOE_PER_FOGSTINK);
        effect eImpact = EffectVisualEffect(259);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                              eAOE,
                              lTargetLoc,
                              RoundsToSeconds(d4()));

    // 31 - 33
    } else if (nRoll < 34) {
        // heavy rain falls briefly
        PlaySound("as_wt_thundercl3");
        object oArea = GetArea(oCaster);
        SetWeather(oArea, WEATHER_RAIN);
        DelayCommand(RoundsToSeconds(5),
                     SetWeather(oArea, WEATHER_USE_AREA_SETTINGS));

    // 34 - 36
    } else if (nRoll < 37) {
        // summon penguin, rat, or cow
        DoSillySummon(oTarget);

    // 37 - 43
    } else if (nRoll < 44) {
        // lightning bolt
        int nDamage = d6(6);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                                              SPELLABILITY_BOLT_LIGHTNING));

        nDamage = GetReflexAdjustedDamage(nDamage,
                                          oTarget,
                                          13,
                                          SAVING_THROW_TYPE_ELECTRICITY);

        //Make a ranged touch attack
        if (nDamage > 0 && TouchAttackRanged(oTarget) > 0) {
            effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING,
                                           oCaster,
                                           BODY_NODE_HAND);
            effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
            effect eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eLightning,
                                oTarget,
                                1.7);
        }

    // 44 - 46
    } else if (nRoll < 47) {
        // polymorph caster into a penguin
        effect ePoly = EffectPolymorph(POLYMORPH_TYPE_PENGUIN);
        effect eImp =  EffectVisualEffect(VFX_IMP_POLYMORPH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oCaster);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            ePoly,
                            oCaster,
                            RoundsToSeconds(d4()));
        SetCustomToken(0, GetName(oCaster));
        FloatingTextStrRefOnCreature( 9266, oCaster);

    // 47 - 49   Butterflies
    } else if (nRoll < 50) {
       ActionCastSpellAtObject(505,
                                    oTarget,
                                    METAMAGIC_ANY, TRUE);
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);

    // 50 - 53
    } else if (nRoll < 54) {
        // enlarge target  -- replaced by giving the target
        // Bull's Strength
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, d4());
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eStr, eDur);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink,
                            oTarget,
                            RoundsToSeconds(d6()));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // 54 - 58
    } else if (nRoll < 59) {
        // darkness around target
        effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                              eAOE,
                              lTargetLoc,
                              RoundsToSeconds(d4()));

    // 59 - 62
    } else if (nRoll < 63) {
        // grass grows around caster
        effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                              eAOE,
                              GetLocation(oCaster),
                              RoundsToSeconds(d6()));

    // 63 - 65
    } else if (nRoll < 66) {
        // turn target ethereal
        effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
        effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);
        effect eSpell = EffectSpellLevelAbsorption(2);
        effect eConceal = EffectConcealment(25);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eDam, eVis);
        eLink = EffectLinkEffects(eLink, eSpell);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eConceal);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink,
                            oTarget,
                            RoundsToSeconds(d4()));

    // 66 - 69
    } else if (nRoll < 70) {
        // reduce wielder -- replaced by making the
        // target invisible
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eInvis,
                            oTarget,
                            RoundsToSeconds(d6()));

    // 70 - 76
    } else if (nRoll < 77) {
        // fireball
        AssignCommand(oCastingObject,
            ActionCastSpellAtObject(SPELL_FIREBALL,
                                    oTarget,
                                    METAMAGIC_NONE,
                                    TRUE,0,
                                    PROJECTILE_PATH_TYPE_DEFAULT,
                                    TRUE));

    // 77 - 79
    } else if (nRoll < 80) {
        // polymorph target into a chicken
        effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN);
        effect eImp =  EffectVisualEffect(VFX_IMP_POLYMORPH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            ePoly,
                            oTarget,
                            RoundsToSeconds(d4()));
        SetCustomToken(0, GetName(oTarget));
        FloatingTextStrRefOnCreature( 9265, oTarget);

    // 80 - 84
    } else if (nRoll < 85) {
        // wielder goes invisible
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eInvis, eDur);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eLink,
                            oCaster,
                            RoundsToSeconds(d6()));

    // 85 - 87
    } else if (nRoll < 88) {
        // leaves grow from target
        // - long-term pixie dust visual effect on caster
        int nEffectPixieDust = 321;
        effect eDust =  EffectVisualEffect(nEffectPixieDust);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eDust,
                            oCaster,
                            RoundsToSeconds(d10(3) + 10));

    // 88 - 90
    } else if (nRoll < 91) {
//    SpawnScriptDebugger();
        // 10-40 gems fly out
        ActionCastSpellAtObject(SPELL_GEM_SPRAY,
                                    oTarget,
                                    METAMAGIC_ANY, TRUE);
//       ActionCastSpellAtObject(504,
//    oTarget,  METAMAGIC_ANY, TRUE);
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
        //DoFlyingGems(oCaster, lTargetLoc);

    // 91 - 95
    } else if (nRoll < 96) {
        // shimmering colors blind
        ActionCastFakeSpellAtObject(SPELL_PRISMATIC_SPRAY,
                                    oTarget,
                                    PROJECTILE_PATH_TYPE_DEFAULT);
        DoBlindnessEffect(oCaster, lTargetLoc, 20.0, d4());

    // 96 - 97
    } else if (nRoll < 98) {
        // wielder turns blue or purple
        effect eVis;
        SetCustomToken(0, GetName(oCaster));
        if (Random(2) == 0) {
            eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
            FloatingTextStrRefOnCreature(8861,
                                         oCaster);
        } else {
            eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
            FloatingTextStrRefOnCreature(8860,
                                         oCaster);
        }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            eVis, oCaster,
                            TurnsToSeconds(3));

    // 98 - 100
    } else  {
        // flesh to stone or stone to flesh
        int nSpell = SPELL_FLESH_TO_STONE;
        effect eEff = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eEff) && GetEffectType(eEff) != EFFECT_TYPE_PETRIFY)
            eEff = GetNextEffect(oTarget);

        if (GetIsEffectValid(eEff) && GetEffectType(eEff) == EFFECT_TYPE_PETRIFY)
            nSpell = SPELL_STONE_TO_FLESH;

        AssignCommand(oCastingObject,
            ActionCastSpellAtObject(nSpell,
                                    oTarget,
                                    METAMAGIC_NONE,
                                    TRUE,0,
                                    PROJECTILE_PATH_TYPE_DEFAULT,
                                    TRUE));
    }

    DestroyObject(oCastingObject, 6.0);
}


/**********************************************************************
 * FUNCTION DEFINITIONS
 * All the individual effect functions are below.
 ***********************************************************/

// Nothing happens message
void DoNothing(object oCaster)
{
    FloatingTextStrRefOnCreature(8848,
                                 oCaster);
}


// Windstorm-force gust of wind effect
void DoWindstorm(location lTarget)
{
    // Play a low thundering sound
    PlaySound("as_wt_thunderds4");

    // Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                           RADIUS_SIZE_HUGE,
                                           lTarget, TRUE,
                                           OBJECT_TYPE_CREATURE |
                                           OBJECT_TYPE_DOOR |
                                           OBJECT_TYPE_AREA_OF_EFFECT);

    // Cycle through the targets within the spell shape
    while (GetIsObjectValid(oTarget)) {

        // Play a random sound
        switch (Random(5)) {
        case 0: AssignCommand(oTarget, PlaySound("as_wt_gustchasm1")); break;
        case 1: AssignCommand(oTarget, PlaySound("as_wt_gustcavrn1")); break;
        case 2: AssignCommand(oTarget, PlaySound("as_wt_gustgrass1")); break;
        case 3: AssignCommand(oTarget, PlaySound("as_wt_guststrng1")); break;
        case 4: AssignCommand(oTarget, PlaySound("fs_floatair")); break;
        }

        // Area-of-effect spells get blown away
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) {
            DestroyObject(oTarget);
        }

        // * unlocked doors will reverse their open state
        else if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR) {
            if (!GetLocked(oTarget)) {
                if (GetIsOpen(oTarget) == FALSE)
                    AssignCommand(oTarget, ActionOpenDoor(oTarget));
                else
                    AssignCommand(oTarget, ActionCloseDoor(oTarget));
            }
        }

        // creatures will get knocked down, tough fort saving throw
        // to resist.
        else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
            if( !FortitudeSave(oTarget, 15) ) {
                effect eKnockdown = EffectKnockdown();
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                    eKnockdown,
                                    oTarget,
                                    RoundsToSeconds(1));
            }
        }

        // Get the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                       RADIUS_SIZE_HUGE,
                                       lTarget, TRUE,
                                       OBJECT_TYPE_CREATURE |
                                       OBJECT_TYPE_DOOR |
                                       OBJECT_TYPE_AREA_OF_EFFECT);
    }

}


// Give premonition for a few rounds, up to d4*5 hp
void DoDetectThoughts(object oCaster)
{
    int nRounds = d4();
    int nLimit = nRounds * 5;

    effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(ePrem, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_PREMONITION, FALSE));

    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eLink, oCaster, RoundsToSeconds(nRounds));
}

// Summon something extremely silly (rats will be hostile to caster!)
void DoSillySummon(object oTarget)
{
    location lTargetLoc = GetOppositeLocation(oTarget);
    int nSummon = d100();
    string sSummon = "";
    if (nSummon < 26) {
        sSummon = "x0_penguin001";
    } else if (nSummon < 51) {
        sSummon = "nw_cow";
    } else {
        sSummon = "nw_rat001";
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
                          lTargetLoc);

    CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
}


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



