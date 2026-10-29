//:://////////////////////////////////////////////////
//:: X0_I0_ANIMS
/*

  Library for playing random animations.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////

// Library for positioning
#include "x0_i0_position"

// Library for stealth/detect modes
#include "x0_i0_modes"

// Library for Voiceset functionality. All voice calls go through here
#include "x0_i0_voice"

// Library for walkways (need to pass it this way to get access to ClearActiosn in x0_i0_assoc
#include "x0_i0_walkway"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Animation length and speed
const float ANIM_LOOPING_LENGTH = 4.0;
const float ANIM_LOOPING_SPEED = 1.0;

// Conversation file that holds the random one-liners for
// NPCs to speak when a PC comes into their home.
const string ANIM_CONVERSATION = "x0_npc_homeconv";

// Variable that holds the animation flags
const string sAnimCondVarname = "NW_ANIM_CONDITION";

// ***  Available animation flags  *** //

// If set, the NPC has been initialized
const int NW_ANIM_FLAG_INITIALIZED             = 0x00000001;

// If set, the NPC will animate on every OnHeartbeat event.
// Otherwise, the NPC will animate only on every OnPerception event.
const int NW_ANIM_FLAG_CONSTANT                = 0x00000002;

// If set, the NPC will use voicechats
const int NW_ANIM_FLAG_CHATTER                 = 0x00000004;

// If set, the NPC has been triggered and should be animating
const int NW_ANIM_FLAG_IS_ACTIVE               = 0x00000008;

// If set, the NPC is currently interacting with a placeable
const int NW_ANIM_FLAG_IS_INTERACTING          = 0x00000010;

// If set, the NPC has gone inside an interior area.
const int NW_ANIM_FLAG_IS_INSIDE               = 0x00000020;

// If set, the NPC has a home waypoint
const int NW_ANIM_FLAG_HAS_HOME                = 0x00000040;

// If set, the NPC is currently talking
const int NW_ANIM_FLAG_IS_TALKING              = 0x00000080;

// If set, the NPC is mobile
const int NW_ANIM_FLAG_IS_MOBILE               = 0x00000100;

// If set, the NPC is mobile in a close-range
const int NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE   = 0x00000200;

// If set, the NPC is civilized
const int NW_ANIM_FLAG_IS_CIVILIZED            = 0x00000400;

// If set, the NPC will close doors
const int NW_ANIM_FLAG_CLOSE_DOORS                             = 0x00001000;

// int NW_ANIM_FLAG_                        = 0x00000000;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Debugging function. Will be commented out for final.
void AnimDebug(string sMsg);

// TRUE if the given creature has the given condition set
int GetAnimationCondition(int nCondition, object oCreature=OBJECT_SELF);

// Mark that the given creature has the given condition set
void SetAnimationCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF);

// Returns TRUE if the creature is busy talking or interacting
// with a placeable.
int GetIsBusyWithAnimation(object oCreature);

// Get a random nearby friend.
// OBJECT_INVALID will be returned if the friend is a PC,
// is busy with another animation, is in conversation or combat,
// or is further away than the distance limit.
//
object GetRandomFriend(float fMaxDistance);

// Get a random nearby object within the specified distance with
// the specified tag.
object GetRandomObjectByTag(string sTag, float fMaxDistance);

// Get a random nearby object within the specified distance with
// the specified type.
// nObjType: Any of the OBJECT_TYPE_* constants
object GetRandomObjectByType(int nObjType, float fMaxDistance);

// Get a random "NW_STOP" object in the area.
// If fMaxDistance is non-zero, will return OBJECT_INVALID
// if the stop is too far away.
// The first time this is called in a given area, it cycles
// through all the stops in the area and stores them.
object GetRandomStop(float fMaxDistance);

// Check for a waypoint marked NW_HOME in the area; if it
// exists, mark it as the caller's home waypoint.
void SetCreatureHomeWaypoint();

// Get a creature's home waypoint; returns OBJECT_INVALID if none set.
object GetCreatureHomeWaypoint();

// Set a specific creature (or OBJECT_INVALID to clear) as the caller's "friend"
void SetCurrentFriend(object oFriend);

// Get the caller's current friend, if set; OBJECT_INVALID otherwise
object GetCurrentFriend();

// Set an object (or OBJECT_INVALID to clear) as the caller's interactive
// target.
void SetCurrentInteractionTarget(object oTarget);

// Get the caller's current interaction target, if set; OBJECT_INVALID otherwise
object GetCurrentInteractionTarget();

// Mark the caller as civilized based on its racialtype.
// This will not unset the NW_ANIM_FLAG_IS_CIVILIZED flag
// if it was set outside.
void CheckIsCivilized();

// Check to see if we should switch on detect/stealth mode
void CheckCurrentModes();

// Check if the creature should be active and turn off if not,
// returning FALSE. This respects the NW_ANIM_FLAG_CONSTANT
// setting.
int CheckIsAnimActive(object oCreature);

// Check to see if we're in the middle of some action
// so we don't interrupt or pile actions onto the queue.
// Returns TRUE if in the middle of an action, FALSE otherwise.
int CheckCurrentAction();

// General initialization for animations.
// Called from all the Play_* functions.
void AnimInitialization();

/**********************************************************************
 * MASTER ANIMATION FUNCTIONS
 * These are the functions called from OnSpawn/OnHeartbeat scripts
 * based on the appropriate spawn-in conditions.
 **********************************************************************/

// This function should be used for mobile NPCs and monsters
// other than avian ones. It should be called by the creature
// that you want to perform the animations.
//
// Creatures will move randomly between objects in their
// area that have the tag "NW_STOP". Injured creatures will
// go to the nearest "NW_SAFE" waypoint and rest there.
// If at any point a creature gets to an "NW_DETECT" or
// "NW_STEALTH" waypoint, they will toggle on/off detect or
// stealth mode as appropriate.
//
// Humanoid creatures will also perform the following actions
// (you can set the NW_ANIM_FLAG_IS_CIVILIZED flag in script
// on non-humanoid creatures to make them use these behaviors):
//
// Creatures who are spawned in an area with the "NW_HOME" tag
// will mark that area as their home, leave during the day,
// and return at night.
//
// Creatures who are spawned in an outdoor area (for instance,
// in city streets) will go inside areas that have one of the
// interior waypoints (NW_TAVERN, NW_SHOP), if those areas
// are connected by an unlocked door. They will come back out
// as well.
//
// Mobile creatures will also have all the behaviors of immobile
// creatures, just tending to move around more.
//
void PlayMobileAmbientAnimations_NonAvian();

// Avian creatures will fly around randomly.
void PlayMobileAmbientAnimations_Avian();

// This function should be used for any NPCs that should
// not move around. It should be called by the creature
// that you want to perform the animations.
//
// Creatures who call this function will never leave the
// area they spawned in.
//
// Injured creatures will rest at their starting location.
//
// Creatures who have the NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE
// flag set will move around slightly within the area.
// Creatures in an area with an "interior" waypoint (NW_HOME,
// NW_SHOP, NW_TAVERN) will be set to have this flag automatically.
//
// Close-range creatures will move around the area, frequently
// returning to their starting point, interacting with other
// creatures and placeables. They will visit NW_STOP waypoints
// in their immediate vicinity, and they will close opened doors.
//
// In all other cases, the creature will not move from its starting
// position. They will turn around randomly, turn to and 'talk' to
// other NPCs in their immediate vicinity, and interact with
// placeables in their immediate vicinity.
//
void PlayImmobileAmbientAnimations();

