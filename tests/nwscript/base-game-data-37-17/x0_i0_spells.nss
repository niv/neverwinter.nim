//::///////////////////////////////////////////////
//:: x0_i0_spells
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Expansion 1 and above include file for spells
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:: Updated On: August 2003, Georg Zoeller:
//::                          Arcane Archer special ability fix,
//::                          New creatures added to Flying/Petrification check
//::                          Several Fixes toMDispelagic
//::                          Added spellsGetHighestSpellcastingClassLevel
//::                          Added code to spellsIsTarget to make NPCs hurt their allies with AoE spells if ModuleSwitch MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES is set
//::                          Creatures with Plot or DM Flag set will no longer be affected by petrify. DMs used to get a GUI panel, even if unaffected.
//:: Updated On: September 2003, Georg Zoeller:
//::                          spellsIsTarget was not using oSource in source checks.
//::                          Creatures with Plot or DM Flag set will no longer be affected by petrify. DMs used to get a GUI panel, even if unaffected.
//:: Updated On: October 2003, Georg Zoeller:
//::                          Missile storm's no longer do a SR check for each missile, but only one per target
//::                          ... and there was much rejoicing
//::                          Added code to handleldispeling of AoE spells better
//::                          Henchmen are booted from the party when petrified
//::                          Dispel Magic delay until VFX hit has been set down to 0.3
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_match"
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "x0_i0_henchman"

// * Constants
// * see spellsIsTarget for a definition of these constants
const int SPELL_TARGET_ALLALLIES = 1;
const int SPELL_TARGET_STANDARDHOSTILE = 2;
const int SPELL_TARGET_SELECTIVEHOSTILE = 3;
const int SAVING_THROW_NONE = 4;


//* get the hightest spellcasting class level of oCreature)
int GZGetHighestSpellcastingClassLevel(object oCreature);

// * dispel magic on one or multiple targets.
// * if bAll is set to TRUE, all effects are dispelled from a creature
// * else it will only dispel the best effect from each creature (used for AoE)
// * Specify bBreachSpells to add Mord's Disjunction to the dispel
void spellsDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE);

// * returns true if oCreature does not have a mind
int spellsIsMindless(object oCreature);

// * Returns true or false depending on whether the creature is flying
// * or not
int spellsIsFlying(object oCreature);

// * returns true if the creature has flesh
int spellsIsImmuneToPetrification(object oCreature);

// * Generic apply area of effect Wrapper
// * lTargetLoc = where spell was targeted
// * fRadius = RADIUS_SIZE_ constant
// * nSpellID
// * eImpact = ring impact
// * eLink = Linked effects to apply to targets in area
// * eVis
void spellsGenericAreaOfEffect(
        object oCaster, location lTargetLoc,
        int nShape, float fRadiusSize, int nSpellID,
        effect eImpact, effect eLink, effect eVis,
        int nDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0,
        int nTargetType=SPELL_TARGET_ALLALLIES, int bHarmful = FALSE,
        int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0,
        int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE,
        int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SAVING_THROW_NONE,
        int nSavingThrowSubType=SAVING_THROW_TYPE_ALL
        );

// * Generic reputation wrapper
// * definition of constants:
// * SPELL_TARGET_ALLALLIES = Will affect all allies, even those in my faction who don't like me
// * SPELL_TARGET_STANDARDHOSTILE: 90% of offensive area spells will work
//   this way. They will never hurt NEUTRAL or FRIENDLY NPCs.
//   They will never hurt FRIENDLY PCs
//   They WILL hurt NEUTRAL PCs
// * SPELL_TARGET_SELECTIVEHOSTILE: Will only ever hurt enemies
int spellsIsTarget(object oTarget, int nTargetType, object oSource);


// * how much should special archer arrows do for damage
int ArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF);

// * simulating enchant arrow
int ArcaneArcherCalculateBonus();

// * returns the size modifier for bullrush in spells
int GetSizeModifier(object oCreature);

// *  Returns the modifier from the ability    score that matters for this caster
int GetCasterAbilityModifier(object oCaster);

// * Checks the appropriate metamagic to see
// * how the damage should be scaled.
int MaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0);

// * can the creature be destroyed without breaking a plot
int CanCreatureBeDestroyed(object oTarget);

// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
void spellsStinkingCloud(object oTarget = OBJECT_INVALID);

// * caltrops do 25 points of damage (1 pnt per target per round) and then are gone
void DoCaltropEffect(object oTarget);

// * apply effects of spike trap on entering object
void DoTrapSpike(int nDamage);

//* fires a storm of nCap missiles at targets in area
void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE);

// * Applies ability score damage
void DoDirgeEffect(object oTarget);

void spellsInflictTouchAttack(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID);

// * improves an animal companion or summoned creature's attack and damage and the ability to hit
// * magically protected creatures
void DoMagicFang(int nPower, int nDamagePower);

// * for spike growth area of effect object
// * applies damage and slow effect
void DoSpikeGrowthEffect(object oTarget);

// * Applies the 'camoflage' magical effect to the target
void DoCamoflage(object oTarget);

// * Does a damage type grenade (direct or splash on miss)
void DoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL);

// * This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void DoPetrification(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC);

// * removed mind effects and provide mind protection
void spellApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0);

