//:://////////////////////////////////////////////////
//:: X0_I0_PARTYWIDE
/*
  Include library for party-wide functions.
  NOTE: this library is included in x0_i0_common
        already. Do NOT dual-include both files or
        you will get errors!
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/08/2002
//:://////////////////////////////////////////////////


// Functions and constants for campaign (persisent db) variables
#include "x0_i0_campaign"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Return the number of other players in the PC's party.
// Does NOT include associates.
int GetNumberPartyMembers(object oPC);

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For strings.
void SetLocalStringOnAll(object oPC, string sVarname, string value);

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For ints.
void SetLocalIntOnAll(object oPC, string sVarname, int value);

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For floats.
void SetLocalFloatOnAll(object oPC, string sVarname, float value);

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For locations.
void SetLocalLocationOnAll(object oPC, string sVarname, location value);

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For objects.
void SetLocalObjectOnAll(object oPC, string sVarname, object value);


/****** CAMPAIGN VARIABLES **************/


// Given a varname, value, and PC, sets the variable on
// all PC members of the PC's party.
// For strings.
void SetCampaignDBStringOnAll(object oPC, string sVarname, string value);

// Given a varname, value, and PC, sets the variable on
// all PC members of the PC's party.
// For ints.
void SetCampaignDBIntOnAll(object oPC, string sVarname, int value);

// Given a varname, value, and PC, sets the variable on
// all PC members of the PC's party.
// For floats.
void SetCampaignDBFloatOnAll(object oPC, string sVarname, float value);

// Given a varname, value, and PC, sets the variable on
// all PC members of the PC's party.
// For vectors.
void SetCampaignDBVectorOnAll(object oPC, string sVarname, vector value);

// Given a varname, value, and PC, sets the variable on
// all PC members of the PC's party.
// For locations.
void SetCampaignDBLocationOnAll(object oPC, string sVarname, location value);

// NOTE: this does not store a reference, it stores the entire actual object,
// including all of its inventory. Storing many objects can be highly resource-
// intensive! It should NOT be used like Set/GetLocalObject.
//
// Given a varname, value, and PC, stores the variable on
// all PC members of the PC's party.
// For objects.
void StoreCampaignDBObjectOnAll(object oPC, string sVarname, object value);

// Delete a campaign variable from all members of the PC's party.
void DeleteCampaignDBVariableOnAll(object oPC, string sVarname);


/********* REWARD FUNCTIONS ******************/


// Given a gold amount, divides it equally among the party members
// of the given PC's party.
// None given to associates.
void GiveGoldToAllEqually(object oPC, int nGoldToDivide);

// Given a gold amount, gives that amount to all party members
// of the given PC's party.
// None given to associates.
void GiveGoldToAll(object oPC, int nGold);

// Given an XP amount, divides it equally among party members
// of the given PC's party.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>) to
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAllEqually(object oPC, int nXPToDivide);

// Given an XP amount, gives that amount to all party members
// of the given PC's party.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>)
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAll(object oPC, int nXP);


/************ REPUTATION ****************/

// This adjusts the reputation of all members of the PC's
// faction with all members of the NPC's faction by the
// specified amount.
void AdjustReputationWithFaction(object oPC, object oNPC, int nAdjustment);

// This clears the personal reputation of all members of the
// PC's faction with all members of the NPC's faction.
void ClearPersonalReputationWithFaction(object oPC, object oNPC);

// Clear the actions of all the PC's associates
void ClearAssociateActions(object oPC, int bClearCombat=FALSE);

// This clears the actions of all nearby friends,
// useful for stopping a battle in progress.
void ClearNearbyFriendActions(object oTarget=OBJECT_SELF, int bClearCombat=FALSE);

// Cause all members of the faction of the given surrendering
// object to issue a SurrenderToEnemies call. Does not work
// on PCs, but DOES work on their associates.
void SurrenderAllToEnemies(object oSurrendering=OBJECT_SELF);

/************* ITEMS ************/

// TRUE if any member of the PC's party has an item with the given tag
int GetIsItemPossessedByParty(object oPC, string sItemTag);

// Check for an item possessed by anyone in the PC's
// party. If not found, returns OBJECT_INVALID.
object GetItemPossessedByParty(object oPC, string sItemTag);

// Remove an item from any party member who has it.
// Note: this assumes that the item is unique.
void RemoveItemFromParty(object oPC, string sItemTag);

