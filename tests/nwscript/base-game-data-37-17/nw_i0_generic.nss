//::///////////////////////////////////////////////
//:: Generic Scripting Include v1.0
//:: NW_I0_GENERIC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

  December 7 2002, Naomi Novik
  Many functions removed to separate libraries:

        x0_i0_anims
            PlayMobileAmbientAnimations_NonAvian
            PlayMobileAmbientAnimations_Avian
                (with PlayMobileAmbientAnimations changed to
                just a call to one of these two)
            PlayImmobileAmbientAnimations

        x0_i0_assoc
            associate constants (NW_ASC_...)
            GetPercentageHPLoss (only used in GetAssociateHealMaster)
            SetAssociateState
            GetAssociateState
            ResetHenchmenState
            AssociateCheck
            GetAssociateHealMaster
            GetFollowDistance
            SetAssociateStartLocation
            GetAssociateStartLocation

        x0_i0_behavior
            behavior constants
            SetBehaviorState
            GetBehaviorState

        x0_i0_spawncond
            OnSpawn condition constants
            SetSpawnInCondition
            GetSpawnInCondition
            SetSpawnInLocals
            SetListeningPatterns

        x0_i0_walkway
            WalkWayPoints
            RunNextCircuit
            RunCircuit
            CheckWayPoints
            GetIsPostOrWalking

        x0_i0_talent
           ALL the talent functions

        x0_i0_equip
            Equipping functions

        x0_i0_match
            Matching functions

        x0_i0_debug
            MyPrintString
            DebugPrintTalentId
            newdebug

        x0_inc_generic
            Pretty much everything else

    ***********************************************'
    CHANGE SUMMARY


    February 6 2003: Commented out the Henchman RespondToShout because now using
                     the newer bkRespondToShout function in x0_i0_henchman


    September 18 2002: DetermineCombatRound broken into smaller functions
              19     : Removed randomness from Talent system. You can't
                       have smart AI and random behavior. Only healing
                       has the possiblity of being random.

                       I may want to add the possibility of getting a
                       random talent only in the Talent filter if
                       something fails (*)


    ********************************************
    WARNING THIS SCRIPT IS CHANGED AT YOUR PERIL
    ********************************************

    This is the master generic script and currently
    handles all combat and some plot behavior
    within NWN. If this script is tampered
    with there is a chance of introducing game
    breaking bugs.  But other than that enjoy.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:://////////////////////////////////////////////

//#include "x0_i0_assoc" - included in x0_inc_generic
//#include "x0_inc_generic" - included in x0_i0_talent
//#include "x0_i0_talent" - included in x0_i0_combat

//#include "x0_i0_combat"    - include in x0_i0_anims

//#include "x0_i0_walkway"   - include in x0_i0_anims
#include "x0_i0_behavior"
#include "x0_i0_anims"


/**********************************************************************
 * CONSTANTS
 **********************************************************************/

/**********************************************************************
 * Flee and move constants
 **********************************************************************/

const int NW_GENERIC_FLEE_EXIT_FLEE = 0;
const int NW_GENERIC_FLEE_EXIT_RETURN = 1;
const int NW_GENERIC_FLEE_TELEPORT_FLEE = 2;
const int NW_GENERIC_FLEE_TELEPORT_RETURN = 3;

/**********************************************************************
 * Shout constants
 **********************************************************************/

// NOT USED
const int NW_GENERIC_SHOUT_I_WAS_ATTACKED = 1;

//IN OnDeath Script
const int NW_GENERIC_SHOUT_I_AM_DEAD = 12;

//IN TalentMeleeAttacked
const int NW_GENERIC_SHOUT_BACK_UP_NEEDED = 13;

const int NW_GENERIC_SHOUT_BLOCKER = 2;

/**********************************************************************
 * chooseTactics constants
 **********************************************************************/

const int      chooseTactics_MEMORY_OFFENSE_MELEE    = 0;
const int      chooseTactics_MEMORY_DEFENSE_OTHERS   = 1;
const int      chooseTactics_MEMORY_DEFENSE_SELF     = 2;
const int      chooseTactics_MEMORY_OFFENSE_SPELL    = 3;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// * New Functions September - 2002


// * The class-specific tactics have been broken out from DetermineCombatRound
// * for readability. This function determines the actual tactics each class
// * will use.
int chooseTactics(object oIntruder);

// Adds all three of the class levels together.  Used before
// GetHitDice became available
int GetCharacterLevel(object oTarget);

//If using ambient sleep this will remove the effect
void RemoveAmbientSleep();

//Searches for the nearest locked object to the master
object GetLockedObject(object oMaster);

/**********************************************************************
 * DetermineCombatRound subfunctions
 **********************************************************************/

//     Used in DetermineCombatRound to keep a
//     henchmen bashing doors.
int BashDoorCheck(object oIntruder = OBJECT_INVALID);

//     Determines which of a NPCs three classes to
//     use in DetermineCombatRound
int DetermineClassToUse();


/**********************************************************************
 * Core AI Functions
 **********************************************************************/

//::///////////////////////////////////////////////
//:: DetermineCombatRound
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This function is the master function for the
    generic include and is called from the main
    script.  This function is used in lieu of
    any actual scripting.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
void DetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10);

//::///////////////////////////////////////////////
//:: Respond To Shouts
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//     Allows the listener to react in a manner
//     consistant with the given shout but only to one
//     combat shout per round
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//NOTE ABOUT COMMONERS
//     Commoners are universal cowards.  If you attack anyone
//     they will flee for 4 seconds away from the attacker.
//     However to make the commoners into a mob, make a single
//     commoner at least 10th level of the same faction.
//     If that higher level commoner is attacked or killed then
//     the commoners will attack the attacker.  They will disperse again
//     after some of them are killed.  Should NOT make multi-class
//     creatures using commoners.
//
//NOTE ABOUT BLOCKERS
//     It should be noted that the Generic Script for On Dialogue
//     attempts to get a local set on the shouter by itself.
//     This object represents the LastOpenedBy object.  It is this
//     object that becomes the oIntruder within this function.
//
//NOTE ABOUT INTRUDERS
//     The intruder object is for cases where a placable needs to
//     pass a LastOpenedBy Object or a AttackMyAttacker
//     needs to make his attacker the enemy of everyone.
void RespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID);


//******** PLOT FUNCTIONS

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
void SetNPCWarningStatus(int nStatus = TRUE);

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
int GetNPCWarningStatus();

// * Presently Does not work with the current implementation
// * of encounter triggers!
//
//     This function works in tandem with an encounter
//     to spawn in guards to fight for the attacked
//     NPC.  MAKE SURE THE ENCOUNTER TAG IS SET TO:
//
//              "ENC_" + NPC TAG
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
void SetSummonHelpIfAttacked();

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
// This function is used only because ActionDoCommand can
// only accept void functions.
void CreateSignPostNPC(string sTag, location lLocal);

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
void ActivateFleeToExit();

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
int GetFleeToExit();

