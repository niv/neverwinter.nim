//:://////////////////////////////////////////////////
//:: X0_I0_INFINITE
/*
  Library for an infinite space system.

  Note -- this isn't actually infinite, because infinite is
  v. boring. But it is intended to convey the impression of a
  non-fixed space.

  This is going to be used for the infinite desert system,
  but could also be used for other types just as easily.
  To create a different infinite system, just do the following:

  - create an include file like x0_i0_infdesert which defines
    the following global constants and functions (easiest: just copy
    x0_i0_infdesert, change INF_BASE, and replace the definitions
    of the functions as appropriate):

    string INF_BASE;

    void INF_CreateRandomEncounter(object oArea, object oPC);
    void INF_CreateRandomPlaceable(object oArea, object oPC);
    string INF_GetEntryMessage();
    string INF_GetReentryMessage();
    string INF_GetReachStartMessage();
    string INF_GetReturnToStartMessage();
    string INF_GetReachRewardMessage();
    string INF_GetReturnToRewardMessage();
    string INF_GetPoolEmptyMessage();

  - comment out #include "x0_i0_infdesert" in this file and
    include your new include file in its place.

  - rename and recompile all the x0_inf_* scripts.

  - of course, you have to create the areas, warning markers, etc.,
    all of which should use the value of INF_BASE in their tags
    instead of INF_DESERT.

    In particular, you will have to make a set of generic areas
    with tags numbered consecutively starting from 1:
         eg,
            INF_DESERT_AREA1
            INF_DESERT_AREA2
            ...
            INF_DESERT_AREA10

    replacing INF_DESERT with the new value of INF_BASE.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/12/2003
//:://////////////////////////////////////////////////

// Required common functions
#include "x0_i0_common"

// Include file for infinite desert
#include "x0_i0_infdesert"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// generic area tag
string INF_AREA = INF_BASE + "_AREA";

// reward area
string INF_REWARD = INF_BASE + "_REWARD";

// key to reward area
string INF_REWARD_KEY = INF_BASE + "_REWARD_KEY";

// transition
string INF_TRANS = INF_BASE + "_TRANS";

// warning marker
string INF_WARN = INF_BASE + "_WARN";

// starting point/entry marker
string INF_START = INF_BASE + "_START";

// out-of-pool var on area
string INF_OUT_OF_POOL = INF_BASE + "_OUT_OF_POOL";

// fixed location var on transition
string INF_FIXED_LOC = INF_BASE + "_FIXED_LOC";

// permanent starting point var on PC
string INF_ENTERED = INF_BASE + "_ENTERED";

// permanent completion var on PC
string INF_COMPLETED = INF_BASE + "_COMPLETED";

// current starting point var on the PC
string INF_CURRENT = INF_BASE + "_CURRENT";

// number of transitions passed var on PC
string INF_NTRANS = INF_BASE + "_NTRANS";

// run length var on PC
string INF_RUNLEN = INF_BASE + "_RUNLEN";

const float INF_MSG_DELAY = 4.0;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get the starting point for this run
object INF_GetCurrentStartingPoint(object oObj);

// Set the starting point for this run
// If OBJECT_INVALID is passed in for oStart, it will
// clear the variable.
void INF_SetCurrentStartingPoint(object oObj, object oStart);

// Determine whether the player is currently inside an infinite
// area.
int INF_GetIsInInfiniteSpace(object oPC);

// Get whether the PC has entered this starting point's run before
int INF_GetHasEntered(object oPC, object oStart);

// Set whether the PC has entered this starting point's run before
void INF_SetHasEntered(object oPC, object oStart);

// Get whether the PC has completed this run before
int INF_GetHasCompleted(object oPC, object oStart);

// Set whether the PC has completed this run before
void INF_SetHasCompleted(object oPC, object oStart);

// Get the number of transitions passed var on PC
int INF_GetNumberTransitionsPassed(object oPC);

// Set the number of transitions passed var (default is 0)
void INF_SetNumberTransitionsPassed(object oPC, int nTrans=0);

// Increment the number of transitions passed var
void INF_IncrNumberTransitionsPassed(object oPC);

// Get the run length var on the PC
int INF_GetRunLength(object oPC);

// Set the run length on the PC
void INF_SetRunLength(object oPC, int nLen);

// Returns TRUE if the area is not currently taken.
int INF_GetIsInPool(object oArea);

// Mark the area as taken or not
void INF_SetIsInPool(object oArea, int bInPool=TRUE);

// Get the fixed location of the transition, OBJECT_INVALID if not set
object INF_GetFixedLocation(object oTrans);

// Set the fixed location of a transition
void INF_SetFixedLocation(object oTrans, object oLocation);

// Returns TRUE if the player has reached the end of the run length
int INF_GetHasFinishedRunLength(object oPC);

// Get the reward area, or OBJECT_INVALID if it doesn't exist
object INF_GetRewardArea(object oPC);

// Get the reward area key item or OBJECT_INVALID if it doesn't exist
object INF_GetRewardKey(object oPC);

// TRUE if the player or a party member has the reward key
int INF_GetPartyHasRewardKey(object oPC);

// Retrieve an area from the pool. If no area is available in the pool,
// return OBJECT_INVALID.
object INF_GetAreaFromPool(object oPC);

// Set up a generic area, possibly specific to the PC triggering
void INF_AreaSetup(object oArea, object oPC);

// Handle item cleanup
void INF_ItemCleanup(object oItem, object oStart);

// Clean up a generic area
void INF_AreaCleanup(object oArea);

// Set up the PC on infinite run entry for the specified
// starting point.
void INF_SetupPC(object oPC, object oStart);

// Clean up the PC on infinite run exit
void INF_CleanupPC(object oPC);

// Clean up a transition
void INF_CleanupTransition(object oTrans);

// Send the PC back to the starting point
void INF_TransportToStartingPoint(object oPC);

// TRUE if the PC's party leader is in the same desert area but
// not in the same room.
int INF_GetIsPartyLeaderInRange(object oPC);

// Send the PC to join the party leader, if in range.
void INF_TransportToPartyLeader(object oPC);

// Get the return transition in the destination area
object INF_GetReturnTransition(object oTrans, object oDestArea);

// Send a message to the PC after a delay.
// Replaces <CUSTOM0> with the name of the area the PC is in,
// if the message contains that.
void INF_SendMessage(object oPC, string sMessage);

// Set up a new area and transport the PC through it.
// Can also do this with a specified reward area
// as an argument.
void INF_TransportToNewArea(object oPC, object oTrans, object oArea=OBJECT_INVALID);


// Handle the first transition into an area
void INF_DoFirstTransition(object oPC, object oTrans);

// Master transition function
// This is what actually handles most of the work.
// See internal comments to the function for details.
void INF_DoTransition(object oPC, object oTrans);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Get the starting point for the PC's run
object INF_GetCurrentStartingPoint(object oObj)
{
    return GetLocalObject(oObj, INF_CURRENT);
}

// Set the starting point for this run.
// If OBJECT_INVALID is passed in for oStart, it will
// clear the variable.
void INF_SetCurrentStartingPoint(object oObj, object oStart)
{
    if (oStart != OBJECT_INVALID)
        SetLocalObject(oObj, INF_CURRENT, oStart);
    else
        DeleteLocalObject(oObj, INF_CURRENT);
}

// Determine whether the player is currently inside an infinite
// area.
int INF_GetIsInInfiniteSpace(object oPC)
{
    // Check for a starting point
    object oStart = INF_GetCurrentStartingPoint(oPC);
    if (!GetIsObjectValid(oStart)) {
        //DBG_msg("No starting point - not in infinite space");
        return FALSE;
    }

    // Check if we're inside a generic area; if so,
    // it will not be in the pool.
    object oArea = GetArea(oPC);
    if (INF_GetIsInPool(oArea) == FALSE) {
        //DBG_msg(GetName(oPC) + ": inside a generic area");
        return TRUE;
    }

    // Check if we're inside a reward area
    if (oArea == INF_GetRewardArea(oPC)) {
        //DBG_msg(GetName(oPC) + ": inside a reward area");
        return TRUE;
    }

    // Nope, not in an infinite space
    //DBG_msg(GetName(oPC) + ": Not in infinite space: " + GetName(oArea));
    return FALSE;
}



// Get whether the PC has entered this starting point's run before
int INF_GetHasEntered(object oPC, object oStart)
{
    return GetLocalInt(oPC,
                       INF_ENTERED + "_" + GetTrapKeyTag(oStart));
}

// Set that the PC has entered this starting point's run before
void INF_SetHasEntered(object oPC, object oStart)
{
    SetLocalInt(oPC,
                INF_ENTERED + "_" + GetTrapKeyTag(oStart),
                TRUE);
}

// Get whether the PC has completed this run before
int INF_GetHasCompleted(object oPC, object oStart)
{
    return GetLocalInt(oPC,
                       INF_COMPLETED + "_" + GetTrapKeyTag(oStart));
}

// Set whether the PC has completed this run before
void INF_SetHasCompleted(object oPC, object oStart)
{
    SetLocalInt(oPC,
                INF_COMPLETED + "_" + GetTrapKeyTag(oStart),
                TRUE);
}

// Get the number of transitions passed var on PC
int INF_GetNumberTransitionsPassed(object oPC)
{
    return GetLocalInt(oPC, INF_NTRANS);
}

// Set the number of transitions passed var (default is 0)
void INF_SetNumberTransitionsPassed(object oPC, int nTrans=0)
{
    SetLocalInt(oPC, INF_NTRANS, nTrans);
}

// Increment the number of transitions passed var
void INF_IncrNumberTransitionsPassed(object oPC)
{
    SetLocalInt(oPC, INF_NTRANS, INF_GetNumberTransitionsPassed(oPC) + 1);
}

// Get the run length var on the PC
int INF_GetRunLength(object oPC)
{
    return GetLocalInt(oPC, INF_RUNLEN);
}

// Set the run length on the PC
void INF_SetRunLength(object oPC, int nLen)
{
    SetLocalInt(oPC, INF_RUNLEN, nLen);
}

// Returns TRUE if the area is not currently taken
int INF_GetIsInPool(object oArea)
{
    return !GetLocalInt(oArea, INF_OUT_OF_POOL);
}

// Mark the area as taken or not
void INF_SetIsInPool(object oArea, int bInPool=TRUE)
{
    SetLocalInt(oArea, INF_OUT_OF_POOL, !bInPool);
}

// Get the fixed location of the transition, OBJECT_INVALID if not set
object INF_GetFixedLocation(object oTrans)
{
    return GetLocalObject(oTrans, INF_FIXED_LOC);
}

// Set the fixed location of a transition.
// Pass in OBJECT_INVALID to unset.
void INF_SetFixedLocation(object oTrans, object oLocation)
{
    if (!GetIsObjectValid(oLocation))
        DeleteLocalObject(oTrans, INF_FIXED_LOC);
    else
        SetLocalObject(oTrans, INF_FIXED_LOC, oLocation);
}

// Returns TRUE if the player has reached the end of the run length
int INF_GetHasFinishedRunLength(object oPC)
{
    return (INF_GetNumberTransitionsPassed(oPC) >= INF_GetRunLength(oPC));
}


// Get the reward area, or OBJECT_INVALID if it doesn't exist
object INF_GetRewardArea(object oPC)
{
    object oStart = INF_GetCurrentStartingPoint(oPC);
    if (!GetIsObjectValid(oStart)) return OBJECT_INVALID;

    return GetObjectByTag(INF_REWARD + "_" + GetTrapKeyTag(oStart));
}

// Get the reward area key item or OBJECT_INVALID if it doesn't exist
object INF_GetRewardKey(object oPC)
{
    object oStart = INF_GetCurrentStartingPoint(oPC);
    if (!GetIsObjectValid(oStart)) return OBJECT_INVALID;

    return GetObjectByTag(INF_REWARD_KEY + "_" + GetTrapKeyTag(oStart));
}

// TRUE if the player or a party member has the reward key
int INF_GetPartyHasRewardKey(object oPC)
{
    object oStart = INF_GetCurrentStartingPoint(oPC);
    if (!GetIsObjectValid(oStart)) return FALSE;
    return GetIsItemPossessedByParty(oPC, INF_REWARD_KEY + "_" + GetTrapKeyTag(oStart));
}


// Get the number of generic areas that exist (not necessarily the
// number that are currently available).
int INF_GetNumGenericAreas()
{
    int i=1;
    string sTag = INF_AREA + IntToString(i);
    while (GetIsObjectValid(GetObjectByTag(sTag))) {
        i++;
        sTag = INF_AREA + IntToString(i);
    }
    return i-1;
}

// Retrieve an area from the pool. If no area is available in the pool,
// return OBJECT_INVALID.
object INF_GetAreaFromPool(object oPC)
{
    string sTag = "";
    object oArea  = OBJECT_INVALID;

    // To avoid the same areas appearing in the same order,
    // we need to start checking in a random spot
    int nNumAreas = INF_GetNumGenericAreas();

    int nStart = Random(nNumAreas) + 1;
    int i;
    int bLooped = 0;

    // Go as long as i is not back to start and
    // we've looped.
    for (i=nStart; !(i == nStart && bLooped); i++) {
        bLooped = TRUE;

        // Look up the area
        sTag = INF_AREA + IntToString(i);
        oArea = GetObjectByTag(sTag);
        //DBG_msg("Looking up area #: " + IntToString(i)
        //        + ", Tag: " + GetTag(oArea));
        if (GetIsObjectValid(oArea) && INF_GetIsInPool(oArea)) {
            // If we have a valid area in the pool,
            // return it.
            //DBG_msg("Valid area, returning: " + GetTag(oArea));
            return oArea;
        }

        // Reset to beginning of areas
        if (i == nNumAreas)
            i = 0;
    }

    // If we got here, the pool is empty
    return OBJECT_INVALID;
}

// Set up a generic area, possibly specific to the PC triggering
void INF_AreaSetup(object oArea, object oPC)
{
    INF_SetIsInPool(oArea, FALSE);
    INF_SetCurrentStartingPoint(oArea, INF_GetCurrentStartingPoint(oPC));
    INF_CreateRandomEncounter(oArea, oPC);
    INF_CreateRandomPlaceables(oArea, oPC);
}

// Handle item cleanup
void INF_ItemCleanup(object oItem, object oStart)
{
    if (GetPlotFlag(oItem)) {
        AssignCommand(oItem, JumpToObject(oStart));
    } else {
        DestroyObject(oItem);
    }

}

// Clean up a generic area
void INF_AreaCleanup(object oArea)
{
    object oStart = INF_GetCurrentStartingPoint(oArea);

    // Clean up all the things lying around the area
    object oThing = GetFirstObjectInArea(oArea);
    int nThingType;
    while (GetIsObjectValid(oThing)) {
        nThingType = GetObjectType(oThing);
        if (nThingType == OBJECT_TYPE_ITEM) {
            // Cleanup the item
            INF_ItemCleanup(oThing, oStart);

        } else if (nThingType == OBJECT_TYPE_CREATURE) {
            // Destroy any creature that isn't a PC or associate
            if ( !GetIsPC(oThing) && !GetIsObjectValid(GetMaster(oThing))) {
                DestroyObject(oThing);
            }

        } else if (nThingType == OBJECT_TYPE_PLACEABLE) {
            // Handle the items in its inventory if there are any
            if (GetHasInventory(oThing)) {
                object oItem = GetFirstItemInInventory(oThing);
                while (GetIsObjectValid(oItem)) {
                    INF_ItemCleanup(oItem, oStart);
                    oItem = GetNextItemInInventory(oThing);
                }
            }

            // Destroy anything that's not a warning marker
            if (GetTag(oThing) != INF_WARN) {
                DestroyObject(oThing);
            }

        } else if (nThingType == OBJECT_TYPE_TRIGGER) {
            // Clean up the transitions
            INF_CleanupTransition(oThing);
        }
        oThing = GetNextObjectInArea(oArea);
    }

    // Clear the starting point
    INF_SetCurrentStartingPoint(oArea, OBJECT_INVALID);

    // Mark the area as available
    INF_SetIsInPool(oArea, TRUE);

}


// Set up the PC on infinite run entry
void INF_SetupPC(object oPC, object oStart)
{
    INF_SetCurrentStartingPoint(oPC, oStart);
    INF_SetNumberTransitionsPassed(oPC, 0);

    // Calculate a random run length
    int nRange = INF_MAX_RUN_LENGTH - INF_MIN_RUN_LENGTH + 1;
    INF_SetRunLength(oPC, Random(nRange) + INF_MIN_RUN_LENGTH);

    // Mark as having entered this area
    INF_SetHasEntered(oPC, oStart);
}

// Clean up the PC on infinite run exit
void INF_CleanupPC(object oPC)
{
    INF_SetCurrentStartingPoint(oPC, OBJECT_INVALID);
    INF_SetRunLength(oPC, 0);
    INF_SetNumberTransitionsPassed(oPC, 0);
}

// Clean up a transition
void INF_CleanupTransition(object oTrans)
{
    object oFixed = INF_GetFixedLocation(oTrans);
    if (!GetIsObjectValid(oFixed)) return;
    object oReturn = INF_GetReturnTransition(oTrans, oFixed);
    INF_SetFixedLocation(oReturn, OBJECT_INVALID);
    INF_SetFixedLocation(oTrans, OBJECT_INVALID);
}


// Send the PC back to the starting point
void INF_TransportToStartingPoint(object oPC)
{
    object oStart = INF_GetCurrentStartingPoint(oPC);
    if (!GetIsObjectValid(oStart)) return;

    INF_CleanupPC(oPC);
    TransportToWaypoint(oPC, oStart);
}

// Send the PC to a good position inside the given transition
void INF_TransportToTransition(object oPC, object oTrans)
{
    object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oTrans);
    if (GetIsObjectValid(oWay))
        TransportToWaypoint(oPC, oWay);
    else {
        //DBG_msg("No nearby waypoint found for transition");
        TransportToWaypoint(oPC, oTrans);
    }
}


// TRUE if the PC's party leader is in the same desert area but
// not in the same room.
int INF_GetIsPartyLeaderInRange(object oPC)
{
    // Make sure leader exists and isn't the PC
    object oLeader = GetFactionLeader(oPC);
    if (!GetIsObjectValid(oLeader) || oLeader == oPC)
        return FALSE;

    // Make sure leader is in same desert area
    object oStart = INF_GetCurrentStartingPoint(oLeader);
    if (!GetIsObjectValid(oStart) || oStart != INF_GetCurrentStartingPoint(oPC))
        return FALSE;

    // Make sure leader is in a different room
    if (GetArea(oLeader) != GetArea(oPC))
        return TRUE;

    return FALSE;
}

// Send the PC to join the party leader.
void INF_TransportToPartyLeader(object oPC)
{
    if (INF_GetIsPartyLeaderInRange(oPC))
        TransportToLocation(oPC, GetLocation(GetFactionLeader(oPC)));
}

// TRUE if the object is an infinite transition trigger
int INF_GetIsTransition(object oTrig)
{
    string sTag = GetTag(oTrig);
    return (sTag == INF_TRANS + "_NORTH"
            ||
            sTag == INF_TRANS + "_SOUTH"
            ||
            sTag == INF_TRANS + "_EAST"
            ||
            sTag == INF_TRANS + "_WEST");
}

// Get the nearest transition to the object
object INF_GetNearestTransition(object oSource)
{
    object oTrig;
    int i = 1;
    object oSourceArea = GetArea(oSource);

    oTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oSource, i);
    while (GetIsObjectValid(oTrig)
           &&  !INF_GetIsTransition(oTrig)
           &&  GetArea(oTrig) == oSourceArea)
    {
        i++;
        oTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oSource, i);
    }
    return oTrig;
}

// Get the return transition in the destination area
object INF_GetReturnTransition(object oTrans, object oDestArea)
{
    //DBG_msg("Dest area: " + GetTag(oDestArea));
    //DBG_msg("Transition: " + GetTag(oTrans));
    string sTag = GetTag(oTrans);
    string sReturn = "";

    if (sTag == INF_TRANS + "_NORTH")
        sReturn = INF_TRANS + "_SOUTH";

    else if (sTag == INF_TRANS + "_SOUTH")
        sReturn = INF_TRANS + "_NORTH";

    else if (sTag == INF_TRANS + "_EAST")
        sReturn = INF_TRANS + "_WEST";

    else
        sReturn = INF_TRANS + "_EAST";

    // Get any object in the destination area to use as a source
    object oObj = GetFirstObjectInArea(oDestArea);
    if (GetTag(oObj) == sReturn) {
        //DBG_msg("Returning first obj: " + GetTag(oObj));
        return oObj;
    }

    //DBG_msg("Reference object: " + GetTag(oObj)
    //        + ", sReturn: " + sReturn);

    object oReturn = GetNearestObjectByTag(sReturn, oObj);

    // ugh, try another transition
    if ( ! GetIsObjectValid(oReturn) ) {
        oReturn = GetNearestObjectByTag(INF_TRANS + "_NORTH", oObj);
    }

    if ( ! GetIsObjectValid(oReturn) ) {
        oReturn = GetNearestObjectByTag(INF_TRANS + "_SOUTH", oObj);
    }

    if ( ! GetIsObjectValid(oReturn) ) {
        oReturn = GetNearestObjectByTag(INF_TRANS + "_EAST", oObj);
    }

    if ( ! GetIsObjectValid(oReturn) ) {
        oReturn = GetNearestObjectByTag(INF_TRANS + "_WEST", oObj);
    }

    // If we STILL don't have a valid object, return the reference obj
    if ( !GetIsObjectValid(oReturn) ) {
        oReturn = oObj;
    }

    //DBG_msg("Returning: " + GetTag(oReturn)
    //        + " in area: " + GetTag(GetArea(oReturn)));

    return oReturn;
}

// Deliberately not prototyped! Do not use outside this
// library. Use INF_SendMessage instead.
// This is the function that actually sends the message.
void INF_ReallySendMessage(object oPC, string sMessage)
{
    string sFinal = "";

    int nPos = FindSubString(sMessage, "<CUSTOM0>");
    if (nPos != -1) {
        // We have a token in the string
        int nEndPos = nPos + 9;
        string sAreaName = GetName(GetArea(oPC));
        sFinal = GetSubString(sMessage, 0, nPos);
        sFinal += sAreaName;
        sFinal += GetSubString(sMessage,
                               nEndPos,
                               GetStringLength(sMessage) - nEndPos);
    } else {
        sFinal = sMessage;
    }

    AssignCommand(oPC, ActionSpeakString(sFinal, TALKVOLUME_WHISPER));
    SendMessageToPC(oPC, sFinal);
}

// Send a message to the PC after a delay.
// Replaces <CUSTOM0> with the name of the area the PC is in,
// if the message contains that.
void INF_SendMessage(object oPC, string sMessage)
{
    DelayCommand(INF_MSG_DELAY,
                 INF_ReallySendMessage(oPC, sMessage));
}

// Set up a new area and transport the PC through it.
// Can also do this with a specified reward area
// as an argument.
void INF_TransportToNewArea(object oPC, object oTrans, object oNewArea=OBJECT_INVALID)
{
    //DBG_msg("Going through transition: " + GetTag(oTrans)
    //        + " in area: " + GetTag(GetArea(oTrans)));

    object oStart = INF_GetCurrentStartingPoint(oPC);

    // If we're going through a transition that has a fixed
    // destination, respect that above other cases.
    object oFixedLoc = INF_GetFixedLocation(oTrans);
    if (GetIsObjectValid(oFixedLoc)) {
        // if the destination is the starting area, end the run
        if (oFixedLoc == GetArea(oStart)) {
            INF_TransportToStartingPoint(oPC);
            DelayCommand(INF_MSG_DELAY,
                         INF_SendMessage(oPC, INF_GetReturnToStartMessage()));
        } else {
            INF_IncrNumberTransitionsPassed(oPC);
            INF_TransportToTransition(oPC,
                                      INF_GetReturnTransition(oTrans,
                                                              oFixedLoc));
        }
        return;
    }

    object oArea = oNewArea;
    if (!GetIsObjectValid(oArea)) {
        oArea = INF_GetAreaFromPool(oPC);

        if (!GetIsObjectValid(oArea)) {
            // No areas available in the pool,
            // send the PC back to the starting point
            INF_TransportToStartingPoint(oPC);
            DelayCommand(INF_MSG_DELAY,
                INF_SendMessage(oPC, INF_GetPoolEmptyMessage()));
            return;
        }

        // Setup the area
        INF_AreaSetup(oArea, oPC);
    } else {
        // This is a reward area. Mark it with the starting point
        // for return journeys.
        INF_SetCurrentStartingPoint(oArea, oStart);
    }

    // Make it the fixed transition
    INF_SetFixedLocation(oTrans, oArea);

    // Make this area the fixed trans for the return
    //DBG_msg("Destination area: " + GetTag(oArea));
    object oReturn = INF_GetReturnTransition(oTrans, oArea);

    INF_SetFixedLocation(oReturn, GetArea(oTrans));

    // Increment number of transitions passed
    INF_IncrNumberTransitionsPassed(oPC);

    // Transport the PC to the return transition
    INF_TransportToTransition(oPC, oReturn);

}

// Handle the first transition into an area
void INF_DoFirstTransition(object oPC, object oTrans)
{
    //DBG_msg("Doing a first transition");
    INF_CleanupPC(oPC);

    object oStart = GetNearestObjectByTag(INF_START, oPC);

    // If there is no valid start object, check to see if
    // there's one saved on the area itself, as it would
    // be in a reward area.
    if (!GetIsObjectValid(oStart)) {
        oStart = INF_GetCurrentStartingPoint(GetArea(oPC));
        if (GetIsObjectValid(oStart)) {
            //DBG_msg("Using start point on area: " + GetTrapKeyTag(oStart));
            INF_SetupPC(oPC, oStart);

            // mark PC as having entered this starting point
            INF_SetHasEntered(oPC, oStart);

            // Start the transition over
            INF_DoTransition(oPC, oTrans);
        } else {
            // If there is STILL no valid start object,
            // it's just a bug -- don't let the PC in.
            INF_SendMessage(oPC, INF_GetNoStartMessage());
        }
        return;
    }

    // If the PC has gone through here before, or if the starting
    // point isn't actually in this area, send them through.
    if (INF_GetHasEntered(oPC, oStart) || GetArea(oStart) != GetArea(oPC)) {
        INF_SetupPC(oPC, oStart);
        INF_TransportToNewArea(oPC, oTrans);
        INF_SendMessage(oPC, INF_GetEntryMessage());
    } else {
        // mark PC as having entered this starting point (HAS_ENTERED)
        INF_SetHasEntered(oPC, oStart);

        // start conversation with nearest entry marker,
        // which will give the option of re-invoking
        // this function to actually enter.
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionStartConversation(oStart));
    }
}

// Master transition function
// This is what actually handles most of the work.
// See internal comments to the function for details.
void INF_DoTransition(object oPC, object oTrans)
{
    if (!GetIsObjectValid(oTrans)) {
        //DBG_msg("Invalid transition in area " + GetTag(GetArea(oPC)));
        return;
    }

    // get current start point on PC
    object oStart = INF_GetCurrentStartingPoint(oPC);

    if (!GetIsObjectValid(oStart)) {
        //DBG_msg(GetName(oPC)
        //        + ": No current starting point at transition in "
        //        + GetName(GetArea(oPC)));
        // the first transition of a run
        INF_DoFirstTransition(oPC, oTrans);
        return;
    }

    // If we get this far, we're inside a run
    object oReward = INF_GetRewardArea(oPC);

    // If we're inside a reward area, send back to
    // the starting point.
    if ( GetArea(oPC) == oReward ) {
        //DBG_msg("In reward area, going back to starting point");
        INF_TransportToStartingPoint(oPC);
        INF_SendMessage(oPC, INF_GetReachStartMessage());
        return;
    }

    // Check to see if we're finished with the run
    int bHasCompleted = INF_GetHasCompleted(oPC, oStart);
    if (bHasCompleted || INF_GetHasFinishedRunLength(oPC)) {
        // Mark that we've finished the run regardless of
        // whether we have the key or not.
        INF_SetHasCompleted(oPC, oStart);

        // If there's a reward area, go there
        if (GetIsObjectValid(oReward)) {

            // Check to see if it's locked
            object oKey = INF_GetRewardKey(oPC);
            if (!GetIsObjectValid(oKey) || INF_GetPartyHasRewardKey(oPC)) {
                INF_TransportToNewArea(oPC, oTrans, oReward);
                if (bHasCompleted)
                   INF_SendMessage(oPC, INF_GetReturnToRewardMessage());
                else
                   INF_SendMessage(oPC, INF_GetReachRewardMessage());
            } else {
                // No key! Send PC back out to get it.
                INF_TransportToStartingPoint(oPC);
                INF_SendMessage(oPC, INF_GetNeedKeyMessage());
            }

        } else {

            // No reward area exists, so send back to start
            INF_TransportToStartingPoint(oPC);
            if (bHasCompleted)
                INF_SendMessage(oPC, INF_GetReturnToStartMessage());
            else
                INF_SendMessage(oPC, INF_GetReachStartMessage());
        }

        return;

    } // End of completed run condition

    // We're in the middle of a run, so go to a new generic area
    INF_TransportToNewArea(oPC, oTrans);
}




/* void main() {} /* */
