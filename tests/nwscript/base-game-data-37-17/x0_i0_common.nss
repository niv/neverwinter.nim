//:://////////////////////////////////////////////////
//:: X0_I0_COMMON
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Common functions used across multiple include files.
Be careful to avoid duplicate includes!
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/12/2002
//:://////////////////////////////////////////////////

// This includes functions for party-wide variable setting,
// setting campaign variables, and giving rewards.
#include "x0_i0_partywide"

// This includes functions for transporting creatures and making them
// travel around properly.
#include "x0_i0_transport"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// If this is set to 0, all debug messages will be turned off
// Note that the code WILL still be compiled in, so this is
// not ideal for final release.
const int X0_DEBUG_SETTING = 0;

// Difficulty settings for skill checks
const int DIFFICULTY_EASY = 1;
const int DIFFICULTY_MODERATE = 2;
const int DIFFICULTY_HARD = 3;
const int DIFFICULTY_IMPOSSIBLE = 4;

/**** Suffixes for item tags & local vars ****/

// This gets tacked onto the NPC's tag to denote
// the tag for their "home" waypoint.

const string sHasMetSuffix = "_MET";
const string sHasHiredSuffix = "_HIRED";
const string sDidQuitSuffix = "_QUIT";
const string sFriendSuffix = "_FR";
const string sHasInterjectionSuffix = "_INTJ";
const string sInterjectionSetSuffix = "_INTJ_SET";
const string sAdviceSuffix = "_ADV";
const string sPersuadeAttemptSuffix = "_PERSUADE";
const string sPersuadeSuccessSuffix = "_PERSUADE_SUCC";
const string sThreatenSuffix = "_THREAT";

/**** Names for the local variables that go on the NPCs ****/

// Holds the current one-liner
const string sOneLinerVarname = "X0_CURRENT_ONE_LINER";

// Holds whether this NPC's one-shot event has occurred
const string sOneShotVarname = "X0_ONE_SHOT_EVENT";

/**** Event router tags ****/
/* The event router is the object in each module that will
 * be responsible for receiving user-defined events (eg, for quest
 * start or completion), and then in turn sending events out
 * to the henchmen and other NPCs as appropriate to trigger
 * new effects on them.
 */
const string sRouterTag = "X0_EVT_ROUTER_M";

/**** Starting Location ****/
// This variable marks the starting location of a creature
const string sStartLocationVarname = "X0_START_LOC";

/**** Respawn Point ****/
// This is the variable that goes on the PC to specify the
// respawn point for them and their henchman.
const string sRespawnLocationVarname = "X0_RESPAWN_LOC";


/**** Conversation attempt delay ****/

// This controls the amount of delay between persistent conversation
// attempts.
const float CONVERSATION_ATTEMPT_DELAY = 3.0;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Print out a short message to the log files.
void DBG_msg(string sMsg);

// THIS WILL ONLY WORK CORRECTLY IN EXPANSION PACK 0.
// NOT VALID FOR USER MODULES!
// Returns the number of the current chapter of the game.
// Module 1: 1
// Module 2: 2
// Module 3: 3
int GetChapter();

// Returns true if this is an end module
// ONLY VALID IN EXPANSION PACK 0!
// NOT VALID FOR USER MODULES!
// Note -- this is actually never true since there are
// no end modules for XP1 now.
int EndModule();

// Returns the tag of the current area oTarget is in
string GetMyArea(object oTarget=OBJECT_SELF);

// Determine if the target is carrying the specified object.
int HasItemByTag(object oTarget, string sTag);

/**** Respawn functions ****/

// Set the respawn point to the current location of the
// caller
void SetRespawnLocation(object oTarget=OBJECT_SELF);

// Set the respawn point for the target to a specific location
void SetRespawnLocationSpecific(object oTarget, location lRespawn);

// Get the current respawn point for the caller
location GetRespawnLocation(object oTarget=OBJECT_SELF);

