//::///////////////////////////////////////////////
//:: nw_g0_convplac
//::
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cause a placeable object to start a
    conversation with the PC.
    
    Use this script as the OnUsed event
    of a Placeable object that is flagged as
    Useable, Has NO Inventory, and is NOT Static.
*/
//:://////////////////////////////////////////////
//:: Created By: Sydney Tang
//:: Created On: Aug 08, 2002
//:://////////////////////////////////////////////

void main()
{
    ActionStartConversation(GetLastUsedBy());
}
