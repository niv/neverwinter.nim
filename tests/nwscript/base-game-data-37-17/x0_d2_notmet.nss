//:://////////////////////////////////////////////////
//:: X0_D2_NOTMET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman/NPC conditional: TRUE if player has not met
this character, period. Does no chapter checks.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    return !GetHasMet(GetPCSpeaker());
}
