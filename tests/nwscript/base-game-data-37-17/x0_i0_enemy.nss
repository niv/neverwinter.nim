//:://////////////////////////////////////////////////
//:: X0_I0_ENEMY
/*
  Library with functions for finding and identifying
  enemies.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/21/2003
//:: Modified: Oct 23, Georg Z: Added Oozes
//:://////////////////////////////////////////////////

#include "x0_i0_match"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// melee distance
const float MELEE_DISTANCE = 3.0;


//GENERIC STRUCTURES

// This structure is used to represent the number and type of
// enemies that a creature is facing, divided into four main
// categories: fighters, clerics, mages, monsters.
struct sEnemies
{
    int FIGHTERS;
    int FIGHTER_LEVELS;
    int CLERICS;
    int CLERIC_LEVELS;
    int MAGES;
    int MAGE_LEVELS;
    int MONSTERS;
    int MONTERS_LEVELS;
    int TOTAL;
    int TOTAL_LEVELS;
};

// This structure is used to collect the number of enemies and
// allies in a situation and their respective challenge rating.
struct sSituation
{
    int ENEMY_NUM;
    int ALLY_NUM;
    int ENEMY_CR;
    int ALLY_CR;
};


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Gets the nearest enemy.
object GetNearestEnemy(object oSource=OBJECT_SELF, int nNth = 1);

//Returns the nearest object that can be seen, then checks for
//the nearest heard target.
// You may pass in any of the CREATURE_TYPE_* constants
// used in GetNearestCreature as nCriteriaType, with
// corresponding values for nCriteriaValue, to get a more
// specific result.
// KLUDGE: Huge default values used here for nCriteriaType/Value
//         because -1 cannot be passed in at the moment due to a
//         compiler bug. Should be changed to -1 once that's fixed.
object GetNearestPerceivedEnemy(object oSource=OBJECT_SELF, int nNth = 1, int nCriteriaType=1000, int nCriteriaValue=1000);

// Get the nearest seen enemy. This will NOT return an enemy that is
// heard but not seen; for that, use GetNearestPerceivedEnemy instead.
object GetNearestSeenEnemy(object oSource=OBJECT_SELF, int nNth = 1);

//Returns the nearest object that can be seen, then checks for
//the nearest heard target.
// Now just a wrapper around GetNearestPerceivedEnemy.
object GetNearestSeenOrHeardEnemy(object oSource=OBJECT_SELF, int nNth = 1);

// Get the nearest seen friend.
object GetNearestSeenFriend(object oSource=OBJECT_SELF, int nNth=1);

// Count the number of enemies and allies in a given radius
// and their respective total CRs (slightly rounded, since
// we use integers instead of floats).
// This returns a "struct sSituation" type value. To use, do
// something like the following:
//
//   struct sSituation sitCurr = CountEnemiesAndAllies(20.0);
//   int nNumEnemies = sitCurr.ENEMY_NUM;
//   int nNumAllies = sitCurr.ALLY_NUM;
//   int nAllyCR = sitCurr.ALLY_CR;
//   int nEnemyCR = sitCurr.ENEMY_CR;
struct sSituation CountEnemiesAndAllies(float fRadius=20.0, object oSource=OBJECT_SELF);

// Categorizes the enemies the creature is facing
// into four types: fighters, clerics, mages, monsters.
// Determines the number of HD of each type as well
// as total number of enemies and total enemy HD.
struct sEnemies DetermineEnemies();

//    Use the four archetypes to determine the
//    most dangerous group type facing the NPC
string GetMostDangerousClass(struct sEnemies sCount);

// Returns TRUE if the given opponent is a melee
// attacker, meaning they are in melee range and
// equipped with a melee weapon.
int GetIsMeleeAttacker(object oAttacker);

// Returns TRUE if the given opponent is a ranged
// attacker, meaning they are outside melee range.
int GetIsRangedAttacker(object oAttacker);

// Returns TRUE if the given opponent is wielding a
// ranged weapon.
int GetIsWieldingRanged(object oAttacker);

//Calculate the number of people currently attacking self.
int GetNumberOfMeleeAttackers();

//Calculate the number of people attacking self from beyond 5m
int GetNumberOfRangedAttackers();

//Determine the number of targets within 20m that are of the
//specified racial-type
int GetRacialTypeCount(int nRacial_Type);

//Returns the number of persons who are considered friendly to the target.
int CheckFriendlyFireOnTarget(object oTarget, float fDistance = 5.0);

//Returns the number of enemies on a target.
int CheckEnemyGroupingOnTarget(object oTarget, float fDistance = 5.0);

//Find a single target who is an enemy with 30m of self
object FindSingleRangedTarget();


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Gets the nearest enemy.
object GetNearestEnemy(object oSource=OBJECT_SELF, int nNth = 1)
{
    return GetNearestCreature(CREATURE_TYPE_REPUTATION,
                              REPUTATION_TYPE_ENEMY,
                              oSource, nNth);
}


// Returns the nearest object that can be seen, then checks for
// the nearest heard target.
// You may pass in any of the CREATURE_TYPE_* constants
// used in GetNearestCreature as nCriteriaType, with
// corresponding values for nCriteriaValue.
object GetNearestPerceivedEnemy(object oSource=OBJECT_SELF, int nNth = 1, int nCriteriaType=1000, int nCriteriaValue=1000)
{
    object oTarget = OBJECT_INVALID;

    if (nCriteriaType != 1000) {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                     REPUTATION_TYPE_ENEMY,
                                     oSource, nNth,
                                     CREATURE_TYPE_PERCEPTION,
                                     PERCEPTION_SEEN,
                                     nCriteriaType,
                                     nCriteriaValue);
    } else {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                     REPUTATION_TYPE_ENEMY,
                                     oSource, nNth,
                                     CREATURE_TYPE_PERCEPTION,
                                     PERCEPTION_SEEN);
    }

    if(GetIsObjectValid(oTarget))
        return oTarget; // found one

        // * NEVER NEVER Look for heard enemies.
        // * it makes creatures go 'hunting' for enemies way past
        // * where they should be looking for them.
        // * BK Feb 2003

/*    // Try looking for the nearest heard enemy instead
    if (nCriteriaType != 1000) {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                     REPUTATION_TYPE_ENEMY,
                                     oSource, nNth,
                                     CREATURE_TYPE_PERCEPTION,
                                     PERCEPTION_HEARD_AND_NOT_SEEN,
                                     nCriteriaType,
                                     nCriteriaValue);
    } else {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                     REPUTATION_TYPE_ENEMY,
                                     oSource, nNth,
                                     CREATURE_TYPE_PERCEPTION,
                                     PERCEPTION_HEARD_AND_NOT_SEEN);
    }
  */
    return oTarget;
}

