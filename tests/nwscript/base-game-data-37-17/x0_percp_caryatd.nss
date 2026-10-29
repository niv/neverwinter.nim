/* Caryatid OnPerception handler -- depetrify when an enemy approaches. */


//::///////////////////////////////////////////////
//:: Default On Percieve
//:: NW_C2_DEFAULT2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the perceived target is an
    enemy and if so fires the Determine Combat
    Round function
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "x0_i0_petrify"

void main()
{
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION) 
       && GetIsPC(GetLastPerceived()) 
       && GetLastPerceptionSeen())
    {
        SpeakOneLinerConversation();
    }

    // If the last perception event was hearing based or if someone 
    // vanished then go to search mode.
    if ((GetLastPerceptionVanished()) && GetIsEnemy(GetLastPerceived()))
    {
        object oGone = GetLastPerceived();
        if( (GetAttemptedAttackTarget() == GetLastPerceived() ||
             GetAttemptedSpellTarget() == GetLastPerceived() ||
             GetAttackTarget() == GetLastPerceived()) 
            && GetArea(GetLastPerceived()) != GetArea(OBJECT_SELF))
        {
            // ADDED FOR CARYATID
            Depetrify(OBJECT_SELF); 
            // ADDED FOR CARYATID
            
            ClearAllActions();
            DetermineCombatRound();
        }
    }
    //Do not bother checking the last target seen if already fighting
    else if(!GetIsObjectValid(GetAttemptedAttackTarget()) 
            && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        //Check if the last percieved creature was actually seen
        if(GetLastPerceptionSeen())
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                DetermineSpecialBehavior();
            }
            else if(GetIsEnemy(GetLastPerceived()))
            {
                if(!GetHasEffect(EFFECT_TYPE_SLEEP))
                {
                    // ADDED FOR CARYATID
                    Depetrify(OBJECT_SELF); 
                    // ADDED FOR CARYATID

                    SetFacingPoint(GetPosition(GetLastPerceived()));
                    SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
                    DetermineCombatRound();
                }
            }

            //Linked up to the special conversation check to initiate a 
            // special one-off conversation to get the PCs attention
            else if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) 
                    && GetIsPC(GetLastPerceived()))
            {
                // ADDED FOR CARYATID
                Depetrify(OBJECT_SELF); 
                // ADDED FOR CARYATID

                ActionStartConversation(OBJECT_SELF);
            }
        }
    }

    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1002));
    }
}


