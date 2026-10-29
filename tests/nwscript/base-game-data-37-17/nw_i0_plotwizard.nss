//////////////////////////////////////////////////////////////////
//
//  Plot Wizard Header file
//
//  Copyright (c) 2002 BioWare Corp.
//
//////////////////////////////////////////////////////////////////
//
//  nw_i0_plotwizard
//
//  Declarations and definitions of functions used by the
//  Plot Wizard
//
//////////////////////////////////////////////////////////////////
//
//  Created By: Sydney Tang
//  Created On: 2002-08-21
//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// Function prototypes

// Give the specified amount of experience to everyone in oPC's party.
void PWGiveExperienceParty(object oPC, int nExperience);

// Set the local integer variable sVarName to nValue
// for all players in oPC's party.
//void PWSetLocalIntParty(object oPC, string sVarName, int nValue);

// Set the local integer variable sVarName to nValue
// for all players in oPC's party.
// If the local int is already greater than nValue, do nothing.
void PWSetMinLocalIntParty(object oPC, string sVarName, int nValue);

// Set the local integer variable sVarName to nValue
// for all players in the PC Speaker's party.
// This function should only be called from a Conversation action script.
//void PWSetLocalIntPartyPCSpeaker(string sVarName, int nValue);

// Set the local integer variable sVarName to nValue
// for all players in the PC Speaker's party.
// If the local int is already greater than nValue, do nothing.
void PWSetMinLocalIntPartyPCSpeaker(string sVarName, int nValue);

void PWSetMinLocalIntAndJournalForItemAcquired(string sVarName, string sJournalTag, int nState, string sItemTag, int nExperience);

void PWSetMinLocalIntAndJournalForOpenerParty(string sVarName, string sJournalTag, int nState, int nExperience);

//////////////////////////////////////////////////////////////////
// Function definitions

void PWGiveExperienceParty(object oPC, int nExperience)
{
  object oPartyMember = GetFirstFactionMember(oPC, TRUE);
  while (oPartyMember != OBJECT_INVALID)
  {
    if (nExperience >= 0)
    {
      GiveXPToCreature(oPartyMember, nExperience);
    }
    else
    {
      int nCurrentXP = GetXP(oPartyMember);
      int nNewXP = nCurrentXP + nExperience;
      if (nNewXP < 0)
      {
        nNewXP = 0;
      }
      SetXP(oPartyMember, nNewXP);
    }
    oPartyMember = GetNextFactionMember(oPC, TRUE);
  }
}
/*
void PWSetLocalIntParty(object oPC, string sVarName, int nValue)
{
  object oPartyMember = GetFirstFactionMember(oPC, TRUE);
  while (oPartyMember != OBJECT_INVALID)
  {
    SetLocalInt(oPartyMember, sVarName, nValue);
    oPartyMember = GetNextFactionMember(oPC, TRUE);
  }
}

void PWSetLocalIntPartyPCSpeaker(string sVarName, int nValue)
{
  PWSetLocalIntParty(GetPCSpeaker(), sVarName, nValue);
}
*/
void PWSetMinLocalIntParty(object oPC, string sVarName, int nValue)
{
  object oPartyMember = GetFirstFactionMember(oPC, TRUE);
  while (oPartyMember != OBJECT_INVALID)
  {
    if (GetLocalInt(oPartyMember, sVarName) < nValue)
    {
      SetLocalInt(oPartyMember, sVarName, nValue);
    }
    oPartyMember = GetNextFactionMember(oPC, TRUE);
  }
}

void PWSetMinLocalIntPartyPCSpeaker(string sVarName, int nValue)
{
  PWSetMinLocalIntParty(GetPCSpeaker(), sVarName, nValue);
}

void PWSetMinLocalIntAndJournalForItemAcquired(string sVarName, string sJournalTag, int nState, string sItemTag, int nExperience)
{
  object oItem = GetModuleItemAcquired();
  string sTag = GetTag(oItem);
  if (sTag == sItemTag)
  {
    object oPC = GetItemPossessor(oItem);
    if (sJournalTag != "")
    {
      AddJournalQuestEntry(sJournalTag, nState, oPC, TRUE, FALSE, FALSE);
    }
    int nOriginalState;
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    while (oPartyMember != OBJECT_INVALID)
    {
      nOriginalState = GetLocalInt(oPartyMember, sVarName);
      if (nOriginalState < nState)
      {
        GiveXPToCreature(oPartyMember, nExperience);
        SetLocalInt(oPartyMember, sVarName, nState);
      }
      oPartyMember = GetNextFactionMember(oPC, TRUE);
    }
  }
}

void PWSetMinLocalIntAndJournalForOpenerParty(string sVarName, string sJournalTag, int nState, int nExperience)
{
  object oPC = GetLastOpenedBy();
  if (oPC == OBJECT_INVALID)
  {
    oPC = GetLastUnlocked();
  }
  if (oPC == OBJECT_INVALID)
  {
    oPC = GetLastKiller();
  }
  if (oPC != OBJECT_INVALID)
  {
    int nOriginalState;
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    while (oPartyMember != OBJECT_INVALID)
    {
      nOriginalState = GetLocalInt(oPartyMember, sVarName);
      if (nOriginalState < nState)
      {
        GiveXPToCreature(oPartyMember, nExperience);
        SetLocalInt(oPartyMember, sVarName, nState);
      }
      oPartyMember = GetNextFactionMember(oPC, TRUE);
    }

    if (sJournalTag != "")
    {
      AddJournalQuestEntry(sJournalTag, nState, oPC, TRUE, FALSE, FALSE);
    }
  }
}

