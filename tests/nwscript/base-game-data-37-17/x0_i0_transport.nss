//:://////////////////////////////////////////////////
//:: X0_I0_TRANSPORT
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*

Functions for making creatures travel/transport to new locations.

 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/12/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/


// Target goes to specified destination object intelligently.
// If location is in same area, walk (or run) there.
// If location is in different area, walk (or run) to
//     most appropriate door, area transition, or waypoint, 
//     then jump.
// If either of these fail, jump after fDelay seconds.
void TravelToObject(object oDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0);

// Target goes to specified location intelligently. See
// TravelToObject for description.
void TravelToLocation(location lDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0);

// Find nearest exit to target (either door or waypoint).
object GetNearestExit(object oTarget=OBJECT_SELF);

// Find best exit based on desired target area
object GetBestExit(object oTarget=OBJECT_SELF, object oTargetArea=OBJECT_INVALID);

// Transport a player and his/her associates to a waypoint.
// This does NOT transport the rest of the player's party,
// only their henchman, summoned, dominated, etc.
void TransportToWaypoint(object oPC, object oWaypoint);

// Transport a player and his/her associates to a location.
// This does NOT transport the rest of the player's party,
// only their henchman, summoned, dominated, etc.
void TransportToLocation(object oPC, location oLoc);

// Transport an entire party to a waypoint
void TransportAllToWaypoint(object oPC, object oWay);

// Transport an entire party to a location
void TransportAllToLocation(object oPC, location lLoc);



/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Target goes to specified destination object intelligently.
// If location is in same area, walk (or run) there.
// If location is in different area, walk (or run) to
//     nearest waypoint or door, then jump.
// If either of these fail, jump after a timeout.
void TravelToObject(object oDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0)
{
    TravelToLocation(GetLocation(oDest), oTarget, bRun, fDelay);
}

// Target goes to specified location intelligently. See
// TravelToObject for description.
void TravelToLocation(location lDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0)
{
    object oDestArea = GetAreaFromLocation(lDest);
    if (oDestArea == GetArea(oTarget)) {
        AssignCommand(oTarget,
                      ActionForceMoveToLocation(lDest, bRun, fDelay));
    } else {
        object oBestExit = GetBestExit(oTarget, oDestArea);
        AssignCommand(oTarget,
                      ActionForceMoveToObject(oBestExit, bRun, 1.0, fDelay));
        int nObjType = GetObjectType(oBestExit);
        if (nObjType == OBJECT_TYPE_DOOR) {
            AssignCommand(oTarget, ActionOpenDoor(oBestExit));
        }
        AssignCommand(oTarget,
                      ActionJumpToLocation(lDest));
    }
    AssignCommand(oTarget, DelayCommand(fDelay, ClearAllActions()));
    AssignCommand(oTarget, DelayCommand(fDelay, JumpToLocation(lDest)));
}

// Find nearest exit to target (either door or trigger or 
// (failing those) waypoint).
object GetNearestExit(object oTarget=OBJECT_SELF)
{
    object oCurArea = GetArea(oTarget);

    object oNearDoor = GetNearestObject(OBJECT_TYPE_DOOR, oTarget);
    if (GetArea(oNearDoor) != oCurArea)
        oNearDoor = OBJECT_INVALID;

    // Find nearest area transition trigger
    int nTrig = 1;
    object oNearTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oTarget);
    while (GetIsObjectValid(oNearTrig) 
           && GetArea(oNearTrig) == oCurArea 
           && !GetIsObjectValid(GetTransitionTarget(oNearTrig))) 
    {
        nTrig++;
        oNearTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oTarget, nTrig);
    }
    if (GetArea(oNearTrig) != oCurArea)
        oNearTrig = OBJECT_INVALID;

    float fMaxDist = 10000.0;
    float fDoorDist = fMaxDist;
    float fTrigDist = fMaxDist;

    if (GetIsObjectValid(oNearDoor)) {
        fDoorDist = GetDistanceBetween(oNearDoor, oTarget);
    }
    if (GetIsObjectValid(oNearTrig)) {
        fTrigDist = GetDistanceBetween(oNearTrig, oTarget);
    }

    if (fTrigDist < fDoorDist)
        return oNearTrig;

    if (fDoorDist < fTrigDist || fDoorDist < fMaxDist)
        return oNearDoor;

    // No door/area transition -- use waypoint as a backup exit
    return GetNearestObject(OBJECT_TYPE_WAYPOINT, oTarget);
}