//     Checks that an item was unlocked.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
void CheckIsUnlocked(object oLastObject);

// This function is now just a wrapper around the functions
// PlayMobileAmbientAnimations_Nonavian() and
// PlayMobileAmbientAnimations_Avian(), in x0_i0_anims
void PlayMobileAmbientAnimations();

//     Determines the special behavior used by the NPC.
//     Generally all NPCs who you want to behave differently
//     than the defualt behavior.
//     For these behaviors, passing in a valid object will
//     cause the creature to become hostile the the attacker.
void DetermineSpecialBehavior(object oIntruder = OBJECT_INVALID);

// * Am I in a invisible or stealth state or sanctuary?
int InvisibleTrue(object oSelf = OBJECT_SELF);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AdjustBehaviorVariable
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Overriding "behavior" variables.
If a variable has been stored on the creature it overrides the above
class defaults
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int AdjustBehaviorVariable(int nVar, string sVarName)
{
    int nPlace =GetLocalInt(OBJECT_SELF, sVarName);
    if (nPlace > 0)
    {
        return nPlace;
    }
    //return nVar; // * return the original value
    return 0;
}

//::///////////////////////////////////////////////
//:: InvisibleBecome
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A more intelligent invisibility solution,
    along the lines of the one used in
    the various end-user AIs.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  June 14, 2003
//:://////////////////////////////////////////////
int InvisibleBecome(object oSelf = OBJECT_SELF)
{
    int iDarkness = FALSE;
    if(GetHasSpell(SPELL_DARKNESS) && GetHasSpell(SPELL_DARKVISION)) iDarkness = TRUE;
    if(GetHasSpell(SPELL_IMPROVED_INVISIBILITY) || GetHasSpell(SPELL_INVISIBILITY) ||
       GetHasSpell(SPELL_INVISIBILITY_SPHERE) || (iDarkness) || GetHasSpell(SPELL_SANCTUARY)
       || GetHasSpell(SPELL_ETHEREALNESS)
       || GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf) == TRUE)
    {

        // * cannot already be invisible, otherwise what is the point
        if(InvisibleTrue(oSelf) == FALSE)
        {
            // * this bit ported directly from Jasperre
            // Can anyone see me? (has spell effects of X)
            // * The point of this is to see if its even worthwhile to go invisbile
            // * or will it be immediately dispeled.
            object oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_TRUE_SEEING);
            if(!GetIsObjectValid(oSeeMe))
            {
                oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_SEE_INVISIBILITY);
           //     if(!GetIsObjectValid(oSeeMe))
           //     {
           //         oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_INVISIBILITY_PURGE);
           //     }
            }


            if(!GetIsObjectValid(oSeeMe))
            {
                int nDiff = GetCombatDifficulty(oSelf, TRUE);
               //SpeakString(IntToString(nDiff));
                if (nDiff > -1)
                {

                    ClearActions(1001);
                    if (iDarkness==TRUE)
                    {
                        ActionCastSpellAtObject(SPELL_DARKVISION, oSelf);
                        ActionCastSpellAtObject(SPELL_DARKNESS, oSelf);
                        return TRUE;
                    }
//                    if (GetHasSpell(SPELL_IMPROVED_INVISIBILITY, oSelf) == TRUE)
                    if (GetHasSpell(SPELL_IMPROVED_INVISIBILITY, oSelf))
                    {
                        ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oSelf);
                        return TRUE;
                    }
                    else
//                    if (GetHasSpell(SPELL_INVISIBILITY, oSelf) == TRUE)
                    if (GetHasSpell(SPELL_INVISIBILITY, oSelf))
                    {
                        ActionCastSpellAtObject(SPELL_INVISIBILITY, oSelf);
                        return TRUE;
                    }
                    else
//                    if (GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf) == TRUE)
                    if (GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf))
                    {
                        ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, oSelf);
                        return TRUE;
                    }
                    else
//                    if (GetHasSpell(SPELL_ETHEREALNESS, oSelf) == TRUE)
                    if (GetHasSpell(SPELL_ETHEREALNESS, oSelf))
                    {
                        ActionCastSpellAtObject(SPELL_ETHEREALNESS, oSelf);
                        return TRUE;
                    }
                    else
//                    if (GetHasSpell(SPELL_SANCTUARY, oSelf) == TRUE)
                    if (GetHasSpell(SPELL_SANCTUARY, oSelf))
                    {
                        ActionCastSpellAtObject(SPELL_SANCTUARY, oSelf);
                        return TRUE;
                    }
                    else
                    if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf))
                    // * go into stealth mode
                    {
                       // SpeakString("Attempting stealth mode");
                        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
                        WrapperActionAttack(GetNearestEnemy());
                        return TRUE;
                    }

                }
            }
            }// is NOT invisible
    }
 return FALSE;
}

//::///////////////////////////////////////////////
//:: InvisibleTrue
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns TRUE if oSelf is hidden either
    magically or via stealth

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  July 14, 2003
//:://////////////////////////////////////////////

int InvisibleTrue(object oSelf =OBJECT_SELF)
{
      if(GetHasEffect(EFFECT_TYPE_INVISIBILITY, oSelf) || GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oSelf)
          || (GetHasSpellEffect(SPELL_DARKNESS, oSelf) && GetHasSpellEffect(SPELL_DARKVISION, oSelf))
            || GetActionMode(oSelf, ACTION_MODE_STEALTH) || GetHasEffect(EFFECT_TYPE_SANCTUARY, oSelf)
            || GetHasEffect(EFFECT_TYPE_ETHEREAL, oSelf))
      {
        return TRUE;

      }
    return FALSE;
}

// * Returns true if a wizard or sorcerer and wearing armor
int GetShouldNotCastSpellsBecauseofArmor(object oTarget, int nClass)
{

    if (GetArcaneSpellFailure(oTarget) > 15 && (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD))
    {
        return TRUE;
    }
    return FALSE;
}


//::///////////////////////////////////////////////
//:: chooseTactics
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Separated this function out from DetermineCombatRound
    for readibility
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:://////////////////////////////////////////////

