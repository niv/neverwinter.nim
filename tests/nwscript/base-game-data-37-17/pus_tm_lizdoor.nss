//::///////////////////////////////////////////////
//::
//:: a3_am_lizdoor
//::
//:: Copyright (c) 2005 Bioware Corp.
//::
//:://////////////////////////////////////////////
//::
//:: Opens and closes lizard hut exterior placeable
//:: door.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Alan Miranda and Brian Dunn
//:: Created On: 10/29/2005
//::
//:://////////////////////////////////////////////

#include "hf_in_npc"

void Close(object oPC, object oDoor)
{
    AssignCommand(oDoor, PlaySound("as_sw_clothop1"));
    AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE, 1.0, 1.0));
    SetLocalInt(oDoor, "nToggle", 0);
}

void Open(object oPC, object oDoor)
{
    AssignCommand(oDoor, PlaySound("as_sw_clothop1"));
    AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE, 1.0, 1.0));
    string sDest = GetLocalString(oDoor, "DESTINATION");
    if (sDest != "")
    {
        object oPC = GetLastUsedBy();
        DelayCommand(1.0, TeleportToWaypoint(oPC, sDest, TRUE));
        DelayCommand(2.0, Close(oDoor, oDoor));
    }
    SetLocalInt(oDoor, "nToggle", 1);
}

void main()
{
    object oPC = GetLastUsedBy();
    object oDoor = OBJECT_SELF;
    if (GetLocalInt(oDoor, "nToggle") == 0)
    {
        Open(oPC, oDoor);
    }
    else
    {
        Close(oPC, oDoor);
    }
}

