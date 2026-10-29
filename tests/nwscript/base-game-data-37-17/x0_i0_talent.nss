//:://////////////////////////////////////////////////
//:: X0_I0_TALENT
/*
  Library for talent functions.

  All of these functions attempt to use a particular category
  of skill, and return TRUE on success, FALSE on failure. This
  allows for building up fall-through chains where one talent
  after another is attempted, with the order determined by the
  creature's particular tactics.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/20/2003
//:: Modified By: Georg Zoeller, 2003-Oct-21:
//::        - commented debug strings
//::        - updated talent advanced buff to include some xp2 stuff          \
//::        - added some code to prevent TalentBardsong from breaking in
//::          epic levels
//:://////////////////////////////////////////////////


#include "x0_inc_generic"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Added by Brent, constant for 'always get me it' things like Healing
const int TALENT_ANY = 20;


// Bitwise constants for negative conditions we might want to try to cure
const int COND_CURSE     = 0x00000001;
const int COND_POISON    = 0x00000002;
const int COND_DISEASE   = 0x00000004;
const int COND_ABILITY   = 0x00000008;
const int COND_DRAINED   = 0x00000010;
const int COND_BLINDDEAF = 0x00000020;

const float WHIRL_DISTANCE = 3.0; // * Shortened distance so its more effective (went from 5.0 to 2.0 and up to 3.0)

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/


 // * Tries to do the Ki Damage ability
int TryKiDamage(object oTarget)
{
    if (GetIsObjectValid(oTarget) == FALSE)
    {
        return FALSE;

    }
    if (GetHasFeat(FEAT_KI_DAMAGE) == TRUE)
    {
        // * Evaluation:
        // * Must have > 40 hitpoints AND  (damage reduction OR damage resistance)
        // * Or just have over 200 hitpoints
        int bHasDamageReduction = FALSE;
        int bHasDamageResistance = FALSE;
        int bHasHitpoints = FALSE;
        int bHasMassiveHitpoints = FALSE;
        int bOutNumbered = FALSE;

        int nCurrentHP = GetCurrentHitPoints(oTarget);
        if (nCurrentHP > 40)
            bHasHitpoints = TRUE;
        if (nCurrentHP > 200)
            bHasMassiveHitpoints = TRUE;
        if (GetHasEffect(EFFECT_TYPE_DAMAGE_REDUCTION, oTarget) == TRUE)
            bHasDamageReduction = TRUE;
        if (GetHasEffect(EFFECT_TYPE_DAMAGE_RESISTANCE, oTarget) == TRUE)
            bHasDamageResistance = TRUE;

        if (GetIsObjectValid(GetNearestEnemy(OBJECT_SELF, 3)) == TRUE)
        {
            bOutNumbered = TRUE;
        }

        if ( (bHasHitpoints && (bHasDamageReduction || bHasDamageResistance) ) || (bHasMassiveHitpoints) || (bHasHitpoints && bOutNumbered) )
        {
            ClearAllActions();
            ActionUseFeat(FEAT_KI_DAMAGE, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}

// Try a spell to produce a particular spell effect.
// This will only cast the spell if the target DOES NOT already have the
// given spell effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpell(int nSpell, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);

// Try a spell corresponding to a particular effect.
// This will only cast the spell if the target DOES have the
// given effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpellForEffect(int nSpell, int nEffect, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);

// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through bkTalentFilter for a final check.
int TryTalent(talent tUse, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);

// PROTECT SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseProtectionOnSelf();

// PROTECT PARTY
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseProtectionOthers(object oDefault=OBJECT_INVALID);

// ENHANCE OTHERS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentEnhanceOthers();

// ENHANCE SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseEnhancementOnSelf();

// SPELL CASTER MELEE ATTACKED
//    Wrote this function so I could do further
//   checks such as making them not cast
//    Dispel Magic.
// * Possible Issue (brent): It may get stuck on
// * dispel magics...trying to cast them
// * and not proceed down Area Of Effect Discriminants...
//  SOLUTION: If this function returns true the TalentMeleeAttacked routine
//  will exit, however if it returns false, it will try and find some
//  other ability to use.
int genericDoHarmfulRangedAttack(talent tUse, object oTarget);

//    Will return true if it succesfully
//    used a harmful ranged talent.
int genericAttemptHarmfulRanged(talent tUse, object oTarget);

// MELEE ATTACKED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID);

// SPELL CASTER RANGED ATTACKED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentRangedAttackers(object oIntruder = OBJECT_INVALID);

// SPELL CASTER WITH RANGED ENEMIES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentRangedEnemies(object oIntruder = OBJECT_INVALID);

// SUMMON ALLIES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSummonAllies();

// HEAL SELF WITH POTIONS AND SPELLS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentHealingSelf(int bForce = FALSE); //Use spells and potions

//Use spells only on others and self
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF);

// MELEE ATTACK OTHERS
//     ISSUE 1: Talent Melee Attack should set the Last Spell Used
//     to 0 so that melee casters can use a single special ability.
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentMeleeAttack(object oIntruder = OBJECT_INVALID);

// SNEAK ATTACK OTHERS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSneakAttack();

// FLEE COMBAT AND HOSTILES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentFlee(object oIntruder = OBJECT_INVALID);

// TURN UNDEAD
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseTurning();

// ACTIVATE AURAS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentPersistentAbilities();

// FAST BUFF SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentAdvancedBuff(float fDistance, int bInstant = TRUE);

// USE POTIONS
//Used for Potions of Enhancement and Protection
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentBuffSelf();

// USE SPELLS TO DEFEAT INVISIBLE CREATURES
// THIS TALENT IS NOT USED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSeeInvisible();

// Utility function for TalentCureCondition
// Checks to see if the creature has the given condition in the
// given condition value.
// To use, you must first calculate the nCurrentConditions value
// with GetCurrentNegativeConditions.
// The value of nCondition can be any of the COND_* constants
// declared in x0_i0_talent.
int GetHasNegativeCondition(int nCondition, int nCurrentConditions);

// Utility function for TalentCureCondition
// Returns an integer with bitwise flags set that represent the
// current negative conditions on the creature.
// To be used with GetHasNegativeCondition.
int GetCurrentNegativeConditions(object oCreature);

// CURE DISEASE, POISON ETC
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentCureCondition();

// DRAGON COMBAT
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentDragonCombat(object oIntruder = OBJECT_INVALID);

// BARD SONG
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentBardSong();

// ADVANCED PROTECT SELF Talent 2.0
// This will use the class specific defensive spells first and
// leave the rest for the normal defensive AI
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentAdvancedProtectSelf();

// Cast a spell mantle or globe of invulnerability protection on
// yourself.
int TalentSelfProtectionMantleOrGlobe();

// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSpellAttack(object oIntruder);

// This function simply attempts to get the best protective
// talent that the caller has, the protective talents as
// follows:
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
talent StartProtectionLoop();


// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Try a spell to produce a particular spell effect.
// This will only cast the spell if the target DOES NOT already have the
// given spell effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpell(int nSpell, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    if (GetHasSpell(nSpell, oCaster) && !GetHasSpellEffect(nSpell, oTarget)) {
        AssignCommand(oCaster,
                      ActionCastSpellAtObject(nSpell, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Try a spell corresponding to a particular effect.
// This will only cast the spell if the target DOES have the
// given effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpellForEffect(int nSpell, int nEffect, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    if (GetHasSpell(nSpell, oCaster) && GetHasEffect(nEffect, oTarget)) {
        AssignCommand(oCaster,
                      ActionCastSpellAtObject(nSpell, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through bkTalentFilter for a final check.
int TryTalent(talent tUse, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);
    if(nType == TALENT_TYPE_SPELL  && GetHasSpellEffect(nIndex, oTarget))
    {
        return FALSE;
    }
    else if(nType == TALENT_TYPE_FEAT && GetHasFeatEffect(nIndex, oTarget))
    {
        return FALSE;

    }
    // MODIFIED February 7 2003. Implicit else, implies success.
    bkTalentFilter(tUse, OBJECT_SELF);
    //MyPrintString("TryTalent Successful Exit");
    return TRUE;

    return FALSE;
}


//:://////////////////////////////////////////////////////////
//:: Talent checks and use functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////////////////
/*
    This is a series of functions that check
    if a particular type of talent is available and
    if so then use that talent.
*/
//:://////////////////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////////////////

