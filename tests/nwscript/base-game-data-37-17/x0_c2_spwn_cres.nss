//::///////////////////////////////////////////////////
//:: X0_C2_SPWN_CRES
//:: OnSpawn handler.
//:: Spawn in as a corpse that can be raised from the dead.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"
#include "x0_i0_walkway"
#include "x0_i0_corpses"
#include "x0_i0_npckilled"

void main()
{
    SetListeningPatterns();
    // * WP_<npc tag>_##, POST_<npc tag>, WN_<npc tag>_##, NIGHT_<npc tag>
    WalkWayPoints();
    CTG_GenerateNPCTreasure(TREASURE_TYPE_MONSTER, OBJECT_SELF);


    // This creature's conversation will only ever become available
    // when they are resurrected, so we use this as a check to see
    // if they were resurrected.
    KillAndReplaceRaiseable(OBJECT_SELF);
    SetNPCJustResurrected(OBJECT_SELF, TRUE);
}
