//:://////////////////////////////////////////////////
//:: X0_D2_M2_NOTMET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman/NPC conditional: TRUE if player has not met 
the henchman in this act and it is act 2.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////
//:: May 2003: Don't say this line if already a henchman
#include "x0_i0_henchman"

int StartingConditional()
{
    if ( (GetChapter() == 2)
         && 
         ! GetHasMet(GetPCSpeaker()) && GetIsObjectValid(GetMaster()) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