// PROTECT SELF
int TalentUseProtectionOnSelf()
{
    //MyPrintString("TalentUseProtectionOnSelf Enter");
    talent tUse;
    int nType, nIndex;
    int bValid = FALSE;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                 GetCRMax());

    if(!GetIsTalentValid(tUse)) {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                     GetCRMax());
        if(GetIsTalentValid(tUse))  {
            ////MyPrintString("I have found a way to protect my self");
            bValid = TRUE;
        }
    } else {
        ////MyPrintString("I have found a way to protect my self");
        bValid = TRUE;
    }


    if (bValid == TRUE) {
        if (TryTalent(tUse)) {
            //MyPrintString("TalentUseProtectionOnSelf Successful Exit");
            return TRUE;
        }
    }

    //MyPrintString("TalentUseProtectionOnSelf Failed Exit");
    return FALSE;
}

//PROTECT PARTY
int TalentUseProtectionOthers(object oDefault=OBJECT_INVALID)
{
    //MyPrintString("TalentUseProtectionOthers Enter");
    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                 nCR);
    tMass = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                  nCR);
    object oTarget;

    // Pausanias: added option for the spell to have a specified target.
    if (oDefault == OBJECT_INVALID)  {
        oTarget = GetNearestSeenFriend();
    } else {
        oTarget = oDefault;
    }

    //Override the nearest target if the master wants aggressive buff spells
    if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF)
       && GetAssociateState(NW_ASC_HAVE_MASTER))
    {
        oTarget = GetMaster();
    }

    while(GetIsObjectValid(oTarget)) {
        if(GetIsTalentValid(tMass) && CheckFriendlyFireOnTarget(oTarget) > 2) {
            if (TryTalent(tMass, oTarget)) {
                //MyPrintString("TalentUseProtectionOthers Successful Exit");
                return TRUE;
            }
        }

        if(GetIsTalentValid(tUse)) {
            if (TryTalent(tUse, oTarget)) {
                //MyPrintString("TalentUseProtectionOthers Successful Exit");
                return TRUE;
            }
        }
        nCnt++;
        oTarget = GetNearestSeenFriend(OBJECT_SELF, nCnt);
    }
    //MyPrintString("TalentUseProtectionOthers Failed Exit");
    return FALSE;
}

// ENHANCE OTHERS
int TalentEnhanceOthers()
{
    //MyPrintString("TalentEnhanceOthers Enter");
    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    int nCR = GetCRMax();
    object oTarget = GetNearestSeenFriend();
    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE, nCR);
    tMass = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT, nCR);

    //Override the nearest target if the master wants aggressive buff spells
    if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF)
       && GetAssociateState(NW_ASC_HAVE_MASTER))
    {
        oTarget = GetMaster();
    }

    while(GetIsObjectValid(oTarget)) {
        if(GetIsTalentValid(tMass)) {
            if(CheckFriendlyFireOnTarget(oTarget) > 2) {
                if (TryTalent(tMass, oTarget)) {
                    //MyPrintString("TalentEnhanceOthers Successful Exit");
                    return TRUE;
                }
            }
        }

        if(GetIsTalentValid(tUse)) {
            if (TryTalent(tUse, oTarget)) {
                    //MyPrintString("TalentEnhanceOthers Successful Exit");
                    return TRUE;
            }
        }
        nCnt++;
        oTarget = GetNearestSeenFriend(OBJECT_SELF, nCnt);
    }
    //MyPrintString("TalentEnhanceOthers Failed Exit");
    return FALSE;
}

// ENHANCE SELF
int TalentUseEnhancementOnSelf()
{
    //MyPrintString("TalentUseEnhancementOnSelf Enter");
    talent tUse;
    int nType;
    int bValid = FALSE;
    int nIndex;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF,
                                 GetCRMax());
    if(!GetIsTalentValid(tUse))  {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE,
                                     GetCRMax());
        if(GetIsTalentValid(tUse)) {
            bValid = TRUE;
        }
    } else {
        bValid = TRUE;
    }

    if(bValid == TRUE) {
        if (GetIdFromTalent(tUse) == SPELL_INVISIBILITY && Random(2) == 0) {
            //MyPrintString("Decided not to use Invisibility");
            return FALSE; // BRENT JULY 2002: There is a 50% chance that
                          // they will not use invisibility if they have it
        }

        if (TryTalent(tUse)) {
            //MyPrintString("TalentUseEnhancementOnSelf Successful Exit");
            return TRUE;
        }
    }

    //MyPrintString("TalentUseEnhancementOnSelf Failed Exit");
    return FALSE;
}

// SPELL CASTER MELEE ATTACKED
//::///////////////////////////////////////////////
//:: genericDoHarmfulRangedAttack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Wrote this function so I could do further
    checks such as making them not cast
    Dispel Magic.
// * Possible Issue (brent): It may get stuck on
// * dispel magics...trying to cast them
// * and not proceed down Area Of Effect Discriminants...
  SOLUTION: If this function returns true the TalentMeleeAttacked routine
  will exit, however if it returns false, it will try and find some
  other ability to use.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

