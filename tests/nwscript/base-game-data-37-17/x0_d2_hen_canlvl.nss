//::///////////////////////////////////////////////////
//:: X0_D2_HEN_CANLVL
//:: TRUE if the caller can level up (is at least two
//:: levels below the speaker, and not currently 
//:: busy). 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/24/2003
//::///////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    return GetCanLevelUp(GetPCSpeaker());
}
