//:://////////////////////////////////////////////////
//:: X0_D2_M1_NOTMET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman/NPC conditional: TRUE if player has not met 
the henchman in this act and it is act 1.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if ( (GetChapter() == 1)
         && 
         ! GetHasMet(GetPCSpeaker()) )
    {
        return TRUE;
    }
    return FALSE;
}
