//::///////////////////////////////////////////////
//::
//:: Conversation Hostile-Faction
//::
//:: NW_D1_FtHostile.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Makes the conversation owner faction hostile to
//:: GetPCSpeaker().
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 4, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    AdjustReputation(OBJECT_SELF,GetFaction(GetPCSpeaker()),-100);
    ActionAttack(GetPCSpeaker());
}
