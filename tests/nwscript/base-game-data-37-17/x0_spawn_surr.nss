//:://////////////////////////////////////////////////
//:: X0_SPAWN_SURR
/*
OnSpawn handler for creatures who should start out hostile
but surrender after hitting a certain hitpoint limit.
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

    // If we're a copy, then don't do any of this
    if (GetIsObjectValid(
              GetNearestObjectByTag(GetTag(OBJECT_SELF), OBJECT_SELF, 1)))
    {
        DBG_msg("Copy made in area " + GetTag(GetArea(OBJECT_SELF)));
        return;
    } else {
        DBG_msg("This is the original NPC: " + GetName(OBJECT_SELF));
    }


    // * Fire User Defined Event 1006 OnDamaged
    // This checks to see if we should surrender
    SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);

    SetListeningPatterns();
    WalkWayPoints();
    GenerateNPCTreasure();

    // Unset plot flag and move to hostile faction
    SetPlotFlag(OBJECT_SELF, FALSE);
    ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
}
