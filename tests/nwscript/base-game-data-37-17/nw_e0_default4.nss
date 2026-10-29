//::///////////////////////////////////////////////
//:: Default OnConversationStart
//::
//:: NW_E0_Default4.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:: If shouted at, then respond to the shout
//:: Otherwise, handle conversation normally
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan On: Sept 6, 2001
//:: Modified By Aidan on Oct 2001
//:://////////////////////////////////////////////
void main()
{
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oTarget = GetLocalObject(oShouter,"NW_L_TargetOfAttack");
    object oCurrentTarget = GetAttackTarget();
    object oAttacker = GetLastAttacker(oShouter);
    object oSecondaryTarget;
    if (nMatch == -1)
    {
        BeginConversation();
    }
    else if(GetIsObjectValid(oShouter) &&
            !GetIsPC(oShouter) &&
            GetIsFriend(oShouter))
    {
        ClearAllActions();
        switch (nMatch)
        {
// "NW_I_WAS_ATTACKED" was shouted
            case 0:
                if (GetIsObjectValid(oCurrentTarget) == FALSE)
                {
                    ActionAttack(oAttacker);
                }
            break;
// "NW_ATTACK_MY_TARGET" was shouted
            case 1:

                if (GetIsObjectValid(oCurrentTarget) == FALSE)
                {
                    SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oTarget);
                    ClearAllActions();
                    ActionAttack(oTarget);
                }
            break;
// "NW_MOVE_TO_LOCATION" was shouted
            case 2:
                ActionMoveToLocation(GetLocalLocation(oShouter,"NW_L_LocationToMoveTo"),TRUE);
            break;
// "NW_FIRE_IN_THE_HOLD" was shouted
            case 3:
                ClearAllActions();
                ActionMoveAwayFromObject(GetLocalObject(oShouter,"NW_L_LocationOfSpell"),TRUE);
                DelayCommand(6.0f,SignalEvent(OBJECT_SELF,EventEndCombat()));
            break;
// "NW_UNLEASH_HELL" was shouted
            case 4:
                if (GetIsObjectValid(oCurrentTarget) == FALSE)
                {
                    oCurrentTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
                    if(GetIsObjectValid(oCurrentTarget))
                    {
                        oSecondaryTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,2);
                        if(GetIsObjectValid(oSecondaryTarget) &&
                           d2() == 1)
                        {
                            oCurrentTarget = oSecondaryTarget;
                        }
                        ClearAllActions();
                        ActionAttack(oCurrentTarget);
                    }
                }
            break;
        }
    }
}