/**** Tag-Generating Functions ****/

// Returns the tag of the target with the 3-letter prefix (x0_)
// stripped. Useful since these are stripped from blueprint
// resrefs when editing copies.
string GetTagNoPrefix(object oTarget=OBJECT_SELF);


/**** Variable-Setting Functions ****/

// Set a true/false value on oTarget.
void SetBooleanValue(object oTarget, string sVarname, int bVal=TRUE);

// Get the value of a true/false variable on oTarget
int GetBooleanValue(object oTarget, string sVarname);

// Set a true/false persistent value on oTarget
void SetCampaignBooleanValue(object oTarget, string sVarname, int bVal=TRUE);

// Get the value of a persistent true/false variable on oTarget
int GetCampaignBooleanValue(object oTarget, string sVarname);



/*** DIALOGUE ***/

// Call to clear all dialogue events
void ClearAllDialogue(object oPC, object oNPC=OBJECT_SELF);

// Call to indicate this NPC has an interjection to
// make to this PC and which one if so.
void SetHasInterjection(object oPC, int bHasInter=TRUE, int nInter=0, object oNPC=OBJECT_SELF);

// Call to set the interjection value
void SetInterjection(object oPC, int nInter=0, object oNPC=OBJECT_SELF);

// Call to determine if the NPC has an interjection
// to make to this PC. Returns FALSE or the number
// of the interjection otherwise.
int GetHasInterjection(object oPC, object oNPC=OBJECT_SELF);

// Call to indicate this NPC has some advice to
// give to this PC and which advice set if so.
void SetHasAdvice(object oPC, int bHasAdvice=TRUE, int nAdvice=0, object oNPC=OBJECT_SELF);

// Call to determine if the NPC has advice to give
// to this PC. Returns FALSE or the number of the
// advice set otherwise.
int GetHasAdvice(object oPC, object oNPC=OBJECT_SELF);

// Set whether an NPC has a one-liner available to make
void SetOneLiner(int bHasOneLiner=TRUE, int nLine=0, object oNPC=OBJECT_SELF);

// Determine whether and which one-liner an NPC has available
int GetOneLiner(object oNPC=OBJECT_SELF);

// Determine whether the PC has attempted to persuade an NPC.
// nCheck is used for NPCs with multiple persuade checks in their
// conversation tree.
int GetPersuadeAttempt(object oPC, int nCheck=1, object oNPC=OBJECT_SELF);

// Indicate that the PC attempted to persuade the NPC
void SetPersuadeAttempt(object oPC, int nCheck=1, object oNPC=OBJECT_SELF);

// Determine whether the PC has successfully persuaded the NPC
int GetDidPersuade(object oPC, int nCheck=1, object oNPC=OBJECT_SELF);

// Indicate that the PC persuaded the NPC
void SetDidPersuade(object oPC, int nCheck=1, object oNPC=OBJECT_SELF);

// Indicate that the PC attempted to threaten the NPC
void SetThreaten(object oPC, object oNPC=OBJECT_SELF);

// Determine if the PC attempted to threaten the NPC
int GetThreaten(object oPC, object oNPC=OBJECT_SELF);

// Indicate that the PC did something friendly
// use FALSE if the PC was nasty
// This increments/decrements a variable on the PC and
// can be looked up to see how many friendly or nasty acts
// a player has committed to this NPC.
void SetFriendly(object oPC, int bFriendly=TRUE, object oNPC=OBJECT_SELF);

// Check how friendly/nasty the PC has been to this NPC
int GetFriendly(object oPC, object oNPC=OBJECT_SELF);


/**** Event Router Functions ****/

// Return the appropriate event router for this chapter.
// This function will create the event router if it doesn't
// already exist.
object GetEventRouter();

// Return the appropriate event router tag for this chapter
string GetEventRouterTag();


// Create the appropriate event router for this chapter
// in the starting location. The event router should be an
// invisible object.
object CreateEventRouter();