/**********************************************************************
 * ANIM ACTION FUNCTIONS
 * These functions are scripted, but they use the hardcoded "Action"
 * functions to enter activities into the action queue. They assume
 * that the caller is a valid creature.
 **********************************************************************/

// Perform a strictly immobile action.
// Includes:
// - play a random animation
// - turn towards a nearby unoccupied friend and 'talk'
// - turn towards a nearby placeable and interact
// - turn around randomly
void AnimActionPlayRandomImmobile();

// Perform a random close-range action.
// This will include:
// - go to a nearby placeable and interact with it
// - go to a nearby friend and interact with them
// - play a random animation
// - walk to a nearby 'NW_STOP' waypoint
// - close an open door and return
// - go back to starting position
// - fall through to ActionPlayRandomImmobile
void AnimActionPlayRandomCloseRange();

// Perform a mobile action.
// Includes:
// - walk to an 'NW_STOP' waypoint in the area
// - walk to an area door and possibly go inside
// - go outside if previously went inside
// - fall through to ActionPlayRandomCloseRange
void AnimActionPlayRandomMobile();

// Perform a mobile action for an uncivilized creature.
// Includes:
// - perform random limited animations
// - walk to an 'NW_STOP' waypoint in the area
// - random walk if none available
void AnimActionPlayRandomUncivilized();

// Start interacting with a placeable object
void AnimActionStartInteracting(object oPlaceable);

// Stop interacting with a placeable object
void AnimActionStopInteracting();

// Start talking with a friend
void AnimActionStartTalking(object oFriend, int nHDiff=0);

// Stop talking to the given friend
void AnimActionStopTalking(object oFriend, int nHDiff=0);

// Play a greeting animation and possibly voicechat.
// If a negative difference is passed in, caller will bow.
void AnimActionPlayRandomGreeting(int nHDiff);

// Play a random farewell animation and possibly voicechat.
// If a negative difference is passed in, caller will bow.
void AnimActionPlayRandomGoodbye(int nHDiff);

// Randomly move away from an object the specified distance.
// This is mainly because ActionMoveAwayFromLocation isn't working.
void AnimActionRandomMoveAway(object oSource, float fDistance);

// Play animation of shaking head "no" to left and right
void AnimActionShakeHead();

// Play animation of looking around to left and right
void AnimActionLookAround();

// Turn around to face a random direction
void AnimActionTurnAround();

// Interact with a placeable object.
// This will activate/deactivate the placeable object if a valid
// one is passed in.
// KLUDGE: If a placeable object without an inventory should
//         still be opened/shut instead of de/activated, set
//         its Will Save to 1.
void AnimActionPlayRandomInteractAnimation(object oPlaceable);

// Play a random talk gesture animation.
// If a hit dice difference (should be the hit dice of the talker
// minus the hit dice of the person being talked to) is passed in,
// slightly different animations will play based on this.
void AnimActionPlayRandomTalkAnimation(int nHDiff);

// Play a random animation that all creatures should have.
// This is a very small set.
// Currently only has: get mid, taunt
void AnimActionPlayRandomBasicAnimation();

// Play a random animation.
// This animation will be chosen from a different set
// based on whether a special waypoint or placeable
// is in the vicinity.
void AnimActionPlayRandomAnimation();


/**********************************************************************
 * The following AnimAction functions are special, because they may fail
 * (for instance, AnimActionsSitInChair() will only work if an actual
 * chair object was found to sit in).
 *
 * They all return TRUE on success, FALSE on failure. This allows for
 * trying an action and doing something else if it failed.
 *
 * Unfortunately, that means they cannot be easily used with
 * DelayCommand / AssignAction, but the tradeoff is worth it, IMO.
 **********************************************************************/


// If there's an open door nearby, possibly go close it,
// then come back to our current spot.
// Returns TRUE on success, FALSE on failure.
int AnimActionCloseRandomDoor();

// Sit in a random nearby chair if available.
// Looks for items with tag: NW_SEAT
// Returns TRUE on success, FALSE on failure.
int AnimActionSitInChair(float fMaxDistance);

// Get up from a chair if we're sitting.
// Returns TRUE on success, FALSE on failure.
int AnimActionGetUpFromChair();

// Go through a nearby door if appropriate.
// This will be done if the door is unlocked and
// the area the door leads to contains a waypoint
// with one of these tags:
//             NW_TAVERN, NW_SHOP
// Returns TRUE on success, FALSE on failure.
int AnimActionGoInside();

// Leave area if appropriate.
// This only works for NPCs that entered an area that
// has a waypoint with one of these tags:
//             NW_TAVERN, NW_SHOP
// If the NPC entered through a door, they will exit through
// that door.
// Returns TRUE on success, FALSE on failure.
int AnimActionGoOutside();

// Go to a nearby waypoint or placeable marked with the
// tag "NW_STOP".
// Returns TRUE on success, FALSE on failure.
int AnimActionGoToStop(float fMaxDistance=20.0);

// Find a friend within the given distance and talk to them.
// Returns TRUE on success, FALSE on failure.
int AnimActionFindFriend(float fMaxDistance);

// Find a placeable within the given distance and interact
// with it.
// Returns TRUE on success, FALSE on failure.
int AnimActionFindPlaceable(float fMaxDistance);

// If injured and mobile, find the nearest NW_SAFE waypoint,
// go to it, and rest. If injured and immobile, go to starting
// location if not already there, and rest.
// Returns TRUE on success, FALSE on failure.
int AnimActionRest();

// If it is night, go back to our home waypoint, if we have one.
// This is only meaningful for mobile NPCs who would have left
// their homes during the day.
// Returns TRUE on success, FALSE on failure.
int AnimActionGoHome();

// If it is day, leave our home area, if we have one.
// This is only meaningful for mobile NPCs.
// Returns TRUE on success, FALSE on failure.
int AnimActionLeaveHome();

// If a PC is in the NPC's home and has not been challenged before,
// challenge them.
// This involves speaking a one-liner conversation from the
// conversation file ANIM_CONVERSATION, set above.
int AnimActionChallengeIntruder();


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Debugging function. Will be commented out for final.
void AnimDebug(string sMsg)
{
    //ActionSpeakString("ANIM: " + GetName(OBJECT_SELF) + " " + sMsg);
    //PrintString("ANIM: " + GetName(OBJECT_SELF) + ": " + sMsg);
}

// TRUE if the given creature has the given condition set
int GetAnimationCondition(int nCondition, object oCreature=OBJECT_SELF)
{
    return (GetLocalInt(oCreature, sAnimCondVarname) & nCondition);
}

// Mark that the given creature has the given condition set
void SetAnimationCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oCreature, sAnimCondVarname);
    if (bValid) {
        SetLocalInt(oCreature, sAnimCondVarname, nCurrentCond | nCondition);
    } else {
        SetLocalInt(oCreature, sAnimCondVarname, nCurrentCond & ~nCondition);
    }
}