//*******************MISC****/
// This adjusts the alignment of all members of the PC's
// faction
void AdjustAlignmentOnAll(object oPC, int nAlignment, int nShift);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Return the number of players in the PC's party
// Does NOT include associates.
int GetNumberPartyMembers(object oPC)
{
    int nNumber = 0;
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem))
    {

        nNumber++;
        // * MODIFIED February 2003. Was an infinite loop before
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    return nNumber;
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party, including associates.
// For strings.
void SetLocalStringOnAll(object oPC, string sVarname, string value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalString(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalString(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party, including associates.
// For ints.
void SetLocalIntOnAll(object oPC, string sVarname, int value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalInt(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalInt(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For floats.
void SetLocalFloatOnAll(object oPC, string sVarname, float value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalFloat(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalFloat(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For locations.
void SetLocalLocationOnAll(object oPC, string sVarname, location value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalLocation(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalLocation(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For objects.
void SetLocalObjectOnAll(object oPC, string sVarname, object value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalObject(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalObject(oPC, sVarname, value);
}



/****** CAMPAIGN VARIABLES **************/

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party, including associates.
// For strings.
void SetCampaignDBStringOnAll(object oPC, string sVarname, string value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetCampaignDBString(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //SetCampaignDBString(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party, including associates.
// For ints.
void SetCampaignDBIntOnAll(object oPC, string sVarname, int value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetCampaignDBInt(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //SetCampaignDBInt(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For floats.
void SetCampaignDBFloatOnAll(object oPC, string sVarname, float value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetCampaignDBFloat(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //SetCampaignDBFloat(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For vectors.
void SetCampaignDBVectorOnAll(object oPC, string sVarname, vector value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetCampaignDBVector(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //SetCampaignDBVector(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on
// all members of the PC's party.
// For locations.
void SetCampaignDBLocationOnAll(object oPC, string sVarname, location value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetCampaignDBLocation(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //SetCampaignDBLocation(oPC, sVarname, value);
}

// Given a varname, value, and PC, stores the variable on
// all members of the PC's party.
// For objects.
void StoreCampaignDBObjectOnAll(object oPC, string sVarname, object value)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        StoreCampaignDBObject(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //StoreCampaignDBObject(oPC, sVarname, value);
}

// Delete a campaign variable from all members of the PC's party.
void DeleteCampaignDBVariableOnAll(object oPC, string sVarname)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        DeleteCampaignDBVariable(oPartyMem, sVarname);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //DeleteCampaignDBVariable(oPC, sVarname);
}


/*********** REWARD FUNCTIONS ****************/

// Given a gold value, divides it equally among the party members
// None given to associates.
void GiveGoldToAllEqually(object oPC, int nGoldToDivide)
{
    int nMembers = GetNumberPartyMembers(oPC);
    int nEqualAmt = nGoldToDivide/nMembers;

    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveGoldToCreature(oPartyMem, nEqualAmt);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveGoldToCreature(oPC, nEqualAmt);
}

// Given a gold value, gives that amount to all party members
// None given to associates.
void GiveGoldToAll(object oPC, int nGold)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveGoldToCreature(oPartyMem, nGold);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveGoldToCreature(oPC, nGold);
}


// Given an XP value, divides it equally among party members
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>) to
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAllEqually(object oPC, int nXPToDivide)
{
    int nMembers = GetNumberPartyMembers(oPC);
    int nEqualAmt = nXPToDivide/nMembers;

    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveXPToCreature(oPartyMem, nEqualAmt);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveXPToCreature(oPC, nEqualAmt);
}


// Given an XP value, gives that amount to all party members.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>)
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAll(object oPC, int nXP)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveXPToCreature(oPartyMem, nXP);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveXPToCreature(oPC, nXP);
}

/************ REPUTATION ****************/

// This adjusts the reputation of all members of the PC's
// faction with all members of the NPC's faction by the
// specified amount.
void AdjustReputationWithFaction(object oPC, object oNPC, int nAdjustment)
{
    // Adjusts the reputation of all members of the PC's faction
    // with the NPC's faction
    object oPCFacMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPCFacMem)) {
        AdjustReputation(oPCFacMem, oNPC, nAdjustment);
        oPCFacMem = GetNextFactionMember(oPC, FALSE);
    }
    //AdjustReputation(oPC, oNPC, nAdjustment);
}

// This clears the personal reputation of all members of the
// PC's faction with all members of the NPC's faction.
void ClearPersonalReputationWithFaction(object oPC, object oNPC)
{
    object oFacMem = GetFirstFactionMember(oNPC, FALSE);
    while (GetIsObjectValid(oFacMem)) {
        // Clear personal rep for all the PC's faction members
        object oPCFacMem = GetFirstFactionMember(oPC, FALSE);
        while (GetIsObjectValid(oPCFacMem)) {
            ClearPersonalReputation(oPCFacMem, oFacMem);
            oPCFacMem = GetNextFactionMember(oPC, FALSE);
        }
        ClearPersonalReputation(oPC, oFacMem);
        oFacMem = GetNextFactionMember(oNPC, FALSE);
    }
}

// Clear the actions of all the PC's associates
void ClearAssociateActions(object oPC, int bClearCombat=FALSE)
{
    // Get all the possible associates of this PC
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);
    object oDomin = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
    object oFamil = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    object oAnimalComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);

    // Clear their actions
    if (GetIsObjectValid(oHench)) {
        AssignCommand(oHench, ClearAllActions(bClearCombat));
    }
    if (GetIsObjectValid(oDomin)) {
        AssignCommand(oDomin, ClearAllActions(bClearCombat));
    }
    if (GetIsObjectValid(oFamil)) {
        AssignCommand(oFamil, ClearAllActions(bClearCombat));
    }
    if (GetIsObjectValid(oSummon)) {
        AssignCommand(oSummon, ClearAllActions(bClearCombat));
    }
    if (GetIsObjectValid(oAnimalComp)) {
        AssignCommand(oAnimalComp, ClearAllActions(bClearCombat));
    }
}


// This clears the actions of all nearby friends,
// useful for stopping a battle in progress.
void ClearNearbyFriendActions(object oTarget=OBJECT_SELF, int bClearCombat=FALSE)
{
    // We'll look for the 10 nearest members
    int nLimit = 10;
    int i=0;
    object oFriend = oTarget;
    for (i=0; i < nLimit && GetIsObjectValid(oFriend) ; i++) {
        AssignCommand(oFriend, ClearAllActions(bClearCombat));
        oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                     REPUTATION_TYPE_FRIEND,
                                     oTarget,
                                     i);
    }
}

// Cause all members of the faction of the given surrendering
// object to issue a SurrenderToEnemies call. Does not work
// on PCs, but DOES work on their associates.
void SurrenderAllToEnemies(object oSurrendering=OBJECT_SELF)
{
    object oMyArea = GetArea(oSurrendering);

    object oFacMem = GetFirstFactionMember(oSurrendering, FALSE);
    while (GetIsObjectValid(oFacMem)) {

        // Only PCs and members in our area should surrender
        if (GetArea(oFacMem) == oMyArea && !GetIsPC(oFacMem)) {
            AssignCommand(oFacMem, SurrenderToEnemies());
        }

        oFacMem = GetNextFactionMember(oSurrendering, FALSE);
    }
    AssignCommand(oSurrendering, SurrenderToEnemies());
}


/************* ITEMS ************/

// TRUE if any member of the PC's party has an item with the given tag
int GetIsItemPossessedByParty(object oPC, string sItemTag)
{
    return GetIsObjectValid(GetItemPossessedByParty(oPC, sItemTag));
}


// Check for an item possessed by anyone in the PC's
// party. If not found, returns OBJECT_INVALID.
// This only checks actual PCs, not associates.
object GetItemPossessedByParty(object oPC, string sItemTag)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    object oItem = OBJECT_INVALID;

    // Check the PC itself
    oItem = GetItemPossessedBy(oPC, sItemTag);
    if (GetIsObjectValid(oItem))
        return oItem;

    // Check other party members
    while (GetIsObjectValid(oPartyMem)) {
        oItem = GetItemPossessedBy(oPartyMem, sItemTag);
        if (GetIsObjectValid(oItem))
            return oItem;
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }

    return OBJECT_INVALID;
}

// Remove an item from any party member who has it.
// Note: this assumes that the item is unique.
// This only checks actual PCs, not associates.
// Note that this WILL destroy plot-flagged items!
void RemoveItemFromParty(object oPC, string sItemTag)
{
    object oItem = GetItemPossessedByParty(oPC, sItemTag);
    if (GetIsObjectValid(oItem)) {
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
    }
}


// ************************MISC*************************************
// This adjusts the alignment of all members of the PC's
// faction
void AdjustAlignmentOnAll(object oPC, int nAlignment, int nShift)
{

    object oPCFacMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPCFacMem)) {
        AdjustAlignment(oPCFacMem, nAlignment, nShift);
        oPCFacMem = GetNextFactionMember(oPC, FALSE);
    }
}

/*  void main() {} /* */
