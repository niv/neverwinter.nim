//::///////////////////////////////////////////////
//::
//:: Commoner On Notice
//::
//:: NW_C2_Commoner2.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: If I see an enemy then store location and run away from enemy.
//:://////////////////////////////////////////////
//::
//:: Created By: Brent On: April 30, 2001
//:: Modified by: Aidan On: June 26, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{

    object oNoticed = GetLastPerceived();
    if(GetIsObjectValid(oNoticed))
    {
        if (GetIsEnemy(oNoticed))
        {
            SetListening(OBJECT_SELF,FALSE);
            ClearAllActions();
            ActionMoveAwayFromObject(oNoticed,TRUE);
            SetLocalObject(OBJECT_SELF,"NW_L_GENERICCommonerFleeFrom",oNoticed);
            SignalEvent(OBJECT_SELF,EventUserDefined(0));
        }
    }
}