/**** Ability/State Checks ****/

// Threaten check
// Formula: (PC level + cha mod + d20) - (NPC level + wis mod + d20)
// DIFFICULTY_EASY: > -2
// DIFFICULTY_MODERATE: > 0
// DIFFICULTY_HARD: > 4
// DIFFICULTY_IMPOSSIBLE: > 8
int ThreatenCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF);

// Friendly check
// DIFFICULTY_EASY: has done at least one friendly thing
// DIFFICULTY_MODERATE: at least two
// DIFFICULTY_HARD: at least four
// DIFFICULTY_IMPOSSIBLE: at least six
int FriendCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF);

// Unfriendly check
// DIFFICULTY_EASY: has done at least one unfriendly thing
// DIFFICULTY_MODERATE: at least two
// DIFFICULTY_HARD: at least four
// DIFFICULTY_IMPOSSIBLE: at least six
int MeanCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF);



/******** CONVERSATION *****************/

// This causes the caller to try to start a conversation with the
// PC repeatedly with progressively longer delays.
void PersistentConversationAttempt(object oPC, string sConvo = "", int bPrivate=FALSE);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

void DBG_msg(string sMsg)
{
    if (X0_DEBUG_SETTING == 1) {
        PrintString(sMsg);
    }
}

// Returns the current chapter
int GetChapter()
{
    int nChapter=0;
    string sChapter = GetTag(GetModule());

    if (sChapter == "x0_module1") {
        nChapter = 1;
    } else if (sChapter == "x0_module2") {
        nChapter = 2;
    } else if (sChapter == "x0_module3") {
        nChapter = 3;
    }
    else if (sChapter == "x0_module3e") {
        nChapter = 3;
    }


    return nChapter;
}

// Returns true if this is an end module
int EndModule()
{
    return FALSE;
}

// Returns the tag of the current area oThing is in
string GetMyArea(object oTarget=OBJECT_SELF)
{
    if (GetIsObjectValid(oTarget)) {
        return GetTag(GetArea(oTarget));
    }
    return "";
}

/**** Respawn functions ****/

// Set the respawn point to the current location of the
// caller.
void SetRespawnLocation(object oTarget=OBJECT_SELF)
{
    SetLocalLocation(oTarget, sRespawnLocationVarname, GetLocation(oTarget));
}

// Set the respawn point for the target to a specific location
void SetRespawnLocationSpecific(object oTarget, location lRespawn)
{
    SetLocalLocation(oTarget, sRespawnLocationVarname, lRespawn);
}


// Get the current respawn point for the caller
location GetRespawnLocation(object oTarget=OBJECT_SELF)
{
    return GetLocalLocation(oTarget, sRespawnLocationVarname);
}


/**** Tag functions ****/

// Returns the tag of the item with the prefix x0_ stripped.
string GetTagNoPrefix(object oTarget=OBJECT_SELF)
{
    string sTag = GetTag(oTarget);

    int nLen = GetStringLength(sTag);
    return GetStringRight(sTag, nLen-3);
}

// Set a true/false value on oTarget
void SetBooleanValue(object oTarget, string sVarname, int bVal=TRUE)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        SetLocalInt(oTarget, sVarname, bVal);
    }
}

// Get the value of a true/false variable on oTarget
int GetBooleanValue(object oTarget, string sVarname)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        return GetLocalInt(oTarget, sVarname);
    }
    return 0;
}

// Set a true/false persistent value on oTarget
void SetCampaignBooleanValue(object oTarget, string sVarname, int bVal=TRUE)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        SetCampaignDBInt(oTarget, sVarname, bVal);
    }
}

// Get the value of a persistent true/false variable on oTarget
int GetCampaignBooleanValue(object oTarget, string sVarname)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        return GetCampaignDBInt(oTarget, sVarname);
    }
    return 0;
}


