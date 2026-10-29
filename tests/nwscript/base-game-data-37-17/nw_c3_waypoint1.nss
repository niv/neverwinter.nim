//::///////////////////////////////////////////////
//::
//:: OnHeartBeat
//::
//:: NW_C3_WayPoint1.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Do my patrol route, if my heartbeat is on.
//:: When get to the end of the waypoints, will
//:: start back the other way.
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 7, 2001
//::
//:://////////////////////////////////////////////

void SetWayPointTo1();
void NextTag(object oWayTarget);
string MakeWay(int nNumber);


void main()
{
    //*TEMP
    SpeakString(IntToString(GetFaction(OBJECT_SELF)));
    //*ENDTEMP


    // * How will I know when to turn this on
        // * Turn on heartbeat


// * Heartbeat on
if (GetLocalInt(OBJECT_SELF,"NW_L_HEARTBEAT") == 0)
{
    ClearAllActions();
    // * if first run of heartbeat then setup to
    // * to move to the first waypoint
    if (GetLocalInt(OBJECT_SELF,"NW_L_WayPointAt") == 0)
    {
        SetWayPointTo1();
    }
    object oWayTarget = GetNearestObjectByTag(GetLocalString(OBJECT_SELF,"NW_L_WayPointTag"));
    NextTag(oWayTarget);
    
   ActionMoveToObject(GetNearestObjectByTag(GetLocalString(OBJECT_SELF,"NW_L_WayPointTag")));
} // heartbeat on
}
//:: [Function Name]
//////////////////////////////////////////////////
//
//  [Function Name]
//
//////////////////////////////////////////////////
//
//
// [A description of the function.  This should contain any
// special ranges on input values]
//
//////////////////////////////////////////////////
//
//  Created By:
//  Created On:
//
//////////////////////////////////////////////////
void SetWayPointTo1()
{
        SetLocalInt(OBJECT_SELF,"NW_L_WayPointAt",1);
        SetLocalString(OBJECT_SELF,"NW_L_WayPointTag",MakeWay(1));
        // * set direction to forward
        SetLocalInt(OBJECT_SELF,"NW_L_WayDirection", 1);

}
//:: [Function Name]
//////////////////////////////////////////////////
//
//  [Function Name]
//
//////////////////////////////////////////////////
//
//
// [A description of the function.  This should contain any
// special ranges on input values]
//
//////////////////////////////////////////////////
//
//  Created By:
//  Created On:
//
//////////////////////////////////////////////////
void NextTag(object oWayTarget)
{
    int nCurrentWayPoint;

        int nDirection = GetLocalInt(OBJECT_SELF,"NW_L_WayDirection");
    // * if close enough to target waypoint, choose the next waypoint
    if (GetDistanceToObject(oWayTarget) < 3.0)
    {
        nCurrentWayPoint = GetLocalInt(OBJECT_SELF,"NW_L_WayPointAt");
        // * if the next waypoint exists, then set
        // * the guard to going there
        if (GetIsObjectValid(GetNearestObjectByTag(MakeWay(nCurrentWayPoint + nDirection))) == TRUE)
        {
            SetLocalInt(OBJECT_SELF,"NW_L_WayPointAt", nCurrentWayPoint + nDirection);
            SetLocalString(OBJECT_SELF,"NW_L_WayPointTag",MakeWay(nCurrentWayPoint + nDirection));
        }
        else

        {
               // * Reverse Direction
            if (nDirection == 1)
           {
                nDirection = -1;
            }
            else
            {
                nDirection = 1;
            }
         SetLocalInt(OBJECT_SELF,"NW_L_WayDirection", nDirection);
        }
    }
}

//:: MakeWay
//////////////////////////////////////////////////
//
//  [Function Name]
//
//////////////////////////////////////////////////
//
//
// Builds the name for the waypoing.
//
//////////////////////////////////////////////////
//
//  Created By:   Brent
//  Created On:   May 11, 2001
//
//////////////////////////////////////////////////
string MakeWay(int nNumber)
{
    return "Way" + IntToString(nNumber) + GetTag(OBJECT_SELF);
}
