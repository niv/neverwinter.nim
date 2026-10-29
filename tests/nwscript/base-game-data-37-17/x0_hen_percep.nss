//::///////////////////////////////////////////////
//:: Associate: On Percieve
//:: NW_CH_AC2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

#include "X0_INC_HENAI"

void main()
{
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
    {
        ActionStartConversation(OBJECT_SELF);
    }
    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
    {
        //Do not bother checking the last target seen if already fighting
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()))
        {
            //Check if the last percieved creature was actually seen
            if(GetLastPerceptionSeen())
            {
                if(GetIsEnemy(GetLastPerceived()))
                {
                    SetFacingPoint(GetPosition(GetLastPerceived()));
                    HenchmenCombatRound(OBJECT_INVALID);
                }
                //Linked up to the special conversation check to initiate a special one-off conversation
                //to get the PCs attention
                else if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) && GetIsPC(GetLastPerceived()))
                {
                    ActionStartConversation(OBJECT_SELF);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1002));
    }
}

/*
#include "NW_I0_GENERIC"

void main()
{
    // * If have no master then run default scripts
    if (GetIsObjectValid(GetMaster()) == FALSE)
    {
        ExecuteScript("nw_c2_default2",OBJECT_SELF);
    }
    else
    {
        object oNoticed = GetLastPerceived();
        object oTarget = GetAttackTarget();
        if(GetIsObjectValid(oNoticed) && !GetIsObjectValid(GetAttemptedAttackTarget()))
        {
            if (GetLastPerceptionSeen() && GetIsEnemy(oNoticed))
            {
                DetermineCombatRound();
            }
            else if(GetLastPerceptionVanished() && oTarget == oNoticed)
            {
                 ClearAllActions();
            }
        }
    }
}
//Could just use the same one as the generic
*/