// * Handle dispel magic of AoEs
void spellsDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel);



//::///////////////////////////////////////////////
//:: DoTrapSpike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a spike trap. Reflex save allowed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// apply effects of spike trap on entering object
void DoTrapSpike(int nDamage)
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    int nRealDamage = GetReflexAdjustedDamage(nDamage, oTarget, 15, SAVING_THROW_TYPE_TRAP, OBJECT_SELF);
    if (nDamage > 0)
    {
        effect eDam = EffectDamage(nRealDamage, DAMAGE_TYPE_PIERCING);
        effect eVis = EffectVisualEffect(253);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}
//::///////////////////////////////////////////////
//:: MaximizeOrEmpower
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks the appropriate metamagic to see
    how the damage should be scaled.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:://////////////////////////////////////////////

int MaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0)
{
    int i = 0;
    int nDamage = 0;
    for (i=1; i<=nNumberOfDice; i++)
    {
        nDamage = nDamage + Random(nDice) + 1;
    }
    //Resolve metamagic
    if (nMeta == METAMAGIC_MAXIMIZE)
    {
        nDamage = nDice * nNumberOfDice;
    }
    else if (nMeta == METAMAGIC_EMPOWER)
    {
       nDamage = nDamage + nDamage / 2;
    }
    return nDamage + nBonus;
}

//::///////////////////////////////////////////////
//:: DoGrenade
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a damage type grenade (direct or splash on miss)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void DoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL)
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eMissile;
    effect eVis = EffectVisualEffect(vSmallHit);
    location lTarget = GetSpellTargetLocation();


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    int nTouch;


    if (GetIsObjectValid(oTarget) == TRUE)
    {
/*        // * BK September 27 2002
        // * if the object is 'far' from the original impact it
        // * will be an automatic miss too
        location lObject = GetLocation(oTarget);
        float fDistance = GetDistanceBetweenLocations(lTarget, lObject);
//        SpawnScriptDebugger();
        if (fDistance > 1.0)
        {
            nTouch = -1;
        }
        else
        This did not work. The location and object location are the same.
        For now we'll have to live with the possiblity of the 'explosion'
        happening away from where the grenade hits.
        We could convert everything to splash...
        */
            nTouch = TouchAttackRanged(oTarget);

    }
    else
    {
        nTouch = -1; // * this means that target was the ground, so the user
                    // * intended to splash
    }
    if (nTouch >= 1)
    {
        //Roll damage
        int nDam = nDirectDamage;

        if(nTouch == 2)
        {
            nDam *= 2;
        }

        //Set damage effect
        effect eDam = EffectDamage(nDam, nDamageType);
        //Apply the MIRV and damage effect

        // * only damage enemies
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
        // * must be the correct racial type (only used with Holy Water)
            if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == GetRacialType(oTarget)))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }
            else
            if ((nRacialType == RACIAL_TYPE_ALL) )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }

        }

    //    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
    }

// *
// * Splash damage always happens as well now
// *
    {
        effect eExplode = EffectVisualEffect(vRingHit);
       //Apply the fireball explosion at the location captured above.

/*       float fFace = GetFacingFromLocation(lTarget);
       vector vPos = GetPositionFromLocation(lTarget);
       object oArea = GetAreaFromLocation(lTarget);
       vPos.x = vPos.x - 1.0;
       vPos.y = vPos.y - 1.0;
       lTarget = Location(oArea, vPos, fFace);
       missing code looks bad because it does not jive with visual
*/
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //Roll damage for each target
            nDamage = nSplashDamage;

            //Set the damage effect
            effect eDam = EffectDamage(nDamage, nDamageType);
            if(nDamage > 0)
            {
        // * must be the correct racial type (only used with Holy Water)
                if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == GetRacialType(oTarget)))
                {
                    // Apply effects to the currently selected target.
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                if ((nRacialType == RACIAL_TYPE_ALL) )
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }

            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
       }
    }
}

//::///////////////////////////////////////////////
//:: GetCasterAbilityModifier
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the modifier from the ability
    score that matters for this caster
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetCasterAbilityModifier(object oCaster)
{
    int nClass = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int nAbility;
    if (nClass > 0)
    {
        nAbility = ABILITY_INTELLIGENCE;
    }
    else
        nAbility = ABILITY_CHARISMA;

    return GetAbilityModifier(nAbility, oCaster);
}
//::///////////////////////////////////////////////
//:: GetSizeModifier
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gets the creature's applicable size modifier.
    Used in Bigby's Forceful hand for the 'bullrush'
    attack.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetSizeModifier(object oCreature)
{
    int nSize = GetCreatureSize(oCreature);
    int nModifier = 0;
    switch (nSize)
    {
    case CREATURE_SIZE_TINY: nModifier = -8;  break;
    case CREATURE_SIZE_SMALL: nModifier = -4; break;
    case CREATURE_SIZE_MEDIUM: nModifier = 0; break;
    case CREATURE_SIZE_LARGE: nModifier = 4;  break;
    case CREATURE_SIZE_HUGE: nModifier = 8;   break;
    }
    return nModifier;
}

