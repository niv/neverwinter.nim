//::///////////////////////////////////////////////
//:: x2_am_sp_dogchik
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This dog creates chickens and chases them.
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
    SetJob(JOB_TAG_IT, OBJECT_SELF, FALSE, "townchicken");
}
