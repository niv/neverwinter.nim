//:://////////////////////////////////////////////////
//:: X0_I0_PLOTGIVER
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  Shared routines for plotgiver NPCs.

  MODIFIED 1/3/2003
  Changed code to use the partywide and campaign functions,
  to preserve information between sequel modules and also
  to keep the status of a mission the same among all party
  members.

 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Constants marking the status of a quest
const int QUEST_NOT_TAKEN = 0;
const int QUEST_IN_PROGRESS = 1;
const int QUEST_COMPLETE = 2;
const int QUEST_COMPLETE_OTHER = 3;

// Variable on NPC monitoring quest status
const string sQuestVarname = "QUEST_STATUS";

// Suffix tacked on for quest status
const string sQuestSuffix = "_Q";

// Suffix tacked on to the quest item for this NPC
const string sQuestItemSuffix = "_QI";

// Suffix tacked on to the plot item for this NPC
const string sPlotItemSuffix = "_PI";

// Suffix tacked on to the reward item for this NPC
const string sRewardItemSuffix = "_RI";

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get the tag for the given quest
string GetQuestTag(object oTarget=OBJECT_SELF, int nQuest=1);

// Get the NPC's local varname for the given quest
string GetQuestVarname(int nQuest=1);

// Return the tag used for the given NPC's plot item
// for the specified quest.
string GetPlotItemTag(object oTarget=OBJECT_SELF, int nQuest=1);

// Return the tag used for the given NPC's quest item
// for the specified quest.
string GetQuestItemTag(object oTarget=OBJECT_SELF, int nQuest=1);

// Return the tag used for the given NPC's reward item
// for the specified quest.
string GetRewardItemTag(object oTarget=OBJECT_SELF, int nQuest=1);

// Call when a PC takes the quest
void SetOnQuest(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Call when a PC completes a quest
void SetQuestDone(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Call to determine the status of the quest relative to this PC
// returns one of:
// QUEST_NOT_TAKEN
// QUEST_IN_PROGRESS
// QUEST_COMPLETE
// QUEST_COMPLETE_OTHER -- quest is complete, but by someone else
int GetQuestStatus(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Give a PC the quest item
void GiveQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Give a PC the reward item
void GiveRewardItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// See if a PC is carrying the quest item
int HasQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// See if a PC is carrying the plot item
int HasPlotItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// See if a PC is carrying the reward item
int HasRewardItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Remove a plot item from a PC
void TakePlotItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);

// Remove a quest item from a PC
void TakeQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Get the tag for the given quest
string GetQuestTag(object oTarget=OBJECT_SELF, int nQuest=1)
{
    if (GetIsObjectValid(oTarget)) {
        return GetTag(oTarget) + sQuestSuffix + IntToString(nQuest);
    }
    return "";
}

// Get the NPC's local varname for the given quest
string GetQuestVarname(int nQuest=1)
{
    return sQuestVarname + IntToString(nQuest);
}

// Return the tag used for the given NPC's plot item
// for the specified quest.
string GetPlotItemTag(object oTarget=OBJECT_SELF, int nQuest=1)
{
    if (GetIsObjectValid(oTarget)) {
        return GetTag(oTarget) + sPlotItemSuffix + IntToString(nQuest);
    }
    return "";
}

// Return the tag used for the given NPC's quest item
// for the specified quest.
string GetQuestItemTag(object oTarget=OBJECT_SELF, int nQuest=1)
{
    if (GetIsObjectValid(oTarget)) {
        return GetTag(oTarget) + sQuestItemSuffix + IntToString(nQuest);
    }
    return "";
}

// Return the tag used for the given NPC's reward item
// for the specified quest.
string GetRewardItemTag(object oTarget=OBJECT_SELF, int nQuest=1)
{
    if (GetIsObjectValid(oTarget)) {
        return GetTag(oTarget) + sRewardItemSuffix + IntToString(nQuest);
    }
    return "";
}

// Call when a PC takes the quest
void SetOnQuest(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}
    SetLocalIntOnAll(oPC, GetQuestTag(oNPC, nQuest), QUEST_IN_PROGRESS);
    GiveQuestItem(oPC, nQuest, oNPC);
}

// Call when a PC completes a quest
void SetQuestDone(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}

    SetLocalIntOnAll(oPC, GetQuestTag(oNPC, nQuest), QUEST_COMPLETE);
    SetLocalInt(oNPC, GetQuestVarname(nQuest), QUEST_COMPLETE);
    TakePlotItem(oPC, nQuest, oNPC);
    TakeQuestItem(oPC, nQuest, oNPC);
    GiveRewardItem(oPC, nQuest, oNPC);
}


// Call to determine the status of the quest
// returns one of:
// QUEST_NOT_TAKEN
// QUEST_IN_PROGRESS
// QUEST_COMPLETE
// QUEST_COMPLETE_OTHER
int GetQuestStatus(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return QUEST_NOT_TAKEN;}

    int nPCStatus = GetLocalInt(oPC, GetQuestTag(oNPC, nQuest));
    int nNPCStatus = GetLocalInt(oNPC, GetQuestVarname(nQuest));
    if (nNPCStatus == QUEST_COMPLETE && nPCStatus != QUEST_COMPLETE)
        return QUEST_COMPLETE_OTHER;
    return nPCStatus;
}

// Give a PC the quest item
void GiveQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}
    if (!HasQuestItem(oPC, nQuest, oNPC))
    {
        string sItemResRef = GetQuestItemTag(oNPC, nQuest);
        if (GetStringLength(sItemResRef) > 16)
        {
            SendMessageToPC(GetFirstPC(), "The ResRef = " + sItemResRef + " is over 16 characters long and is an invalid resref. Fix it.");
        }
        else
        {
            object oItem = CreateItemOnObject(sItemResRef, oPC);
            //if (oItem == OBJECT_INVALID)
            //    DBG_msg("DEBUG: couldn't create " + GetQuestItemTag(oNPC, nQuest));
        }
    }
}

// Give a PC the reward item
void GiveRewardItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}
    if ( !HasRewardItem(oPC, nQuest, oNPC)) {
        object oItem = CreateItemOnObject(GetRewardItemTag(oNPC, nQuest), oPC);
        //if (oItem == OBJECT_INVALID)
        //    DBG_msg("DEBUG: couldn't create " + GetRewardItemTag(oNPC, nQuest));
    }
}

// See if a PC's party is carrying the quest item
int HasQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return FALSE;}
    string sItemTag = GetQuestItemTag(oNPC, nQuest);
    return GetIsItemPossessedByParty(oPC, sItemTag);
}


// See if a PC's party is carrying the plot item
int HasPlotItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return FALSE;}
    string sItemTag = GetPlotItemTag(oNPC, nQuest);
    return GetIsItemPossessedByParty(oPC, sItemTag);
}

// See if a PC's party is carrying the reward item
int HasRewardItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return FALSE;}
    string sItemTag = GetRewardItemTag(oNPC, nQuest);
    return GetIsItemPossessedByParty(oPC, sItemTag);
}

// Remove a plot item from a PC
void TakePlotItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}
    string sItemTag = GetPlotItemTag(oNPC, nQuest);
    RemoveItemFromParty(oPC, sItemTag);
}


// Remove a quest item from a PC
void TakeQuestItem(object oPC, int nQuest=1, object oNPC=OBJECT_SELF)
{
    if (!GetIsObjectValid(oNPC)) {return;}
    string sItemTag = GetQuestItemTag(oNPC, nQuest);
    RemoveItemFromParty(oPC, sItemTag);
}

// For testing only
/*  void main() {} /* */