// Get the nearest seen enemy. This will NOT return an enemy that is
// heard but not seen; for that, use GetNearestPerceivedEnemy instead.
object GetNearestSeenEnemy(object oSource=OBJECT_SELF, int nNth = 1)
{
    return GetNearestCreature(CREATURE_TYPE_REPUTATION,
                              REPUTATION_TYPE_ENEMY,
                              oSource, nNth,
                              CREATURE_TYPE_PERCEPTION,
                              PERCEPTION_SEEN);
}

//Returns the nearest object that can be seen, then checks for
//the nearest heard target.
// Now just a wrapper around GetNearestPerceivedEnemy.
object GetNearestSeenOrHeardEnemy(object oSource=OBJECT_SELF, int nNth = 1)
{
    return GetNearestPerceivedEnemy(oSource, nNth);
}

// Get the nearest seen friend.
object GetNearestSeenFriend(object oSource=OBJECT_SELF, int nNth=1)
{
    return GetNearestCreature(CREATURE_TYPE_REPUTATION,
                              REPUTATION_TYPE_FRIEND,
                              oSource, nNth,
                              CREATURE_TYPE_PERCEPTION,
                              PERCEPTION_SEEN);
}


// Count the number of enemies and allies in a given radius
// and their respective total CRs (slightly rounded, since
// we use integers instead of floats).
// This returns a "struct sSituation" type value. To use, do
// something like the following:
//
//   struct sSituation sitCurr = CountEnemiesAndAllies(20.0);
//   int nNumEnemies = sitCurr.ENEMY_NUM;
//   int nNumAllies = sitCurr.ALLY_NUM;
//   int nAllyCR = sitCurr.ALLY_CR;
//   int nEnemyCR = sitCurr.ENEMY_CR;
struct sSituation CountEnemiesAndAllies(float fRadius=20.0, object oSource=OBJECT_SELF)
{
    struct sSituation sitCurrent;
    sitCurrent.ENEMY_NUM = 0;
    sitCurrent.ALLY_NUM = 0;
    sitCurrent.ENEMY_CR = 0;
    sitCurrent.ALLY_CR = 0;

    location lSource = GetLocation(oSource);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                           fRadius,
                                           lSource,
                                           TRUE);
    while(GetIsObjectValid(oTarget)) {
        if (GetObjectSeen(oTarget)) {
            if (GetIsEnemy(oTarget)) {
                if (GetIsPC(oTarget) == TRUE)
                    sitCurrent.ENEMY_CR += GetHitDice(oTarget);
                else
                    sitCurrent.ENEMY_CR += FloatToInt(GetChallengeRating(oTarget));

                sitCurrent.ENEMY_NUM++;
            } else if (GetIsFriend(oTarget)) {
                if (GetIsPC(oTarget) == TRUE)
                    sitCurrent.ALLY_CR += GetHitDice(oTarget);
                else
                    sitCurrent.ALLY_CR += FloatToInt(GetChallengeRating(oTarget));

                sitCurrent.ALLY_NUM++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lSource, TRUE);
    }
    return sitCurrent;
}


