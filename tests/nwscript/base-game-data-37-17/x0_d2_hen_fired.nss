//:://////////////////////////////////////////////////
//:: X0_D2_HEN_FIRED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Returns TRUE if the player has previously used this
henchman but had fired him/her.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (!GetIsHired() && GetPlayerHasHired(GetPCSpeaker()))
        return TRUE;
    return FALSE;
}
