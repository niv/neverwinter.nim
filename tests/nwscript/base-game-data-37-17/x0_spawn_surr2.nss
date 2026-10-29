//:://////////////////////////////////////////////////
//:: X0_SPAWN_SURR2
/*
OnSpawn handler for creatures who should start out neutral,
go hostile in conversation (or through some other trigger),
then surrender after hitting a certain hitpoint limit.
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
    // * Fire User Defined Event 1006 OnDamaged
    // This checks to see if we should surrender
    SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);          

    SetListeningPatterns();    
    WalkWayPoints();           
    GenerateNPCTreasure();     
}
