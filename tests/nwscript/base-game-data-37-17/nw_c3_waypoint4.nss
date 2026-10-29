//::///////////////////////////////////////////////
//:: Waypoint OnConversationStart
//::
//:: NW_C3_Waypoint4.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:: If shouted at, then respond to the shout
//:: Otherwise, handle conversation normally
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan On: Sept 6, 2001
//:://////////////////////////////////////////////
void main()
{
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oTarget = GetLocalObject(oShouter,"NW_L_TargetOfAttack");
    object oCurrentTarget = GetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack");
    object oAttacker = GetLastAttacker(oShouter);
    object oSecondaryTarget;
    if (nMatch == -1)
    {
        StartConversation();
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
                    SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oAttacker);
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

// "NW_FIRE_IN_THE_HOLD" was shouted
            case 3:
                SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",OBJECT_INVALID);
                ActionMoveAwayFromObject(GetLocalObject(oShouter,"NW_L_LocationOfSpell"),TRUE);
            break;
        }
    }
}
