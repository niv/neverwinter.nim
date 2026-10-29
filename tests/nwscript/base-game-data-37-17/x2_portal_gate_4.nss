//::///////////////////////////////////////////////
//:: Name x2_portal_gate_4.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This branch of the conversation should only appear
    if someone other than the PC is the party leader.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 17/03
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetName(GetItemPossessor(GetObjectByTag("x2_p_reaper"))) != GetName(GetPCSpeaker()))
        return TRUE;
    return FALSE;
}

