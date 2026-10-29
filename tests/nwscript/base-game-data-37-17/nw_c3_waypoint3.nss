///////////////////////////////////////////////////////////////////////////////
//:: Guard walking between waypoints]
//::
//:: NW_C3_Waypoint3.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Every round of combat, this script will cheack to see if the last
    opponent is still available.  If not, it will check for a new opponent.  If
    no opponent meets the crieria, the creature will resume walking between
    waypoints.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 4, 2001
///////////////////////////////////////////////////////////////////////////////
object FindTarget(float fMaxDistance);

void main()
{
    float fFollowDistance = 25.0f;
    object oTarget = GetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack");
    if(  GetIsObjectValid(oTarget) &&
         GetDistanceToObject(oTarget) < fFollowDistance &&
         !GetIsDead(oTarget) &&
         GetIsEnemy(oTarget) &&
         d3() != 1)
    {
        ActionAttack(oTarget);
    }
    else
    {
        oTarget = FindTarget(fFollowDistance);
        SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oTarget);
        if(  GetIsObjectValid(oTarget) )
        {
            ClearAllActions();
            ActionAttack(oTarget);
        }
        else
        {
            ClearAllActions();
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",OBJECT_INVALID);
            SignalEvent(OBJECT_SELF,EventUserDefined(1));
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
//  FindTarget
///////////////////////////////////////////////////////////////////////////////
/* This function will return the nearest viable Target within the given range
   If none are available, it will return OBJECT_INVALID
*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan  On:
///////////////////////////////////////////////////////////////////////////////


object FindTarget(float fMaxDistance)
{
    object oFoundTarget;
    object oTarget = GetFirstObjectInShape (SHAPE_SPHERE, fMaxDistance,GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    while ( GetIsObjectValid(oTarget) )
    {
        if( !GetIsDead(oTarget) &&
            GetIsEnemy(oTarget)  )
        {
            oFoundTarget = oTarget;
            oTarget = OBJECT_INVALID;
        }
        else
        {
            oTarget = GetNextObjectInShape (SHAPE_SPHERE, fMaxDistance,GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
        }
    }
    return oFoundTarget;
}
