//::///////////////////////////////////////////////
//:: Name x2_portal_gate_a
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This conversation branch should only appear if
    the PC is here after dying - this variable is
    set in the OnPlayerDeath script 'x2_death'
    and reset on leaving the Realm of the Reaper
*/
//:://////////////////////////////////////////////
//:: Created By:  Keith Warner
//:: Created On:  Jan 17/03
//:://////////////////////////////////////////////

int StartingConditional()
{

    if (GetLocalInt(GetPCSpeaker(), "NW_L_I_DIED") == 1)
        return TRUE;
    return FALSE;
}


