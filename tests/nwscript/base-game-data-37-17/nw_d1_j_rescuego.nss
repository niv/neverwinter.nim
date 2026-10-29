//::///////////////////////////////////////////////
//:: RescueGo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Rescue Plot Giver and Prisoner Leave.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////
#include "nw_i0_plot"
#include "nw_j_rescue"

void main()
{
    if (GetIsObjectValid(GetPrisoner()))
        AssignCommand(GetPrisoner(), EscapeArea());
    EscapeArea();
}
