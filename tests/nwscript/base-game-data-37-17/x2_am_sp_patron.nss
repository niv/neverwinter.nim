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
    SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);
    GiveGoldToCreature(OBJECT_SELF, Random(10) + 1);
    SetJob(JOB_PATRON, OBJECT_SELF, TRUE);
}



