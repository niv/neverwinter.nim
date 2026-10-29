//::///////////////////////////////////////////////
//:: Deekin, Player Knows His True Name (Condition Script)
//:: x2_deekin_name.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns TRUE if the player has learned
     Deekin's True Name
*/
//:://////////////////////////////////////////////
//:: Created By: Rob Bartel
//:: Created On: October 21, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int bName = GetLocalInt(GetModule(), "bKnower_DeekinNamed");
    if (bName == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
