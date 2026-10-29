//::///////////////////////////////////////////////////
//:: X0_D2_HEN_DETCN
//:: TRUE if henchman is NOT in detect mode.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/24/2003
//::///////////////////////////////////////////////////

#include "x0_i0_modes"

int StartingConditional()
{
    return !GetModeActive(NW_MODE_DETECT);
}
