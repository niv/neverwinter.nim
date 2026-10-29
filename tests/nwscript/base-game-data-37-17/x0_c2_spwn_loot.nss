//::///////////////////////////////////////////////////
//:: X0_C2_SPWN_LOOT
//:: OnSpawn handler. 
//:: Spawn in as a corpse that can be looted.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_corpses"

void main()
{
    KillAndReplaceLootable(OBJECT_SELF, FALSE);
}