//::///////////////////////////////////////////////
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the ability score damage of the dirge effect.

    March 2003
    Because ability score penalties do not stack, I need
    to store the ability score damage done
    and increment each round.
    To that effect I am going to update the description and
    remove the dirge effects if the player leaves the area of effect.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoDirgeEffect(object oTarget)
{    //Declare major variables
//    int nMetaMagic = GetMetaMagicFeat();

   // SpawnScriptDebugger();

    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));
        //Spell resistance check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {

            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_ALL, GetAreaOfEffectCreator()))
            {
                int nGetLastPenalty = GetLocalInt(oTarget, "X0_L_LASTPENALTY");
                // * increase penalty by 2
                nGetLastPenalty = nGetLastPenalty + 2;

                effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
                effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
                //change from sonic effect to bard song...
                effect eVis =    EffectVisualEffect(VFX_FNF_SOUND_BURST);
                effect eLink = EffectLinkEffects(eDex, eStr);

                //Apply damage and visuals
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
            }

        }
    }
}
//::///////////////////////////////////////////////
//:: DoCamoflage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the 'camoflage' magical effect
    to the target
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoCamoflage(object oTarget)
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = GetMetaMagicFeat();

    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHide, eDur);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = 10 * nDuration; // * Duration 10 turn/level
    if (nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}
//::///////////////////////////////////////////////
//:: DoSpikeGrowthEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    1d4 damage, plus a 24 hr slow if take damage.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoSpikeGrowthEffect(object oTarget)
{
    float fDelay = GetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_SPIKE_GROWTH));
        //Spell resistance check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            int nMetaMagic = GetMetaMagicFeat();
            int nDam = MaximizeOrEmpower(4, 1, nMetaMagic);

            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING);
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            //effect eLink = eDam;
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam/*eLink*/, oTarget));

           // * only apply a slow effect from this spell once
           if (GetHasSpellEffect(SPELL_SPIKE_GROWTH, oTarget) == FALSE)
           {
                //Make a Reflex Save to avoid the effects of the movement hit.
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_ALL, GetAreaOfEffectCreator(), fDelay))
                {
                    effect eSpeed = EffectMovementSpeedDecrease(30);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oTarget, HoursToSeconds(24));
                }
           }
        }
    }
}
//::///////////////////////////////////////////////
//:: spellsInflictTouchAttack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    nDamage: Amount of damage to do
    nMaxExtraDamage: Max amount of +1 per level damage
    nMaximized: Amount of damage to do if maximized
    vfx_impactHurt: Impact to play if hurt by spell
    vfx_impactHeal: Impact to play if healed by spell
    nSpellID: SpellID to broactcast in the signal event
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void spellsInflictTouchAttack(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nTouch = TouchAttackMelee(oTarget);

    int nExtraDamage = GetCasterLevel(OBJECT_SELF); // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }

        //Check for metamagic
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = nMaximized;
    }
    else
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage / 2);
    }


    //Check that the target is undead
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        effect eVis2 = EffectVisualEffect(vfx_impactHeal);
        //Figure out the amount of damage to heal
        //nHeal = nDamage;
        //Set the heal effect
        effect eHeal = EffectHeal(nDamage + nExtraDamage);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    }
    else if (nTouch >0 )
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                int nDamageTotal = nDamage + nExtraDamage;
                // A succesful will save halves the damage
                if(MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_ALL,OBJECT_SELF))
                {
                    nDamageTotal = nDamageTotal / 2;
                }
                effect eVis = EffectVisualEffect(vfx_impactHurt);
                effect eDam = EffectDamage(nDamageTotal,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            }
        }
    }
}

//::///////////////////////////////////////////////
//:: DoMissileStorm
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a volley of missiles around the area
    of the object selected.

    Each missiles (nD6Dice)d6 damage.
    There are casterlevel missiles (to a cap as specified)
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Modified March 14 2003: Removed the option to hurt chests/doors
//::  was potentially causing bugs when no creature targets available.
void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE)
{
    object oTarget = OBJECT_INVALID;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
//    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt = 1;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    int nMissiles = nCasterLvl;

    if (nMissiles > nCap)
    {
        nMissiles = nCap;
    }

        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // GZ: You can only fire missiles on visible targets
            // If the firing object is a placeable (such as a projectile trap),
            // we skip the line of sight check as placeables can't "see" things.
            if ( ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE ) ||
                   GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     if (nEnemies == 0) return; // * Exit if no enemies to hit
     int nExtraMissiles = nMissiles / nEnemies;

     // April 2003
     // * if more enemies than missiles, need to make sure that at least
     // * one missile will hit each of the enemies
     if (nExtraMissiles <= 0)
     {
        nExtraMissiles = 1;
     }

     // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     if (nExtraMissiles >0)
        nRemainder = nMissiles % nEnemies;

     if (nEnemies > nMissiles)
        nEnemies = nMissiles;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) &&
           (oTarget != OBJECT_SELF) &&
           (( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE ) ||
           (GetObjectSeen(oTarget,OBJECT_SELF))))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

                // * recalculate appropriate distances
                fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
                fDelay = fDist/(3.0 * log(fDist) + 2.0);

                // Firebrand.
                // It means that once the target has taken damage this round from the
                // spell it won't take subsequent damage
                if (nONEHIT == TRUE)
                {
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }

                int i = 0;
                //--------------------------------------------------------------
                // GZ: Moved SR check out of loop to have 1 check per target
                //     not one check per missile, which would rip spell mantels
                //     apart
                //--------------------------------------------------------------
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    for (i=1; i <= nExtraMissiles + nRemainder; i++)
                    {
                        //Roll damage
                        int nDam = d6(nD6Dice);
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                             nDam = nD6Dice*6;//Damage is at max
                        }
                        if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                              nDam = nDam + nDam/2; //Damage/Healing is +50%
                        }
                        // Jan. 29, 2004 - Jonathan Epp
                        // Reflex save was not being calculated for Firebrand
                        if(nReflexSave)
                        {
                            if ( nDAMAGETYPE == DAMAGE_TYPE_ELECTRICAL )
                            {
                                nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
                            }
                            else if ( nDAMAGETYPE == DAMAGE_TYPE_FIRE )
                            {
                                nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                            }
                        }

                        fTime = fDelay;
                        fDelay2 += 0.1;
                        fTime += fDelay2;

                        //Set damage effect
                        effect eDam = EffectDamage(nDam, nDAMAGETYPE);
                        //Apply the MIRV and damage effect
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                        DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    }
                } // for
                else
                {  // * apply a dummy visual effect
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
                }
                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

}
//::///////////////////////////////////////////////
//:: DoMagicFang
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

