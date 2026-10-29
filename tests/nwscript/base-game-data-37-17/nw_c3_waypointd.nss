///////////////////////////////////////////////////////////////////////////////
//:: Guard walking between waypoints.
//::
//:: NW_C3_WaypointD.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   This script has 3 uses depending on where it was called from. Case:
    0- It will detect the end of combat. ***Removed***
    1- It will set the pathe for a creature between all possible waypoints,
    starting at WP_XXX_01.
    2- It will set the pathe for a creature between all possible waypoints,
    starting at the closest waypoint.
    20 - hack that will be removed when EventEndCombat is available
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: July 10, 2001
///////////////////////////////////////////////////////////////////////////////
void RunCircuit(int nTens, int nNum);
object FindTarget(float fMaxDistance);

void main()
{
    int nEvent = GetUserDefinedEventNumber();
    switch (nEvent)
    {
        case 1:
            int nNth =1;
            int nTens;
            int nNum;
            object oNearest = GetNearestObject(OBJECT_TYPE_WAYPOINT,OBJECT_SELF,nNth);
            while (GetIsObjectValid(oNearest))
            {
               string sNearestTag = GetTag(oNearest);

               //removes the first 3 and last three characters from the waypoint's tag
               //and checks it against his own tag.  Waypoint tag format is WP_MyTag_XX.
               if( GetSubString( sNearestTag, 3, GetStringLength( sNearestTag ) - 6 ) == GetTag( OBJECT_SELF ) )
                {
                    string sTens = GetStringRight(GetTag(oNearest),2);
                    nTens = StringToInt(sTens)/10;
                    nNum= StringToInt(GetStringRight(GetTag(oNearest),1));
                    oNearest = OBJECT_INVALID;
                }
                else
                {
                    nNth++;
                    oNearest = GetNearestObject(OBJECT_TYPE_WAYPOINT,OBJECT_SELF,nNth);
                }
            }
            RunCircuit(nTens, nNum);
            ActionWait(3.0f);
            ActionDoCommand(SignalEvent(OBJECT_SELF,EventUserDefined(2)));
        break;
        case 2:
        {
            RunCircuit(0,1);
            ActionWait(3.0f);
            ActionDoCommand(SignalEvent(OBJECT_SELF,EventUserDefined(2)));
        }
        break;
        //start of vanish hack
        case 20:
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
        break;
        //end of vanish hack
        
    }

}

///////////////////////////////////////////////////////////////////////////////
//
//  RunCircuit
//
///////////////////////////////////////////////////////////////////////////////
/*  This function will move a creature through all available waypoints starting
    at WP_XXX_<nTens><nNum>.  It will move sequentially up through waypoints
    and again down to WP_XXX_01.
*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan  On: July 10, 2001
///////////////////////////////////////////////////////////////////////////////


void RunCircuit(int nTens, int nNum)
{
    // starting at a given way point, move sequentialy through incrementally
    // increasing points until there are no more valid ones.
    object oTargetPoint = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_" + IntToString(nTens) +IntToString(nNum));

    while(GetIsObjectValid(oTargetPoint))
    {
        ActionMoveToObject(oTargetPoint);
        nNum++;
        if (nNum > 9)
        {
            nTens++;
            nNum = 0;
        }
        oTargetPoint = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_" + IntToString(nTens) +IntToString(nNum));
    }
    // once there are no more waypoints available, decriment back to the last
    // valid point.
    nNum--;
    if (nNum < 0)
    {
        nTens--;
        nNum = 9;
    }

    // start the cycle again going back to point 01
    oTargetPoint = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_" + IntToString(nTens) +IntToString(nNum));
    while(GetIsObjectValid(oTargetPoint))
    {
        ActionMoveToObject(oTargetPoint);
        nNum--;
        if (nNum < 0)
        {
            nTens--;
            nNum = 9;
        }
        oTargetPoint = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF) + "_" + IntToString(nTens) +IntToString(nNum));
    }
    
}

//remove when EventEndCombat is available
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
