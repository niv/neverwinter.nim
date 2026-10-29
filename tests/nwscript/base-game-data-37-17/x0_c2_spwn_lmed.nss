//::///////////////////////////////////////////////////
//:: X0_C2_SPWN_LMED
//:: OnSpawn handler. 
//:: Spawn in as a corpse that can be looted, with random
//:: medium treasure.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_corpses"
#include "x0_i0_treasure"

void main()
{
    CTG_CreateTreasure(TREASURE_TYPE_MED, GetFirstPC(), OBJECT_SELF);
    KillAndReplaceLootable(OBJECT_SELF, FALSE);
}