int genericDoHarmfulRangedAttack(talent tUse, object oTarget)
{
    //MyPrintString("BK: genericDoharmfulRangedAttack");

    int bConditionsMet = FALSE;
    // * check to see if this talent is a spell talent
    if (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
    {
        int nSpellID = GetIdFromTalent(tUse);
        // * Check to see if Dispel Magic and similar spells should *not* be cast
        if (nSpellID == SPELL_DISPEL_MAGIC || nSpellID == SPELL_MORDENKAINENS_DISJUNCTION
           || nSpellID == SPELL_LESSER_DISPEL || nSpellID == SPELL_GREATER_DISPELLING)
        {
            //MyPrintString("BK: inside of dispel magic");
            effect eEffect = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eEffect) == TRUE)
            {
                //MyPrintString("BK: Valid effect");
                int nEffectID = GetEffectSpellId(eEffect);
                // * JULY 14 2003
                // * If the effects originated from me (i.e., I cast
                // * a disabling effect on you. Then I will not
                // * dispel that effect
                if (GetEffectCreator(eEffect) == OBJECT_SELF)
                {

                  bConditionsMet = FALSE;
                  break;
                }
                else
                // * this effect was applied from a spell if it
                // * isn't -1
                // * dispel magic should only attempt to remove spell
                // * granted effects
                if (nEffectID == -1)
                {
                 //MyPrintString("BK: conditions NOT met");
                }
                else
                {
                    //MyPrintString("BK: conditions met");
                 bConditionsMet = TRUE;
                }
                eEffect = GetNextEffect(oTarget);
            }
        } else {
             // if not a special condition spell then conditions are met auto.
             bConditionsMet = TRUE;
        }
    }


    // * only returns true if all of the conditions are met.
    if (bConditionsMet == TRUE)
    {
        //MyPrintString("BK: bCOnditionsMet == TRUE");
        //DebugPrintTalentID(tUse);
        //MyPrintString("TalentMeleeAttacked Successful Exit");
        bkTalentFilter(tUse, oTarget);
        return TRUE;
    }

    return FALSE;
}

//::///////////////////////////////////////////////
//:: genericAttemptHarmfulRanged
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will return true if it succesfully
    used a harmful ranged talent.
    BK: Wrapper function to encapsulate some
    commonly used behavior in these
    scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

int genericAttemptHarmfulRanged(talent tUse, object oTarget)
{
    //SpawnScriptDebugger();
    if(  GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL
         ||
         (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
          && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)
          && !CompareLastSpellCast(GetIdFromTalent(tUse)) )
      )
    {
        //MyPrintString("2164: Can try to do a DoHarmfulRangedAttack");
        if (genericDoHarmfulRangedAttack(tUse, oTarget)) {
            if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL) {
                SetLastGenericSpellCast(GetIdFromTalent(tUse));
            }
            return TRUE;
        }
    }
    else
    // MODIFIED
    // Try to find a suitable second choice (up to 5 tries to find one)
    {
    int nSteps = 0;
    int bDone = FALSE;


      while (bDone == FALSE)
      {
        if (nSteps >= 5)
            bDone = TRUE;

        nSteps++;

        tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_RANGED);
        if (GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL
          ||
          (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
           && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)
           && !CompareLastSpellCast(GetIdFromTalent(tUse)) )
           )
           {
              if (genericDoHarmfulRangedAttack(tUse, oTarget))
              {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                                 SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                  return TRUE;
              }
           }
       }
       // * End modification to loop through available talents

    }
    // else
    //MyPrintString("BK: Harmful Ranged will return false");
    return FALSE;
}

int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentMeleeAttacked Enter");
    talent tUse;
    int nMelee = GetNumberOfMeleeAttackers();
    object oTarget = oIntruder;
    int nCR = GetCRMax();

    if(!GetIsObjectValid(oIntruder) && GetIsObjectValid(GetLastHostileActor()))
    {
        oTarget = GetLastHostileActor();
    }
    else
    {
        return FALSE;
    }

    /*
        ISSUE 1: The check in this function to use a random ability
        after failing to use best will fail in the following
        case.  The creature is unable to affect the target with
        the spell and has only 1 spell of that type.  This can
        be eliminated with a check in the else to the effect of :

            else if(!CompareLastSpellCast(GetIdFromTalent(tUse)))

        This check was not put in in version 1.0 due to time constraints.

        ISSUE 2: Given the Spell Attack is the drop out check the
        else statements in this talent should be cut.
    */

    if(nMelee == 1)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked HARMFUL TOUCH Successful Exit");
                bkTalentFilter(tUse, oTarget);
                return TRUE;
            }
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
        if(GetIsTalentValid(tUse))
        {
            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                return TRUE;
            }
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked AREAEFFECT D Successful Exit");
                bkTalentFilter(tUse, oTarget);
                return TRUE;
            }
        }
    }
    else if (nMelee > 1)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
        if(GetIsTalentValid(tUse))
        {
             if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
             {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked AREA EFFECT DSuccessful Exit");
                bkTalentFilter(tUse, oTarget);
                return TRUE;
            }
        }
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked HARMFUL TOUCH Successful Exit");
                bkTalentFilter(tUse, oTarget);
                return TRUE;
            }
        }

         tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
        if(GetIsTalentValid(tUse))
        {
            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                //MyPrintString("TalentMeleeAttacked HARMFUL RANGED Successful Exit");

                return TRUE;
            }
        }

    }
    //MyPrintString("TalentMeleeAttacked Failed Exit");
    return FALSE;
}

// SPELL CASTER RANGED ATTACKED
int TalentRangedAttackers(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentRangedAttackers Enter");
    //Check for Single Ranged Targets
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
    }
    if(GetIsObjectValid(oTarget) && GetDistanceBetween(oTarget, OBJECT_SELF) > 5.0)
    {
        if(CheckFriendlyFireOnTarget(oTarget) > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
            if(GetIsTalentValid(tUse))
            {
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedAttackers Successful Exit");
                    bkTalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        else if(CheckEnemyGroupingOnTarget(oTarget) > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR);


            if(GetIsTalentValid(tUse))
            {

            //MyPrintString("2346 : Choose Talent here " + IntToString(nCR));
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedAttackers Successful Exit");
                    ClearActions(CLEAR_X0_I0_TALENT_RangedAttackers);
                    ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
                    return TRUE;
                }
            }
        }
        else
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
            if(GetIsTalentValid(tUse))
            {
                // * BK: July 2002: Wrapped up harmful ranged into
                // * a function to make it easier to make global
                // * changes to the decision making process.
                if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
                {
                    return TRUE;
                }
            }
       }
    }
    //MyPrintString("TalentRangedAttackers Failed Exit");
    return FALSE;
}

// SPELL CASTER WITH RANGED ENEMIES
int TalentRangedEnemies(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentRangedEnemies Enter");
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetNearestSeenEnemy();
    }

    if(GetIsObjectValid(oTarget))
    {
        int nEnemy = CheckEnemyGroupingOnTarget(oTarget);
        if(CheckFriendlyFireOnTarget(oTarget) > 0 &&  nEnemy > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                         nCR);

            if(GetIsTalentValid(tUse))
            {
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedEnemies Successful Exit");
                    // * ONLY TalentFilter not to have a ClarAllActions before it(February 6 2003)
                    bkTalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        else if(nEnemy > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR);

            if(GetIsTalentValid(tUse))
            {
                //MyPrintString("2428 : Choose Talent here " + IntToString(nCR));

              if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedEnemies Successful Exit");
                    ClearActions(CLEAR_X0_I0_TALENT_RangedEnemies);
                    ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
                    return TRUE;
                }
            }
            else
            {
                tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                             nCR);
                if(GetIsTalentValid(tUse))
                {
                    if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                        !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                        !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                        GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                    {
                        if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                        {
                            SetLastGenericSpellCast(GetIdFromTalent(tUse));
                        }
                        // DebugPrintTalentID(tUse);
                        //MyPrintString("TalentRangedEnemies Successful Exit");
                        bkTalentFilter(tUse, oTarget);
                        return TRUE;
                    }
                }
            }
        }
        else if(GetDistanceToObject(oTarget) > 5.0)
        {
           tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
            if(GetIsTalentValid(tUse))
            {
                // * BK: July 2002: Wrapped up harmful ranged into
                // * a function to make it easier to make global
                // * changes to the decision making process.
                if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
                {
                    return TRUE;
                }
            }
       }
    }
    //MyPrintString("TalentRangedEnemies Failed Exit");
    return FALSE;
}
// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF)
{
    // * bRandom can be overridden by the variable X2_SPELL_RANDOM = 1
    if (bRandom == FALSE)
    {
        bRandom = GetLocalInt(OBJECT_SELF, "X2_SPELL_RANDOM");
    }

    if (bRandom == FALSE)
    {
        return GetCreatureTalentBest(nCategory, nCRMax, oCreature);
    }
    else
    // * randomize it
    {
        return GetCreatureTalentRandom(nCategory, oCreature);
    }
}