int chooseTactics(object oIntruder)
{

    // SELF PRESERVATION: Always attempt to heal self first
    if(TalentHealingSelf() == TRUE) return 99; //Use spells and potions

    // Next, try the special tactics routines
    // specific to XP1
    if (SpecialTactics(oIntruder)) return 99;

    // * These constants in ChooseTactics routine
    // * remember previous rounds choices

    //moved to top of script, made into real constants
    //int      MEMORY_OFFENSE_MELEE    = 0;
    //int      MEMORY_DEFENSE_OTHERS   = 1;
    //int      MEMORY_DEFENSE_SELF     = 2;
    //int      MEMORY_OFFENSE_SPELL    = 3;

    // * If defensive last round, try to be offensive this round
    // * this is to prevent wasting time on multiple protections
    int nPreviousMemory = GetLocalInt(OBJECT_SELF, "NW_L_MEMORY");

    int nClass = DetermineClassToUse();

    //This does not seem to be used, so no point declaring it...
    //int nCrazy  =  0;

    // * Defaulted high so unspecified classes will not be cowards
    int nOffense = 50;

    int nCompassion = 25;

    // * Defaulted this high because non standard creatures
    // * with spells should try and use them.
    int nMagic = 55;

    // * setup base BEHAVIOR
    switch (nClass)
    {
        case CLASS_TYPE_COMMONER:
            // Commoners should run away from fights
            //SpawnScriptDebugger();
            nOffense = 0; nCompassion = 0; nMagic = 0;  break;
        case CLASS_TYPE_PALEMASTER:
        case  CLASS_TYPE_WIZARD:
        case  CLASS_TYPE_SORCERER:
                  //  SpawnScriptDebugger();
            nOffense = 40; nCompassion = 40; nMagic = 100; break;
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_DRAGONDISCIPLE:
        {
            if(TalentBardSong() == TRUE) return 99;
            nOffense = 40; nCompassion = 42; nMagic = 43; break;
        }
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_SHIFTER:
        {
            nOffense = 40;
            nCompassion = 45;
            nMagic = 44;
            // * Clerics shouldn't constantly cast spells
            if (nPreviousMemory != chooseTactics_MEMORY_OFFENSE_MELEE)
                nMagic = Random(50) + 1;
            break;
        }
        case CLASS_TYPE_PALADIN :
        case CLASS_TYPE_RANGER :
            nOffense = 40; nCompassion = 25; nMagic = Random(50) + 1; break;
        case CLASS_TYPE_BARBARIAN:
        {
           // SpawnScriptDebugger();
            // * GetHasFeat(...) does not work correctly with no-leveled up
            // * characters. So for now, only Xanos gets to do this.
            string sTag = GetTag(OBJECT_SELF);
            if (sTag == "x0_hen_xan" || sTag == "x2_hen_daelan")
            {
                if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE) == FALSE)
                {

                    if (GetHasFeat(FEAT_BARBARIAN_RAGE) == TRUE)
                    {
                        ActionUseFeat(FEAT_BARBARIAN_RAGE, OBJECT_SELF);
                        return 99;
                    }
                }
            }
            nOffense = 50; nCompassion = 25; nMagic = 20; break;
            // * set high magic to use rage
            // * suggestion don't give barbarians lots of magic or else they will fight oddly
        }
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_ROGUE : //SpawnScriptDebugger();
        case CLASS_TYPE_MONK :
            nOffense = 40; nCompassion = 0; nMagic = 0; break;
        case CLASS_TYPE_UNDEAD:
            nOffense = 40; nCompassion = 40; nMagic = 40; break;
        case CLASS_TYPE_OUTSIDER:
        {
            nOffense = 40; nMagic = 40;
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
                nCompassion = 40;
            }
            else nCompassion = 0;
            break;
        }
        case CLASS_TYPE_CONSTRUCT:
        case CLASS_TYPE_ELEMENTAL:
            nOffense = 40; nCompassion = 0; nMagic = 40; break;
        case CLASS_TYPE_DRAGON:
            nOffense = 40; nCompassion = 20; nMagic = 40; break;
        default:
            nOffense = 50; nCompassion = 25; nMagic = 55; break;
    }

    //really minor optimization - since this bit doesn't rely on the variables set
    //below, might as well check it before we do all those calculations
    // * Dragon Disciple Breath
    if (GetHasFeat(FEAT_DRAGON_DIS_BREATH) && Random(100) > 50)
    {
        ClearActions(2000);
        ActionCastSpellAtObject(690, GetNearestEnemy(), METAMAGIC_ANY, TRUE);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGON_DIS_BREATH);
        return 99;
    }


    // MyPrintString("Made it past the class-specific settings");


    // ************************************
    // * MODIFY BEHAVIOR FOR SPECIAL CASES
    // ************************************
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD)
        nCompassion = nCompassion - 20;

    // Randomize things a bit
    //seems that nCrazy is always 0, so might as well comment them out
    nOffense = Random(10 /*+ nCrazy*/) + nOffense;
    nMagic = Random(10 /*+ nCrazy*/) + nMagic;
    nCompassion = Random(10 /*+ nCrazy*/) + nCompassion;



    // * if your opponent is close to you, then increase offense
    // * as casting defensive abilities when enemies are close
    // * is generally not a good idea.
    // * Dec 18 2002: If you have Combat Casting, you'll still be more
    // * liable to use defensive abilities
    if (GetIsObjectValid(oIntruder) && !GetHasFeat(FEAT_COMBAT_CASTING))
    {
        if (GetDistanceToObject(oIntruder) <= 5.0) {
            nOffense = nOffense + 20;
            nMagic = nMagic - 20;
        }
    }

    // * If enemies are further away, more chance of doing magic
    if (GetDistanceToObject(oIntruder) > 3.0)
        nMagic = nMagic + 15;

    // * Dec 18 2002: Add your level to your magic rating
    nMagic = nMagic + GetHitDice(OBJECT_SELF);


   // **************************************
   // * CHOOSE TALENT TO USE
   // **************************************

    //SpawnScriptDebugger();

    // * If defensive last round, try to be offensive this round
    // * this is to prevent wasting time on multiple protections
    if ((nPreviousMemory == chooseTactics_MEMORY_DEFENSE_OTHERS)
        || (nPreviousMemory == chooseTactics_MEMORY_DEFENSE_SELF))
    {
        nOffense = nOffense + 40;
    }


    // April 2003
    // If in rage should be almost no chance of doing magic
    // * June 2003
    // * If has more than 5% chance of spell failure don't try casting
    // 5% chance changed to 15%
    if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE)== TRUE || GetShouldNotCastSpellsBecauseofArmor(OBJECT_SELF, nClass) == TRUE
        || GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 10)
    {
        nMagic = 0;
    }




    // **************
    // * JULY 12 2003
    // * Overriding "behavior" variables.
    // * If a variable has been stored on the creature it overrides the above
    // * class defaults
    // * JULY 28 2003
    // * changed this so that its an additive process, not an overrwrite.
    // * gives more flexiblity.
    // **************
    nMagic = nMagic + AdjustBehaviorVariable(nMagic, "X2_L_BEH_MAGIC");
    nOffense = nOffense + AdjustBehaviorVariable(nOffense, "X2_L_BEH_OFFENSE");
    nCompassion = nCompassion + AdjustBehaviorVariable(nCompassion, "X2_L_BEH_COMPASSION");


    // * If invisbile of any sort, become Defensive and
    // * magical to use any buffs you may have
    // * This behavior variable setting should override all others
    // * October 22 2003 - Lines 690 and 713 modified to only work if magic
    // * setting has not been turned off. Nathyrra always going invisible
    // * can be annoying.
    if (InvisibleTrue(OBJECT_SELF) == TRUE && nMagic > 0)
    {
        // SpawnScriptDebugger();
        // * if wounded at all take this time to heal self
        // * since I am invisible there is little danger from doing this
        if (GetCurrentHitPoints(OBJECT_SELF) < GetMaxHitPoints(OBJECT_SELF))
        {
            if(TalentHealingSelf(TRUE) == TRUE) return 99;
        }

        nOffense = 7;
        nMagic = 100;

        if (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == TRUE)
        {
          nOffense = 100; // * if in stealth attempt sneak attacks
        }
    }
    else
    // **************
    // * JULY 14 2003
    // * Attempt To Go Invisible
    // **************
    if (InvisibleBecome() == TRUE && nMagic > 0)
        return 99;

    // PHYSICAL, NO OFFENSE
    if (nOffense <= 5)
    {
        //SpawnScriptDebugger();
        //SpeakString("fleeing");
        if (TalentFlee(oIntruder) == TRUE) return 99;
    }

    // protect others: MAGICAL, DEFENSE, COMPASSION
    if ((nOffense<= 50) && (nMagic > 50) && (nCompassion > 50))
    {
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_DEFENSE_OTHERS);
        if (TalentHeal() == TRUE) return 99;
        if (TalentCureCondition() == TRUE) return 99;
        if (TalentUseProtectionOthers() == TRUE) return 99;
        if (TalentEnhanceOthers() == TRUE) return 99;

        // * Temporarily be non-compassionate to buff self
        // * if we got to this point.
        nCompassion = 0;
    }

    // protectself: MAGICAL, DEFENSE, NO COMPASSION
    if ((nOffense<= 50) && (nMagic > 50) && (nCompassion <=50))
    {
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_DEFENSE_SELF);

        /* Dec 19 2002:
        Against spell-casters, cast protection spells more often
        */
        int nClass = GetClassByPosition(1,oIntruder);
        if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER
            || nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID)
        {
            if (TalentSelfProtectionMantleOrGlobe())
                return 99;
        }

        if(TalentUseProtectionOnSelf() == TRUE) return 99;
        if(TalentUseEnhancementOnSelf() == TRUE) return 99;
        if(TalentPersistentAbilities() == TRUE) return 99;
        //    int TalentAdvancedBuff(float fDistance);

        //Used for Potions of Enhancement and Protection
        if(TalentBuffSelf() == TRUE) return 99;

        if(TalentAdvancedProtectSelf() == TRUE) return 99;
        if(TalentSummonAllies() == TRUE) return 99;
        if(TalentSeeInvisible() == TRUE) return 99;
        if(TalentMeleeAttacked(oIntruder) == TRUE) return 99;
        if(TalentRangedAttackers(oIntruder) == TRUE) return 99;
        if(TalentRangedEnemies(oIntruder) == TRUE) return 99;


    }

    //  MAGICAL, OFFENSE
    if (nMagic > 50)
    {
        // // MyPrintString("in offensive spell");
        // SpawnScriptDebugger();
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_OFFENSE_SPELL);
        if (TalentUseTurning() == TRUE) return 99;
        if (TalentSpellAttack(oIntruder) == TRUE) return 99;
    }

    // If we got here, we're going to melee offense
    SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_OFFENSE_MELEE);

    // PHYSICAL, OFFENSE (if nothing else applies)
    if (TryKiDamage(oIntruder) == TRUE) return 99;
    if (TalentSneakAttack() == TRUE) return 99;
    if (TalentDragonCombat(oIntruder)) {return 99;}
    if (TalentMeleeAttack(oIntruder) == TRUE) return 99;


    object oHostile = GetNearestSeenEnemy();

    // * Feb 17 2003: This error could happen in the situation that someone
    // * went into combat mode and their 'hostility' ended while going through ChooseTactics
    if (GetIsObjectValid(oHostile) == TRUE)
    {

        // * BK if it returns this it means the AI found nothing
        // * Appropriate to do
        //SpeakString("BUG!!!!!!!!!!!!!!!!!!!!!!!! (Let Brent Knowles know about this. Supply savegame) Nothing valid to do !!!!!!!!!!!!!!!!!!!!!");
        //SpeakString("BUG!! Magic " + IntToString(nMagic) + " Compassion " + IntToString(nCompassion) + " Offense " + IntToString(nOffense));
    }
    return 1;

} // * END of choosetactics