// Determine if the target is carrying the specified object.
int HasItemByTag(object oTarget, string sTag)
{
    if (GetIsObjectValid(oTarget)) {
        return GetIsObjectValid(GetItemPossessedBy(oTarget, sTag));
    }
    return FALSE;
}

/**** Dialogue events ****/


// Call to clear all dialogue events
void ClearAllDialogue(object oPC, object oNPC=OBJECT_SELF)
{
    // Clear the advice and one-liner for the henchman
    SetHasAdvice(oPC, FALSE, 0, oNPC);
    SetOneLiner(FALSE, 0, oNPC);

    // This sets the interjection to 0 and then clears the
    // interjection being available
    SetInterjection(oPC, 0, oNPC);
    SetHasInterjection(oPC, FALSE, 0, oNPC);
}


// Call to indicate this NPC has an interjection to
// make to this PC right now and which one if so.
void SetHasInterjection(object oPC, int bHasInter=TRUE, int nInter=0, object oNPC=OBJECT_SELF)
{
    if (bHasInter) {
        SetLocalInt(oPC, GetTag(oNPC) + sHasInterjectionSuffix, TRUE);
        //DBG_msg("Set var " + GetTag(oNPC) + sHasInterjectionSuffix
        //    + " to TRUE");
        SetLocalInt(oPC, GetTag(oNPC) + sInterjectionSetSuffix, nInter);
        //DBG_msg("Set var " + GetTag(oNPC) + sInterjectionSetSuffix
        //    + " to " + IntToString(nInter));
    } else {
        SetLocalInt(oPC, GetTag(oNPC) + sHasInterjectionSuffix, FALSE);
        //DBG_msg("Turned off interjection");
    }
}

// Call to set the interjection value
void SetInterjection(object oPC, int nInter=0, object oNPC=OBJECT_SELF)
{
    SetLocalInt(oPC, GetTag(oNPC) + sInterjectionSetSuffix, nInter);
    //DBG_msg("Set var " + GetTag(oNPC) + sInterjectionSetSuffix
    //        + " to " + IntToString(nInter));
}

// Call to determine if the NPC has an interjection
// to make to this PC right now. Returns TRUE or FALSE.
int GetHasInterjection(object oPC, object oNPC=OBJECT_SELF)
{
    //DBG_msg("Getting var " + GetTag(oNPC) + sHasInterjectionSuffix);
    return GetLocalInt(oPC, GetTag(oNPC) + sHasInterjectionSuffix);
}

// Call to determine the current interjection set.
int GetInterjectionSet(object oPC, object oNPC=OBJECT_SELF)
{
    return GetLocalInt(oPC, GetTag(oNPC) + sInterjectionSetSuffix);
}

// Call to indicate this NPC has some advice to
// give to this PC and which advice set if so.
void SetHasAdvice(object oPC, int bHasAdvice=TRUE, int nAdvice=0, object oNPC=OBJECT_SELF)
{
    if (bHasAdvice) {
        SetLocalInt(oPC, GetTag(oNPC) + sAdviceSuffix, nAdvice);
        //DBG_msg("Setting var " + GetTag(oNPC) + sAdviceSuffix
        //    + " to " + IntToString(nAdvice));
    } else {
        SetLocalInt(oPC, GetTag(oNPC) + sAdviceSuffix, FALSE);
        //DBG_msg("Turning off advice");
    }
}

// Call to determine if the NPC has advice to give
// to this PC. Returns FALSE or the number of the
// advice set otherwise.
int GetHasAdvice(object oPC, object oNPC=OBJECT_SELF)
{
    //DBG_msg("Getting var " + GetTag(oNPC) + sAdviceSuffix);
    return GetLocalInt(oPC, GetTag(oNPC) + sAdviceSuffix);
}

