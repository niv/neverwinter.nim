//:://////////////////////////////////////////////////
//:: X0_D2_M2_REMET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman/NPC conditional: first meeting in module 2
but player has met henchman before.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (!GetHasMet(oPC)
        &&
        GetPlayerHasHiredInCampaign(oPC)
        &&
        (GetChapter() == 2)
        ) 
    {
        return TRUE;
    }
    return FALSE;
}