FEB 19: Made it so only Animal Companions get these bonuses
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoMagicFang(int nPower, int nDamagePower)
{


    //Declare major variables
    object oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

    if (GetIsObjectValid(oTarget) == FALSE)
    {
            FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
            return; // has neither an animal companion
    }

    //Remove effects of anyother fang spells
    RemoveSpellEffects(452, GetMaster(oTarget), oTarget);
    RemoveSpellEffects(453, GetMaster(oTarget), oTarget);

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    int nMetaMagic = GetMetaMagicFeat();

    effect eAttack = EffectAttackIncrease(nPower);
    effect eDamage = EffectDamageIncrease(nPower);
    effect eReduction = EffectDamageReduction(nPower, nDamagePower); // * doing this because
                                                                     // * it creates a true
                                                                     // * enhancement bonus

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eDur);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eReduction);

    int nDuration = GetCasterLevel(OBJECT_SELF); // * Duration 1 turn/level
     if (nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

}

//::///////////////////////////////////////////////
//:: DoCaltropEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The area effect will only do a total of
    25 points of damage and then destroy itself.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoCaltropEffect(object oTarget)
{

    //int nDam = 1;

 //   effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
    //effect eLink = eDam;

    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator())
     && spellsIsFlying(oTarget) == FALSE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 471));
        {
            effect eDam = EffectDamage(1, DAMAGE_TYPE_PIERCING);
            float fDelay = GetRandomDelay(1.0, 2.2);
            //Apply damage and visuals
            //DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            int nDamageDone = GetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE");
            nDamageDone++;

            //  * storing variable on area of effect object
            SetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE", nDamageDone);
            if (nDamageDone == 25)
            {
                DestroyObject(OBJECT_SELF);
                object oImpactNode = GetLocalObject(OBJECT_SELF, "X0_L_IMPACT");
                if (GetIsObjectValid(oImpactNode) == TRUE)
                {
                    DestroyObject(oImpactNode);
                }
            }

        }
    }
}

//::///////////////////////////////////////////////
//:: CanCreatureBeDestroyed
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the creature is allowed
    to die (i.e., not plot)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

//*GZ: 2003-07-23. honor critical and weapon spec
// Updated: 02/14/2008 CraigW - Added support for Epic Weapon Specialization.
// nCrit -

int ArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int nDamage;
    int bSpec = FALSE;
    int bEpicSpecialization = FALSE;

    if (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW )
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bEpicSpecialization = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
        {
            nDamage = d6();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bEpicSpecialization = TRUE;
            }
        }
        else
            return 0;
    }
    else
    {
            return 0;
    }

    // add strength bonus
    int nStrength = GetAbilityModifier(ABILITY_STRENGTH,oUser);
    nDamage += nStrength;

    if (bSpec == TRUE)
    {
        nDamage +=2;
    }
    if ( bEpicSpecialization == TRUE )
    {
        nDamage +=4;
    }
    if (bCrit == TRUE)
    {
         nDamage *=3;
    }

    return nDamage;
}

//*GZ: 2003-07-23. Properly calculated enhancement bonus
int ArcaneArcherCalculateBonus()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);

    if (nLevel == 0) //not an arcane archer?
    {
        return 0;
    }
    int nBonus = ((nLevel+1)/2); // every odd level after 1 get +1
    return nBonus;
}


