//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////


#include "inc_mf_combat"
void main()
{
    if(!GetFleeToExit())
    {
        if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    DetermineSpecialBehavior(GetLastDamager());
                }
                else if(GetIsObjectValid(GetLastDamager()))
                {
                    DetermineMindflayerCombat(OBJECT_INVALID);
                    if(!GetIsFighting(OBJECT_SELF))
                    {
                        object oTarget = GetLastDamager();
                        if(!GetObjectSeen(oTarget) && GetArea(OBJECT_SELF) == GetArea(oTarget))
                        {
                            ActionMoveToLocation(GetLocation(oTarget), TRUE);
                            ActionDoCommand(DetermineMindflayerCombat(OBJECT_INVALID));
                        }
                    }
                }
            }
            else if (!GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                object oTarget = GetAttackTarget();
                if(!GetIsObjectValid(oTarget))
                {
                    oTarget = GetAttemptedAttackTarget();
                }
                object oAttacker = GetLastHostileActor();
                if (GetIsObjectValid(oAttacker) && oTarget != oAttacker && GetIsEnemy(oAttacker) &&
                   (GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4) ||
                    (GetHitDice(oAttacker) - 2) > GetHitDice(oTarget) ) )
                {
                    DetermineMindflayerCombat(oAttacker);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1006));
    }
}
