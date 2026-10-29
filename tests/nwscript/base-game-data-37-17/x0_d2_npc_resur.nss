//::///////////////////////////////////////////////////
//:: X0_D2_NPC_RESUR
//:: TRUE if the PC raised this  NPC from the dead. 
//:: 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_npckilled"

int StartingConditional()
{
    return GetNPCResurrected(GetPCSpeaker());
}