// *  This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void DoPetrification(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC)
{

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // * exit if creature is immune to petrification
        if (spellsIsImmuneToPetrification(oTarget) == TRUE)
        {
            return;
        }
        float fDifficulty = 0.0;
        int bIsPC = GetIsPC(oTarget);
        int bShowPopup = FALSE;

        // * calculate Duration based on difficulty settings
        int nGameDiff = GetGameDifficulty();
        switch (nGameDiff)
        {
            case GAME_DIFFICULTY_VERY_EASY:
            case GAME_DIFFICULTY_EASY:
            case GAME_DIFFICULTY_NORMAL:
                    fDifficulty = RoundsToSeconds(nPower); // One Round per hit-die or caster level
                break;
            case GAME_DIFFICULTY_CORE_RULES:
            case GAME_DIFFICULTY_DIFFICULT:
                bShowPopup = TRUE;
            break;
        }

        int nSaveDC = nFortSaveDC;
        effect ePetrify = EffectPetrify();

        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        effect eLink = EffectLinkEffects(eDur, ePetrify);

            // Let target know the negative spell has been cast
            SignalEvent(oTarget,
                        EventSpellCastAt(OBJECT_SELF, nSpellID));
                        //SpeakString(IntToString(nSpellID));

            // Do a fortitude save check
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC))
            {
                // Save failed; apply paralyze effect and VFX impact

                /// * The duration is permanent against NPCs but only temporary against PCs
                if (bIsPC == TRUE)
                {
                    if (bShowPopup == TRUE)
                    {
                        // * under hardcore rules or higher, this is an instant death
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                        DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
                        // if in hardcore, treat the player as an NPC
                        bIsPC = FALSE;
                        //fDifficulty = TurnsToSeconds(nPower); // One turn per hit-die
                    }
                    else
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty);
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

                    //----------------------------------------------------------
                    // GZ: Fix for henchmen statues haunting you when changing
                    //     areas. Henchmen are now kicked from the party if
                    //     petrified.
                    //----------------------------------------------------------
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
                    {
                        FireHenchman(GetMaster(oTarget),oTarget);
                    }

                }
                // April 2003: Clearing actions to kick them out of conversation when petrified
                AssignCommand(oTarget, ClearAllActions(TRUE));
            }
    }

}

//::///////////////////////////////////////////////
//:: spellsIsTarget
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the reputation wrapper.
    It performs the check to see if, based on the
    constant provided
    it is okay to target this target with the
    spell effect.


    MODIFIED APRIL 2003
    - Other player's associates will now be harmed in
       Standard Hostile mode
    - Will ignore dead people in all target attempts

    MODIFIED AUG 2003 - GZ
    - Multiple henchmen support: made sure that
      AoE spells cast by one henchmen do not
      affect other henchmen in the party

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: March 6 2003
//:://////////////////////////////////////////////

int spellsIsTarget(object oTarget, int nTargetType, object oSource)
{
    // * if dead, not a valid target
    if (GetIsDead(oTarget) == TRUE)
    {
        return FALSE;
    }

    int nReturnValue = FALSE;

    switch (nTargetType)
    {
        // * this kind of spell will affect all friendlies and anyone in my
        // * party, even if we are upset with each other currently.
        case SPELL_TARGET_ALLALLIES:
        {
            if(GetIsReactionTypeFriendly(oTarget,oSource) || GetFactionEqual(oTarget,oSource))
            {
                nReturnValue = TRUE;
            }
            break;
        }
        case SPELL_TARGET_STANDARDHOSTILE:
        {
            //SpawnScriptDebugger();
            int bPC = GetIsPC(oTarget);
            int bNotAFriend = FALSE;
            int bReactionType = GetIsReactionTypeFriendly(oTarget, oSource);
            if (bReactionType == FALSE)
            {
                bNotAFriend = TRUE;
            }

            // * Local Override is just an out for end users who want
            // * the area effect spells to hurt 'neutrals'
            if (GetLocalInt(GetModule(), "X0_G_ALLOWSPELLSTOHURT") == 10)
            {
                bPC = TRUE;
            }

            int bSelfTarget = FALSE;
            object oMaster = GetMaster(oTarget);

            // March 25 2003. The player itself can be harmed
            // by their own area of effect spells if in Hardcore mode...
            if (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL)
            {
                // Have I hit myself with my spell?
                if (oTarget == oSource)
                {
                    bSelfTarget = TRUE;
                }
                else
                // * Is the target an associate of the spellcaster
                if (oMaster == oSource)
                {
                    bSelfTarget = TRUE;
                }
            }

            // April 9 2003
            // Hurt the associates of a hostile player
            if (bSelfTarget == FALSE && GetIsObjectValid(oMaster) == TRUE)
            {
                // * I am an associate
                // * of someone
                if ( (GetIsReactionTypeFriendly(oMaster,oSource) == FALSE && GetIsPC(oMaster) == TRUE)
                || GetIsReactionTypeHostile(oMaster,oSource) == TRUE)
                {
                    bSelfTarget = TRUE;
                }
            }


            // Assumption: In Full PvP players, even if in same party, are Neutral
            // * GZ: 2003-08-30: Patch to make creatures hurt each other in hardcore mode...

            if (GetIsReactionTypeHostile(oTarget,oSource))
            {
                nReturnValue = TRUE;         // Hostile creatures are always a target
            }
            else if (bSelfTarget == TRUE)
            {
                nReturnValue = TRUE;         // Targetting Self (set above)?
            }
            else if (bPC && bNotAFriend)
            {
                nReturnValue = TRUE;         // Enemy PC
            }
            else if (bNotAFriend && (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL))
            {
                if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES) == TRUE)
                {
                    nReturnValue = TRUE;        // Hostile Creature and Difficulty > Normal
                }                               // note that in hardcore mode any creature is hostile
            }
            break;
        }
        // * only harms enemies, ever
        // * current list:call lightning, isaac missiles, firebrand, chain lightning, dirge, Nature's balance,
        // * Word of Faith
        case SPELL_TARGET_SELECTIVEHOSTILE:
        {
            if(GetIsEnemy(oTarget,oSource))
            {
                nReturnValue = TRUE;
            }
            break;
        }
    }

    // GZ: Creatures with the same master will never damage each other
    if (GetMaster(oTarget) != OBJECT_INVALID && GetMaster(oSource) != OBJECT_INVALID )
    {
        if (GetMaster(oTarget) == GetMaster(oSource))
        {
            if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE) == 0 )
            {
                nReturnValue = FALSE;
            }
        }
    }

    return nReturnValue;
}