// Set whether an NPC has a one-liner available to make
void SetOneLiner(int bHasOneLiner=TRUE, int nLine=0, object oNPC=OBJECT_SELF)
{
    if (bHasOneLiner) {
        SetLocalInt(oNPC, sOneLinerVarname, nLine);
        //DBG_msg("Setting var " + sOneLinerVarname
        //    + " to " + IntToString(nLine));
    } else {
        SetLocalInt(oNPC, sOneLinerVarname, FALSE);
        //DBG_msg("Turning off one-liner");
    }
}

// Determine whether and which one-liner an NPC has available
int GetOneLiner(object oNPC=OBJECT_SELF)
{
    //DBG_msg("Getting var " + sOneLinerVarname);
    return GetLocalInt(oNPC, sOneLinerVarname);
}

// Determine whether the PC has attempted to persuade an NPC.
// nCheck is used for NPCs with multiple persuade checks in their
// conversation tree.
int GetPersuadeAttempt(object oPC, int nCheck=1, object oNPC=OBJECT_SELF)
{
    return GetLocalInt(oPC, GetTag(oNPC)
                       + sPersuadeAttemptSuffix
                       + IntToString(nCheck));
}

// Indicate that the PC attempted to persuade the NPC
void SetPersuadeAttempt(object oPC, int nCheck=1, object oNPC=OBJECT_SELF)
{
    SetLocalInt(oPC, GetTag(oNPC)
                + sPersuadeAttemptSuffix
                + IntToString(nCheck),
                TRUE);
}

// Determine whether the PC has successfully persuaded the NPC
int GetDidPersuade(object oPC, int nCheck=1, object oNPC=OBJECT_SELF)
{
    return GetLocalInt(oPC, GetTag(oNPC)
                       + sPersuadeSuccessSuffix
                       + IntToString(nCheck));
}

// Indicate that the PC persuaded the NPC
void SetDidPersuade(object oPC, int nCheck=1, object oNPC=OBJECT_SELF)
{
    SetLocalInt(oPC, GetTag(oNPC)
                + sPersuadeSuccessSuffix
                + IntToString(nCheck),
                TRUE);
}

// Indicate that the PC attempted to threaten the NPC
void SetThreaten(object oPC, object oNPC=OBJECT_SELF)
{
    SetBooleanValue(oPC, GetTag(oNPC) + sThreatenSuffix, TRUE);
}

// Determine if the PC attempted to threaten the NPC
int GetThreaten(object oPC, object oNPC=OBJECT_SELF)
{
    return GetBooleanValue(oPC, GetTag(oNPC) + sThreatenSuffix);
}

// Indicate that the PC did something friendly
// use FALSE if the PC was nasty
// This increments/decrements a variable on the PC and
// can be looked up to see how many friendly or nasty acts
// a player has committed to this NPC.
void SetFriendly(object oPC, int bFriendly=TRUE, object oNPC=OBJECT_SELF)
{
    int nFriendly = GetFriendly(oPC, oNPC);
    if (bFriendly)
        nFriendly++;
    else
        nFriendly--;
    SetLocalInt(oPC, GetTag(oNPC) + sFriendSuffix, nFriendly);
}

// Check how friendly/nasty the PC has been to this NPC
int GetFriendly(object oPC, object oNPC=OBJECT_SELF)
{
    return GetLocalInt(oPC, GetTag(oNPC)+sFriendSuffix);
}


/**********************************************************************
 * Event Router Functions
 **********************************************************************/

// Return the appropriate event router for this chapter.
// This function will create an event router object if it doesn't
// already exist.
object GetEventRouter()
{
    //DBG_msg("Event router tag: " + GetEventRouterTag());
    object oEvtRouter = GetObjectByTag(GetEventRouterTag());
    if (!GetIsObjectValid(oEvtRouter))
        return CreateEventRouter();
    return oEvtRouter;
}

// Return the appropriate event router tag for this chapter
string GetEventRouterTag()
{
    switch (GetChapter()) {
    case 1:
        return sRouterTag + "1";
    case 2:
        return sRouterTag + "2";
    case 3:
        return sRouterTag + "3";
    }
    return "";
}