//::///////////////////////////////////////////////
//:: __InCombatRound
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Tests to see if already running a determine
    combatround this round.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   July 11 2003
//:://////////////////////////////////////////////
int __InCombatRound()
{

    // * if just in attackaction, turn combat round off
    // * if simply fighting it is okay to turn the combat round off
    // * and try again because it doesn't hurt an attackaction
    // * to be reiniated whereas it does break a spell
    int nCurrentAction =  GetCurrentAction(OBJECT_SELF);
    if (nCurrentAction == ACTION_ATTACKOBJECT || nCurrentAction == ACTION_INVALID || nCurrentAction == ACTION_MOVETOPOINT)
    {
        return FALSE;
    }
    if (GetLocalInt(OBJECT_SELF, "X2_L_MUTEXCOMBATROUND") == TRUE)
    {
        //SpeakString("DEBUG:: In Combat Round, busy.");
        return TRUE;
    }
    return FALSE;
}
//::///////////////////////////////////////////////
//:: __TurnCombatRoundOn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will set the exclusion variable on whether
    in combat or not.
    This is to prevent multiple firings
    of determinecombatround in one round
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 11 2003
//:://////////////////////////////////////////////

void __TurnCombatRoundOn(int bBool)
{
    if (bBool == TRUE)
    {
        SetLocalInt(OBJECT_SELF, "X2_L_MUTEXCOMBATROUND", TRUE);
    }
    else
    {
        // * delay it turning off like an action
        ActionDoCommand(SetLocalInt(OBJECT_SELF, "X2_L_MUTEXCOMBATROUND", FALSE));
    }
}
//::///////////////////////////////////////////////
//:: DetermineCombatRound
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This function is the master function for the
    generic include and is called from the main
    script.  This function is used in lieu of
    any actual scripting.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

void DetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10)
{
    // MyPrintString("************** DETERMINE COMBAT ROUND START *************");
    // MyPrintString("**************  " + GetTag(OBJECT_SELF) + "  ************");

    // ----------------------------------------------------------------------------------------
    // May 2003
    // Abort out of here, if petrified
    // ----------------------------------------------------------------------------------------
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF) == TRUE)
    {
        return;
    }

    // ----------------------------------------------------------------------------------------
    // Oct 06/2003 - Georg Zoeller,
    // Fix for ActionRandomWalk blocking the action queue under certain circumstances
    // ----------------------------------------------------------------------------------------
    if (GetCurrentAction() == ACTION_RANDOMWALK)
    {
        ClearAllActions();
    }

    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT");
    if (sSpecialAI != "")
    {
        SetLocalObject(OBJECT_SELF,"X2_NW_I0_GENERIC_INTRUDER", oIntruder);
        ExecuteScript(sSpecialAI, OBJECT_SELF);
        if (GetLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK"))
        {
            DeleteLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK");
            return;
        }
    }


    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: EVALUATIONS
    // ----------------------------------------------------------------------------------------
    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    if(BashDoorCheck(oIntruder)) {return;}

    // ----------------------------------------------------------------------------------------
    // BK: stop fighting if something bizarre that shouldn't happen, happens
    // ----------------------------------------------------------------------------------------

    if (bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE)
        return;

    // ** Store HOw Difficult the combat is for this round
    int nDiff = GetCombatDifficulty();
    SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);

    // MyPrintString("COMBAT: " + IntToString(nDiff));

    // ----------------------------------------------------------------------------------------
    // If no special target has been passed into the function
    // then choose an appropriate target
    // ----------------------------------------------------------------------------------------
    if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = bkAcquireTarget();


    if (GetIsDead(oIntruder) == TRUE)
    {
        // ----------------------------------------------------------------------------------------
        // If for some reason my target is dead, then leave
        // the poor guy alone. Jeez. What kind of monster am I?
        // ----------------------------------------------------------------------------------------
        return;
    }

    // ----------------------------------------------------------------------------------------
    /*
       JULY 11 2003
       If in combat round already (variable set) do not enter it again.
       This is meant to prevent multiple calls to DetermineCombatRound
       from happening during the *same* round.

       This variable is turned on at the start of this function call.
       It is turned off at each "return" point for this function
       */
    // ----------------------------------------------------------------------------------------
    if (__InCombatRound() == TRUE)
    {
        return;
    }

    __TurnCombatRoundOn(TRUE);

    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: ACTIONS
    // ----------------------------------------------------------------------------------------
    if(GetIsObjectValid(oIntruder))
    {

        if(TalentPersistentAbilities()) // * Will put up things like Auras quickly
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // ----------------------------------------------------------------------------------------
        // BK September 2002
        // If a succesful tactic has been chosen then
        // exit this function directly
        // ----------------------------------------------------------------------------------------

        if (chooseTactics(oIntruder) == 99)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // ----------------------------------------------------------------------------------------
        // This check is to make sure that people do not drop out of
        // combat before they are supposed to.
        // ----------------------------------------------------------------------------------------

        object oNearEnemy = GetNearestSeenEnemy();
        DetermineCombatRound(oNearEnemy);

        return;
    }
     __TurnCombatRoundOn(FALSE);

    // ----------------------------------------------------------------------------------------
    // This is a call to the function which determines which
    // way point to go back to.
    // ----------------------------------------------------------------------------------------
    ClearActions(CLEAR_NW_I0_GENERIC_658);
    SetLocalObject(OBJECT_SELF,
                   "NW_GENERIC_LAST_ATTACK_TARGET",
                   OBJECT_INVALID);
    WalkWayPoints();
}



//::///////////////////////////////////////////////
//:: Respond To Shouts
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the listener to react in a manner
    consistant with the given shout but only to one
    combat shout per round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////

//NOTE ABOUT COMMONERS
/*
    Commoners are universal cowards.  If you attack anyone they will flee for 4 seconds away from the attacker.
    However to make the commoners into a mob, make a single commoner at least 10th level of the same faction.
    If that higher level commoner is attacked or killed then the commoners will attack the attacker.  They will disperse again
    after some of them are killed.  Should NOT make multi-class creatures using commoners.
*/
//NOTE ABOUT BLOCKERS
/*
    It should be noted that the Generic Script for On Dialogue attempts to get a local set on the shouter by itself.
    This object represents the LastOpenedBy object.  It is this object that becomes the oIntruder within this function.
*/

//NOTE ABOUT INTRUDERS
/*
    The intruder object is for cases where a placable needs to pass a LastOpenedBy Object or a AttackMyAttacker
    needs to make his attacker the enemy of everyone.
*/

void RespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID)
{

    // Pausanias: Do not respond to shouts if you've surrendered.
    int iSurrendered = GetLocalInt(OBJECT_SELF,"Generic_Surrender");
    if (iSurrendered) return;

    switch (nShoutIndex)
    {
        case 1://NW_GENERIC_SHOUT_I_WAS_ATTACKED:
            {
                object oTarget = oIntruder;
                if(!GetIsObjectValid(oTarget))
                {
                    oTarget = GetLastHostileActor(oShouter);
                }
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                    {
                        if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                        {
                            if(GetIsObjectValid(oTarget))
                            {
                                if(!GetIsFriend(oTarget) && GetIsFriend(oShouter))
                                {
                                    RemoveAmbientSleep();
                                    //DetermineCombatRound(oTarget);
                                    DetermineCombatRound(GetLastHostileActor(oShouter));
                                }
                            }
                        }
                    }
                    else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    else
                    {
                        DetermineCombatRound(oIntruder);
                    }
                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;

        case 2://NW_GENERIC_SHOUT_MOB_ATTACK:
            {
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {

                    //Is friendly check to make sure that only like minded commoners attack.
                    if(GetIsFriend(oShouter))
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    //if(TalentMeleeAttack()) {return;}
                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;

        case 3://NW_GENERIC_SHOUT_I_AM_DEAD:
            {
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    //Use I was attacked script above
                    if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                    {
                        if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                        {
                            if(GetIsObjectValid(GetLastHostileActor(oShouter)))
                            {
                                if(!GetIsFriend(GetLastHostileActor(oShouter)) && GetIsFriend(oShouter))
                                {
                                    DetermineCombatRound(GetLastHostileActor(oShouter));
                                }
                            }
                        }
                    }
                    else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    else
                    {
                        DetermineCombatRound();
                    }

                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;
        //For this shout to work the object must shout the following
        //string sHelp = "NW_BLOCKER_BLK_" + GetTag(OBJECT_SELF);
        case 4: //BLOCKER OBJECT HAS BEEN DISTURBED
            {
                if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                {
                    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                    {
                        if(GetIsObjectValid(oIntruder))
                        {
                            SetIsTemporaryEnemy(oIntruder);
                            DetermineCombatRound(oIntruder);
                        }
                    }
                }
                else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                {
                    WrapperActionAttack(oIntruder);
                }
                else
                {
                    DetermineCombatRound();
                }
            }
        break;

        case 5: //ATTACK MY TARGET
            {
                AdjustReputation(oIntruder, OBJECT_SELF, -100);
                if(GetIsFriend(oShouter))
                {
                    SetIsTemporaryEnemy(oIntruder);
                    ClearActions(CLEAR_NW_I0_GENERIC_834);
                    DetermineCombatRound(oIntruder);
                }
            }
        break;

        case 6: //CALL_TO_ARMS
            {
                //This was once commented out.
                DetermineCombatRound();
            }
        break;

        //ASSOCIATE SHOUT RESPONSES  ******************************************************************************

        /* This was moved into X0_I0_HENCHMAN as bkRespondToHenchmenShout
        case ASSOCIATE_COMMAND_ATTACKNEAREST: //Used to de-activate AGGRESSIVE DEFEND MODE
            {
                ResetHenchmenState();
                SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
                SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
                DetermineCombatRound();
            }
        break;

        case ASSOCIATE_COMMAND_FOLLOWMASTER: //Only used to retreat, or break free from Stand Ground Mode
            {
                ResetHenchmenState();
                SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
                DelayCommand(2.5, VoiceCanDo());

                if(GetAssociateState(NW_ASC_AGGRESSIVE_STEALTH))
                {
                   //ActionUseSkill(SKILL_HIDE, OBJECT_SELF);
                }
                if(GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH))
                {
                   ActionUseSkill(SKILL_SEARCH, OBJECT_SELF);
                }
                ActionForceFollowObject(GetMaster(), GetFollowDistance());
                SetAssociateState(NW_ASC_IS_BUSY);
                DelayCommand(5.0, SetAssociateState(NW_ASC_IS_BUSY, FALSE));
            }
        break;

        case ASSOCIATE_COMMAND_GUARDMASTER: //Used to activate AGGRESSIVE DEFEND MODE
            {
                ResetHenchmenState();
                DelayCommand(2.5, VoiceCanDo());
                //Companions will only attack the Masters Last Attacker
                SetAssociateState(NW_ASC_MODE_DEFEND_MASTER);
                SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
                if(GetIsObjectValid(GetLastHostileActor(GetMaster())))
                {
                    DetermineCombatRound(GetLastHostileActor(GetMaster()));
                }
            }
        break;

        case ASSOCIATE_COMMAND_HEALMASTER: //Ignore current healing settings and heal me now
            {
                ResetHenchmenState();
                //SetCommandable(TRUE);
                if(TalentCureCondition()) {DelayCommand(2.0, VoiceCanDo()); return;}
                if(TalentHeal(TRUE)) {DelayCommand(2.0, VoiceCanDo()); return;}
                DelayCommand(2.5, VoiceCannotDo());
            }
        break;

        case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK: //Check local for Re-try locked doors and
            {
                if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                {
                    if(GetAssociateState(NW_ASC_RETRY_OPEN_LOCKS))
                    {
                        int bValid = TRUE;
                        object oLastObject = GetLockedObject(GetMaster());
                        int nSkill = GetSkillRank(SKILL_OPEN_LOCK) - GetAbilityModifier(ABILITY_DEXTERITY);

                        if(GetIsObjectValid(oLastObject) && GetPlotFlag(oLastObject) == FALSE)
                        {
                            if(GetIsDoorActionPossible(oLastObject, DOOR_ACTION_KNOCK) || GetIsPlaceableObjectActionPossible(oLastObject, PLACEABLE_ACTION_KNOCK))
                            {
                                ClarAllActions();
                                VoiceCanDo();
                                ActionCastSpellAtObject(SPELL_KNOCK, oLastObject);
                                ActionWait(1.0);
                                bValid = FALSE;
                            }
                            else if (GetIsDoorActionPossible(oLastObject, DOOR_ACTION_UNLOCK)|| GetIsPlaceableObjectActionPossible(oLastObject, PLACEABLE_ACTION_UNLOCK))
                            {
                                ClarAllActions();
                                VoicePicklock();
                                ActionWait(1.0);
                                ActionUseSkill(SKILL_OPEN_LOCK,oLastObject);
                                bValid = FALSE;
                            }
                            else if(nSkill < 5 && GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16 && GetSkillRank(SKILL_OPEN_LOCK) <= 0)
                            {
                                if(GetIsDoorActionPossible(oLastObject, DOOR_ACTION_BASH) || GetIsPlaceableObjectActionPossible(oLastObject, PLACEABLE_ACTION_BASH))
                                {
                                    ClarAllActions();
                                    VoiceCanDo();
                                    ActionEquipMostDamagingMelee(oLastObject);
                                    WrapperActionAttack(oLastObject);
                                    SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oLastObject);
                                    bValid = FALSE;
                                }
                            }
                            if(bValid == TRUE)
                            {
                                //ClarAllActions();
                                VoiceCannotDo();
                            }
                            else
                            {
                                ActionDoCommand(VoiceTaskComplete());
                            }
                        }
                    }
                }
            }
        break;

        case ASSOCIATE_COMMAND_MASTERUNDERATTACK:  //Check whether the master has you in AGGRESSIVE DEFEND MODE
            {
                if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                {
                    //Check the henchmens current target
                    object oTarget = GetAttemptedAttackTarget();
                    if(!GetIsObjectValid(oTarget))
                    {
                        oTarget = GetAttemptedSpellTarget();
                        if(!GetIsObjectValid(oTarget))
                        {
                            if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
                            {
                                DetermineCombatRound(GetLastHostileActor(GetMaster()));
                            }
                            else
                            {
                                DetermineCombatRound();
                            }
                        }
                    }
                    //Switch targets only if the target is not attacking the master and is greater than 6.0 from
                    //the master.
                    if(GetAttackTarget(oTarget) != GetMaster() && GetDistanceBetween(oTarget, GetMaster()) > 6.0)
                    {
                        if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) && GetIsObjectValid(GetLastHostileActor(GetMaster())))
                        {
                            DetermineCombatRound(GetLastHostileActor(GetMaster()));
                        }
                    }
                }
            }
        break;

        case ASSOCIATE_COMMAND_STANDGROUND: //No longer follow the master or guard him
            {
                SetAssociateState(NW_ASC_MODE_STAND_GROUND);
                SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
                DelayCommand(2.0, VoiceCanDo());
                WrapperActionAttack(OBJECT_INVALID);
                ClarAllActions();
            }
        break;

        case ASSOCIATE_COMMAND_MASTERSAWTRAP:
            {
                int nCheck = 0;
                if(!GetIsInCombat())
                {
                    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                    {
                        object oTrap = GetLastTrapDetected();
                        if(GetIsObjectValid(oTrap))
                        {
                            int nTrapDC = GetTrapDisarmDC(oTrap);
                            int nSkill = GetSkillRank(SKILL_DISABLE_TRAP);
                            int nMod = GetAbilityModifier(ABILITY_DEXTERITY);
                            if((nSkill - nMod) > 0)
                            {
                                nSkill = nSkill + 20 - nTrapDC;
                            }
                            else
                            {
                                nSkill = 0;
                                nCheck = 1;
                            }

                            if(GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP && nSkill > 0)
                            {
                                VoiceStop();
                                if(GetHasSkill(SKILL_DISABLE_TRAP, OBJECT_SELF))
                                {
                                    ClarAllActions();
                                    ActionUseSkill(SKILL_DISABLE_TRAP, oTrap);
                                    ActionDoCommand(SetCommandable(TRUE));
                                    ActionDoCommand(VoiceTaskComplete());
                                    SetCommandable(FALSE);
                                    nCheck = 2;
                                }
                            }
                            else if(nCheck = 0 &&
                                    GetSkillRank(SKILL_DISABLE_TRAP) > 0 &&
                                    GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP)
                            {
                                VoiceCannotDo();
                            }
                        }
                    }
                }
            }
        break;

        case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
            {
                if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                {
                    if(!GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
                    {
                        if(!GetIsFighting(OBJECT_SELF))
                        {
                            object oAttack = GetAttackTarget(GetMaster());
                            if(GetIsObjectValid(oAttack) && GetObjectSeen(oAttack))
                            {
                                ClarAllActions();
                                DetermineCombatRound(oAttack);
                            }
                        }
                    }
                }
            }
        break;

        case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
            {
                if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                {
                    if(!GetIsFighting(OBJECT_SELF))
                    {
                        object oAttacker = GetGoingToBeAttackedBy(GetMaster());
                        if(GetIsObjectValid(oAttacker) && GetObjectSeen(oAttacker))
                        {
                            ClarAllActions();
                            DetermineCombatRound(oAttacker);
                        }
                    }
                }
            }
        break;

        case ASSOCIATE_COMMAND_LEAVEPARTY:
            {
                object oMaster = GetMaster();
                if(GetIsObjectValid(oMaster))
                {
                    ClarAllActions();
                    if(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF)
                    {
                        AddJournalQuestEntry("Henchman",50,GetMaster(),FALSE,FALSE,TRUE);
                    }
                    SetLocalObject(OBJECT_SELF,"NW_L_FORMERMASTER", oMaster);
                    RemoveHenchman(oMaster, OBJECT_SELF);
                }

            }
        break; */
    }
}

//::///////////////////////////////////////////////
//:: Set and Get NPC Warning Status
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This function sets a local int on OBJECT_SELF
    which will be checked in the On Attack, On
    Damaged and On Disturbed scripts to check if
    the offending party was a PC and was friendly.
    The Get will return the status of the local.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
void SetNPCWarningStatus(int nStatus = TRUE)
{
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_WARNING_STATUS", nStatus);
}

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
int GetNPCWarningStatus()
{
    return GetLocalInt(OBJECT_SELF, "NW_GENERIC_WARNING_STATUS");
}

//::///////////////////////////////////////////////
//:: Set SummonHelpIfAttacked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This function works in tandem with an encounter
    to spawn in guards to fight for the attacked
    NPC.  MAKE SURE THE ENCOUNTER TAG IS SET TO:

             "ENC_" + NPC TAG
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

//Presently Does not work with the current implementation of encounter trigger
void SetSummonHelpIfAttacked()
{
    string sEncounter = "ENC_" + GetTag(OBJECT_SELF);
    object oTrigger = GetObjectByTag(sEncounter);

    if(GetIsObjectValid(oTrigger))
    {
        SetEncounterActive(TRUE, oTrigger);
    }
}

//************************************************************************************************************************************
//************************************************************************************************************************************
//
// ESCAPE FUNCTIONS
//
//************************************************************************************************************************************
//************************************************************************************************************************************

//::///////////////////////////////////////////////
//:: Set, Get Activate,Flee to Exit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target object flees to the specified
    way point and then destroys itself, to be
    respawned at a later point.  For unkillable
    sign post characters who are not meant to fight
    back.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

//This function is used only because ActionDoCommand can only accept void functions
void CreateSignPostNPC(string sTag, location lLocal)
{
    CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocal);
}

void ActivateFleeToExit()
{
     //minor optimizations - only grab these variables when actually needed
     //can make for larger code, but it's faster
     //object oExitWay = GetWaypointByTag("EXIT_" + GetTag(OBJECT_SELF));
     //location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
     //string sTag = GetTag(OBJECT_SELF);

     //I suppose having this as a variable made it easier to change at one point....
     //but it never changes, and is only used twice, so we don't need it
     //float fDelay =  6.0;

     int nPlot = GetLocalInt(OBJECT_SELF, "NW_GENERIC_MASTER");

     if(nPlot & NW_FLAG_TELEPORT_RETURN || nPlot & NW_FLAG_TELEPORT_LEAVE)
     {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        if(nPlot & NW_FLAG_TELEPORT_RETURN)
        {
            location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
            string sTag = GetTag(OBJECT_SELF);
            DelayCommand(6.0, ActionDoCommand(CreateSignPostNPC(sTag, lLocal)));
        }
        ActionDoCommand(DestroyObject(OBJECT_SELF, 0.75));
     }
     else
     {
        if(nPlot & NW_FLAG_ESCAPE_LEAVE)
        {
            object oExitWay = GetWaypointByTag("EXIT_" + GetTag(OBJECT_SELF));
            ActionMoveToObject(oExitWay, TRUE);
            ActionDoCommand(DestroyObject(OBJECT_SELF, 1.0));
        }
        else if(nPlot & NW_FLAG_ESCAPE_RETURN)
        {
            string sTag = GetTag(OBJECT_SELF);
            object oExitWay = GetWaypointByTag("EXIT_" + sTag);
            ActionMoveToObject(oExitWay, TRUE);
            location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
            DelayCommand(6.0, ActionDoCommand(CreateSignPostNPC(sTag, lLocal)));
            ActionDoCommand(DestroyObject(OBJECT_SELF, 1.0));
        }
     }
}

int GetFleeToExit()
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_GENERIC_MASTER");
    if(nPlot & NW_FLAG_ESCAPE_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_ESCAPE_LEAVE)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_TELEPORT_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_TELEPORT_LEAVE)
    {
       return TRUE;
    }
    return FALSE;
}



//**********************************
//**********************************
//**********************************
// PRIVATE FUNCTIONS
//**********************************
//**********************************
//**********************************

//This is experimental and has not been looked at closely.
void ExitAOESpellArea(object oAOEObject)
{
    ClearActions(CLEAR_NW_I0_GENERIC_ExitAOESpellArea);
    ActionMoveAwayFromObject(oAOEObject, TRUE, 5.0);
    AssignCommand(OBJECT_SELF, DetermineCombatRound());
}


//::///////////////////////////////////////////////
//:: Get Character Levels
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the combined class levels of the
    target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

int GetCharacterLevel(object oTarget)
{
    return GetHitDice(oTarget);
}




//::///////////////////////////////////////////////
//:: Remove Ambient Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the NPC has sleep on them because
    of ambient animations. Sleeping creatures
    must make a DC 15 listen check.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002
//:://////////////////////////////////////////////

void RemoveAmbientSleep()
{
    if(GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        effect eSleep = GetFirstEffect(OBJECT_SELF);
        while(GetIsEffectValid(eSleep))
        {
            if(GetEffectCreator(eSleep) == OBJECT_SELF)
            {
                int nRoll = d20();
                nRoll += GetSkillRank(SKILL_LISTEN);
                nRoll += GetAbilityModifier(ABILITY_WISDOM);
                if(nRoll > 15)
                {
                    RemoveEffect(OBJECT_SELF, eSleep);
                }
            }
            eSleep = GetNextEffect(OBJECT_SELF);
        }
    }
}


//::///////////////////////////////////////////////
//:: Get Locked Object
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Finds the closest locked object to the object
    passed in up to a maximum of 10 objects.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 15, 2002
//:://////////////////////////////////////////////

object GetLockedObject(object oMaster)
{
    int nCnt = 1;
    int bValid = TRUE;
    object oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    while (GetIsObjectValid(oLastObject) && bValid == TRUE)
    {
        //COMMENT THIS BACK IN WHEN DOOR ACTION WORKS ON PLACABLE.

        //object oItem = GetFirstItemInInventory(oLastObject);
        if(GetLocked(oLastObject))
        {
            return oLastObject;
        }
        nCnt++;
        if(nCnt == 10)
        {
            bValid = FALSE;
        }
        oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    }
    return OBJECT_INVALID;
}





//::///////////////////////////////////////////////
//:: Check if an item is locked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks that an item was unlocked.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

void CheckIsUnlocked(object oLastObject)
{
    if(GetLocked(oLastObject))
    {
        ActionDoCommand(VoiceCuss());
    }
    else
    {
        ActionDoCommand(VoiceCanDo());
    }
}


//::///////////////////////////////////////////////
//:: Play Mobile Ambient Animations
//:: This function is now just a wrapper around
//:: code from x0_i0_anims.
//:://////////////////////////////////////////////
void PlayMobileAmbientAnimations()
{
    if(!GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)) {
        // not a bird
        PlayMobileAmbientAnimations_NonAvian();
    } else {
        // a bird
        PlayMobileAmbientAnimations_Avian();
    }
}