/*
  ISSUE 1: The check in this function to use a random ability
  after failing to use best will fail in the following
  case.  The creature is unable to affect the target with the
  spell and has only 1 spell of that type.  This can
  be eliminated with a check in the else to the effect of :

  else if(!CompareLastSpellCast(GetIdFromTalent(tUse)))

  This check was not put in in version 1.0 due to time constraints.
  May cause an AI loop in some Mages with limited spell selection.
*/
int TalentSpellAttack(object oIntruder)
{
    //MyPrintString("Talent Spell Attack Enter");
    talent tUse;
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != GetArea(OBJECT_SELF) || GetPlotFlag(OBJECT_SELF) == TRUE)
    {
        oTarget = GetLastHostileActor();
        //MyPrintString("Last Hostile Attacker: " + ObjectToString(oTarget));
        if(!GetIsObjectValid(oTarget)
            || GetIsDead(oTarget)
            || GetArea(oTarget) != GetArea(OBJECT_SELF)
            || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oTarget = GetNearestSeenEnemy();
            //MyPrintString("Get Nearest Seen or Heard: " + ObjectToString(oTarget));
            if(!GetIsObjectValid(oTarget))
            {
                return FALSE;
            }
        }
    }

    //Attack chosen target
    int bValid = FALSE;
    tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                 GetCRMax());
    if (GetIsTalentValid(tUse) == FALSE)
    {
        //MyPrintString("Discriminant AOE not valid");
        //newdebug("Discriminant AOE not valid");
        // * November 2002
        // * if there are no allies near the target
        // * then feel free to grab an indiscriminant spell instead
        int nFriends = CheckFriendlyFireOnTarget(oIntruder) ;
        if (nFriends <= 1)
        {
            //newdebug("no friendly fire");
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                         GetCRMax());
        }
        if (GetIsTalentValid(tUse) == FALSE)
        {
            //newdebug("SpellAttack: INDiscriminant AOE not valid");
        }
    }
    if(GetIsTalentValid(tUse))
    {
        if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
             && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)) )
        {
            //newdebug("Valid talent found AREA OF EFFECT DISCRIMINANT");
            //MyPrintString("Spell Attack Discriminate Chosen");
            bValid = TRUE;
        }
    }

    if(bValid == FALSE)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED,
                                     GetCRMax());
        if(GetIsTalentValid(tUse))
        {     //  SpawnScriptDebugger();

            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                //MyPrintString("Spell Attack Harmful Ranged Chosen");
                bValid = FALSE; // * Keep bValid false because we have chosen
                                // * to actually cast the spell here.
                return TRUE;
            }

        }
    }



    if(bValid == FALSE)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH,
                                     GetCRMax());

        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
                 && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)) )
            {
                //MyPrintString("Spell Attack Harmful Ranged Chosen");
                bValid = TRUE;
            }
        }
    }

    if (bValid == TRUE)
    {
        if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
        {
            SetLastGenericSpellCast(GetIdFromTalent(tUse));
        }

        // DebugPrintTalentID(tUse);
        //MyPrintString("Talent Spell Attack Successful Exit");

        // Use a final filter to avoid problems
        if (bkTalentFilter(tUse, oTarget) == TRUE)
         return TRUE;
    }

    //MyPrintString("Talent Spell Attack Failed Exit");
    /* JULY 2003
       At this point grab a random spell attack to use, not just "best"
    */
    //SpawnScriptDebugger();
     tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT);
     if (GetIsTalentValid(tUse) == FALSE || bkTalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_RANGED);
     }
     if (GetIsTalentValid(tUse) == FALSE || bkTalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT);
     }
     if (GetIsTalentValid(tUse) == FALSE || bkTalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_TOUCH);
     }

    // * if something was valid, attempt to use that something intelligently
    if (GetIsTalentValid(tUse) == TRUE)
    {
       if (!GetHasSpellEffect(GetIdFromTalent(tUse), oTarget))
       {
         // * so far, so good
         // Use a final filter to avoid problems
         if (bkTalentFilter(tUse, oTarget) == TRUE)
          return TRUE;
       }
    }


    /* End July 11 Mods BK */
    return FALSE;
}


// SUMMON ALLIES
int TalentSummonAllies()
{
    //MyPrintString("TalentSummonAllies Enter");

    if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
    {
        int nCR = GetCRMax();
        talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, nCR);
        if(GetIsTalentValid(tUse))
        {
            location lSelf;
            object oTarget =  FindSingleRangedTarget();
            if(GetIsObjectValid(oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(OBJECT_SELF);
                vector vDirection = vTarget - vSource;
                float fDistance = VectorMagnitude(vDirection) / 2.0f;
                vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
                lSelf = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));
                //lSelf = GetLocation(oTarget);
            }
            else
            {
                lSelf = GetLocation(OBJECT_SELF);
            }
            ClearActions(CLEAR_X0_I0_TALENT_SummonAllies);
            //This is for henchmen wizards, so they do no run off and get killed
            //summoning in allies.
            if(GetIsObjectValid(GetMaster()))
            {
                //MyPrintString("TalentSummonAllies Successful Exit");
                ActionUseTalentAtLocation(tUse, GetLocation(GetMaster()));
            }
            else
            {
                //MyPrintString("TalentSummonAllies Successful Exit");
                ActionUseTalentAtLocation(tUse, lSelf);
            }
            return TRUE;
        }
        //   else
            //MyPrintString("No valid Talent for summoning Allies with Difficulty " + IntToString(GetLocalInt(OBJECT_SELF,"NW_L_COMBATDIFF")));
    }
    //MyPrintString("TalentSummonAllies Failed Exit");
    return FALSE;
}

