//::///////////////////////////////////////////////
//:: Set Distance to 18ft
//:: NW_CH_DIST_18
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Set Follow Distance to 18ft (6m)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

void main()
{
    SetAssociateState(NW_ASC_DISTANCE_2_METERS, FALSE);
    SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
    SetAssociateState(NW_ASC_DISTANCE_6_METERS);
}
