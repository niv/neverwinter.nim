//::///////////////////////////////////////////////////
//:: X0_D2_NPC_RESR1
//:: TRUE if the NPC was a corpse that was just resurrected, 
//:: if the NPC's death handler (or on spawn for spawned-in
//:: corpses) set the variable.
//:: 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_npckilled"

int StartingConditional()
{
    return GetNPCJustResurrected();
}
