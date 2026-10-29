///////////////////////////////////////////////////////////////////////////////
//:: Guard walking between waypoints]
//::
//:: NW_C3_Waypoint9.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Sets the strings to listen for, and initiates the moving cycle.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 12, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    SetListening(OBJECT_SELF,TRUE);
    SetListenPattern(OBJECT_SELF,"NW_I_WAS_ATTACKED",0);
    SetListenPattern(OBJECT_SELF,"NW_ATTACK_MY_TARGET",1);
    //the shouter must have an target object stored on itself
    //with the name "NW_L_TargetOfAttack"
    SetListenPattern(OBJECT_SELF,"NW_MOVE_TO_LOCATION",2);
    //the shouter must have a location stored on itself with
    //the name "NW_L_LocationToMoveTo"
    SetListenPattern(OBJECT_SELF,"NW_FIRE_IN_THE_HOLE",3);
    //the shouter must have a location stored on itself with
    //the name "NW_L_LocationOfSpell"
    SetListenPattern(OBJECT_SELF,"NW_UNLEASH_HELL",4);
    DelayCommand(1.0f,SignalEvent(OBJECT_SELF,EventUserDefined(1)));
}