// HEAL SELF WITH POTIONS AND SPELLS
// * July 14 2003: If bForce=TRUE then force a heal
int TalentHealingSelf(int bForce = FALSE)
{
    // BK: Sep 2002
    // * Moved the racial type filter into here instead of having it
    // * out everyplace that this talent is called
    // * Will have to keep an eye out to see if this breaks anything
    if(GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ABERRATION ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_BEAST ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_VERMIN ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_MAGICAL_BEAST ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_DRAGON    ||
//       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT ||
       GetRacialType(OBJECT_SELF) != 29 || //oozes
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ANIMAL)
    {

        //MyPrintString("TalentHealingSelf Enter");
        int nCurrent = GetCurrentHitPoints(OBJECT_SELF) * 2;
        int nBase = GetMaxHitPoints(OBJECT_SELF);

        if( (nCurrent < nBase) || (bForce == TRUE) )
        {
            talent tUse = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH);
            if(GetIsTalentValid(tUse))
            {
                //MyPrintString("Talent\ Successful Exit");
                bkTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
            else
            {
                tUse = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION);
                if(GetIsTalentValid(tUse))
                {
                    //MyPrintString("TalentHealingSelf Successful Exit");
                    bkTalentFilter(tUse, OBJECT_SELF);
                    return TRUE;
                }
            }
        }
    }
    //MyPrintString("TalentHealingSelf Failed Exit");
    return FALSE;
}

// HEAL ALL ALLIES
// BK: Added an optional parameter for object.
int TalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF)
{
    //MyPrintString("TalentHeal Enter");
    int nCurrent = GetCurrentHitPoints(oTarget);

/*    if (nForce == TRUE)
        nCurrent = nCurrent;
    else
        nCurrent = GetCurrentHitPoints(oTarget)*2;*/
    if(nForce != TRUE)
        nCurrent = nCurrent*2;

    int nBase = GetMaxHitPoints(oTarget);
    //int nCR;

    talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
    /***************REMOVED**********************
    // * New henchmen scripts will be calling this directly
    // * in the determine combat round.
    // * redundant.
    if(GetAssociateHealMaster() || nForce == TRUE)
    {
        tUse = GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
        if(GetIsTalentValid(tUse) && !GetIsDead(GetMaster()))
        {
            //MyPrintString("TalentHeal Successful Exit");
            return TRUE;
        }
    }
    */

    int bValid = GetIsTalentValid(tUse);

    // * BK: force a heal
    if (bValid && oTarget != OBJECT_SELF && GetCurrentHitPoints(oTarget) < nBase)
    {
        bkTalentFilter(tUse, oTarget);
        //MyPrintString("TalentHeal (MASTER) Successful Exit");
        return TRUE;
    }
    // * Heal self
    if(nCurrent < nBase)
    {
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //MyPrintString("TalentHeal Failed Exit");
            return FALSE;
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
        if(GetIsTalentValid(tUse))
        {
            //MyPrintString("TalentHeal Successful Exit");
            bkTalentFilter(tUse, oTarget);
            return TRUE;
        }
    }
    // * change target
    // * find nearest friend to heal.
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
    int i = 0;
    while (GetIsObjectValid(oTarget))
    {
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //MyPrintString("TalentHeal Failed Exit");
        }
        else
        {
            if (nForce == TRUE)
                nCurrent = GetCurrentHitPoints(oTarget);
            else
            nCurrent = GetCurrentHitPoints(oTarget)*2;

            nBase = GetMaxHitPoints(oTarget);

            if(nCurrent < nBase && !GetIsDead(oTarget))
            {
                tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
                if(GetIsTalentValid(tUse))
                {
                    //MyPrintString("TalentHeal Successful Exit");
                    bkTalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        i++;
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, i);
    }

    //MyPrintString("TalentHeal Failed Exit");
    return FALSE;
}

// MELEE ATTACK OTHERS
/*
    ISSUE 1: Talent Melee Attack should set the Last Spell Used to 0 so that melee casters can use
    a single special ability.
*/
int WhirlwindGetNumberOfMeleeAttackers(float fDist=5.0)
{
    object oOne = GetNearestEnemy(OBJECT_SELF, 1);

    if (GetIsObjectValid(oOne) == TRUE)
    {
        object oTwo = GetNearestEnemy(OBJECT_SELF, 2);
        if (GetDistanceToObject(oOne) <= fDist && GetIsObjectValid(oTwo) == TRUE)
        {
            if (GetDistanceToObject(oTwo) <= fDist)
            {
                // * DO NOT WHIRLWIND if any of the targets are "large" or bigger
                // * it seldom works against such large opponents.
                // * Though its okay to use Improved Whirlwind against these targets
                // * October 13 - Brent
                if (GetHasFeat(FEAT_IMPROVED_WHIRLWIND))
                {
                    return TRUE;
                }
                else
                if (GetCreatureSize(oOne) < CREATURE_SIZE_LARGE && GetCreatureSize(oTwo) < CREATURE_SIZE_LARGE)
                {
                    return TRUE;
                }
                return FALSE;
            }
        }
    }
    return FALSE;
}


// * Returns true if the creature's variable
// * set on it rolled against a d100
// * says it is okay to whirlwind.
// * Added this because it got silly to see creatures
// * constantly whirlwinded
int GetOKToWhirl(object oCreature)
{
    int nWhirl = GetLocalInt(oCreature, "X2_WHIRLPERCENT");



    if (nWhirl == 0 || nWhirl == 100)
    {
        return TRUE; // 0 or 100 is 100%
    }
    else
    {
        if (Random(100) + 1 <= nWhirl)
        {
            return TRUE;
        }

    }
    return FALSE;
}


int TalentMeleeAttack(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentMeleeAttack Enter");
    //MyPrintString("Intruder: " + ObjectToString(oIntruder));

    object oTarget = oIntruder;
    if( !GetIsObjectValid(oTarget)
        || GetArea(oTarget) != GetArea(OBJECT_SELF)
        // not clear to me why we check this here...
        // || GetPlotFlag(OBJECT_SELF) == TRUE)
        || GetAssociateState(NW_ASC_MODE_DYING, oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        //MyPrintString("Attempted Attack Target: " + ObjectToString(oTarget));
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget)
           || (!GetObjectSeen(oTarget) && !GetObjectHeard(oTarget))
           || GetArea(oTarget) != GetArea(OBJECT_SELF)
           || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oTarget = GetLastHostileActor();
            //MyPrintString("Last Attacker: " + ObjectToString(oTarget));
            if(!GetIsObjectValid(oTarget)
               || GetIsDead(oTarget)
               || GetArea(oTarget) != GetArea(OBJECT_SELF)
               || GetPlotFlag(OBJECT_SELF) == TRUE)
            {
                oTarget = GetNearestPerceivedEnemy();
                //MyPrintString("Get Nearest Perceived: "                              + ObjectToString(oTarget));
                if(!GetIsObjectValid(oTarget)) {
                    //MyPrintString("TALENT MELEE ATTACK FAILURE EXIT"                                  + " - NO TARGET FOUND");
                    return FALSE;
                }
            }
        }
    }

    //MyPrintString("Selected Target: " + ObjectToString(oTarget));

    talent tUse;

    // If the difference between the attacker's AC and our
    // attack capabilities is greater than 10, we just use
    // a straightforward attack; otherwise, we try our best
    // melee talent.
    int nAC = GetAC(oTarget);
    float fAttack;
    int nAttack = GetHitDice(OBJECT_SELF);

    fAttack = (IntToFloat(nAttack) * 0.75)
        + IntToFloat(GetAbilityModifier(ABILITY_STRENGTH));

    //fAttack = IntToFloat(nAttack) + GetAbilityModifier(ABILITY_STRENGTH);

    int nDiff = nAC - nAttack;
    //MyPrintString("nDiff = " + IntToString(nDiff));

    // * only the playable races have whirlwind attack
    // * Attempt to Use Whirlwind Attack
    int bOkToWhirl = GetOKToWhirl(OBJECT_SELF);
    int bHasFeat = GetHasFeat(FEAT_WHIRLWIND_ATTACK);
    int bPlayableRace = FALSE;
    if (GetIsPlayableRacialType(OBJECT_SELF) || GetTag(OBJECT_SELF) == "x2_hen_valen")
      bPlayableRace = TRUE;

    int bNumberofAttackers = WhirlwindGetNumberOfMeleeAttackers(WHIRL_DISTANCE);
    if (bOkToWhirl == TRUE && bHasFeat == TRUE  &&   bPlayableRace == TRUE
       &&  bNumberofAttackers == TRUE)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        ActionUseFeat(FEAT_WHIRLWIND_ATTACK, OBJECT_SELF);
        return TRUE;
    }
    else
    // * Try using expertise
    if (GetHasFeat(FEAT_EXPERTISE) && nDiff < 12)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        SetActionMode(OBJECT_SELF, ACTION_MODE_EXPERTISE, TRUE);
        WrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    // * Try using expertise
    if (GetHasFeat(FEAT_IMPROVED_EXPERTISE) && nDiff < 15)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        SetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, TRUE);
        WrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    if(nDiff < 10)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        // * this function will call the BK function
        EquipAppropriateWeapons(oTarget);
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_MELEE,
                                     GetCRMax());
        //MyPrintString("Melee Talent Valid = "+ IntToString(GetIsTalentValid(tUse)));
        //MyPrintString("Feat ID = " + IntToString(GetIdFromTalent(tUse)));

        if(GetIsTalentValid(tUse)
           && VerifyDisarm(tUse, oTarget)
           && VerifyCombatMeleeTalent(tUse, oTarget))
        {
            //MyPrintString("TalentMeleeAttack: Talent Use Successful");
            // February 6 2003: Did not have a clear all actions before it
            bkTalentFilter(tUse, oTarget);
            return TRUE;
        }
        else
        {
            //MyPrintString("TalentMeleeAttack Successful Exit");
            WrapperActionAttack(oTarget);
            return TRUE;
        }
    }
    else
    {
        //MyPrintString("TalentMeleeAttack Successful Exit");
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack2);
        // * this function will call the BK function
        EquipAppropriateWeapons(oTarget);
        WrapperActionAttack(oTarget);
        return TRUE;
    }

    //MyPrintString("TALENT MELEE ATTACK FAILURE EXIT - THIS IS VERY BAD");
    return FALSE;
}