// Returns TRUE if the creature is busy talking or interacting
// with a placeable.
int GetIsBusyWithAnimation(object oCreature)
{
    int bReturn = GetAnimationCondition(NW_ANIM_FLAG_IS_TALKING, oCreature)
        || GetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING, oCreature)
        || GetCurrentAction(oCreature) != ACTION_INVALID;

//    if (bReturn == TRUE)     AssignCommand(oCreature, SpeakString("Busy with anim"));
    return bReturn;
}

// Get a random nearby friend within the specified distance limit,
// that isn't busy doing something else.
object GetRandomFriend(float fMaxDistance)
{
    object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                        REPUTATION_TYPE_FRIEND,
                                        OBJECT_SELF, d2(),
                                        CREATURE_TYPE_PERCEPTION,
                                        PERCEPTION_SEEN);

    if (GetIsObjectValid(oFriend)
        && !GetIsPC(oFriend)
        //&& !GetIsBusyWithAnimation(oFriend) BK Feb 2003: There's not enough talking happening
        && GetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE, oFriend)
        && !IsInConversation(oFriend)
        && !GetIsInCombat(oFriend)
        && GetDistanceToObject(oFriend) <= fMaxDistance)
    {
        return oFriend;
    }

    return OBJECT_INVALID;
}

// Get a random nearby object within the specified distance with
// the specified tag.
object GetRandomObjectByTag(string sTag, float fMaxDistance)
{
    int nNth;
    if (fMaxDistance == DISTANCE_SHORT) {
        nNth = d2();
    } else if (fMaxDistance == DISTANCE_MEDIUM) {
        nNth = d4();
    } else {
        nNth = d6();
    }
    object oObj = GetNearestObjectByTag(sTag, OBJECT_SELF, nNth);
    if (GetIsObjectValid(oObj) && GetDistanceToObject(oObj) <= fMaxDistance)
        return oObj;
    return OBJECT_INVALID;
}

// Get a random nearby object within the specified distance with
// the specified type.
// nObjType: Any of the OBJECT_TYPE_* constants
object GetRandomObjectByType(int nObjType, float fMaxDistance)
{
    int nNth;
    if (fMaxDistance == DISTANCE_SHORT) {
        nNth = d2();
    } else if (fMaxDistance == DISTANCE_LARGE) {
        nNth = d4();
    } else {
        nNth = d6();
    }
    //AnimDebug("looking for random object: " + IntToString(nNth));
    object oObj = GetNearestObject(nObjType, OBJECT_SELF, nNth);
    if (GetIsObjectValid(oObj) && GetDistanceToObject(oObj) <= fMaxDistance)
        return oObj;
    return OBJECT_INVALID;
}

// Get a random "NW_STOP" object in the area.
// If fMaxDistance is non-zero, will return OBJECT_INVALID
// if the stop is too far away.
// The first time this is called in a given area, it cycles
// through all the stops in the area and stores them.
object GetRandomStop(float fMaxDistance)
{
    object oStop;
    object oArea = GetArea(OBJECT_SELF);
    if (! GetLocalInt(oArea, "ANIM_STOPS_INITIALIZED") ) {
        //AnimDebug("Initializing stops in area " + GetName(oArea));
        // first time -- look up all the stops in the area and store them
        int nNth = 1;
        oStop = GetNearestObjectByTag("NW_STOP");
        while (GetIsObjectValid(oStop)) {
            //AnimDebug("Stop found");
            SetLocalObject(oArea, "ANIM_STOP_" + IntToString(nNth), oStop);
            nNth++;
            oStop = GetNearestObjectByTag("NW_STOP", OBJECT_SELF, nNth);
        }
        SetLocalInt(oArea, "ANIM_STOPS", nNth-1);
        SetLocalInt(oArea, "ANIM_STOPS_INITIALIZED", TRUE);
    }

    int nStop = Random(GetLocalInt(oArea, "ANIM_STOPS")) + 1;
    oStop = GetLocalObject(oArea, "ANIM_STOP_" + IntToString(nStop));
    //AnimDebug("Stop: " + IntToString(nStop)
    //            + ": " + GetTag(oStop)
    //            + ": " + FloatToString(GetDistanceToObject(oStop)));
    if (GetIsObjectValid(oStop) && GetDistanceToObject(oStop) <= fMaxDistance)
        return oStop;
    return OBJECT_INVALID;
}

// Check for a waypoint marked NW_HOME in the area; if it
// exists, mark it as the caller's home waypoint.
void SetCreatureHomeWaypoint()
{
    object oHome = GetNearestObjectByTag("NW_HOME");
    if (GetIsObjectValid(oHome)) {
        SetAnimationCondition(NW_ANIM_FLAG_HAS_HOME);
        SetLocalObject(OBJECT_SELF, "NW_ANIM_HOME", oHome);
    }
}

// Get a creature's home waypoint; returns OBJECT_INVALID if none set.
object GetCreatureHomeWaypoint()
{
    if (GetAnimationCondition(NW_ANIM_FLAG_HAS_HOME)) {
        return GetLocalObject(OBJECT_SELF, "NW_ANIM_HOME");
    }
    return OBJECT_INVALID;
}


// Set a specific creature (or OBJECT_INVALID to clear) as the caller's "friend"
void SetCurrentFriend(object oFriend)
{
    if (!GetIsObjectValid(oFriend)) {
        DeleteLocalObject(OBJECT_SELF, "NW_ANIM_FRIEND");
    } else {
        SetLocalObject(OBJECT_SELF, "NW_ANIM_FRIEND", oFriend);
    }
}

// Get the caller's current friend, if set; OBJECT_INVALID otherwise
object GetCurrentFriend()
{
    return GetLocalObject(OBJECT_SELF, "NW_ANIM_FRIEND");
}

// Set an object (or OBJECT_INVALID to clear) as the caller's interactive
// target.
void SetCurrentInteractionTarget(object oTarget)
{
    if (!GetIsObjectValid(oTarget)) {
        DeleteLocalObject(OBJECT_SELF, "NW_ANIM_TARGET");
    } else {
        SetLocalObject(OBJECT_SELF, "NW_ANIM_TARGET", oTarget);
    }
}

// Get the caller's current interaction target, if set; OBJECT_INVALID otherwise
object GetCurrentInteractionTarget()
{
    return GetLocalObject(OBJECT_SELF, "NW_ANIM_TARGET");
}


// Mark the caller as civilized based on its racialtype.
// This will not unset the NW_ANIM_FLAG_IS_CIVILIZED flag
// if it was set outside.
void CheckIsCivilized()
{
    int nRacialType = GetRacialType(OBJECT_SELF);
    switch (nRacialType) {
    case RACIAL_TYPE_ELF :
    case RACIAL_TYPE_GNOME :
    case RACIAL_TYPE_HALFELF :
    case RACIAL_TYPE_HALFLING :
    case RACIAL_TYPE_HALFORC :
    case RACIAL_TYPE_HUMAN :
    case RACIAL_TYPE_HUMANOID_GOBLINOID :
    case RACIAL_TYPE_HUMANOID_REPTILIAN :
    case RACIAL_TYPE_HUMANOID_ORC:
        SetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED);
    }
}