// * generic area of effect constructor
void spellsGenericAreaOfEffect(
        object oCaster, location lTargetLoc,
        int nShape, float fRadiusSize, int nSpellID,
        effect eImpact, effect eLink, effect eVis,
        int nDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0,
        int nTargetType=SPELL_TARGET_ALLALLIES, int bHarmful = FALSE,
        int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0,
        int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE,
        int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SAVING_THROW_NONE,
        int nSavingThrowSubType=SAVING_THROW_TYPE_ALL
        )
{
    //Apply Impact
    if (GetEffectType(eImpact) != 0)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
    }

    object oTarget = OBJECT_INVALID;
    float fDelay = 0.0;

    //Get the first target in the radius around the caster
    if (bPersistentObject == TRUE)
        oTarget = GetFirstInPersistentObject();
    else
        oTarget = GetFirstObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, nTargetType, oCaster) == TRUE)
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHarmful));
            int nResistSpellSuccess = FALSE;
            // * actually perform the resist check
            if (bResistCheck == TRUE)
            {
                nResistSpellSuccess = MyResistSpell(oCaster, oTarget);
            }
          if(!nResistSpellSuccess)
          {
                int nSavingThrowSuccess = FALSE;
                // * actually roll saving throw if told to
                if (nSavingThrowType != SAVING_THROW_NONE)
                {
                  nSavingThrowSuccess = MySavingThrow(nSavingThrowType, oTarget, GetSpellSaveDC(), nSavingThrowSubType);
                }
                if (!nSavingThrowSuccess)
                {
                    fDelay = GetRandomDelay(0.4, 1.1);



                    //Apply VFX impact
                    if (GetEffectType(eVis) != 0)
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }

                    // * Apply effects
                   // if (GetEffectType(eLink) != 0)
                   // * Had to remove this test because LINKED effects have no valid type.
                    {

                        DelayCommand(fDelay, ApplyEffectToObject(nDurationType, eLink, oTarget, fDuration));
                    }

                    // * If this is a removal spell then perform the appropriate removals
                    if (nRemoveEffectSpell == TRUE)
                    {
                        //Remove effects
                        RemoveSpecificEffect(nRemoveEffect1, oTarget);
                        if(nRemoveEffect2 != 0)
                        {
                            RemoveSpecificEffect(nRemoveEffect2, oTarget);
                        }
                        if(nRemoveEffect3 != 0)
                        {
                            RemoveSpecificEffect(nRemoveEffect3, oTarget);
                        }

                    }
                }// saving throw
            } // resist spell check
        }
        //Get the next target in the specified area around the caster
        if (bPersistentObject == TRUE)
            oTarget = GetNextInPersistentObject();
        else
            oTarget = GetNextObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    }
}

//::///////////////////////////////////////////////
//:: ApplyMindBlank
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies Mind blank to the target
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void spellApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0)
{
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eSearch = GetFirstEffect(oTarget);
    int bValid;
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
    //Search through effects
    while(GetIsEffectValid(eSearch))
    {
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED)
        {
            bValid = TRUE;
        }
    // * Additional March 2003
    // * Remove any feeblemind originating effects
        else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)
        {
            bValid = TRUE;
        }
        else if (GetEffectSpellId(eSearch) == SPELL_BANE)
        {
            bValid = TRUE;
        }

        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE)
        {
            RemoveEffect(oTarget, eSearch);
        }
        eSearch = GetNextEffect(oTarget);
    }

    //After effects are removed we apply the immunity to mind spells to the target
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));

}
//::///////////////////////////////////////////////
//:: doAura
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in the Alignment aura - unholy and holy
    aura scripts fromthe original campaign
    spells. Cleaned them up to be consistent.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void doAura(int nAlign, int nVis1, int nVis2, int nDamageType)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;    //Duration is +100%
    }

    effect eVis = EffectVisualEffect(nVis1);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    //Change the effects so that it only applies when the target is evil
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR = EffectSpellResistanceIncrease(25); //Check if this is a bonus or a setting.
    effect eDur = EffectVisualEffect(nVis2);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eEvil = EffectDamageShield(6, DAMAGE_BONUS_1d8, nDamageType);


    // * make them versus the alignment

    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, nAlign);
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, nAlign);
    eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    eEvil = VersusAlignmentEffect(eEvil,ALIGNMENT_ALL, nAlign);


    //Link effects
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eEvil);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
void spellsStinkingCloud(object oTarget = OBJECT_INVALID)
{
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);

    effect eImpact; // * null


    if (GetIsObjectValid(oTarget) == TRUE)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,  GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON))
            {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
                    {
                        float fDelay = GetRandomDelay(0.75, 1.75);
                        //Apply the VFX impact and linked effects
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                   }
            }
        }
    }
    else
    {
       spellsGenericAreaOfEffect(GetAreaOfEffectCreator(),
            GetLocation(OBJECT_SELF), // * not relevent for persistent area of effect
            SHAPE_CONE, 0.0,          // * not relevent for persistent area of effect
            GetSpellId(), eImpact, eLink, eVis,
            DURATION_TYPE_TEMPORARY, RoundsToSeconds(2), SPELL_TARGET_STANDARDHOSTILE,
            TRUE, FALSE, 0, 0, 0, FALSE, OBJECT_TYPE_CREATURE,
            TRUE, FALSE, SAVING_THROW_FORT, SAVING_THROW_TYPE_POISON);
    }
}

