//::///////////////////////////////////////////////
//:: nw_g0_convdoor
//::
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cause a door to start a
    conversation with the PC.
    
    Use this script as the OnFailToOpen event
    of a locked door.
*/
//:://////////////////////////////////////////////
//:: Created By: Sydney Tang
//:: Created On: Aug 08, 2002
//:://////////////////////////////////////////////

void main()
{
    ActionStartConversation(GetEnteringObject());
}