// Check to see if we should switch on detect/stealth mode
void CheckCurrentModes()
{
    //wSpeakString("running check current modes");
    object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT);
    string sTag = GetTag(oWay);
    if (sTag == "NW_STEALTH")
    {
        if (GetModeActive(NW_MODE_STEALTH))
        {
            // turn off stealth mode
            SetModeActive(NW_MODE_STEALTH, FALSE);
        }
        else
        {
            // turn on stealth mode
            SetModeActive(NW_MODE_STEALTH);
        }
    }
    else if (sTag == "NW_DETECT")
    {
        if (GetModeActive(NW_MODE_DETECT))
        {
            // turn off detect mode
            SetModeActive(NW_MODE_DETECT);
        }
        else
        {
            // turn on detect mode
            SetModeActive(NW_MODE_DETECT);
        }
    }
}


// Check if the creature should be active and turn off if not,
// returning FALSE. This respects the NW_ANIM_FLAG_CONSTANT
// setting.
int CheckIsAnimActive(object oCreature)
{
    // Unless we're set to be constant, turn off if there's
    // no PC in the area
    if ( ! GetAnimationCondition(NW_ANIM_FLAG_CONSTANT)) {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                        PLAYER_CHAR_IS_PC);
        if ( !GetIsObjectValid(oPC) || GetArea(oPC) != GetArea(OBJECT_SELF)) {
            // turn off
            SetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE, FALSE);
            return FALSE;
        }
    }
    return TRUE;
}


// Check to see if we're in the middle of some action
// so we don't interrupt or pile actions onto the queue.
// Returns TRUE if in the middle of an action, FALSE otherwise.
int CheckCurrentAction()
{
    int nAction = GetCurrentAction();
    if (nAction == ACTION_SIT) {
        // low prob of getting up, so we don't bop up and down constantly
        if (Random(10) == 0) {
            AnimActionGetUpFromChair();
        }
        return TRUE;
    } else if (nAction != ACTION_INVALID) {
        // we're doing *something*, don't switch
        //AnimDebug("performing action");
        return TRUE;
    }
    return FALSE;
}

// General initialization for animations.
// Called from all the Play_* functions.
void AnimInitialization()
{
    // If we've been set to be constant, flag us as
    // active.
    // if (GetAnimationCondition(NW_ANIM_FLAG_CONSTANT))
    SetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE);

    // Set our home, if we have one
    SetCreatureHomeWaypoint();

    // Mark whether we're civilized or not
    CheckIsCivilized();

    SetAnimationCondition(NW_ANIM_FLAG_INITIALIZED);

}

// This function should be used for mobile NPCs and monsters
// other than avian ones. It should be called by the creature
// that you want to perform the animations.
//
// Creatures will interact with each other and move around,
// possibly even moving between areas.
//
// Creatures who are spawned in an area with the "NW_HOME" tag
// will mark that area as their home, leave from the nearest
// door during the day, and return at night.
//
// Injured creatures will go to the nearest "NW_SAFE" waypoint
// in their immediate area and rest there.
//
// If at any point the nearest waypoint is "NW_DETECT" or
// "NW_STEALTH", the creature will toggle search/stealth mode
// respectively.
//
// Creatures who are spawned in an outdoor area (for instance,
// in city streets) will go inside areas that have one of the
// interior waypoints (NW_TAVERN, NW_SHOP), if those areas
// are connected by an unlocked door. They will come back out
// as well.
//
// Creatures will also move randomly between objects in their
// area that have the tag "NW_STOP".
//
// Mobile creatures will have all the same behaviors as immobile
// creatures, just tending to move around more.
void PlayMobileAmbientAnimations_NonAvian()
{

    if (!GetAnimationCondition(NW_ANIM_FLAG_INITIALIZED)) {
        // General initialization
        AnimInitialization();

        // Mark us as mobile
        SetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE);
    }

    // Short-circuit everything if we're not active yet
    if (!GetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE))
        return;
    //AnimDebug("currently active");

    // Check if we should turn off
    if (!CheckIsAnimActive(OBJECT_SELF))
        return;

    //AnimDebug("staying active");

    //SpawnScriptDebugger();
    int nCurrentAction = GetCurrentAction();

    // Check current actions so we don't interrupt something in progress
    // Feb 14 2003: Because of the random walkthere needs to be a chance
    //  to stop walking.
    // May 26 2004: Added ACTION_RANDOMWALK to the exclusion list.
    if (CheckCurrentAction() && (nCurrentAction != ACTION_MOVETOPOINT)&& (nCurrentAction != ACTION_WAIT) && (nCurrentAction != ACTION_RANDOMWALK)) {
        return;
    }

    // Go someplace safe and rest if we are hurt
    if (AnimActionRest()) {
        //AnimDebug("resting");
        return;
    }

    // Check if current modes should change
    CheckCurrentModes();
    //UseStealthMode();
    //UseDetectMode();

    int bIsCivilized = GetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED);
    if (bIsCivilized)
    {


        // Challenge an intruding PC
        if (AnimActionChallengeIntruder()) {
            return;
        }

        // Check if we should go home
        if (AnimActionGoHome()) {
            //AnimDebug("going home");
            return;
        }

        // Check if we should leave home
        if (AnimActionLeaveHome()) {
            //AnimDebug("leaving home");
            return;
        }

        // Otherwise, do something random
        AnimActionPlayRandomMobile();
    } else
    {
        //AnimDebug("uncivilized");
        AnimActionPlayRandomUncivilized();
    }
}

// Avian creatures will fly around randomly.
void PlayMobileAmbientAnimations_Avian()
{
    int nRoll = d4();
    object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                        REPUTATION_TYPE_FRIEND,
                                        OBJECT_SELF,
                                        nRoll,
                                        CREATURE_TYPE_PERCEPTION,
                                        PERCEPTION_SEEN);

    ClearActions(CLEAR_X0_I0_ANIMS_PlayMobile);
    if(GetIsObjectValid(oFriend)) {
        int nBird = d4();
        if(nBird == 1) {
            ActionMoveToObject(oFriend, TRUE);
        } else if (nBird == 2 || nBird == 3) {
            AnimActionRandomMoveAway(oFriend, 100.0);
        } else {
            effect eBird = EffectDisappearAppear(GetLocation(oFriend));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBird, OBJECT_SELF, 4.0);
            AnimActionRandomMoveAway(oFriend, 100.0);
        }
    } else {
        ActionRandomWalk();
    }
}

