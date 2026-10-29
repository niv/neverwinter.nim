//:://////////////////////////////////////////////////
//:: X0_D2_REMET
/*
Henchman conditional: TRUE if player has not met
this character in this chapter but has hired them before.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return ( !GetHasMet(oPC) && GetPlayerHasHired(oPC) );
}