// Create the appropriate event router for this chapter
// in the starting location. The event router should be an
// invisible object with matching tag and resref.
object CreateEventRouter()
{
    object oEvtRouter = GetObjectByTag(GetEventRouterTag());
    if (GetIsObjectValid(oEvtRouter))
        return oEvtRouter;
    return CreateObject(OBJECT_TYPE_PLACEABLE,
            GetEventRouterTag(),
            GetStartingLocation());
}



/**** Ability/Value Checks ****/

// Threaten check
// Formula: (PC level + cha mod + d20) - (NPC level + wis mod + d20)
// DIFFICULTY_EASY: > -2
// DIFFICULTY_MODERATE: > 0
// DIFFICULTY_HARD: > 4
// DIFFICULTY_IMPOSSIBLE: > 8
int ThreatenCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF)
{
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nMyChaMod = GetAbilityModifier(ABILITY_WISDOM, oNPC);
    int nHD = GetHitDice(oPC);
    int nMyHD = GetHitDice(oNPC);

    int nPCThreatLevel = nHD + nChaMod + d20();
    int nMyThreatLevel = nMyHD + nMyChaMod + d20();
    int nCheck = nPCThreatLevel - nMyThreatLevel;

    // Now, by difficulty
    if (nDifficulty == DIFFICULTY_IMPOSSIBLE) {
        return (nCheck > 8);
    } else if (nDifficulty == DIFFICULTY_HARD) {
        return (nCheck > 4);
    } else if (nDifficulty == DIFFICULTY_MODERATE) {
        return (nCheck > 0);
    } else if (nDifficulty == DIFFICULTY_EASY) {
        return (nCheck > -2);
    }
    return FALSE;
}

// Friendly check
// Easy: has done at least one friendly thing
// Moderate: at least two
// Hard: at least four
// Impossible: at least six
int FriendCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF)
{
    int nCheck = GetFriendly(oPC, oNPC);

    if (nDifficulty == DIFFICULTY_IMPOSSIBLE) {
        return (nCheck > 5);
    } else if (nDifficulty == DIFFICULTY_HARD) {
        return (nCheck > 3);
    } else if (nDifficulty == DIFFICULTY_MODERATE) {
        return (nCheck > 1);
    } else if (nDifficulty == DIFFICULTY_EASY) {
        return (nCheck > 0);
    }

    return FALSE;
}

// Unfriendly check
// Easy: has done at least one unfriendly thing
// Moderate: at least two
// Hard: at least four
// Impossible: at least six
int MeanCheck(int nDifficulty, object oPC, object oNPC=OBJECT_SELF)
{
    int nCheck = GetFriendly(oPC, oNPC);

    if (nDifficulty == DIFFICULTY_IMPOSSIBLE) {
        return (nCheck < -5);
    } else if (nDifficulty == DIFFICULTY_HARD) {
        return (nCheck < -3);
    } else if (nDifficulty == DIFFICULTY_MODERATE) {
        return (nCheck < -1);
    } else if (nDifficulty == DIFFICULTY_EASY) {
        return (nCheck < 0);
    }

    return FALSE;
}


/******** CONVERSATION *****************/



// This causes the caller to try to start a conversation with the
// PC repeatedly with progressively longer delays.
void PersistentConversationAttempt(object oPC, string sConvo = "", int bPrivate=FALSE)
{
    int nTries = 0;
    while (!IsInConversation(OBJECT_SELF) && nTries < 4) {
        //DBG_msg(GetName(OBJECT_SELF)
        //        + ": Trying to start convo with PC "
        //        + GetName(oPC));
        ActionStartConversation(oPC, sConvo, bPrivate);
        ActionWait(CONVERSATION_ATTEMPT_DELAY);
        nTries++;
    }
}



/*
 * This is strictly for testing purposes and must be commented out
 * for actual usage.
 *
 */
/*  void main() {} /* */