// SNEAK ATTACK OTHERS
int TalentSneakAttack()
{
     //MyPrintString("TalentSneakAttack Enter");

     if(GetHasFeat(FEAT_SNEAK_ATTACK))
     {
         object oFriend = GetNearestSeenFriend();
         if (GetIsObjectValid(oFriend)) {
             object oTarget = GetLastHostileActor(oFriend);
             if(GetIsObjectValid(oTarget)
                && !GetIsDead(oTarget)
                && !GetAssociateState(NW_ASC_MODE_DYING, oTarget)) {
                 //MyPrintString("TalentSneakAttack Successful Exit");
                 TalentMeleeAttack(oTarget);
                 return TRUE;
             }
         }
     }
     //MyPrintString("TalentSneakAttack Failed Exit");
     return FALSE;
}

// FLEE COMBAT AND HOSTILES
int TalentFlee(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentFlee Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetNearestSeenEnemy();
            float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                //MyPrintString("TalentFlee Failed Exit");
                return FALSE;
            }
        }
    }
    //MyPrintString("TalentFlee Successful Exit");
    ClearActions(CLEAR_X0_I0_TALENT_TalentFlee);
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oTarget, TRUE, 10.0f);
    DelayCommand(4.0, ClearActions(CLEAR_X0_I0_TALENT_TalentFlee2));
    return TRUE;
}

