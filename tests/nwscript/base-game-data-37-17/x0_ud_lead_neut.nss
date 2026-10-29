//::///////////////////////////////////////////////////
//:: X0_UD_LEAD_NEUT
//:: OnUserDefinedEvent handler. 
//:: Cause the entire faction to surrender when this character 
//:: has taken half hit points damage.
//:: This REQUIRES uncommenting the OnDamaged user defined event 
//:: in the OnSpawn handler for the NPC. Use with X0_SPAWN_SURR2.
//:: 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::///////////////////////////////////////////////////

#include "x0_i0_common"

int USEREVENT_HEARTBEAT = 1001;
int USEREVENT_PERCEIVE = 1002;
int USEREVENT_END_COMBAT_ROUND = 1003;
int USEREVENT_DIALOGUE = 1004;
int USEREVENT_ATTACKED = 1005;
int USEREVENT_DAMAGED = 1006;
int USEREVENT_DISTURBED = 1008;

void main()
{
    int nEvent = GetUserDefinedEventNumber();

    if (nEvent == USEREVENT_HEARTBEAT) {

    } else if (nEvent == USEREVENT_PERCEIVE) {

    } else if (nEvent == USEREVENT_DIALOGUE) {

    } else if (nEvent == USEREVENT_DISTURBED) {

    } else if (nEvent == USEREVENT_ATTACKED) {

    } else if (nEvent == USEREVENT_DAMAGED) {
        // If we surrendered once, we don't do it again
        if (GetLocalInt(OBJECT_SELF, "X0_HAS_SURRENDERED"))
            return;

        // Check if we're going to surrender
        if ( (GetMaxHitPoints() / 2 ) > GetCurrentHitPoints() ) {
            
            object oPC = GetLastDamager();
            
            if (!GetIsPC(oPC)) {
                // Use the nearest PC
                oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, 
                                         PLAYER_CHAR_IS_PC);
                if (GetArea(oPC) != GetArea(OBJECT_SELF)) {
                    DBG_msg("NO VALID PC FOR SURRENDER: " 
                            + GetTag(OBJECT_SELF));
                    return;
                }
            }
            
            // Stop the fight
            ClearAllActions();
            AssignCommand(oPC, ClearAllActions());
            SurrenderAllToEnemies(OBJECT_SELF);
            SurrenderAllToEnemies(oPC);
            
            // Make the entire faction neutral to the PC
            // and any friends, and vice versa
            AdjustReputationWithFaction(oPC, OBJECT_SELF, 70);
            AdjustReputationWithFaction(OBJECT_SELF, oPC, 70);
            ClearPersonalReputationWithFaction(oPC, OBJECT_SELF);
            ClearPersonalReputationWithFaction(OBJECT_SELF, oPC);

            // Mark that we've surrendered
            SetLocalInt(OBJECT_SELF, "X0_HAS_SURRENDERED", TRUE);
            
            // This assumes the NPC has a one-liner conversation along 
            // the lines of "stop, I surrender!" that uses the script
            // x0_d2_surrender as its condition. 
            SpeakOneLinerConversation();
            
            // Speak with the PC
            DelayCommand(6.0, PersistentConversationAttempt(oPC));
            
            return;
        }
    } else if (nEvent == USEREVENT_END_COMBAT_ROUND) {

    }
}


