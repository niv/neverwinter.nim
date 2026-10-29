//:://////////////////////////////////////////////////
//:: X0_C2_PER_DEF
/*
  Default OnPerception event handler for NPCs. 

  Handles behavior when perceiving a creature for the 
  first time. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{
    object oPercep = GetLastPerceived();
    int bSeen = GetLastPerceptionSeen();

    // This will cause the NPC to speak their one-liner 
    // conversation on perception even if they are already 
    // in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION) 
       && GetIsPC(oPercep) 
       && bSeen)
    {
        SpeakOneLinerConversation();
    }

    // This section has been heavily revised while keeping the 
    // pre-existing behavior: 
    // - If we're in combat, keep fighting. 
    // - If not and we've perceived an enemy, start to fight. 
    //   Even if the perception event was a 'vanish', that's
    //   still what we do anyway, since that will keep us 
    //   fighting any visible targets. 
    // - If we're not in combat and haven't perceived an enemy,
    //   see if the perception target is a PC and if we should
    //   speak our attention-getting one-liner. 
    if (GetIsFighting(OBJECT_SELF)) {
        // don't do anything else, we're busy
    } else if (GetIsEnemy(oPercep)) {
        // We spotted an enemy and we're not already fighting
        if(!GetHasEffect(EFFECT_TYPE_SLEEP)) {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
                DetermineSpecialBehavior();
            } else {
                SetFacingPoint(GetPosition(oPercep));
                SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
                DetermineCombatRound();
            }
        }
    } else if (bSeen) {
        if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
            DetermineSpecialBehavior();
        } else if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) 
                  && GetIsPC(oPercep))
        {
            // The NPC will speak their one-liner conversation
            // This should probably be:
            // SpeakOneLinerConversation(oPercep);
            // instead, but leaving it as is for now.
            ActionStartConversation(OBJECT_SELF);
        }
    }

    // Send the user-defined event if appropriate
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_PERCEIVE));
    }
}


