///////////////////////////////////////////////////////////////////////////////
//:: Warn and Attack on dilogue
//::
//:: [NW_C2_WnAttack4.nss]
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Description
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: June 29, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oSpeaker = GetLastSpeaker();
    int nHeard = GetListenPatternNumber();
    if(GetIsObjectValid(oSpeaker))
    {
        switch(nHeard)
        {
            case -1 :
                ActionStartConversation(oSpeaker);
            break;
            case 0:
                if(GetIsFriend(oSpeaker))
                {
                    object oAttacker = GetLastAttacker(oSpeaker);
                    if(GetIsObjectValid(oAttacker))
                    {
                        SetListening(OBJECT_SELF,FALSE);
                        ClearAllActions();
                        ActionAttack(oAttacker);
                        SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oAttacker);
                        SignalEvent(OBJECT_SELF,EventUserDefined(0));
                    }
                }
            break;
        }
    }
}
