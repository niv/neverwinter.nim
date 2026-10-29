//::///////////////////////////////////////////////
//:: Custom On Spawn In
//:: File Name
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Stationary Guard spawn-in script
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
#include "nw_i0_generic"

void main()
{
    //   guards don't drink
    SetLocalInt(OBJECT_SELF, "NW_L_NODRINKSFORME", 10);
    SetJob(JOB_GUARD2);
    //WalkWayPoints();
}