// Private function: find the best exit of the desired type.
object GetBestExitByType(object oTarget=OBJECT_SELF, object oTargetArea=OBJECT_INVALID, int nObjType=OBJECT_TYPE_DOOR)
{
    object oCurrentArea = GetArea(oTarget);
    int nDoor = 1;

    object oDoor = GetNearestObject(nObjType, oTarget);
    object oNearestDoor = oDoor;
    object oDestArea = OBJECT_INVALID;

    object oBestDoor = OBJECT_INVALID;
    object oBestDestArea = OBJECT_INVALID;

    while (GetIsObjectValid(oDoor) && GetArea(oDoor) == oCurrentArea) {
        oDestArea = GetArea(GetTransitionTarget(oDoor));

        // If we find a door that leads to the target
        // area, use it
        if (oDestArea == oTargetArea) {
            return oDoor;
        }

        // If we find a door that leads to a different area,
        // that might be good if we haven't already found one
        // that leads to the desired area, or a closer door
        // that leads to a different area.
        if (oDestArea != oCurrentArea && !GetIsObjectValid(oBestDoor)) {
            oBestDoor = oDoor;
        }

        // try the next door
        nDoor++;
        oDoor = GetNearestObject(nObjType, oTarget, nDoor);
    }
    
    // If we found a door that leads to a different area, 
    // return that one. 
    if (GetIsObjectValid(oBestDoor)) 
        return oBestDoor;
    
    // Otherwise, return the nearest, if it's in this area.
    if (GetArea(oNearestDoor) == oCurrentArea)
        return oNearestDoor;

    return OBJECT_INVALID;
}


// Find best exit based on desired target area
object GetBestExit(object oTarget=OBJECT_SELF, object oTargetArea=OBJECT_INVALID)
{
    if (!GetIsObjectValid(oTargetArea))
        return GetNearestExit(oTarget);

    // Try and find a door
    object oBestDoor = GetBestExitByType(oTarget, 
                                         oTargetArea, 
                                         OBJECT_TYPE_DOOR);

    if (GetIsObjectValid(oBestDoor)) {
        if (GetTransitionTarget(oBestDoor) == oTargetArea) {
            return oBestDoor;
        }
    }

    // Try and find a trigger
    object oBestTrigger = GetBestExitByType(oTarget, 
                                            oTargetArea, 
                                            OBJECT_TYPE_TRIGGER);
    if (GetIsObjectValid(oBestTrigger)) {
        if (GetTransitionTarget(oBestTrigger) == oTargetArea) {
            return oBestTrigger;
        }
    }

    if (GetIsObjectValid(oBestDoor))
        return oBestDoor;

    if (GetIsObjectValid(oBestTrigger))
        return oBestTrigger;

    return GetNearestExit(oTarget);
        
}


// Transport a player and his/her associates to a waypoint.
// This does NOT transport the rest of the player's party,
// only their henchman, summoned, dominated, etc.
void TransportToWaypoint(object oPC, object oWaypoint)
{
    if (!GetIsObjectValid(oWaypoint)) {
        return;
    }
    TransportToLocation(oPC, GetLocation(oWaypoint));
}

// Transport a player and his/her associates to a location.
// This does NOT transport the rest of the player's party,
// only their henchman, summoned, dominated, etc.
void TransportToLocation(object oPC, location oLoc)
{
    // Jump the PC
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToLocation(oLoc));

    // Not a PC, so has no associates
    if (!GetIsPC(oPC))
        return;

    // Get all the possible associates of this PC
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);
    object oDomin = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
    object oFamil = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    object oAnimalComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);

    // Jump any associates
    if (GetIsObjectValid(oHench)) {
        AssignCommand(oHench, ClearAllActions());
        AssignCommand(oHench, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oDomin)) {
        AssignCommand(oDomin, ClearAllActions());
        AssignCommand(oDomin, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oFamil)) {
        AssignCommand(oFamil, ClearAllActions());
        AssignCommand(oFamil, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oSummon)) {
        AssignCommand(oSummon, ClearAllActions());
        AssignCommand(oSummon, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oAnimalComp)) {
        AssignCommand(oAnimalComp, ClearAllActions());
        AssignCommand(oAnimalComp, JumpToLocation(oLoc));
    }
}


// Transport an entire party with all associates to a waypoint.
void TransportAllToWaypoint(object oPC, object oWaypoint)
{
    if (!GetIsObjectValid(oWaypoint)) {
        return;
    }
    TransportAllToLocation(oPC, GetLocation(oWaypoint));
}

// Transport an entire party with all associates to a location.
void TransportAllToLocation(object oPC, location oLoc)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        TransportToLocation(oPartyMem, oLoc);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    TransportToLocation(oPC, oLoc);
}

