//::///////////////////////////////////////////////
//:: Name con_q2ereaper_1
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

    // * if in Chapter 1, hide option until this info has been revealed.
    if (GetTag(GetModule()) == "x0_module1" && GetLocalInt(GetModule(), "X2_L_DEATHINFOREVEALED") == 0)
    {
        return FALSE;
    }

    if (GetLocalInt(GetPCSpeaker(), "NW_L_I_DIED") == 1)
        return TRUE;
    return FALSE;
}