// This function should be used for any NPCs that should
// not move around. It should be called by the creature
// that you want to perform the animations.
//
// Creatures who call this function will never leave the
// area they spawned in.
//
// Injured creatures will rest at their starting location.
//
// Creatures who have the NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE
// flag set will move around slightly within the area.
// Creatures in an area with an "interior" waypoint (NW_HOME,
// NW_SHOP, NW_TAVERN) will be set to have this flag automatically.
//
// Close-range creatures will move around the area, frequently
// returning to their starting point, interacting with other
// creatures and placeables. They will visit NW_STOP waypoints
// in their immediate vicinity, and they will close opened doors.
//
// In all other cases, the creature will not move from its starting
// position. They will turn around randomly, turn to and 'talk' to
// other NPCs in their immediate vicinity, and interact with
// placeables in their immediate vicinity.
//
void PlayImmobileAmbientAnimations()
{
    if (!GetAnimationCondition(NW_ANIM_FLAG_INITIALIZED)) {
        // General initialization
        AnimInitialization();

        // if we are at home, make us mobile in close-range
        if (GetIsObjectValid(GetCreatureHomeWaypoint())) {
            SetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE);
        }

        // also save our starting location
        SetLocalLocation(OBJECT_SELF,
                         "ANIM_START_LOCATION",
                         GetLocation(OBJECT_SELF));
    }

    // Short-circuit everything if we're not active yet
    if (!GetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE))
        return;

    //AnimDebug("currently active");

    // Check if we should turn off
    if (!CheckIsAnimActive(OBJECT_SELF))
        return;

    //AnimDebug("staying active");

    // Check current actions so we don't interrupt something in progress
    if (CheckCurrentAction()) {
        return;
    }

    // First check: go back to starting position and rest if we are hurt
    if (AnimActionRest()) {
        //AnimDebug("resting");
        return;
    }

    // Check if current modes should change
    CheckCurrentModes();


    // Challenge an intruding PC
    if (AnimActionChallengeIntruder()) {
        return;
    }

    int bIsCivilized = GetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED);

    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE)) {
        //AnimDebug("close range");
        AnimActionPlayRandomCloseRange();
    } else {
        //AnimDebug("immobile");
        AnimActionPlayRandomImmobile();
    }
}


// Perform a strictly immobile action.
// Includes:
// - turn towards a nearby unoccupied friend and 'talk'
// - turn towards a nearby placeable and interact
// - turn around randomly
// - play a random animation
void AnimActionPlayRandomImmobile()
{
    int nRoll = Random(12);

    //SpawnScriptDebugger();


    // If we're talking, either keep going or stop.
    // Low prob of stopping, since both parties have
    // a chance and conversations are cool.
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_TALKING)) {
        object oFriend = GetCurrentFriend();
        int nHDiff = GetHitDice(OBJECT_SELF) - GetHitDice(oFriend);

        if (nRoll == 0) {
            AnimActionStopTalking(oFriend, nHDiff);
        } else {
            AnimActionPlayRandomTalkAnimation(nHDiff);
        }
        return;
    }

    // If we're interacting with a placeable, either keep going or
    // stop. High probability of stopping, since looks silly to
    // constantly turn something on-and-off.
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING)) {
        if (nRoll < 4) {
            AnimActionStopInteracting();
        } else {
            AnimActionPlayRandomInteractAnimation(GetCurrentInteractionTarget());
        }
        return;
    }

    // If we got here, we're not busy at the moment.

    // Clean out the action queue
    ClearActions(CLEAR_X0_I0_ANIMS_PlayRandomMobile);
    if (nRoll <=9) {
        if (AnimActionFindFriend(DISTANCE_LARGE))
            return;
    }

    if (nRoll > 9) {
        // Try and interact with a nearby placeable
        if (AnimActionFindPlaceable(DISTANCE_SHORT))
            return;
    }

    // Default: clear our action queue and play a random animation
    if ( nRoll < 5 ) {
        // Turn around and play a random animation

        // BK Feb 2003: I got rid of this because I've never seen it look appropriate
        // it always looks out of place and unrealistic
       AnimActionTurnAround();
        AnimActionPlayRandomAnimation();
    } else {
        // Just play a random animation
        AnimActionPlayRandomAnimation();
    }
}

// Perform a random close-range action.
// This will include:
// - any of the immobile actions
// - close any nearby doors, then return to current position
// - go to a nearby placeable and interact with it
// - go to a nearby friend and interact with them
// - walk to a nearby 'NW_STOP' waypoint
// - going back to starting point
void AnimActionPlayRandomCloseRange()
{
    if (GetIsBusyWithAnimation(OBJECT_SELF)) {
        // either we're already in conversation or
        // interacting with something, so continue --
        // all handled already in RandomImmobile.
        AnimActionPlayRandomImmobile();
        return;
    }

    // If we got here, we're not busy

    // Clean out the action queue
    ClearActions(CLEAR_X0_I0_ANIMS_PlayRandomCloseRange1);

    // Possibly close open doors
    if (GetAnimationCondition(NW_ANIM_FLAG_CLOSE_DOORS) && AnimActionCloseRandomDoor()) {
        return;
    }

    // For the rest of these, we check for specific rolls,
    // to ensure that we don't do a lot of lookups on any one
    // given pass.

    int nRoll = Random(6);

    // Possibly start talking to a friend
    if (nRoll == 0 || nRoll == 1) {
        if (AnimActionFindFriend(DISTANCE_LARGE))
            return;
        // fall through to default
    }

    // Possibly start fiddling with a placeable
    if (nRoll == 2) {
        if (AnimActionFindPlaceable(DISTANCE_LARGE))
            return;
        // fall through if no placeable found
    }

    // Possibly sit down
    if (nRoll == 3) {
        if (AnimActionSitInChair(DISTANCE_LARGE))
            return;
    }

    // Go to a nearby stop
    if (nRoll == 4) {
        if (AnimActionGoToStop(DISTANCE_LARGE)) {
            return;
        }

        // No stops, so do a random walk and then come back
        // to our current location
        ClearActions(CLEAR_X0_I0_ANIMS_PlayRandomCloseRange2);
        location locCurr = GetLocation(OBJECT_SELF);
        ActionRandomWalk();
        ActionMoveToLocation(locCurr);
    }

    if (nRoll == 5 && !GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE)) {
        // Move back to starting point, saved at initialization
        ActionMoveToLocation(GetLocalLocation(OBJECT_SELF,
                                              "ANIM_START_LOCATION"));
        return;
    }

    // Default: do a random immobile animation
    AnimActionPlayRandomImmobile();
}

// Perform a mobile action.
// Includes:
// - walk to an 'NW_STOP' waypoint in the area
// - walk to an area door and possibly go inside
// - go outside if previously went inside
// - fall through to AnimActionPlayRandomCloseRange
void AnimActionPlayRandomMobile()
{
    if (GetIsBusyWithAnimation(OBJECT_SELF)) {
        // either we're already in conversation or
        // interacting with something, so continue --
        // all handled already in RandomImmobile.
        AnimActionPlayRandomImmobile();
        return;
    }

    // If we got here, we're not busy

    // Clean out the action queue
    ClearActions(CLEAR_X0_I0_ANIMS_AnimActionPlayRandomMobile1);

    int nRoll = Random(9);

    if (nRoll == 0) {
        // If we're inside, possibly leave
        if (AnimActionGoOutside())
            return;
    }

    if (nRoll == 1) {
        // Possibly go into an interior area
        if (AnimActionGoInside())
            return;
    }

    // If we fell through or got a random number
    // less than 7, go to a stop waypoint, or random
    // walk if no stop waypoints were found.
    if (nRoll < 5) {
        // Pass in a huge number so any stop will be valid
        if (AnimActionGoToStop(1000.0))
            return;

        // If no stops, do a random walk
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionPlayRandomMobile2);
        ActionRandomWalk();
        return;
    }

    // Default: do something close-range
//    AnimActionPlayRandomCloseRange();

    // MODIFIED February 14 2003. Will play an immobile animation, if nothing else found to do

    PlayImmobileAmbientAnimations();
}

