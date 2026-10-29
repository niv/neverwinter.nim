//::///////////////////////////////////////////////////
//:: X0_D1_HEN_NOMODE
//:: Turn off stealth and detect modes. Since slowdown
//:: is the only penalty for each of them, there's no cost
//:: to leaving both on, so might as well just turn them
//:: both on/off at the same time. 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/24/2003
//::///////////////////////////////////////////////////

#include "x0_i0_modes"

void main()
{
    SetModeActive(NW_MODE_STEALTH, FALSE);
    SetModeActive(NW_MODE_DETECT, FALSE);
}
