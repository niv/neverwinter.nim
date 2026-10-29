//::///////////////////////////////////////////////
//:: x2_am_sp_rat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The rat will use the WANDER work routine.
    As well, if it perceives a hunter, it will flee
    back to its 'home'.
    
    The 'home' is the object that created this (i.e.,
    this rat assumes it was created from a pile of filth
    and will return itself there).
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_generic"
#include "x2_am_inc"

void main()
{
   SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);
   SetJob(JOB_WANDER);
    
}

