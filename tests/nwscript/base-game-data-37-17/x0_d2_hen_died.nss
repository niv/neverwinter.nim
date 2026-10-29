//:://////////////////////////////////////////////////
//:: X0_D2_HEN_DIED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Returns TRUE if this henchman works for this player and
the henchman had died.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (GetKilled(GetPCSpeaker()) && GetDidDie())
        return TRUE;
    return FALSE;
}
