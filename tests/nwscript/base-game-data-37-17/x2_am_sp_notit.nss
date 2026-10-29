//::///////////////////////////////////////////////
//:: x2_am_sp_notit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will play tag.
    Is not it.
    
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
    SetJob(JOB_TAG_NOTIT, OBJECT_SELF, FALSE);
}