// TURN UNDEAD
int TalentUseTurning()
{
    //MyPrintString("TalentUseTurning Enter");
    int nCount;
    if(GetHasFeat(FEAT_TURN_UNDEAD))
    {
        object oUndead = GetNearestPerceivedEnemy();
        int nHD = GetHitDice(oUndead);
        if(GetHasEffect(EFFECT_TYPE_TURNED, oUndead)
           || GetHitDice(OBJECT_SELF) <= nHD)
        {
            return FALSE;
        }
        int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER)
            + GetHasFeat(FEAT_EARTH_DOMAIN_POWER)
            + GetHasFeat(FEAT_FIRE_DOMAIN_POWER)
            + GetHasFeat(FEAT_WATER_DOMAIN_POWER);

        int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER)
            + GetHasFeat(FEAT_ANIMAL_COMPANION);
        int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
        int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER)
            + GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
            + GetHasFeat(854);             // planar turning

        if(nElemental == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_ELEMENTAL);

        if(nVermin == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_VERMIN);

        if(nOutsider == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_OUTSIDER);

        if(nConstructs == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_CONSTRUCT);

        nCount += GetRacialTypeCount(RACIAL_TYPE_UNDEAD);

        if(nCount > 0)
        {
            //MyPrintString("TalentUseTurning Successful Exit");
            ClearActions(CLEAR_X0_I0_TALENT_UseTurning);
            //ActionCastSpellAtObject(SPELLABILITY_TURN_UNDEAD, OBJECT_SELF);
            ActionUseFeat(FEAT_TURN_UNDEAD, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentUseTurning Failed Exit");
    return FALSE;
}

// ACTIVATE AURAS
int TalentPersistentAbilities()
{
    //MyPrintString("TalentPersistentAbilities Enter");
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, GetCRMax());
    int nSpellID;
    if(GetIsTalentValid(tUse))
    {
        nSpellID = GetIdFromTalent(tUse);
        if(!GetHasSpellEffect(nSpellID))
        {
            //MyPrintString("TalentPersistentAbilities Successful Exit");
            bkTalentFilter(tUse, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentPersistentAbilities Failed Exit");
    return FALSE;
}

// FAST BUFF SELF
// * Dec 19 2002: Added the instant parameter so this could be used for 'legal' spellcasting as well
int TalentAdvancedBuff(float fDistance, int bInstant = TRUE)
{
    //MyPrintString("TalentAdvancedBuff Enter");
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if(GetIsObjectValid(oPC))
    {
        if(GetDistanceToObject(oPC) <= fDistance)
        {
            if(!GetIsFighting(OBJECT_SELF))
            {
                ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
                //Combat Protections
                if(GetHasSpell(SPELL_PREMONITION) && !GetHasSpellEffect(SPELL_PREMONITION))
                {
                    ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_GREATER_STONESKIN)&& !GetHasSpellEffect(SPELL_GREATER_STONESKIN))
                {
                    ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, 0, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_STONESKIN)&& !GetHasSpellEffect(SPELL_STONESKIN))
                {
                    ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Visage Protections
                if(GetHasSpell(SPELL_SHADOW_SHIELD)&& !GetHasSpellEffect(SPELL_SHADOW_SHIELD))
                {
                    ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_ETHEREAL_VISAGE)&& !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE))
                {
                    ActionCastSpellAtObject(SPELL_ETHEREAL_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_GHOSTLY_VISAGE)&& !GetHasSpellEffect(SPELL_GHOSTLY_VISAGE))
                {
                    ActionCastSpellAtObject(SPELL_GHOSTLY_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Mantle Protections
                if(GetHasSpell(SPELL_GREATER_SPELL_MANTLE)&& !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE))
                {
                    ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SPELL_MANTLE)&& !GetHasSpellEffect(SPELL_SPELL_MANTLE))
                {
                    ActionCastSpellAtObject(SPELL_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_LESSER_SPELL_BREACH)&& !GetHasSpellEffect(SPELL_LESSER_SPELL_BREACH))
                {
                    ActionCastSpellAtObject(SPELL_LESSER_SPELL_BREACH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                // Globes
                if(GetHasSpell(SPELL_GLOBE_OF_INVULNERABILITY)&& !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY))
                {
                    ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_MINOR_GLOBE_OF_INVULNERABILITY)&& !GetHasSpellEffect(SPELL_MINOR_GLOBE_OF_INVULNERABILITY))
                {
                    ActionCastSpellAtObject(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Misc Protections
                if(GetHasSpell(SPELL_ELEMENTAL_SHIELD)&& !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD))
                {
                    ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if (GetHasSpell(SPELL_MESTILS_ACID_SHEATH)&& !GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH))
                {
                    ActionCastSpellAtObject(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if (GetHasSpell(SPELL_DEATH_ARMOR)&& !GetHasSpellEffect(SPELL_DEATH_ARMOR))
                {
                    ActionCastSpellAtObject(SPELL_DEATH_ARMOR, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Elemental Protections
                if(GetHasSpell(SPELL_PROTECTION_FROM_ELEMENTS)&& !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS))
                {
                    ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ELEMENTS, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_RESIST_ELEMENTS)&& !GetHasSpellEffect(SPELL_RESIST_ELEMENTS))
                {
                    ActionCastSpellAtObject(SPELL_RESIST_ELEMENTS, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_ENDURE_ELEMENTS)&& !GetHasSpellEffect(SPELL_ENDURE_ELEMENTS))
                {
                    ActionCastSpellAtObject(SPELL_ENDURE_ELEMENTS, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Mental Protections
                if(GetHasSpell(SPELL_MIND_BLANK)&& !GetHasSpellEffect(SPELL_MIND_BLANK))
                {
                    ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_LESSER_MIND_BLANK)&& !GetHasSpellEffect(SPELL_LESSER_MIND_BLANK))
                {
                    ActionCastSpellAtObject(SPELL_LESSER_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_CLARITY)&& !GetHasSpellEffect(SPELL_CLARITY))
                {
                    ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Summon Ally
                if(GetHasSpell(SPELL_BLACK_BLADE_OF_DISASTER))
                {
                    ActionCastSpellAtLocation(SPELL_BLACK_BLADE_OF_DISASTER, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_IX))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IX, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VIII))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VIII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VII))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VI))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VI, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_V))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_V, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_IV))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IV, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_III))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_III, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_II))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_II, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_I))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_I, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //MyPrintString("TalentAdvancedBuff Successful Exit");
                return TRUE;
            }
        }
    }
    //MyPrintString("TalentAdvancedBuff Failed Exit");
    return FALSE;
}

// USE POTIONS
int TalentBuffSelf()
{
    //MyPrintString("TalentBuffSelf Enter");
    //int bValid = FALSE;
    int nCRMax = GetCRMax();
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION,
                                 nCRMax);
    if(!GetIsTalentValid(tUse)) {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION,
                                     nCRMax);
        if(!GetIsTalentValid(tUse))
            return FALSE;
    }
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);

    if(nType == TALENT_TYPE_SPELL && !GetHasSpellEffect(nIndex)) {
        //MyPrintString("TalentBuffSelf Successful Exit");
        bkTalentFilter(tUse, OBJECT_SELF);
        return TRUE;
    }

    //MyPrintString("TalentBuffSelf Failed Exit");
    return FALSE;
}

// USE SPELLS TO DEFEAT INVISIBLE CREATURES
// THIS TALENT IS NOT USED
int TalentSeeInvisible()
{
    //MyPrintString("TalentSeeInvisible Enter");
    int nSpell;
    int bValid = FALSE;
    if(GetHasSpell(SPELL_TRUE_SEEING))
    {
        nSpell = SPELL_TRUE_SEEING;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_INVISIBILITY_PURGE))
    {
        nSpell = SPELL_INVISIBILITY_PURGE;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_SEE_INVISIBILITY))
    {
        nSpell = SPELL_SEE_INVISIBILITY;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE))
    {
        nSpell = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
        bValid = TRUE;
    }
    if(bValid == TRUE)
    {
        //MyPrintString("TalentSeeInvisible Successful Exit");
        ClearActions(CLEAR_X0_I0_TALENT_SeeInvisible);
        ActionCastSpellAtObject(nSpell, OBJECT_SELF);
    }
    //MyPrintString("TalentSeeInvisible Failed Exit");
    return bValid;
}

// Utility function for TalentCureCondition
// Checks to see if the creature has the given condition in the
// given condition value.
// To use, you must first calculate the nCurrentConditions value
// with GetCurrentNegativeConditions.
// The value of nCondition can be any of the COND_* constants
// declared in x0_i0_talent.
int GetHasNegativeCondition(int nCondition, int nCurrentConditions)
{
    return (nCurrentConditions & nCondition);
}

// Utility function for TalentCureCondition
// Returns an integer with bitwise flags set that represent the
// current negative conditions on the creature.
// To be used with GetHasNegativeCondition.
int GetCurrentNegativeConditions(object oCreature)
{
    int nSum = 0;
    int nType=-1;
    effect eEffect = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eEffect)) {
        nType = GetEffectType(eEffect);
        switch (nType) {
        case EFFECT_TYPE_DISEASE:           nSum = nSum | COND_DISEASE; break;
        case EFFECT_TYPE_POISON:            nSum = nSum | COND_POISON; break;
        case EFFECT_TYPE_CURSE:             nSum = nSum | COND_CURSE; break;
        case EFFECT_TYPE_NEGATIVELEVEL:     nSum = nSum | COND_DRAINED; break;
        case EFFECT_TYPE_ABILITY_DECREASE:  nSum = nSum | COND_ABILITY; break;
        case EFFECT_TYPE_BLINDNESS:
        case EFFECT_TYPE_DEAF:              nSum = nSum | COND_BLINDDEAF; break;
        }
        eEffect = GetNextEffect(oCreature);
    }
    return nSum;
}