//::///////////////////////////////////////////////
//:: RemoveSpellEffects2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Advanced version of RemoveSpellEffects to
    handle multiple spells (allows code reuse
    for shadow conjuration darkness)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void RemoveSpellEffects2(int nSpell_ID, object oCaster, object oTarget, int nSpell_ID2, int nSpell_ID3)
{

    //Declare major variables
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget) || GetHasSpellEffect(nSpell_ID2, oTarget) || GetHasSpellEffect(nSpell_ID3, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                //If the effect was created by the spell then remove it
                if(GetEffectSpellId(eAOE) == nSpell_ID || GetEffectSpellId(eAOE) == nSpell_ID2
                 || GetEffectSpellId(eAOE) == nSpell_ID3)
                {
                    RemoveEffect(oTarget, eAOE);
                    bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

// * returns true if the creature has flesh
int spellsIsImmuneToPetrification(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bImmune = FALSE;
    switch (nAppearance)
    {
    case APPEARANCE_TYPE_BASILISK:
    case APPEARANCE_TYPE_COCKATRICE:
    case APPEARANCE_TYPE_MEDUSA:
    case APPEARANCE_TYPE_ALLIP:
    case APPEARANCE_TYPE_ELEMENTAL_AIR:
    case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_EARTH:
    case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_FIRE:
    case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_WATER:
    case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
    case APPEARANCE_TYPE_GOLEM_STONE:
    case APPEARANCE_TYPE_GOLEM_IRON:
    case APPEARANCE_TYPE_GOLEM_CLAY:
    case APPEARANCE_TYPE_GOLEM_BONE:
    case APPEARANCE_TYPE_GORGON:
    case APPEARANCE_TYPE_HEURODIS_LICH:
    case APPEARANCE_TYPE_LANTERN_ARCHON:
    case APPEARANCE_TYPE_SHADOW:
    case APPEARANCE_TYPE_SHADOW_FIEND:
    case APPEARANCE_TYPE_SHIELD_GUARDIAN:
    case APPEARANCE_TYPE_SKELETAL_DEVOURER:
    case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
    case APPEARANCE_TYPE_SKELETON_COMMON:
    case APPEARANCE_TYPE_SKELETON_MAGE:
    case APPEARANCE_TYPE_SKELETON_PRIEST:
    case APPEARANCE_TYPE_SKELETON_WARRIOR:
    case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
    case APPEARANCE_TYPE_SPECTRE:
    case APPEARANCE_TYPE_WILL_O_WISP:
    case APPEARANCE_TYPE_WRAITH:
    case APPEARANCE_TYPE_BAT_HORROR:
    case 405: // Dracolich:
    case 415: // Alhoon
    case 418: // shadow dragon
    case 420: // mithral golem
    case 421: // admantium golem
    case 430: // Demi Lich
    case 469: // animated chest
    case 474: // golems
    case 475: // golems
        bImmune = TRUE;
    }

    // 03/07/2005 CraigW - Petrification immunity can also be granted as an item property.
    if ( ResistSpell(OBJECT_SELF,oCreature) == 2 )
    {
        bImmune = TRUE;
    }

    // * GZ: Sept 2003 - Prevent people from petrifying DM, resulting in GUI even when
    //                   effect is not successful.
    if (!GetPlotFlag(oCreature) && GetIsDM(oCreature))
    {
       bImmune = FALSE;
    }
    return bImmune;
}

// * Returns true or false depending on whether the creature is flying
// * or not
int spellsIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother
        bFlying = TRUE;
    }
    return bFlying;
}

// * returns true if oCreature does not have a mind
int spellsIsMindless(object oCreature)
{
    int nRacialType = GetRacialType(oCreature);
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_OOZE:
        return TRUE;
    }
    return FALSE;
}


