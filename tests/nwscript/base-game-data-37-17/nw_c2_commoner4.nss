///////////////////////////////////////////////////////////////////////////////
//:: Commoner On Dialogue
//::
//:: [NW_C2_Commoner4.nss]
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Causes the commomer to run from shouts from friends being attacked by
    enemies
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: June 26, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oSpeaker = GetLastSpeaker();
    int nHeard = GetListenPatternNumber();
    if (nHeard == -1)
    {
                BeginConversation();
    }
    else
    {
    if(GetIsObjectValid(oSpeaker))
    {
        switch(nHeard)
        {
            case 0:
                if(GetIsFriend(oSpeaker))
                {
                    object oAttacker = GetLastAttacker(oSpeaker);
                    if(GetIsObjectValid(oAttacker))
                    {
                        SetListening(OBJECT_SELF,FALSE);
                        ClearAllActions();
                        ActionMoveAwayFromObject(oAttacker,TRUE);
                        SetLocalObject(OBJECT_SELF,"NW_L_GENERICCommonerFleeFrom",oAttacker);
                        SignalEvent(OBJECT_SELF,EventUserDefined(0));
                    }
                }
            break;
        }
    }
    }
}
