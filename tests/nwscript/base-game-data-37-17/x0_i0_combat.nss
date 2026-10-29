//:://////////////////////////////////////////////////
//:: X0_I0_COMBAT
/*
  This is the library for the XP1-specific modified
  combat AI.

*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/19/2003
//:://////////////////////////////////////////////////

#include "x0_i0_talent"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Special combat behavior flags

const string sCombatCondVarname = "X0_COMBAT_CONDITION";

const int X0_COMBAT_FLAG_RANGED            = 0x00000001;
const int X0_COMBAT_FLAG_DEFENSIVE         = 0x00000002;
const int X0_COMBAT_FLAG_COWARDLY          = 0x00000004;
const int X0_COMBAT_FLAG_AMBUSHER          = 0x00000008;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Determine whether the specified X0_COMBAT_FLAG_* is set on the target
int GetCombatCondition(int nCond, object oTarget=OBJECT_SELF);

// Set one of the X0_COMBAT_FLAG_* values on the target
void SetCombatCondition(int nCond, int bValid=TRUE, object oTarget=OBJECT_SELF);

// This function checks for the special tactics flags and
// chooses tactics appropriately for each.
// Currently available:
// X0_COMBAT_FLAG_{RANGED,DEFENSIVE,COWARDLY,AMBUSHER}
//
// Note that only one special tactics flag should be applied
// to a single creature for the most part!
//
// Returns TRUE on success, FALSE on failure.
int SpecialTactics(object oTarget);

// Special tactics for ranged fighters.
// The caller will attempt to stay in ranged distance and
// will make use of active ranged combat feats (Rapid Shot
// and Called Shot).
// If the target is too close and is not currently attacking
// the caller, the caller will instead try to find a ranged
// enemy to attack. If that fails, the caller will try to run
// away from the target to a ranged distance.
// This will fall through and return FALSE after three
// consecutive attempts to get away from an opponent within
// melee distance, at which point the caller will use normal
// tactics until they are again at a ranged distance from
// their target.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsRanged(object oTarget);

// Special tactics for ambushers.
// Ambushers will first attempt to get out of sight
// of their target if currently visible to that target.
// If not visible to the target, they will use any invisibility/
// hide powers they have.
// Once hidden, they will then attempt to attack the target using
// standard AI.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsAmbusher(object oTarget);

// Special tactics for cowardly creatures
// Cowards act as follows:
// - if you and your friends outnumber the enemy by 6:1 or
//   by more than 10, fall through to normal combat.
// - if you are currently being attacked by a melee attacker,
//   fight defensively (see SpecialTacticsDefensive).
// - if there is a "NW_SAFE" waypoint in your area that is
//   out of sight of the target, run to it.
// - otherwise, run away randomly from the target.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsCowardly(object oTarget);

// Special tactics for defensive fighters
// This will attempt to use the active defensive feats such as
// Knockdown and Expertise, and also use Parry mode, when these
// are appropriate. Falls through to standard combat on failure.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsDefensive(object oTarget);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Determine whether the specified X0_COMBAT_FLAG_* is set on the target
int GetCombatCondition(int nCond, object oTarget=OBJECT_SELF)
{
    return (GetLocalInt(oTarget, sCombatCondVarname) & nCond);
}

// Set one of the X0_COMBAT_FLAG_* values on the target
void SetCombatCondition(int nCond, int bValid=TRUE, object oTarget=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oTarget, sCombatCondVarname);
    if (bValid) {
        SetLocalInt(oTarget, sCombatCondVarname, nCurrentCond | nCond);
    } else {
        SetLocalInt(oTarget, sCombatCondVarname, nCurrentCond & ~nCond);
    }
}


// This function checks for the special tactics flags and
// chooses tactics appropriately for each.
// Returns TRUE on success, FALSE on failure.
int SpecialTactics(object oTarget)
{
    if (GetCombatCondition(X0_COMBAT_FLAG_COWARDLY)
        && SpecialTacticsCowardly(oTarget))
        return TRUE;

    if (GetCombatCondition(X0_COMBAT_FLAG_AMBUSHER)
        && SpecialTacticsAmbusher(oTarget))
        return TRUE;

    if (GetCombatCondition(X0_COMBAT_FLAG_RANGED)
        && SpecialTacticsRanged(oTarget))
        return TRUE;

    if (GetCombatCondition(X0_COMBAT_FLAG_DEFENSIVE)
        && SpecialTacticsDefensive(oTarget))
        return TRUE;

    return FALSE;

}

// Special tactics for ranged fighters.
// The caller will attempt to stay in ranged distance and
// will make use of active ranged combat feats (Rapid Shot
// and Called Shot).
// If the target is too close and is not currently attacking
// the caller, the caller will instead try to find a ranged
// enemy to attack. If that fails, the caller will try to run
// away from the target to a ranged distance.
// This will fall through and return FALSE after three
// consecutive attempts to get away from an opponent within
// melee distance, at which point the caller will use normal
// tactics until they are again at a ranged distance from
// their target.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsRanged(object oTarget)
{
    // // MyPrintString("ranged combat");

    if (GetDistanceToObject(oTarget) < 5.0) {
        // too close to our target! move away.
        // MyPrintString("Too close to " + GetName(oTarget));
        int bFoundBetterTarget = FALSE;
        if (GetAttackTarget(oTarget) != OBJECT_SELF) {
            // they aren't attacking us, so let's check if
            // we have a ranged enemy
            object oRangedEnemy = FindSingleRangedTarget();
            if (GetIsObjectValid(oRangedEnemy) && oRangedEnemy != oTarget) {
                oTarget = oRangedEnemy;
                bFoundBetterTarget = TRUE;
                // MyPrintString("Found better target: " + GetName(oTarget));
            }
        }

        if (!bFoundBetterTarget) {
            // prevent constant attempts to run away
            int nAttempts = GetLocalInt(OBJECT_SELF, "X0_MOVE_AWAY_ATTEMPTS");
            if (nAttempts < 3) {
                // MyPrintString("Trying to move away");
                ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsRanged1);
                ActionMoveAwayFromObject(oTarget, TRUE, 10.0);
                SetLocalInt(OBJECT_SELF, "X0_MOVE_AWAY_ATTEMPTS", nAttempts++);
            } else {
                // fall through to regular combat until
                // we're far enough away again
                // MyPrintString("Tried to move away too many times, giving up");
                return FALSE;
            }
        }
    } else {
        // MyPrintString("far enough away from " + GetName(oTarget));
        SetLocalInt(OBJECT_SELF, "X0_MOVE_AWAY_ATTEMPTS", 0);
    }

    if (!GetIsWieldingRanged(OBJECT_SELF)) {
        // MyPrintString("Not wielding ranged! Switching");
        ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsRanged2);
        ActionEquipMostDamagingRanged();
    }

    // Occasionally use active feats
    int nRand = Random(5);
    int nFeat = -1;
    if (nRand == 0 && GetHasFeat(FEAT_CALLED_SHOT)) {
        // try called shot if we have it
        nFeat = FEAT_CALLED_SHOT;
    } else if (nRand == 1 && GetHasFeat(FEAT_RAPID_SHOT)
               && MatchNormalBow(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,
                                               OBJECT_SELF))) {
        nFeat = FEAT_RAPID_SHOT;
    }

    if (nFeat != -1) {
        ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsRanged3);
        ActionUseFeat(nFeat, oTarget);
        return TRUE;
    }

    // If we fall through, just make a standard attack
    WrapperActionAttack(oTarget);
    return TRUE;
}

// Special tactics for ambushers.
// Ambushers will first attempt to get out of sight
// of their target if currently visible to that target.
// If not visible to the target, they will use any invisibility/
// hide powers they have.
// Once hidden, they will then attempt to attack the target using
// standard AI.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsAmbusher(object oTarget)
{
    int bIsSeen = GetObjectSeen(OBJECT_SELF, oTarget);
    int bTried = GetLocalInt(OBJECT_SELF, "X0_TRIED_TO_HIDE");
    if ( bIsSeen && !bTried) {
        ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsAmbusher);

        // get out of sight
        ActionMoveAwayFromObject(oTarget, TRUE, 30.0);

        // use any hiding talents we have
        if (GetHasSkill(SKILL_HIDE)) {
            ActionUseSkill(SKILL_HIDE, OBJECT_SELF);
        }

        if (GetHasSkill(SKILL_MOVE_SILENTLY)) {
            ActionUseSkill(SKILL_MOVE_SILENTLY, OBJECT_SELF);
        }

        if (!TrySpell(SPELL_IMPROVED_INVISIBILITY)) {
            TrySpell(SPELL_INVISIBILITY);
        }

        SetLocalInt(OBJECT_SELF, "X0_TRIED_TO_HIDE", TRUE);
        return TRUE;
    }

    if (!bIsSeen && GetDistanceToObject(oTarget) < 10.0) {
        // we successfully hid, so let's get ready to try it again
        SetLocalInt(OBJECT_SELF, "X0_TRIED_TO_HIDE", FALSE);
    }

    // If we're hidden and close by, just attack normally
    return FALSE;
}


// Special tactics for cowardly creatures
// Cowards act as follows:
// - if you and your friends outnumber the enemy by 6:1 or
//   by more than 10, fall through to normal combat.
// - if you are currently being attacked by a melee attacker,
//   fight defensively (see SpecialTacticsDefensive).
// - if there is a "NW_SAFE" waypoint in your area that is
//   out of sight of the target, run to it.
// - otherwise, run away randomly from the target.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsCowardly(object oTarget)
{
    // See what our overall situation looks like
    struct sSituation sitCurrent = CountEnemiesAndAllies();
    if ( ((sitCurrent.ENEMY_NUM + 10) <= (sitCurrent.ALLY_NUM + 1))
         ||
         ( (sitCurrent.ENEMY_NUM * 6) <= (sitCurrent.ALLY_NUM + 1))) {
        // me and my pals really outnumber the enemy
        // MyPrintString("Cowardly, but we outnumber the enemy");
        // MyPrintString("Enemies: " + IntToString(sitCurrent.ENEMY_NUM));
        // MyPrintString("Allies: " + IntToString(sitCurrent.ALLY_NUM));
        return FALSE;
    }

    // Are we pinned down by a melee attacker?
    object oLastEnemy = GetLastHostileActor();
    if ( GetIsObjectValid(oLastEnemy)
         && GetIsMeleeAttacker(oLastEnemy)
         && GetAttackTarget(oLastEnemy)==OBJECT_SELF) {
        // we're being attacked, so try and hold 'em off
        // MyPrintString("Under melee attack by " + GetName(oLastEnemy));
        return SpecialTacticsDefensive(oLastEnemy);
    }

    // Try and find someplace safe to run to
    int nNth = 1;
    object oSafe = GetNearestObjectByTag("NW_SAFE", OBJECT_SELF, nNth);
    while (GetIsObjectValid(oSafe) && GetObjectSeen(oSafe, oTarget)) {
        nNth++;
        oSafe = GetNearestObjectByTag("NW_SAFE", OBJECT_SELF, nNth);
    }
    if (GetIsObjectValid(oSafe)) {
        // MyPrintString("Running to safepoint");
        ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsCowardly1);
        ActionMoveToObject(oSafe);
        return TRUE;
    }

    // Failed, just try and run anywhere
    // MyPrintString("Running away anywhere");
    ClearActions(CLEAR_X0_I0_COMBAT_SpecialTacticsCowardly2);
    ActionMoveAwayFromObject(oTarget, TRUE, 30.0);
    return TRUE;
}


// Special tactics for defensive fighters
// This will attempt to use the active defensive feats such as
// Knockdown and Expertise, and also use Parry mode, when these
// are appropriate. Falls through to standard combat on failure.
// Returns TRUE on success, FALSE on failure.
int SpecialTacticsDefensive(object oTarget)
{
    int nFeat = -1;
    int nSkill = -1;


    // use knockdown occasionally if we have it
    // and the target is not immune
    int nRand = Random(4);
    if (nRand == 0) {
        int nMySize = GetCreatureSize(OBJECT_SELF);
        if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN)) {
            nFeat = FEAT_IMPROVED_KNOCKDOWN;
            nMySize++;
        } else if (GetHasFeat(FEAT_KNOCKDOWN)) {
            nFeat = FEAT_KNOCKDOWN;
        }

        // prevent silly use of knockdown on immune or
        // too-large targets
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)
            || GetCreatureSize(oTarget) > nMySize+1 )
            nFeat = -1;
    }

    // We use improved expertise if BAB+10 > opponent AC
    // We use expertise if BaseAttackBonus+15 > opponent AC
    // If we have both, use both.
    //int tempExpertise = 389;
    //int tempImprovedExpertise = 390;
    int bHasExpertise = GetHasFeat(FEAT_EXPERTISE);
    int bHasImprovedExpertise = GetHasFeat(FEAT_IMPROVED_EXPERTISE);
    if (nFeat == -1 && (bHasExpertise || bHasImprovedExpertise)) {
        int nBAB = GetBaseAttackBonus(OBJECT_SELF);
        int nAC = GetAC(oTarget);
        if (nBAB + 15 > nAC) {
            // we can use either
            if (nRand < 2) {
                nFeat = FEAT_IMPROVED_EXPERTISE;
            } else {
                nFeat = FEAT_EXPERTISE;
            }
        } else if (nBAB + 10 > nAC) {
            // only use improved
            nFeat = FEAT_IMPROVED_EXPERTISE;
        }
    }

    if (nFeat != -1) {
        // MyPrintString("Defensive combat: Using feat: " + IntToString(nFeat));
        bkEquipAppropriateWeapons(oTarget);
        ActionUseFeat(nFeat, oTarget);
        return TRUE;
    }

    // Only use parry on an active melee attacker, and
    // only if our parry skill > our AC - 10
    // JE, Apr.14,2004: Bugfix to make this actually work. Thanks to the message board
    // members who investigated this.
    object oEnemy = GetLastHostileActor();
    if (GetIsObjectValid(oEnemy)
        && GetAttackTarget(oEnemy) == OBJECT_SELF
        && GetIsMeleeAttacker(oEnemy)
        && oEnemy==oTarget)
    {
        int nParrySkill = GetSkillRank(SKILL_PARRY);
        int nAC = GetAC(OBJECT_SELF);
        if (nParrySkill > (nAC - 10) ) {
            // MyPrintString("Defensive combat: Using parry skill ");
            bkEquipAppropriateWeapons(oTarget);
            //ActionUseSkill(SKILL_PARRY, oTarget);
            SetActionMode(OBJECT_SELF, ACTION_MODE_PARRY, TRUE);
            ActionAttack(oTarget);
            return TRUE;
        }
    }

    // MyPrintString("falling through to normal tactics");
    // MyPrintString("last hostile: " + GetName(oEnemy));
    // MyPrintString("their attack target: " + GetName(GetAttackTarget(oEnemy)));

    return FALSE;
}

