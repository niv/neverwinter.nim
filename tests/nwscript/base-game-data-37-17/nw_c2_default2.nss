//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT2
/*
  Default OnPerception event handler for NPCs.

  Handles behavior when perceiving a creature for the
  first time.
 */
//:://////////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{
// * if not runnning normal or better Ai then exit for performance reasons
    // * if not runnning normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

    object oPercep = GetLastPerceived();
    int bSeen = GetLastPerceptionSeen();
    int bHeard = GetLastPerceptionHeard();
    if (bHeard == FALSE)
    {
        // Has someone vanished in front of me?
        bHeard = GetLastPerceptionVanished();
    }

    // This will cause the NPC to speak their one-liner
    // conversation on perception even if they are already
    // in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION)
       && GetIsPC(oPercep)
       && bSeen)
    {
        SpeakOneLinerConversation();
    }

    // March 5 2003 Brent
    // Had to add this section back in, since  modifications were not taking this specific
    // example into account -- it made invisibility basically useless.
    //If the last perception event was hearing based or if someone vanished then go to search mode
    if ((GetLastPerceptionVanished()) && GetIsEnemy(GetLastPerceived()))
    {
        object oGone = GetLastPerceived();
        if((GetAttemptedAttackTarget() == GetLastPerceived() ||
           GetAttemptedSpellTarget() == GetLastPerceived() ||
           GetAttackTarget() == GetLastPerceived()) && GetArea(GetLastPerceived()) != GetArea(OBJECT_SELF))
        {
           ClearAllActions();
           DetermineCombatRound();
        }
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
    if (GetIsInCombat(OBJECT_SELF))
    {
        // don't do anything else, we're busy
        //MyPrintString("GetIsFighting: TRUE");

    }
    // * BK FEB 2003 Only fight if you can see them. DO NOT RELY ON HEARING FOR ENEMY DETECTION
    else if (GetIsEnemy(oPercep) && bSeen)
    { // SpawnScriptDebugger();
        //MyPrintString("GetIsEnemy: TRUE");
        // We spotted an enemy and we're not already fighting
        if(!GetHasEffect(EFFECT_TYPE_SLEEP)) {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                //MyPrintString("DetermineSpecialBehavior");
                DetermineSpecialBehavior();
            } else
            {
                //MyPrintString("DetermineCombatRound");
                SetFacingPoint(GetPosition(oPercep));
                SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
                DetermineCombatRound();
            }
        }
    }
    else
    {
        if (bSeen)
        {
            //MyPrintString("GetLastPerceptionSeen: TRUE");
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
                DetermineSpecialBehavior();
            } else if (GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION)
                       && GetIsPC(oPercep))
            {
                // The NPC will speak their one-liner conversation
                // This should probably be:
                // SpeakOneLinerConversation(oPercep);
                // instead, but leaving it as is for now.
                ActionStartConversation(OBJECT_SELF);
            }
        }
        else
        // * July 14 2003: Some minor reactions based on invisible creatures being nearby
        if (bHeard && GetIsEnemy(oPercep))
        {
           // SpeakString("vanished");
            // * don't want creatures wandering too far after noises
            if (GetDistanceToObject(oPercep) <= 7.0)
            {
//                if (GetHasSpell(SPELL_TRUE_SEEING) == TRUE)
                if (GetHasSpell(SPELL_TRUE_SEEING))
                {
                    ActionCastSpellAtObject(SPELL_TRUE_SEEING, OBJECT_SELF);
                }
                else
//                if (GetHasSpell(SPELL_SEE_INVISIBILITY) == TRUE)
                if (GetHasSpell(SPELL_SEE_INVISIBILITY))
                {
                    ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, OBJECT_SELF);
                }
                else
//                if (GetHasSpell(SPELL_INVISIBILITY_PURGE) == TRUE)
                if (GetHasSpell(SPELL_INVISIBILITY_PURGE))
                {
                    ActionCastSpellAtObject(SPELL_INVISIBILITY_PURGE, OBJECT_SELF);
                }
                else
                {
                    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 0.5);
                    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 0.5);
                    ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 0.5);
                }
            }
        }

        // activate ambient animations or walk waypoints if appropriate
       if (!IsInConversation(OBJECT_SELF)) {
           if (GetIsPostOrWalking()) {
               WalkWayPoints();
           } else if (GetIsPC(oPercep) &&
               (GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS)
                || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)
                || GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS)
                || GetIsEncounterCreature()))
           {
                SetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE);
           }
        }
    }

    // Send the user-defined event if appropriate
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_PERCEIVE));
    }
}




