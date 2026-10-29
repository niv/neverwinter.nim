//::///////////////////////////////////////////////
//:: Gated Demon: On Heartbeat
//:: NW_C2_GATED.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations. For the Gated Balor this script
    will check if the master is protected from
    by Protection from Evil.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

void main()
{
    object oMaster = GetMaster(OBJECT_SELF);
    if(!GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oMaster) &&
       !GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oMaster) &&
       !GetHasSpellEffect(SPELL_HOLY_AURA, oMaster))
    {
        RemoveSummonedAssociate(oMaster, OBJECT_SELF);
        SetIsTemporaryEnemy(oMaster);
        DetermineCombatRound(oMaster);
    }
    else
    {
        SetIsTemporaryFriend(oMaster);
        //Do not bother checking the last target seen if already fighting
        if(
           !GetIsObjectValid(GetAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()) &&
           !GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
          )
        {
            if(GetAssociateState(NW_ASC_HAVE_MASTER))
            {
                if(!GetIsInCombat() || !GetAssociateState(NW_ASC_IS_BUSY))
                {
                    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                    {
                        if(GetDistanceToObject(GetMaster()) > GetFollowDistance())
                        {
                            //SpeakString("DEBUG: I am moving to master");
                            ClearAllActions();
                            ActionForceMoveToObject(GetMaster(), TRUE, GetFollowDistance());
                        }
                    }
                }
            }
        }
        if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
        {
            SignalEvent(OBJECT_SELF, EventUserDefined(1001));
        }
    }
}