//::///////////////////////////////////////////////
//:: Determine Enemies
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Uses four general categories to determine what
    kinds of enemies the NPC is facing.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

struct sEnemies DetermineEnemies()
{
    struct sEnemies sEnemyCount;

    int nCnt = 1;
    int nClass;
    int nHD;
    object oTarget = GetNearestPerceivedEnemy();

    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 40.0)
    {
        nClass = GetClassByPosition(1, oTarget);
        nHD = GetHitDice(oTarget);
        if(nClass == CLASS_TYPE_ANIMAL ||
           nClass == CLASS_TYPE_BARBARIAN ||
           nClass == CLASS_TYPE_BEAST ||
           nClass == CLASS_TYPE_COMMONER ||
           nClass == CLASS_TYPE_CONSTRUCT ||
           nClass == CLASS_TYPE_ELEMENTAL ||
           nClass == CLASS_TYPE_FIGHTER ||
           nClass == CLASS_TYPE_GIANT ||
           nClass == CLASS_TYPE_HUMANOID ||
           nClass == CLASS_TYPE_MONSTROUS ||
           nClass == CLASS_TYPE_PALADIN ||
           nClass == CLASS_TYPE_RANGER ||
           nClass == CLASS_TYPE_ROGUE ||
           nClass == CLASS_TYPE_VERMIN ||
           nClass == CLASS_TYPE_MONK ||
           nClass == CLASS_TYPE_SHAPECHANGER)
        {
            sEnemyCount.FIGHTERS += 1;
            sEnemyCount.FIGHTER_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_CLERIC ||
           nClass == CLASS_TYPE_DRUID)
        {
            sEnemyCount.CLERICS += 1;
            sEnemyCount.CLERIC_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_BARD ||
                nClass == CLASS_TYPE_FEY ||
                nClass == CLASS_TYPE_SORCERER ||
                nClass == CLASS_TYPE_WIZARD)
        {
           sEnemyCount.MAGES += 1;
           sEnemyCount.MAGE_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_ABERRATION ||
                nClass == CLASS_TYPE_DRAGON ||
                nClass == 29 || //oozes
                nClass == CLASS_TYPE_MAGICAL_BEAST ||
                nClass == CLASS_TYPE_OUTSIDER)
        {
           sEnemyCount.MONSTERS += 1;
           sEnemyCount.MONTERS_LEVELS += nHD;
        }
        sEnemyCount.TOTAL += 1;
        sEnemyCount.TOTAL_LEVELS += nHD;
        nCnt++;
        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nCnt);
    }
    return sEnemyCount;
}

//::///////////////////////////////////////////////
//:: Get Most Dangerious Class
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Use the four archetypes to determine the
    most dangerous group type facing the NPC
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

string GetMostDangerousClass(struct sEnemies sCount)
{
    string sClass;
    int nFighter = ((sCount.FIGHTER_LEVELS) * 13)/10;
    //SpeakString(IntToString(nFighter) + " " + IntToString(sCount.CLERIC_LEVELS) + " " + IntToString(sCount.MAGE_LEVELS) + " " + IntToString(sCount.MONTERS_LEVELS));

    if(nFighter >= sCount.CLERIC_LEVELS)
    {
        if(nFighter >= sCount.MAGE_LEVELS)
        {
            if(nFighter >= sCount.MONTERS_LEVELS)
            {
                sClass = "FIGHTER";
            }
            else
            {   sClass = "MONSTER";

            }
        }
        else if(sCount.MAGE_LEVELS >= sCount.MONTERS_LEVELS)
        {
            sClass = "MAGE";
        }
        else
        {
            sClass = "MONSTER";
        }
    }
    else if(sCount.CLERIC_LEVELS >= sCount.MAGE_LEVELS)
    {
        if(sCount.CLERIC_LEVELS >= sCount.MONTERS_LEVELS)
        {
            sClass = "CLERIC";
        }
        else
        {
            sClass = "MONSTER";
        }
    }
    else if(sCount.MAGE_LEVELS >= sCount.MONTERS_LEVELS)
    {
        sClass = "MAGE";
    }
    else
    {
        sClass = "MONSTER";
    }
    return sClass;
}

// Returns TRUE if the given opponent is a melee
// attacker, meaning they are in melee range and
// equipped with a melee weapon.
int GetIsMeleeAttacker(object oAttacker)
{
    if (GetDistanceToObject(oAttacker) > MELEE_DISTANCE)
        return FALSE;

    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
    if (GetIsObjectValid(oRight) && MatchMeleeWeapon(oRight))
        return TRUE;

    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
    if (GetIsObjectValid(oLeft) && MatchMeleeWeapon(oLeft))
        return TRUE;

    return FALSE;
}

