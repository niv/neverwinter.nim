//::///////////////////////////////////////////////
//:: x2_am_sp_it
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will play tag.

    Is it (there should only be one of these one each
    fix-it trigger)

    Requires the x2_am_user_play script on user defined
    event as well
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
    SetJob(JOB_TAG_IT, OBJECT_SELF);
}
