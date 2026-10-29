//::///////////////////////////////////////////////////
//:: X0_UD_LEAD_NEUT
//:: OnUserDefinedEvent handler. 
//:: Cause the entire faction to become hostile when this character 
//:: is damaged.
//:: This REQUIRES uncommenting the OnDamaged user defined event 
//:: in the OnSpawn handler for the NPC. Use with X0_SPAWN_SURR2.
//:: 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::///////////////////////////////////////////////////

#include "nw_i0_generic"
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
    // If we're already hostile, ignore
    if (GetLocalInt(OBJECT_SELF, "X0_IS_HOSTILE")) {return;}

    object oPC = OBJECT_INVALID;
        
    int nEvent = GetUserDefinedEventNumber();

    if (nEvent == USEREVENT_ATTACKED) {
        // We were attacked
        oPC = GetLastAttacker();
    } else if (nEvent == USEREVENT_DAMAGED) {
        // We were damaged
        oPC = GetLastDamager();
    }

    if (!GetIsPC(oPC)) {
        if (GetIsObjectValid(GetMaster(oPC))) {
            oPC = GetMaster(oPC);
        } else {
            // Use the nearest PC
            oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, 
                                     PLAYER_CHAR_IS_PC);
        }
        if (GetArea(oPC) != GetArea(OBJECT_SELF)) {
            DBG_msg("NO VALID PC FOR HOSTILITY: " 
                    + GetTag(OBJECT_SELF));
            return;
        }
    }
        
    // Make us all mad at the PC and all pals
    AdjustReputationWithFaction(oPC, OBJECT_SELF, -100);
    SetLocalInt(OBJECT_SELF, "X0_IS_HOSTILE", TRUE);

    // Yell an appropriate attack
    SpeakOneLinerConversation("", oPC);

    // Start fighting
    DelayCommand(0.3, DetermineCombatRound());

    // Shout to our friends
    DelayCommand(0.6, 
                 SpeakString ("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK));

    
}


