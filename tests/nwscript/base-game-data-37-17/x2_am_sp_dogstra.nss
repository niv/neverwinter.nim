//::///////////////////////////////////////////////
//:: x2_am_sp_dogstra
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Stray dog wanders around
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
    SetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT);
    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "Go away", LISTEN_GOAWAY);
    SetJob(JOB_HUNTER);
}
