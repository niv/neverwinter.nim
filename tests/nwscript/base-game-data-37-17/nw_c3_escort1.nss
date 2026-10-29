//::///////////////////////////////////////////////
//::
//:: Escort by player
//::
//:: NW_C3_Escort1.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Follows player.  If gets close to a waypoint
//:: named NW_WAY_<MyTag> then says thank you text
//:: and escapes area.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 16, 2001
//::
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

void main()
{
    ClearAllActions();
SpeakString(IntToString(GetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT")));
    // * made it to waypoint in time
    if (GetIsObjectValid(GetNearestPC()) == TRUE)
    {
    if ((GetDistanceToObject(GetNearestObjectByTag("NW_WAY_"+GetTag(OBJECT_SELF))) < 7.0)&& (GetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT") > 0))
    {
        SetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT",30);
        ActionStartConversation(GetNearestPC());
        SetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT",40);
    }
    else
    // * follow, if players accepted
    if ((GetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT") == 10) && (GetDistanceToObject(GetNearestPC()) > 4.0))
    {
        ActionMoveToObject(GetNearestPC(),TRUE);
    }
    else
    // * timer expired
    if (FALSE)
    {
        SetLocalInt(OBJECT_SELF,"NW_L_MADEITTOEXIT",20);
        ActionStartConversation(GetNearestPC());
    }
    } // PC object is valid
    else
    {
        SpeakString("TEMP NO PC");
    }
}
