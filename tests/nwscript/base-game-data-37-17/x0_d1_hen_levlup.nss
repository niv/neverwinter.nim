//::///////////////////////////////////////////////////
//:: X0_D1_HEN_LEVLUP
//:: Henchman levels up, preserving inventory and
//:: equipped weapons, and current behavior settings. 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/24/2003
//::///////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    object oNew = DoLevelUp(GetPCSpeaker());
}