//::///////////////////////////////////////////////
//:: Determine Special Behavior
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the special behavior used by the NPC.
    Generally all NPCs who you want to behave differently
    than the defualt behavior.
    For these behaviors, passing in a valid object will
    cause the creature to become hostile the the attacker.

    MODIFIED February 7 2003:
    - Rearranged logic order a little so that the creatures
    will actually randomwalk when not fighting
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14, 2001
//:://////////////////////////////////////////////

void DetermineSpecialBehavior(object oIntruder = OBJECT_INVALID)
{
    object oTarget = GetNearestSeenEnemy();
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE))
    {
        int bAttack = FALSE;
        if(!GetIsObjectValid(oIntruder))
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 8.0)
                {
                    if(!GetIsFriend(oTarget))
                    {
                        if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                        {
                            SetIsTemporaryEnemy(oTarget, OBJECT_SELF, FALSE, 20.0);
                            bAttack = TRUE;
                            DetermineCombatRound(oTarget);
                        }
                    }
                }
            }
        }
        else if(!IsInConversation(OBJECT_SELF))
        {
            bAttack = TRUE;
            DetermineCombatRound(oIntruder);
        }

        // * if not attacking, the wander
        if (bAttack == FALSE)
        {
            ClearActions(CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior1);
            ActionRandomWalk();
            return;
        }
    }
    else if(GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
    {
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()) &&
           !GetIsObjectValid(GetAttackTarget()))
        {
            if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 6.0)
            {
                if(!GetIsFriend(oTarget))
                {
                    if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                    {
                        TalentFlee(oTarget);
                    }
                }
            }
        }
        else if(!IsInConversation(OBJECT_SELF))
        {
            ClearActions(CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior2);
            ActionRandomWalk();
            return;
        }
    }
}