// Perform a mobile action for an uncivilized creature.
// Includes:
// - perform random limited animations
// - walk to an 'NW_STOP' waypoint in the area
// - random walk if none available
void AnimActionPlayRandomUncivilized()
{
    int nRoll = Random(6);

    if (nRoll != 5) {
        if (AnimActionGoToStop(1000.0))
            return;
        // no stops, so random walk
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionPlayRandomUncivilized);
        ActionRandomWalk();
    }

    // Play one of our few random animations
    AnimActionPlayRandomBasicAnimation();
}

/**********************************************************************
 **********************************************************************
 * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE
 * The functions below here are building blocks used in the main
 * functions above.
 * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE
 **********************************************************************
 **********************************************************************/


// Start interacting with a placeable object
void AnimActionStartInteracting(object oPlaceable)
{
    SetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING);

    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE)
        || GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE))
    {
        ActionMoveToObject(oPlaceable, FALSE, DISTANCE_TINY);
    }
    ActionDoCommand(SetFacingPoint(GetPosition(oPlaceable)));
    SetCurrentInteractionTarget(oPlaceable);

    AnimActionPlayRandomInteractAnimation(oPlaceable);
}

// Stop interacting with a placeable object
void AnimActionStopInteracting()
{
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE)) {
        AnimActionRandomMoveAway(GetCurrentInteractionTarget(), DISTANCE_LARGE);
    }
    SetCurrentInteractionTarget(OBJECT_INVALID);

    SetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING, FALSE);

    AnimActionTurnAround();
    AnimActionPlayRandomAnimation();
}

// Start talking with a friend
void AnimActionStartTalking(object oFriend, int nHDiff=0)
{
    //AnimDebug("started talking to " + GetName(oFriend));
    object oMe = OBJECT_SELF;

    // Say hello and move to each other if we're not immobile
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE)
        || GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE))
    {
        ActionMoveToObject(oFriend, FALSE, DISTANCE_TINY);
        AnimActionPlayRandomGreeting(nHDiff);
    }
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE, oFriend)
        || GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE, oFriend))
    {
        AssignCommand(oFriend,
                      ActionMoveToObject(oMe, FALSE, DISTANCE_TINY));
        AssignCommand(oFriend, AnimActionPlayRandomGreeting(0 - nHDiff));
    }

    SetCurrentFriend(oFriend);
    AssignCommand(oFriend, SetCurrentFriend(oMe));
    ActionDoCommand(SetFacingPoint(GetPosition(oFriend)));
    AssignCommand(oFriend, ActionDoCommand(SetFacingPoint(GetPosition(oMe))));
    SetAnimationCondition(NW_ANIM_FLAG_IS_TALKING);
    SetAnimationCondition(NW_ANIM_FLAG_IS_TALKING, TRUE, oFriend);
}

// Stop talking to the given friend
void AnimActionStopTalking(object oFriend, int nHDiff=0)
{
    //AnimDebug("stopped talking to " + GetName(oFriend));
    object oMe = OBJECT_SELF;

    // Say goodbye and move away if we're not immobile
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE)) {
        AnimActionPlayRandomGoodbye(nHDiff);
        AnimActionRandomMoveAway(oFriend, DISTANCE_LARGE);
    } else {
        AnimActionTurnAround();
        AnimActionPlayRandomAnimation();
    }

    if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE, oFriend)) {
        AssignCommand(oFriend, AnimActionPlayRandomGoodbye(0 - nHDiff));
        AssignCommand(oFriend,
                      AnimActionRandomMoveAway(oMe, DISTANCE_HUGE));
    } else {
        AssignCommand(oFriend, AnimActionTurnAround());
        AssignCommand(oFriend, AnimActionPlayRandomAnimation());
    }

    SetAnimationCondition(NW_ANIM_FLAG_IS_TALKING, FALSE);
    SetAnimationCondition(NW_ANIM_FLAG_IS_TALKING, FALSE, oFriend);

}

// Play a greeting animation and possibly voicechat.
// If a negative hit dice difference (HD caller - HD greeted) is
// passed in, the caller will bow.
void AnimActionPlayRandomGreeting(int nHDiff=0)
{
    if (Random(2) == 0 && GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
        VoiceHello();
    }

    if (nHDiff < 0 || Random(4) == 0)
        ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);
    else
        ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
}

// Play a random farewell animation and possibly voicechat.
// If a negative hit dice difference is passed in, the
// caller will bow.
void AnimActionPlayRandomGoodbye(int nHDiff)
{
    if (Random(2) == 0 && GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
        VoiceGoodbye();
    }

    if (nHDiff < 0 || Random(4) == 0)
        ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);
    else
        ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
}

// Randomly move away from an object the specified distance.
// This is mainly because ActionMoveAwayFromLocation isn't working.
void AnimActionRandomMoveAway(object oSource, float fDistance)
{
    location lTarget = GetRandomLocation(GetArea(OBJECT_SELF),
                                         oSource,
                                         fDistance);

    ActionMoveToLocation(lTarget);
}

// Play animation of shaking head "no" to left & right
void AnimActionShakeHead()
{
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 3.0);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 3.0);
}

// Play animation of looking to left and right
void AnimActionLookAround()
{
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 0.75);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 0.75);
}

// Turn around to face a random direction
void AnimActionTurnAround()
{
// BK Feb 2003: This never looks good. Don't do it.
//    ActionDoCommand(SetFacing(IntToFloat(Random(360))));
}