//------------------------------------------------------------------------------
// Doesn't care who the caster was removes the effects of the spell nSpell_ID.
// will ignore the subtype as well...
// GZ: Removed the check that made it remove only one effect.
//------------------------------------------------------------------------------
void RemoveAnySpellEffects(int nSpell_ID, object oTarget)
{
    //Declare major variables

    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the spell then remove it
            if(GetEffectSpellId(eAOE) == nSpell_ID)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

//------------------------------------------------------------------------------
// Attempts a dispel on one target, with all safety checks put in.
//------------------------------------------------------------------------------
void spellsDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE)
{
    //--------------------------------------------------------------------------
    // Don't dispel magic on petrified targets
    // this change is in to prevent weird things from happening with 'statue'
    // creatures. Also creature can be scripted to be immune to dispel
    // magic as well.
    //--------------------------------------------------------------------------
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE || GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
    {
        return;
    }

    effect eDispel;
    float fDelay = GetRandomDelay(0.1, 0.3);
    int nId = GetSpellId();

    //--------------------------------------------------------------------------
    // Fire hostile event only if the target is hostile...
    //--------------------------------------------------------------------------
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId));
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
    }

    //--------------------------------------------------------------------------
    // GZ: Bugfix. Was always dispelling all effects, even if used for AoE
    //--------------------------------------------------------------------------
    if (bAll == TRUE )
    {
        eDispel = EffectDispelMagicAll(nCasterLevel);
        //----------------------------------------------------------------------
        // GZ: Support for Mord's disjunction
        //----------------------------------------------------------------------
        if (bBreachSpells)
        {
            DoSpellBreach(oTarget, 6, 10, nId);
        }
    }
    else
    {
        eDispel = EffectDispelMagicBest(nCasterLevel);
        if (bBreachSpells)
        {
           DoSpellBreach(oTarget, 2, 10, nId);
        }
    }

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget));
}

//------------------------------------------------------------------------------
// GZ: Aug 27 2003
// Return the hightest spellcasting class of oCreature, used for dispel magic
// workaround
//------------------------------------------------------------------------------
int GZGetHighestSpellcastingClassLevel(object oCreature)
{
    int nMax;
    if (GetIsPC(oCreature))
    {
        int i;
        int nClass;
        int nLevel;
        for (i =1; i<= 3; i++)
        {
            // This is kind of hacky as high level pally's and ranger's will
            // dispell at their full class level...
            nClass= GetClassByPosition(i,oCreature);
            if (nClass != CLASS_TYPE_INVALID)
            {
                if (nClass ==  CLASS_TYPE_SORCERER || nClass ==  CLASS_TYPE_WIZARD ||
                    nClass ==  CLASS_TYPE_PALEMASTER || nClass == CLASS_TYPE_CLERIC ||
                    nClass == CLASS_TYPE_DRUID || nClass == CLASS_TYPE_BARD ||
                    nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
                {
                    nLevel = GetLevelByClass(nClass,oCreature);

                    if (nLevel> nMax)
                    {
                        nMax = nLevel;
                    }
                }
            }
        }
    }

    else
    {
        //* not a creature ... be unfair and count full HD :)
        nMax = GetHitDice(oCreature);
    }

    return nMax;
}

//------------------------------------------------------------------------------
// returns TRUE if a creature is not in the condition to use gaze attacks
// i.e. blindness
//------------------------------------------------------------------------------
int GZCanNotUseGazeAttackCheck(object oCreature)
{
    if (GetHasEffect( EFFECT_TYPE_BLINDNESS,oCreature))
    {
        FloatingTextStrRefOnCreature(84530, oCreature ,FALSE); // * blinded
        return TRUE;
    }
    return FALSE;
}

//------------------------------------------------------------------------------
// Handle Dispelling Area of Effects
// Before adding this AoE's got automatically destroyed. Since NWN does not give
// the required information to do proper dispelling on AoEs, we do some simulated
// stuff here:
// - Base chance to dispel is 25, 50, 75 or 100% depending on the spell
// - Chance is modified positive by the caster level of the spellcaster as well
// - as the relevant ability score
// - Chance is modified negative by the highest spellcasting class level of the
//   AoE creator and the releavant ability score.
// Its bad, but its not worse than just dispelling the AoE as the game did until
// now
//------------------------------------------------------------------------------
void spellsDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel)
{
    object oCreator = GetAreaOfEffectCreator(oTargetAoE);
    int nChance;
    int nId   = GetSpellId();
    if ( nId == SPELL_LESSER_DISPEL )
    {
        nChance = 25;
    }
    else if ( nId == SPELL_DISPEL_MAGIC)
    {
        nChance = 50;
    }
    else if ( nId == SPELL_GREATER_DISPELLING )
    {
        nChance = 75;
    }
    else if ( nId == SPELL_MORDENKAINENS_DISJUNCTION )
    {
        nChance = 100;
    }


    nChance += ((nCasterLevel + GetCasterAbilityModifier(oCaster)) - (10  + GetCasterAbilityModifier(oCreator))*2) ;

    //--------------------------------------------------------------------------
    // the AI does cheat here, because it can not react as well as a player to
    // AoE effects. Also DMs are always successful
    //--------------------------------------------------------------------------
    if (!GetIsPC(oCaster))
    {
        nChance +=30;
    }

    if (oCaster == oCreator)
    {
        nChance = 100;
    }

    int nRand = Random(100);

    if ((nRand < nChance )|| GetIsDM(oCaster) || GetIsDMPossessed(oCaster))
    {
        FloatingTextStrRefOnCreature(100929,oCaster);  // "AoE dispelled"
        DestroyObject (oTargetAoE);
    }
    else
    {
        FloatingTextStrRefOnCreature(100930,oCaster); // "AoE not dispelled"
    }

}


