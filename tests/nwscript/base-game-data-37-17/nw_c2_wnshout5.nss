//::///////////////////////////////////////////////
//::
//:: Warning: Summon On Attacked
//::
//:: NW_C2_WnShout5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: If I am attacked by a friend or a neutral, give a warning.
//:: otherwise attack my attacker. Note the attack will inherintly lower
//:: the attackers standing from friend to Neutral.
//:://////////////////////////////////////////////
//:: Created By: Brent On: April 30, 2001
//:: Modified by: Aidan on: June 29, 2001
//:://////////////////////////////////////////////

void main()
{
    object oAttacker = GetLastAttacker();
    if(GetIsObjectValid(oAttacker))
    {
        // Temp, this will be handled automatically
        AdjustReputation(oAttacker,GetFaction(OBJECT_SELF), - 35);
        if (GetIsNeutral(OBJECT_SELF,oAttacker) || GetIsFriend(OBJECT_SELF,oAttacker))
        {
        // * TEMP, this should become a SpeakString by resref
            //ActionSpeakString("Attack me again and you'll be sorry.");
            ActionStartConversation(oAttacker,"Warning");

        }
        else
        {
        // * Attack my last attacker
            ClearAllActions();
            if (GetIsObjectValid(GetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack")) == FALSE )
            {
                ActionSpeakString ("Help",TALKVOLUME_SHOUT);

            //At this point an encounter should be triggered
                object oHelper = CreateObject(OBJECT_TYPE_CREATURE,"HELPER",GetLocation(GetWaypointByTag("wpHelper")));
                AssignCommand(oHelper,ActionAttack(oAttacker));
            }
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oAttacker);
            SetListening(OBJECT_SELF,FALSE);
            DelayCommand(3.0,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
        }
    }
}
