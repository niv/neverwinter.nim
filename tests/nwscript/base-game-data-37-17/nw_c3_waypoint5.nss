///////////////////////////////////////////////////////////////////////////////
//:: Guard walking between waypoints]
//::
//:: NW_C3_Waypoint5.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   If I am attacked by a friend or a neutral, give a warning. otherwise
     attack my attacker. Note the attack will inherintly lower the attackers
     standing from friend to Neutral.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: July 10, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oAttacker = GetLastAttacker();

    if(GetIsObjectValid(oAttacker))
    {
        // Temp, this will be handled automatically
        //AdjustReputation(oAttacker,GetFaction(OBJECT_SELF), - 35);
        //if (GetIsNeutral(oAttacker) || GetIsFriend(oAttacker))
        //{
        // * TEMP, this should become a SpeakString by resref
        //    ClearAllActions();
        //    ActionSpeakString("Attack me again and you'll be sorry.");
       //     SignalEvent(OBJECT_SELF,EventUserDefined(2));
            //ActionStartConversation(oAttacker,"Warning");

       // }
        //else
        //{
        // * Attack my last attacker
            ClearAllActions();
            ActionSpeakString ("Help",TALKVOLUME_SILENT_SHOUT);
            ActionAttack(oAttacker);
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oAttacker);
            SetLocalInt(OBJECT_SELF,"NW_L_Interrupted",TRUE);
            SetListening(OBJECT_SELF,FALSE);
            //DelayCommand(3.0,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
        //}
    }
}
