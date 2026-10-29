///////////////////////////////////////////////////////////////////////////////
//:: Warn and Attack User Defined
//::
//:: [NW_C2_WnAttackD.nss]
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
    int nEvent = GetUserDefinedEventNumber();
    switch (nEvent)
    {
        case 0:
            object oTarget = GetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack");
            if(GetIsObjectValid(oTarget) &&
                !GetIsDead(oTarget) &&
                GetDistanceToObject(oTarget) < 30.0 &&
                GetIsEnemy(oTarget))
            {
                ActionAttack(oTarget);
                DelayCommand(3.0,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
            }
            else
            {
                ClearAllActions();
                ActionMoveToLocation(GetLocalLocation(OBJECT_SELF,"NW_L_StartLocation"));
                SetListening(OBJECT_SELF,TRUE);
                
            }
        break;
    }
}