// Returns TRUE if the given opponent is a ranged
// attacker, meaning they are outside melee range.
int GetIsRangedAttacker(object oAttacker)
{
    if (GetDistanceToObject(oAttacker) > MELEE_DISTANCE)
        return TRUE;
    return FALSE;
}

// Returns TRUE if the given opponent is wielding a
// ranged weapon.
int GetIsWieldingRanged(object oAttacker)
{
    return
        GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker));
}


//::///////////////////////////////////////////////
//:: GetNumberOfMeleeAttackers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check how many enemies are within 5m of the
    target object.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 11, 2001
//:://////////////////////////////////////////////
int GetNumberOfMeleeAttackers()
{
    int nCnt = 0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                           5.0,
                                           GetLocation(OBJECT_SELF), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget))
            nCnt++;
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                        5.0,
                                        GetLocation(OBJECT_SELF), TRUE);
    }
    return nCnt;
}

//::///////////////////////////////////////////////
//:: GetNumberOfRangedAttackers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check how many enemies are attacking the
    target from as distance
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 12, 2001
//:://////////////////////////////////////////////
int GetNumberOfRangedAttackers()
{
    int nCnt;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 40.0,
                                           GetLocation(OBJECT_SELF), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(GetAttackTarget(oTarget) == OBJECT_SELF
           && GetDistanceBetween(OBJECT_SELF, oTarget) > 5.0)
         {
            nCnt++;
         }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 40.0,
                                       GetLocation(OBJECT_SELF), TRUE);
    }
    return nCnt;
}

//::///////////////////////////////////////////////
//:: Get Racial Type Count
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Counts and returns the number of a certain
    racial type within a certain radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////

int GetRacialTypeCount(int nRacial_Type)
{
    int nCnt = 1;
    int nCount = 0;
    object oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nCnt,
                                              CREATURE_TYPE_RACIAL_TYPE,
                                              nRacial_Type);

    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 20.0)
    {
        if(!GetHasEffect(EFFECT_TYPE_TURNED, oTarget))
        {
            nCount++;
        }
        nCnt++;
        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nCnt,
                                           CREATURE_TYPE_RACIAL_TYPE,
                                           nRacial_Type);
    }
    return nCount;
}

//::///////////////////////////////////////////////
//:: Check Friendly Fire on Target
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Takes a target object and a radius and
    returns how many targets of the caster's faction
    are in that zone.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////

int CheckFriendlyFireOnTarget(object oTarget, float fDistance = 5.0)
{
    int nCnt, nHD, nMyHD;
    nMyHD = GetHitDice(OBJECT_SELF);
    object oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    while(GetIsObjectValid(oCheck))
    {
        //Use this instead of GetIsFriend to make sure that friendly casualties do not occur.
        //Formerlly GetIsReactionTypeFriendly(oCheck)
        nHD = GetHitDice(oCheck);
        if((GetIsFriend(oCheck)) &&
            oTarget != oCheck &&
            nMyHD <= (nHD * 2))
        {
            if(!GetIsReactionTypeFriendly(oCheck) || GetHenchman(OBJECT_SELF) != oCheck)
            {
                nCnt++;
            }
        }
        oCheck = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    }
    return nCnt;
}

//::///////////////////////////////////////////////
//:: Check For Enemies Around Target
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Takes a target object and a radius and
    returns how many targets of the enemy faction
    are in that zone.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
int CheckEnemyGroupingOnTarget(object oTarget, float fDistance = 5.0)
{
    int nCnt;
    object oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    while(GetIsObjectValid(oCheck))
    {
        if(GetIsEnemy(oCheck) && oTarget != oCheck)
        {
            nCnt++;
        }
        oCheck = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    }
    return nCnt;
}


//::///////////////////////////////////////////////
//:: Find Single Ranged Target
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Seeks out an enemy more than 5m away and alone
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: October 5, 2001
//:://////////////////////////////////////////////

object FindSingleRangedTarget()
{
    int nCnt = FALSE;
    object oTarget;
    float fDistance = 50.0;
    object oCount = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oCount) && nCnt == FALSE)
    {
        if(oCount != OBJECT_SELF)
        {
            if(GetIsEnemy(oCount) && oTarget != OBJECT_SELF)
            {
                fDistance = GetDistanceBetween(oTarget, OBJECT_SELF);
                if(fDistance == 0.0)
                {
                    fDistance = 60.0;
                }
                if(GetDistanceBetween(oCount, OBJECT_SELF) < fDistance && fDistance > 3.0)
                {
                    oTarget = oCount;
                    //nCnt = TRUE;
                }
            }
        }
        oCount = GetNextObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF));
    }
    return oTarget;
}


/* void main() {} /* */