// Go through a door and close it behind you,
// then walk a short distance away.
// This assumes the door exists, is unlocked, etc.
void AnimActionGoThroughDoor(object oDoor)
{
    //AnimDebug("going through door " + GetTag(oDoor));
    SetLocalInt(oDoor, "BEING_CLOSED", TRUE);
    object oDest = GetTransitionTarget(oDoor);
    ActionMoveToObject(oDest);
    ActionDoCommand(AssignCommand(oDest, ActionCloseDoor(oDest)));
    ActionDoCommand(AssignCommand(oDoor, ActionCloseDoor(oDoor)));
    ActionDoCommand(SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
    DelayCommand(10.0, SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
    AnimActionRandomMoveAway(oDest, DISTANCE_MEDIUM);
}

/**********************************************************************
 * The following AnimAction functions have a possibility of failing
 * and not assigning any actions.
 * They return TRUE on success, FALSE on failure. See notes up in the
 * prototype section for details.
 **********************************************************************/


// If there's an open door nearby, possibly go close it,
// then come back to our current spot.
int AnimActionCloseRandomDoor()
{
    if (Random(4) != 0) return FALSE;

    int nNth = 1;
    object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
    location locCurrent = GetLocation(OBJECT_SELF);
    while (GetIsObjectValid(oDoor)) {
        // make sure everyone doesn't run to close the same door
        if (GetIsOpen(oDoor) && !GetLocalInt(oDoor, "BEING_CLOSED")) {
            //AnimDebug("closing door: " + GetTag(oDoor));
            SetLocalInt(oDoor, "BEING_CLOSED", TRUE);
            ActionCloseDoor(oDoor);
            ActionDoCommand(SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
            ActionMoveToLocation(locCurrent);
            return TRUE;
        }// else {
         //   AnimDebug("closed or being closed: " + GetTag(oDoor));
        //}
        nNth++;
        oDoor = GetNearestObject(OBJECT_TYPE_DOOR, OBJECT_SELF, nNth);
    }
    return FALSE;
}

// Sit in a random nearby chair if available.
// Looks for items with tag: Chair
int AnimActionSitInChair(float fMaxDistance)
{
    object oChair = GetRandomObjectByTag("Chair", fMaxDistance);
    if (GetIsObjectValid(oChair) && !GetIsObjectValid(GetSittingCreature(oChair))) {
        ActionSit(oChair);
        SetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING);
        return TRUE;
    }
    return FALSE;
}

// Get up from a chair if we're sitting
int AnimActionGetUpFromChair()
{
    //AnimDebug("getting up from chair");
    if (GetCurrentAction() == ACTION_SIT) {
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionGetUpFromChair);
        SetAnimationCondition(NW_ANIM_FLAG_IS_INTERACTING, FALSE);
        AnimActionRandomMoveAway(GetNearestObject(OBJECT_TYPE_PLACEABLE), DISTANCE_SHORT);
        //AnimDebug("got up from chair");
        return TRUE;
    }
    return FALSE;
}

// Go through a nearby door if appropriate.
// This will be done if the door is unlocked and
// the area the door leads to contains a waypoint
// with one of these tags:
//             NW_TAVERN, NW_SHOP
int AnimActionGoInside()
{
    // Don't go inside a second area, since we'll never get
    // back to our original one if we do that.
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_INSIDE)) {
        //AnimDebug("is inside already");
        return FALSE;
    }

    object oDoor = GetRandomObjectByType(OBJECT_TYPE_DOOR, 1000.0);
    if (!GetIsObjectValid(oDoor) || GetLocked(oDoor)) {
        //AnimDebug("Failed to enter door: " + GetTag(oDoor));
        return FALSE;
    }

    object oDest = GetTransitionTarget(oDoor);
    //AnimDebug("Destination: " + GetTag(oDest));
    object oWay = GetNearestObjectByTag("NW_TAVERN", oDest);
    if (!GetIsObjectValid(oWay))
        oWay = GetNearestObjectByTag("NW_SHOP", oDest);
    if (GetIsObjectValid(oWay)) {
        //AnimDebug("Valid waypoint found: " + GetTag(oWay));
        AnimActionGoThroughDoor(oDoor);
        SetAnimationCondition(NW_ANIM_FLAG_IS_INSIDE);
        SetLocalObject(OBJECT_SELF, "NW_ANIM_DOOR", oDest);
        return TRUE;
    }

    return FALSE;
}

