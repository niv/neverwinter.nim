//::///////////////////////////////////////////////
//::
//:: Commoner User defined
//::
//:: NW_C2_CommonerD.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Commoners return to their stored location
//:: after hostilities are over.
//:://////////////////////////////////////////////
//::
//:: Created By: Aidan On: June 26, 2001
///////////////////////////////////////////////////////////////////////////////


void main()
{
    int nEvent = GetUserDefinedEventNumber();
    float fRecallTime = 3.0f;
    float fDangerRange = 50.0f;
    switch (nEvent)
    {
        case 0:
            object oFleeFrom = GetLocalObject(OBJECT_SELF,
                                              "NW_L_GENERICCommonerFleeFrom");
            if (GetIsObjectValid(oFleeFrom) &&
                !GetIsDead(oFleeFrom) &&
                GetDistanceToObject(oFleeFrom) < fDangerRange)
            //if danger is still present then continue fleeing and check again
            {
                ActionMoveAwayFromObject(oFleeFrom,TRUE);
                DelayCommand(fRecallTime,SignalEvent(OBJECT_SELF,
                             EventUserDefined(0)));
            }
            else
            // reset to calm mode and go back to starting position
            {
                SetListening(OBJECT_SELF,TRUE);
                ClearAllActions();
                ActionMoveToLocation(GetLocalLocation(OBJECT_SELF,
                                         "NW_L_GENERICCommonerStoreLocation"));
            }
        break;
    }
}
