//:://////////////////////////////////////////////////
//:: X0_SPAWN_LEAD
/*
OnSpawn handler for the leader(s) of a faction. When the
leader is attacked/damaged, the rest of the faction goes
hostile as a group. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//:://////////////////////////////////////////////////


#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"
#include "x0_i0_common"


void main()
{
    SetSpawnInCondition(NW_FLAG_ATTACK_EVENT);           
    SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);          

    SetListeningPatterns();    
    WalkWayPoints();           
    GenerateNPCTreasure();     
}