// Leave area if appropriate.
// This only works for NPCs that entered an area that
// has a waypoint with one of these tags:
//             NW_TAVERN, NW_SHOP
// If the NPC entered through a door, they will exit through
// that door.
int AnimActionGoOutside()
{
    if (GetAnimationCondition(NW_ANIM_FLAG_IS_INSIDE)) {
        object oDoor = GetLocalObject(OBJECT_SELF, "NW_ANIM_DOOR");
        if (GetIsObjectValid(oDoor)) {
            DeleteLocalObject(OBJECT_SELF, "NW_ANIM_DOOR");
            AnimActionGoThroughDoor(oDoor);
            SetAnimationCondition(NW_ANIM_FLAG_IS_INSIDE, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

// Go to a nearby waypoint or placeable marked with the
// tag "NW_STOP".
int AnimActionGoToStop(float fMaxDistance)
{
    object oStop = GetRandomStop(fMaxDistance);
    if (GetIsObjectValid(oStop)) {
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionGoToStop);
        ActionMoveToObject(oStop, FALSE, DISTANCE_SHORT);
        return TRUE;
    }
    return FALSE;
}

// Find a friend within the given distance and talk to them.
// Returns TRUE on success, FALSE on failure.
int AnimActionFindFriend(float fMaxDistance)
{
    // If we had a friend recently, make sure we don't start talking
    // again right away
//    if (GetIsObjectValid(GetCurrentFriend())) {
//        SetCurrentFriend(OBJECT_INVALID);
//    } else
   {
        // Try and find a friend to talk to
        object oFriend = GetRandomFriend(fMaxDistance);
        if (GetIsObjectValid(oFriend) && !GetIsBusyWithAnimation(oFriend)) {
            int nHDiff = GetHitDice(OBJECT_SELF) - GetHitDice(oFriend);
            AnimActionStartTalking(oFriend, nHDiff);
            return 1;
        }
    }
    return 0;
}

// Find a placeable within the given distance and interact
// with it.
// Returns TRUE on success, FALSE on failure.
int AnimActionFindPlaceable(float fMaxDistance)
{
    object oPlaceable = GetRandomObjectByTag("NW_INTERACTIVE", DISTANCE_SHORT);
    if (GetIsObjectValid(oPlaceable)) {
        AnimActionStartInteracting(oPlaceable);
        return 1;
    }
    return 0;
}

// If injured, find the nearest "NW_SAFE" object,
// go to it, and rest.
// Returns TRUE on success, FALSE on failure.
int AnimActionRest()
{
    if (GetCurrentHitPoints() < GetMaxHitPoints()) {
        object oSafe = GetNearestObjectByTag("NW_SAFE");
        if (GetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE) && GetIsObjectValid(oSafe)) {
            ClearActions(CLEAR_X0_I0_ANIMS_AnimActionRest1);
            ActionMoveToObject(oSafe);
            //ActionRest();
            return TRUE;
        } else {
            location lStart = GetLocalLocation(OBJECT_SELF, "ANIM_START_LOCATION");
            ClearActions(CLEAR_X0_I0_ANIMS_AnimActionRest2);
            ActionMoveToLocation(lStart);
            //ActionRest();
            return TRUE;
        }
    }
    return FALSE;
}

// If it is night, go back to our home waypoint, if we have one.
// This is only meaningful for mobile NPCs who would have left
// their homes during the day.
// Returns TRUE on success, FALSE on failure.
int AnimActionGoHome()
{
    object oHome = GetCreatureHomeWaypoint();
    if ( GetIsObjectValid(oHome) && !GetIsDay() && GetArea(OBJECT_SELF) != GetArea(oHome)) {
        ClearActions(CLEAR_X0_I0_ANIMS_GoHome);
        AnimActionGoOutside();
        AnimActionGoThroughDoor(GetLocalObject(OBJECT_SELF,
                                               "NW_ANIM_DOOR_HOME"));
        return TRUE;
    }
    return FALSE;
}

// If it is day, leave our home area, if we have one.
// This is only meaningful for mobile NPCs.
// Returns TRUE on success, FALSE on failure.
int AnimActionLeaveHome()
{
    object oHome = GetCreatureHomeWaypoint();
    if ( GetIsObjectValid(oHome) && GetIsDay() && GetArea(OBJECT_SELF) == GetArea(oHome)) {
        // Find the nearest door and walk out
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionLeaveHome);
        object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
        if (!GetIsObjectValid(oDoor) || GetLocked(oDoor))
            return FALSE;

        object oDest = GetTransitionTarget(oDoor);
        if (GetIsObjectValid(oDest)) {
            SetLocalObject(OBJECT_SELF, "NW_ANIM_DOOR_HOME", oDest);
            AnimActionGoThroughDoor(oDoor);
            return TRUE;
        }
    }
    return FALSE;
}


// If a PC is in the NPC's home and has not been challenged before,
// challenge them.
// This involves speaking a one-liner conversation from the
// conversation file ANIM_CONVERSATION, set above.
// Returns TRUE on success, FALSE on failure.
int AnimActionChallengeIntruder()
{
    object oHome = GetCreatureHomeWaypoint();
    if (GetIsObjectValid(oHome) && GetArea(OBJECT_SELF) == GetArea(oHome)) {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (GetIsObjectValid(oPC) && !GetLocalInt(OBJECT_SELF, GetName(oPC) + "_CHALLENGED")) {
            ClearActions(CLEAR_X0_I0_ANIMS_AnimActionChallengeIntruder);
            ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
            ActionDoCommand(SpeakOneLinerConversation(ANIM_CONVERSATION, oPC));
            SetLocalInt(OBJECT_SELF, GetName(oPC) + "_CHALLENGED", TRUE);
            return TRUE;
        }
    }
    return FALSE;
}


/**********************************************************************
 **********************************************************************
 * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE
 * The functions stuck below here are generally just big ugly
 * switch statements to choose between a bunch of random
 * animations.
 * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE * NOTE
 **********************************************************************
 **********************************************************************/

// Interact with a placeable object.
// This will activate/deactivate the placeable object if a valid
// one is passed in.
// KLUDGE: If a placeable object without an inventory should
//         still be opened/shut instead of de/activated, set
//         its Will Save to 1.
void AnimActionPlayRandomInteractAnimation(object oPlaceable)
{
    int nRoll = Random(5);

    if (nRoll == 0) {
        ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
        return;
    }

    // See where the placeable is in relation to us, height-wise
    vector vPos = GetPosition(oPlaceable);
    vector vMyPos = GetPosition(OBJECT_SELF);
    float fZDiff = vMyPos.z - vPos.z;
    if ( fZDiff > 0.0 ) {
        // we're above the placeable
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
                            ANIM_LOOPING_SPEED,
                            ANIM_LOOPING_LENGTH);
    } else {
        ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,
                            ANIM_LOOPING_SPEED,
                            ANIM_LOOPING_LENGTH);
    }

    // KLUDGE! KLUDGE! KLUDGE!
    // Because of placeables like the trap doors, etc, that should be
    // "opened" rather than "activated", but don't have an inventory,
    // we use this ugly hack: set the "Will" saving throw of a placeable
    // to the value 1 if it should be opened rather than activated.
    if (GetHasInventory(oPlaceable) || GetWillSavingThrow(oPlaceable) == 1) {
        if (GetIsOpen(oPlaceable)) {
            AssignCommand(oPlaceable,
                          DelayCommand(ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
        } else {
            AssignCommand(oPlaceable,
                          DelayCommand(ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN)));
        }
    } else {
        int bIsActive = GetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE");
        if (bIsActive) {
            AssignCommand(oPlaceable,
                          DelayCommand(ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
            SetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE", FALSE);
        } else {
            AssignCommand(oPlaceable,
                          DelayCommand(ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
            SetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE", TRUE);
        }
    }

    return;
}

// Play a random talk gesture animation.
// If a hit dice difference (should be the hit dice of the caller
// minus the hit dice of the person being talked to) is passed in,
// the caller will play slightly different animations if they are
// weaker.
void AnimActionPlayRandomTalkAnimation(int nHDiff)
{
    int nRoll = Random(9);
//SpeakString("Talk " + IntToString(nRoll));
    switch (nRoll) {
    case 0:
        if (GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
            VoiceYes();
        }
        // deliberate fall-through!
    case 1:
        ActionPlayAnimation(ANIMATION_LOOPING_LISTEN,
                            ANIM_LOOPING_SPEED,
                            ANIM_LOOPING_LENGTH);
        break;
    case 2:
    case 3:
        ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,
                            ANIM_LOOPING_SPEED,
                            ANIM_LOOPING_LENGTH);
        break;
    case 4:
        if (nHDiff < 0)
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
        else {
            if (Random(2) == 0 && GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
                VoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
        }
        break;
    case 5:
        // BK Feb 2003 Salutes look stupid
      //  if (nHDiff < 0)
      //      ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE, 0.75);
      //  else
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
        break;
    case 6:
        if (GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
            VoiceNo();
        }
        // deliberate fall-through!
    case 7:
        AnimActionShakeHead();
        break;
    case 8:
        if (nHDiff > 0)
            ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
        else {
            if (Random(2) == 0 && GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
                VoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
        }
        break;
    }

    return;
}

// Play a random animation that all creatures should have.
void AnimActionPlayRandomBasicAnimation()
{
    int nRoll = Random(2);
    switch (nRoll) {
    case 0:
    // BK Feb 2003: This always looks dumb
    //    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,
    //                        ANIM_LOOPING_SPEED,
    //                        ANIM_LOOPING_LENGTH);
        break;
    case 1:
        ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
        break;
    }
}


// Play a random animation.
void AnimActionPlayRandomAnimation()
{
    int nRoll;
    int bInTavern=FALSE;
    int bInHome=FALSE;
    int bNearAltar=FALSE;

    object oWay = GetNearestObjectByTag("NW_TAVERN");
    if (GetIsObjectValid(oWay)) {
        bInTavern = TRUE;
    } else {
        oWay = GetNearestObjectByTag("NW_HOME");
        if (GetIsObjectValid(oWay)) {
            bInHome = TRUE;
        } else {
            oWay = GetNearestObjectByTag("NW_ALTAR");
            if (GetIsObjectValid(oWay) && GetDistanceToObject(oWay) < DISTANCE_SHORT) {
                bNearAltar = TRUE;
            }
        }
    }

    if (bInTavern) {
        nRoll = Random(15);
        switch (nRoll) {
        case 0:
        case 1:
            ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK); break;
        case 2:
            if (GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
                VoicePoisoned();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 3:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1); break;
        case 5:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2); break;
        case 6:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3); break;
        case 7:
        case 8:
            if (GetAnimationCondition(NW_ANIM_FLAG_CHATTER)) {
                VoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 9:
        case 10:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 11:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 12:
        case 13:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 14:
            AnimActionLookAround(); break;
        }
    } else if (bNearAltar) {
        nRoll = Random(10);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_FIREFORGET_READ); break;
        case 1:
        case 2:
        case 3:
            ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH * 2);
            break;
        case 4:
        case 5:
            ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH * 2);
            break;
        case 6:
            ActionPlayAnimation(ANIMATION_LOOPING_LISTEN,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 7:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 8:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 9:
            AnimActionLookAround(); break;
        }
    } else if (bInHome) {
        nRoll = Random(6);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 1:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 2:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 3:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 5:
            AnimActionLookAround(); break;
        }
    } else {
        // generic set, for the street
        nRoll = Random(8);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 1:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 2:
            /* Bk Feb 2003: Looks dumb
            ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;*/
        case 3:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 5:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 6:
            ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR,
                                ANIM_LOOPING_SPEED,
                                ANIM_LOOPING_LENGTH);
            break;
        case 7:
            AnimActionLookAround(); break;
        }
    }
    return;
}

/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
