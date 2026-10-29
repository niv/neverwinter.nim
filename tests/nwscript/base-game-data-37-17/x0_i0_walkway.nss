//:://////////////////////////////////////////////////
//:: X0_I0_WALKWAY
/*
  Include library holding the code for WalkWayPoints.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////
//:: Updated On : 2003/09/03 - Georg Zoeller
//::                           * Added code to allow area transitions if global integer
//::                             X2_SWITCH_CROSSAREA_WALKWAYPOINTS set to 1 on the module
//::                           * Fixed Night waypoints not being run correcty
//::                           * XP2-Only: Fixed Stealth and detect modes spawnconditions
//::                             not working
//::                           * Added support for SleepAtNight SpawnCondition: if you put
//::                             a string on the module called X2_S_SLEEP_AT_NIGHT_SCRIPT,
//::                             pointing to a script, this script will fire if it is night
//::                             and your NPC has the spawncondition set
//::                           * Added the ability to make NPCs turn to the facing of
//::                             a waypoint when setting int X2_L_WAYPOINT_SETFACING to 1 on
//::                             the waypoint

#include "x0_i0_spawncond"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

const string sWalkwayVarname = "NW_WALK_CONDITION";

// If set, the creature's waypoints have been initialized.
const int NW_WALK_FLAG_INITIALIZED                 = 0x00000001;

// If set, the creature will walk its waypoints constantly,
// moving on in each OnHeartbeat event. Otherwise,
// it will walk to the next only when triggered by an
// OnPerception event.
const int NW_WALK_FLAG_CONSTANT                    = 0x00000002;

// Set when the creature is walking day waypoints.
const int NW_WALK_FLAG_IS_DAY                      = 0x00000004;

// Set when the creature is walking back
const int NW_WALK_FLAG_BACKWARDS                   = 0x00000008;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get whether the condition is set
int GetWalkCondition(int nCondition, object oCreature=OBJECT_SELF);

// Set a given condition
void SetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF);

// Get a waypoint number suffix, padded if necessary
string GetWaypointSuffix(int i);

// Look up the caller's waypoints and store them on the creature.
// Waypoint variables:
//        WP_NUM     : number of day waypoints
//        WN_NUM     : number of night waypoints
//        WP_#, WN_# : the waypoint objects
//        WP_CUR     : the current waypoint number
// bCrossAreas: if set to TRUE, the creature will travel between areas to reach
//              its waypoint
void LookUpWalkWayPoints();

// Get the creature's next waypoint.
// If it has just become day/night, or if this is
// the first time we're getting a waypoint, we go
// to the nearest waypoint in our new set.
object GetNextWalkWayPoint(object oCreature=OBJECT_SELF);

// Get the number of the nearest of the creature's current
// set of waypoints (respecting day/night).
int GetNearestWalkWayPoint(object oCreature=OBJECT_SELF);

// HEAVILY REVISED!
// The previous version of this function was too little
// bang-for-the-buck, as it set up an infinite loop and
// made creatures walk around even when there was no one
// in the area.
//
// Now, each time this function is called, the caller
// will move to their next waypoint. The OnHeartbeat and
// OnPerception scripts have been modified to call this
// function as appropriate.
//
// However, also note that the mobile ambient animations
// have been heavily revised. For most creatures, those
// should now be good enough, especially if you put down
// some "NW_STOP" waypoints for them to wander among.
// Specific waypoints will now be more for creatures that
// you really want to patrol back and forth along a pre-set
// path.
void WalkWayPoints(int nRun = FALSE, float fPause = 1.0);

// Check to make sure that the walker has at least one valid
// waypoint they will walk to at some point (day or night).
int CheckWayPoints(object oWalker = OBJECT_SELF);

// Check to see if the specified object is currently walking
// waypoints or standing at a post.
int GetIsPostOrWalking(object oWalker = OBJECT_SELF);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Get whether the specified WalkWayPoints condition is set
int GetWalkCondition(int nCondition, object oCreature=OBJECT_SELF)
{
    return (GetLocalInt(oCreature, sWalkwayVarname) & nCondition);
}

// Set a given WalkWayPoints condition
void SetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oCreature, sWalkwayVarname);
    if (bValid) {
        SetLocalInt(oCreature, sWalkwayVarname, nCurrentCond | nCondition);
    } else {
        SetLocalInt(oCreature, sWalkwayVarname, nCurrentCond & ~nCondition);
    }
}


// Get a waypoint number suffix, padded if necessary
string GetWaypointSuffix(int i)
{
    if (i < 10) {
        return "0" + IntToString(i);
    }
    return IntToString(i);
}

// Look up the caller's waypoints and store them on the creature.
// Waypoint variables:
//        WP_NUM     : number of day waypoints
//        WN_NUM     : number of night waypoints
//        WP_#, WN_# : the waypoint objects
//        WP_CUR     : the current waypoint number
void LookUpWalkWayPoints()
{
    // check if the module enables area transitions for walkwaypoints
    int bCrossAreas = (GetLocalInt(GetModule(),"X2_SWITCH_CROSSAREA_WALKWAYPOINTS") == TRUE);

    SetLocalInt(OBJECT_SELF, "WP_CUR", -1);

    string sTag = "WP_" + GetTag(OBJECT_SELF) + "_";

    int nNth=1;
    object oWay;

    if (!bCrossAreas)
    {
        oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
    }
    else
    {
       oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
    }
    if (!GetIsObjectValid(oWay)) {
        if (!bCrossAreas)
        {
            oWay = GetNearestObjectByTag("POST_" + GetTag(OBJECT_SELF));
        }
        else
        {
            oWay = GetObjectByTag("POST_" + GetTag(OBJECT_SELF));
        }
        if (GetIsObjectValid(oWay)) {
            // no waypoints but a post
            SetLocalInt(OBJECT_SELF, "WP_NUM", 1);
            SetLocalObject(OBJECT_SELF, "WP_1", oWay);
        } else {
            // no waypoints or post
            SetLocalInt(OBJECT_SELF, "WP_NUM", -1);
        }
    } else {
        // look up and store all the waypoints
        while (GetIsObjectValid(oWay)) {
            SetLocalObject(OBJECT_SELF, "WP_" + IntToString(nNth), oWay);
            nNth++;
            if (!bCrossAreas)
            {
                oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
            }
            else
            {
                oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
            }
        }
        nNth--;
        SetLocalInt(OBJECT_SELF, "WP_NUM", nNth);
    }


    //The block of code below deals with night and day
    // cycle for postings and walkway points.
    if( !GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING)) {
        // no night-time waypoints
        SetLocalInt(OBJECT_SELF, "WN_NUM", -1);
    } else {
        sTag = "WN_" + GetTag(OBJECT_SELF) + "_";
        nNth = 1;

        if (!bCrossAreas)
        {
            oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
        }
        else
        {
            oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
        }
        if (!GetIsObjectValid(oWay)) {
            if (!bCrossAreas)
            {
                oWay = GetNearestObjectByTag("NIGHT_" + GetTag(OBJECT_SELF));
            }
            else
            {
                oWay = GetObjectByTag("NIGHT_" + GetTag(OBJECT_SELF));
            }
            if (GetIsObjectValid(oWay)) {
                // no waypoints but a post
                SetLocalInt(OBJECT_SELF, "WN_NUM", 1);
                SetLocalObject(OBJECT_SELF, "WN_1", oWay);
            } else {
                // no waypoints or post
                SetLocalInt(OBJECT_SELF, "WN_NUM", -1);
            }
        } else {
            // look up and store all the waypoints
            while (GetIsObjectValid(oWay)) {
                SetLocalObject(OBJECT_SELF, "WN_" + IntToString(nNth), oWay);
                nNth++;
                if (!bCrossAreas)
                {
                    oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
                }
                else
                {
                    oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
                }
            }
            nNth--;
            SetLocalInt(OBJECT_SELF, "WN_NUM", nNth);
        }
    }
}

// Get the creature's next waypoint.
// If it has just become day/night, or if this is
// the first time we're getting a waypoint, we go
// to the nearest waypoint in our new set.
object GetNextWalkWayPoint(object oCreature=OBJECT_SELF)
{
    string sPrefix = "WP_";

    // Check to see if we have to switch to day/night
    if (GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING)) {
        int bIsWalkingDay = GetWalkCondition(NW_WALK_FLAG_IS_DAY, oCreature);

        if ( (bIsWalkingDay && !GetIsDay()) || (!bIsWalkingDay && GetIsDay()) ) {
            //SpeakString("Switch to day=" + IntToString(!bIsWalkingDay));
            // time to switch to different set of waypoints
            SetWalkCondition(NW_WALK_FLAG_IS_DAY, !bIsWalkingDay, oCreature);
            // Get the nearest waypoint, then set our "current" waypoint
            // to be the one just before that.
            int nFakeCurrent = GetNearestWalkWayPoint(oCreature) - 1;
            SetLocalInt(oCreature, "WP_CUR", nFakeCurrent);
        }
        if (!GetIsDay()) {
            // Change the prefix if necessary
            sPrefix = "WN_";
        }

    }

    // if we only have one post, just go there
    int nPoints = GetLocalInt(oCreature, sPrefix + "NUM");
    if (nPoints == 1) {
        return GetLocalObject(oCreature, sPrefix + "1");
    }

    // Move up to the next waypoint

    // Get the current waypoint
    int nCurWay = GetLocalInt(oCreature, "WP_CUR");

    // Check to see if this is the first time
    if (nCurWay == -1) {
        nCurWay = GetNearestWalkWayPoint(oCreature);
    } else {
        // we're either walking forwards or backwards -- check
        int bGoingBackwards = GetWalkCondition(NW_WALK_FLAG_BACKWARDS, oCreature);
        if (bGoingBackwards) {
            nCurWay--;
            if (nCurWay == 0) {
                nCurWay = 2;
                SetWalkCondition(NW_WALK_FLAG_BACKWARDS, FALSE, oCreature);
            }
        } else {
            nCurWay++;
            if (nCurWay > nPoints) {
                nCurWay = nCurWay - 2;
                SetWalkCondition(NW_WALK_FLAG_BACKWARDS, TRUE, oCreature);
            }
        }
    }

    // Set our current point and return
    SetLocalInt(oCreature, "WP_CUR", nCurWay);
    if (nCurWay == -1)
        return OBJECT_INVALID;

        object oRet =GetLocalObject(oCreature, sPrefix + IntToString(nCurWay));
    return oRet;
}


// Get the number of the nearest of the creature's current
// set of waypoints (respecting day/night).
int GetNearestWalkWayPoint(object oCreature=OBJECT_SELF)
{
    int nNumPoints;
    string sPrefix;

    if (!GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING) || GetIsDay()) {
        nNumPoints = GetLocalInt(oCreature, "WP_NUM");
        sPrefix = "WP_";
    } else {
        nNumPoints = GetLocalInt(oCreature, "WN_NUM");
        sPrefix = "WN_";
    }

    if (nNumPoints < 1) return -1;
    int i;
    int nNearest = -1;
    float fDist = 1000000.0;

    object oTmp;
    float fTmpDist;
    for (i=1; i <= nNumPoints; i++) {
        oTmp = GetLocalObject(oCreature, sPrefix + IntToString(i));
        fTmpDist = GetDistanceBetween(oTmp, oCreature);
        if (fTmpDist >= 0.0 && fTmpDist < fDist) {
            nNearest = i;
            fDist = fTmpDist;
        }
    }
    return nNearest;
}


// Make the caller walk through their waypoints or go to their post.
void WalkWayPoints(int nRun = FALSE, float fPause = 1.0)
{
    // * don't interrupt current circuit
    object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    int bIsEnemyValid = GetIsObjectValid(oNearestEnemy);

    // * if I can see an enemy I should not be trying to walk waypoints
    if (bIsEnemyValid == TRUE)
    {
        if( GetObjectSeen(oNearestEnemy) == TRUE)
        {
            return;
        }
    }

    int bIsFighting = GetIsFighting(OBJECT_SELF);
    int bIsInConversation = IsInConversation(OBJECT_SELF);
    int bMoving = GetCurrentAction(OBJECT_SELF) == ACTION_MOVETOPOINT;
    int bWaiting = GetCurrentAction(OBJECT_SELF) == ACTION_WAIT;

    if (bIsFighting == TRUE || bIsInConversation == TRUE || bMoving == TRUE || bWaiting == TRUE)
        return;

    // Initialize if necessary
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED)) {
        LookUpWalkWayPoints();
        SetWalkCondition(NW_WALK_FLAG_INITIALIZED);


        // Use appropriate skills, only once
        // * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
        if(GetSpawnInCondition(NW_FLAG_STEALTH)) {
            SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,TRUE);
        }

        // * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
        if(GetSpawnInCondition(NW_FLAG_SEARCH)){
            SetActionMode(OBJECT_SELF,ACTION_MODE_DETECT,TRUE);
        }
    }
    // Move to the next waypoint
    object oWay = GetNextWalkWayPoint(OBJECT_SELF);
    if (GetIsObjectValid(oWay) == TRUE)
    {
        SetWalkCondition(NW_WALK_FLAG_CONSTANT);
        // * Feb 7 2003: Moving this from 299 to 321, because I don't see the point
        // * in clearing actions unless I actually have waypoints to walk
        ClearActions(CLEAR_X0_I0_WALKWAY_WalkWayPoints);

        //SpeakString("Moving to waypoint: " + GetTag(oWay));
        ActionMoveToObject(oWay, nRun);
        if(GetLocalInt(oWay,"X2_L_WAYPOINT_SETFACING") == 1)
        {
            ActionDoCommand(SetFacing(GetFacing(oWay)));
        }
        ActionWait(fPause);
        ActionDoCommand(WalkWayPoints(nRun,fPause));      // February 14 2003 added else route only happens once

        // GZ: 2003-09-03
        // Since this wasnt implemented and we we don't have time for this either, I
        // added this code to allow builders to react to NW_FLAG_SLEEPING_AT_NIGHT.
        if(GetIsNight())
        {
            if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
            {
                string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
                if (sScript != "")
                {
                    ExecuteScript(sScript,OBJECT_SELF);
                }
            }
        }
     }
     else // also do stuff if there are no waypoints set
     {

        // GZ: 2003-09-03
        // Since this wasnt implemented and we we don't have time for this either, I
        // added this code to allow builders to react to NW_FLAG_SLEEPING_AT_NIGHT.
        if(GetIsNight())
        {
            if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
            {
                string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
                if (sScript != "")
                {
                    ExecuteScript(sScript,OBJECT_SELF);
                }
            }
        }
     }
}


// Check to make sure that the walker has at least one valid
// waypoint to walk to at some point.
int CheckWayPoints(object oWalker = OBJECT_SELF)
{
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED, oWalker)) {
        AssignCommand(oWalker, LookUpWalkWayPoints());
    }

    if (GetLocalInt(oWalker, "WP_NUM") > 0 || GetLocalInt(oWalker, "WN_NUM") > 0)
        return TRUE;
    return FALSE;
}

// Check to see if the specified object is currently walking
// waypoints or standing at a post.
int GetIsPostOrWalking(object oWalker = OBJECT_SELF)
{
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED, oWalker)) {
        AssignCommand(oWalker, LookUpWalkWayPoints());
    }

    if (!GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING) || GetIsDay()) {
        if (GetLocalInt(oWalker, "WP_NUM") > 0) {
            return TRUE;
        }
    } else if (GetLocalInt(oWalker, "WN_NUM") > 0) {
        return TRUE;
    }

    return FALSE;
}



/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
