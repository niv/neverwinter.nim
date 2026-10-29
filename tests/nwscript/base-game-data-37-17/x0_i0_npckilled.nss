//:://////////////////////////////////////////////////
//:: X0_I0_NPCKILLED
/*
  Small library to handle process of awarding victory
  after death in battle with NPCs, and also to handle
  NPC resurrection by the player.

  See comments for "CreateReplacementNPC" for general guidelines.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

string sKilledPrefix = "X0_KILLED_";

string sResurrectedPrefix = "X0_RESURRECTED_";

string sJustResurrectedVarname = "X0_I_WAS_JUST_RESURRECTED";

/*************************************************
 * FUNCTION PROTOTYPES
 *************************************************/

// Mark all members of the party as having killed the NPC
void SetNPCKilled(object oPC, string sNPCTag, int bDidKill=TRUE);

// Determine if the player killed this NPC
int GetNPCKilled(object oPC, string sNPCTag);

// Create a replacement for the NPC
// * General system:
// * - Create an NPC *BLUEPRINT*
// * - Put it in a non-hostile faction and set it PLOT
// * - Use the script 'x0_d1_go_hostile' in conversation to cause the
// *   NPC to become hostile and to unset its PLOT flag.
// * - Put the script 'x0_death_npc' in the OnDeath handler function
// *   of the NPC.
// * - Create a conversation node for after the NPC's death using the
// *   script 'x0_d2_npckilled'.
// * - Paint the NPC in the appropriate location.
object CreateReplacementNPC(object oPC, string sNPCResRef, location lNPC);

// Mark the NPC as just having been resurrected
void SetNPCJustResurrected(object oNPC=OBJECT_SELF, int bRaised=TRUE);

// Check if the NPC was just resurrected
int GetNPCJustResurrected(object oNPC=OBJECT_SELF);

// Mark the PC & friends as having resurrected this NPC
// and clear the 'just resurrected' var.
void SetNPCResurrected(object oPC, object oNPC=OBJECT_SELF, int bRaised=TRUE);

// Check if this PC resurrected this NPC
int GetNPCResurrected(object oPC, object oNPC=OBJECT_SELF);


/*************************************************
 * FUNCTION DEFINITIONS
 *************************************************/


// Mark all members of the party as having killed the NPC
void SetNPCKilled(object oPC, string sNPCTag, int bDidKill=TRUE)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalInt(oPartyMem, sKilledPrefix + sNPCTag, bDidKill);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
}


// Determine if the player killed this NPC
int GetNPCKilled(object oPC, string sNPCTag)
{
    return GetLocalInt(oPC, sKilledPrefix + sNPCTag);
}


// Create a replacement for the NPC
object CreateReplacementNPC(object oPC, string sNPCResRef, location lNPC)
{
    // Create a replacement
    effect eReplace = EffectVisualEffect(VFX_IMP_HEALING_G);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eReplace, lNPC);
    object oNewSelf = CreateObject(OBJECT_TYPE_CREATURE,
                        sNPCResRef,
                        lNPC);
    return oNewSelf;
}


// Mark the NPC as just having been resurrected
void SetNPCJustResurrected(object oNPC=OBJECT_SELF, int bRaised=TRUE)
{
    SetLocalInt(oNPC, sJustResurrectedVarname, bRaised);
}

// Check if the NPC was just resurrected
int GetNPCJustResurrected(object oNPC=OBJECT_SELF)
{
    return GetLocalInt(oNPC, sJustResurrectedVarname);
}

// Mark the PC & friends as having resurrected this NPC
// and clear the 'just resurrected' var.
void SetNPCResurrected(object oPC, object oNPC=OBJECT_SELF, int bRaised=TRUE)
{
    SetNPCJustResurrected(oNPC, FALSE);
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalInt(oPartyMem, sResurrectedPrefix + GetTag(oNPC), bRaised);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
}

// Check if this PC resurrected this NPC
// Check if the NPC was just resurrected
int GetNPCResurrected(object oPC, object oNPC = OBJECT_SELF)
{
    return GetLocalInt(oPC, sResurrectedPrefix + GetTag(oNPC) );
}


/*
void main() {}
/* */
