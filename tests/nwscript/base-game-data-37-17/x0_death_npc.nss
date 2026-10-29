/* Handle special case where the NPC is killed, then should resurrect
 * and grant reward. Should be used as OnDeath handler for the NPC.
 */

#include "x0_i0_npckilled"

// This creates the replacement and starts conversation.
// We have to do this in this clunky way because if we have
// the NPC delay a command, it will be destroyed before the
// command actually issues, and the replacement will never
// occur.
void DoReplacement(object oPC, string sMyResRef, location lMyLoc)
{
    object oNewSelf = CreateReplacementNPC(oPC, sMyResRef, lMyLoc);
    DelayCommand(3.0, AssignCommand(oNewSelf, ActionMoveToObject(oPC)));
    DelayCommand(5.0, AssignCommand(oNewSelf, ActionStartConversation(oPC)));
}

void main()
{
    object oPC = GetLastKiller();

    if (!GetIsPC(oPC)) {
        // Get the nearest PC instead
        oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    }

    SetNPCKilled(oPC, GetTag(OBJECT_SELF));
    string sMyResRef = GetResRef(OBJECT_SELF);
    location lMyLoc = GetLocation(OBJECT_SELF);
    AssignCommand(oPC,
        DelayCommand(3.0, DoReplacement(oPC, sMyResRef, lMyLoc)));
}
