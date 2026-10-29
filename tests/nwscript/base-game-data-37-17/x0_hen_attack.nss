//::///////////////////////////////////////////////
//:: Associate On Attacked
//:: NW_CH_AC5
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

#include "X0_INC_HENAI"

void main()
{
    SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    if(!GetAssociateState(NW_ASC_IS_BUSY))
    {
        SetCommandable(TRUE);
        if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
        {
            if(!GetIsObjectValid(GetAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(GetIsObjectValid(GetLastAttacker()))
                {
                    if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
                    {
                        object oTarget = GetLastAttacker(GetMaster());
                        HenchmenCombatRound(oTarget);
                    }
                    else
                    {
                        HenchmenCombatRound(OBJECT_INVALID);
                    }

                }
            }
            if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(1005));
            }
        }
    }
}