// CURE DISEASE, POISON ETC
int TalentCureCondition()
{
    //MyPrintString("TalentCureCondition Enter");
    int nSum;
    int nCond;
    int nSpell;
    effect eEffect;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget)) {
            nSpell = 0;
            nSum = GetCurrentNegativeConditions(oTarget);
            if (nSum != 0) {
                // friend has negative effects -- try and heal them

                // These effects will be healed in reverse order if
                // we have the spells for them and don't have
                // restoration.
                if (GetHasNegativeCondition(COND_POISON, nSum)) {
                    nCond++;
                    if (GetHasSpell(SPELL_NEUTRALIZE_POISON))
                        nSpell = SPELL_NEUTRALIZE_POISON;
                }
                if (GetHasNegativeCondition(COND_DISEASE, nSum)) {
                    nCond++;
                    if (GetHasSpell(SPELL_REMOVE_DISEASE))
                        nSpell = SPELL_REMOVE_DISEASE;
                }
                if (GetHasNegativeCondition(COND_CURSE, nSum)) {
                    nCond++;
                    if (GetHasSpell(SPELL_REMOVE_CURSE))
                        nSpell = SPELL_REMOVE_CURSE;
                }
                if (GetHasNegativeCondition(COND_BLINDDEAF, nSum)) {
                    nCond++;
                    if (GetHasSpell(SPELL_REMOVE_BLINDNESS_AND_DEAFNESS))
                        nSpell = SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
                }

                // For the conditions that can only be cured by
                // restoration, we add 2
                if (GetHasNegativeCondition(COND_DRAINED, nSum)) {
                    nCond += 2;
                }
                if (GetHasNegativeCondition(COND_ABILITY, nSum)) {
                    nCond += 2;
                }

                // If we have more than one condition or a condition
                // that can only be cured by restoration, try one of
                // those spells first if we have them.
                if (nCond > 1) {
                    if (GetHasSpell(SPELL_GREATER_RESTORATION)) {
                        nSpell = SPELL_GREATER_RESTORATION;
                    } else if (GetHasSpell(SPELL_RESTORATION)) {
                        nSpell = SPELL_RESTORATION;
                    } else if (GetHasSpell(SPELL_LESSER_RESTORATION)) {
                        nSpell = SPELL_LESSER_RESTORATION;
                    }
                }

                if(nSpell != 0) {
                    //MyPrintString("TalentCureCondition Successful Exit");
                    ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
                    ActionCastSpellAtObject(nSpell, oTarget);
                    return TRUE;
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    }

    //MyPrintString("TalentCureCondition Failed Exit");
    return FALSE;
}

// DRAGON COMBAT
// * February 2003: Cut the melee interaction (BK)
int TalentDragonCombat(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentDragonCombat Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetLastHostileActor();
            if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
            {
                oTarget = GetNearestPerceivedEnemy();
                if(!GetIsObjectValid(oTarget))
                {
                    return FALSE;
                }
            }
        }
    }
    int nCnt = GetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH");
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_DRAGONS_BREATH, GetCRMax());
    //SpeakString(IntToString(nCnt));
    if(GetIsTalentValid(tUse) && nCnt >= 2)
    {
        //MyPrintString("TalentDragonCombat Successful Exit");
        bkTalentFilter(tUse, oTarget);
        nCnt = 0;
        SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);
        return TRUE;
    }
    // * breath weapons only happen every 3 rounds
    nCnt++;
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);

    //MyPrintString("TalentDragonCombat Failed Exit");
    //SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);
    return FALSE;
}

// BARD SONG
// * July 15 2003: Improving so its more likely
// * to work with non creature wizard designed creatures
// * GZ: Capped bardsong at level 20 so we don't overflow into
//       other feats
int TalentBardSong()
{
    int iMyBardFeat;
    //MyPrintString("TalentBardSong Enter");
    int iMyBardLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
    if (iMyBardLevel < 1)
    {
        return FALSE;
    }

    //BARD SONG CONSTANT PENDING
    if ( iMyBardLevel == 1 )
    {
        iMyBardFeat = 257;
    }
    else
    {
        if (iMyBardLevel >20)
        {
            iMyBardLevel = 20;
        }
        iMyBardFeat = 353 + iMyBardLevel;
    }

    if(!GetHasSpellEffect(411))
    {
        if(GetHasFeat(iMyBardFeat) == TRUE)
        {
            //MyPrintString("TalentBardSong Successful Exit");
            ClearActions(CLEAR_X0_I0_TALENT_BardSong);
            ActionUseFeat(iMyBardFeat, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentBardSong Failed Exit");
    return FALSE;
}

//**********************************
//**********************************
//**********************************
// VERSION 2.0 TALENTS
//**********************************
//**********************************
//**********************************

// ADVANCED PROTECT SELF Talent 2.0
// This will use the class specific defensive spells first and
// leave the rest for the normal defensive AI
int TalentAdvancedProtectSelf()
{
    //MyPrintString("TalentAdvancedProtectSelf Enter");

    struct sEnemies sCount = DetermineEnemies();
    int bValid = FALSE;
    int nCnt;
    string sClass = GetMostDangerousClass(sCount);
    talent tUse = StartProtectionLoop();
    while(GetIsTalentValid(tUse) && nCnt < 10)
    {
        //MyPrintString("TalentAdvancedProtectSelf Search Self");
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                     GetCRMax());
        if(GetIsTalentValid(tUse)
           && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
        {
            bValid = TRUE;
            nCnt = 11;
        } else {
            //MyPrintString(" TalentAdvancedProtectSelfSearch Single");
            tUse =
                GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                      GetCRMax());
            if(GetIsTalentValid(tUse)
               && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
            {
                bValid = TRUE;
                nCnt = 11;
            } else {
                //MyPrintString("TalentAdvancedProtectSelf Search Area");
                tUse =
                    GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                          GetCRMax());
                if(GetIsTalentValid(tUse)
                   && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
                {
                    bValid = TRUE;
                    nCnt = 11;
                }
            }
        }
        nCnt++;
    }

    if(bValid == TRUE)
    {
        int nType = GetTypeFromTalent(tUse);
        int nIndex = GetIdFromTalent(tUse);

        if(nType == TALENT_TYPE_SPELL)
        {
            if(!GetHasSpellEffect(nIndex)) {
                //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
                bkTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else if(nType == TALENT_TYPE_FEAT) {
            if(!GetHasFeatEffect(nIndex)) {
                //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
                bkTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else {
            //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
            bkTalentFilter(tUse, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentAdvancedProtectSelf Failed Exit");
    return FALSE;
}

// Cast a spell mantle or globe of invulnerability protection on
// yourself.
int TalentSelfProtectionMantleOrGlobe()
{
    //Mantle Protections
    if (TrySpell(SPELL_GREATER_SPELL_MANTLE))
        return TRUE;

    if (TrySpell(SPELL_SPELL_MANTLE))
        return TRUE;

    if (TrySpell(SPELL_GLOBE_OF_INVULNERABILITY))
        return TRUE;

    if (TrySpell(SPELL_MINOR_GLOBE_OF_INVULNERABILITY))
        return TRUE;

    return FALSE;
}

// This function simply attempts to get the best protective
// talent that the caller has, the protective talents as
// follows:
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
talent StartProtectionLoop()
{
    talent tUse;
    int nCRMax = GetCRMax();
    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                 nCRMax);
    return tUse;
}



/* void main() {} /* */
