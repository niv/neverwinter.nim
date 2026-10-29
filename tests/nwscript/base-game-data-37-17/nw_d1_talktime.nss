//::///////////////////////////////////////////////
//::
//:: c_gpc_TalkTimes
//::
//:: c_gpc_TalkTimes
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Controls the number of times you've talked to someone.
//:: Simply increments the TalkTimes local each time this script is called.
//::
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent Knowles
//:: Created On: April 20, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    SetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES",GetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES") + 1);
}
