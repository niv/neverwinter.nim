//::///////////////////////////////////////////////
//:: Custom On Spawn In
//:: File Name
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Barmaid spawn-in script
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
#include "nw_i0_generic"

void main()
{
    SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING);
    SetJob(JOB_BARMAID);
    WalkWayPoints();
}