//::///////////////////////////////////////////////
//:: Bash Doors
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in DetermineCombatRound to keep a
    henchmen bashing doors.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

int BashDoorCheck(object oIntruder = OBJECT_INVALID)
{
    int bDoor = FALSE;
    //This code is here to make sure that henchmen keep bashing doors and placables.
    object oDoor = GetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");

    // * MODIFICATION February 7 2003 BK
    // * don't bash trapped doors.
    if (GetIsTrapped(oDoor) ) return FALSE;

    if(GetIsObjectValid(oDoor))
    {
        int nDoorMax = GetMaxHitPoints(oDoor);
        int nDoorNow = GetCurrentHitPoints(oDoor);
        int nCnt = GetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP");
        if(!GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
           || (!GetIsObjectValid(oIntruder) && !GetIsObjectValid(GetMaster())))
        {
            if(GetLocked(oDoor))
            {
                if(nDoorMax == nDoorNow)
                {
                    nCnt++;
                    SetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP", nCnt);
                }
                if(nCnt <= 0)
                {
                    bDoor = TRUE;
                    if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK))
                    {
                        ActionUseFeat(FEAT_IMPROVED_POWER_ATTACK, oDoor);
                    }
                    else if(GetHasFeat(FEAT_POWER_ATTACK))
                    {
                        ActionUseFeat(FEAT_POWER_ATTACK, oDoor);
                    }
                    else
                    {
                        WrapperActionAttack(oDoor);
                    }
                }
            }
        }
        if(bDoor == FALSE)
        {
            VoiceCuss();
            DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
            DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
        }
    }
    return bDoor;
}

//::///////////////////////////////////////////////
//:: Determine Class to Use
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines which of a NPCs three classes to
    use in DetermineCombatRound
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

int DetermineClassToUse()
{
    int nClass;
    int nTotal = GetHitDice(OBJECT_SELF);

    //this is silly...
/*
    float fTotal = IntToFloat(nTotal);
    int nState1 = FloatToInt((IntToFloat(GetLevelByClass(GetClassByPosition(1))) / fTotal) * 100);
    // MyPrintString(GetTag(OBJECT_SELF) + "Class: " + IntToString(GetClassByPosition(1)) + " %" + IntToString(nState1));

    int nState2 = FloatToInt((IntToFloat(GetLevelByClass(GetClassByPosition(2))) / fTotal) * 100) + nState1;
    // MyPrintString(GetTag(OBJECT_SELF) + "Class: " + IntToString(GetClassByPosition(2)) + " %" + IntToString(nState2));

    int nState3 = FloatToInt((IntToFloat(GetLevelByClass(GetClassByPosition(3))) / fTotal) * 100) + nState2;
    // MyPrintString(GetTag(OBJECT_SELF) + "Class: " + IntToString(GetClassByPosition(3)) + " %" + IntToString(nState3));
*/
    int nClass1 = GetClassByPosition(1);
    int nClass2 = GetClassByPosition(2);

    int nState1 = GetLevelByClass(nClass1) * 100 / nTotal;
    int nState2 = GetLevelByClass(nClass2) * 100 / nTotal;
//    int nState3 = GetLevelByClass(GetClassByPosition(3)) * 100 / nTotal;

    int nUseClass = d100();
    // MyPrintString("D100 Roll " + IntToString(nUseClass));

    if(nUseClass <= nState1)
    {
        nClass = nClass1;
    }
    else if(nUseClass > nState1 && nUseClass <= nState2)
    {
        nClass = nClass2;
    }
    else
    {
        nClass = GetClassByPosition(3);
    }
    // MyPrintString(GetName(OBJECT_SELF) + " Return Class = " + IntToString(nClass));

    return nClass;
}



/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
