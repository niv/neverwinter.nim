//::///////////////////////////////////////////////
//::
//:: Flee, when this script is called
//::
//:: NW_C2_NoDieFlee.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Leave an area if attacked.  Should use the module
//:: to bring me back here after a certain period in time.
//:: Useful for signpost characters.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 15, 2001
//::
//:://////////////////////////////////////////////
void main()
{
    ClearAllActions();
    location lCurrentLocation = GetLocation(OBJECT_SELF);
    SetLocalLocation(OBJECT_SELF,"NW_L_MYLOCATION",lCurrentLocation);
    // * Jump to safe room
    ActionJumpToObject(GetNearestObjectByTag("WaySafePoint" + GetTag(OBJECT_SELF)),FALSE);
    SetLocalInt(OBJECT_SELF,"NW_L_WILLFLEE",0);
    // * in a minute, jump back
    DelayCommand(5.0,ActionJumpToLocation(GetLocalLocation(OBJECT_SELF,"NW_L_MYLOCATION")));
}
