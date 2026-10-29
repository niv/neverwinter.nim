///////////////////////////////////////////////////////////////////////////////
//:: Guard walking between waypoints]
//::
//:: NW_C3_Waypoint2.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   This script will begin the attack cycle if the last seen creature belongs
     to an enemy faction.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: July 10, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oNoticed = GetLastPerceived();
    if(GetIsObjectValid(oNoticed))
    {
        if (GetLastPerceptionSeen() && GetIsEnemy(oNoticed))
        {
            ClearAllActions();
            SetListening(OBJECT_SELF,FALSE);
            ActionAttack(oNoticed);
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oNoticed);
            //DelayCommand(3.0,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
        }
        else if(GetLastPerceptionVanished() &&
                 GetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack") == oNoticed)
        {
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",OBJECT_INVALID);
            SignalEvent(OBJECT_SELF,EventUserDefined(20));
            //this is a hack until EventEndCombat is available.
        }
    }
}
