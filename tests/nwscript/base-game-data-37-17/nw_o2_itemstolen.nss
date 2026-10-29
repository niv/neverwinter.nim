//::///////////////////////////////////////////////
//:: Name
//:: NW_O2_ITEMSTOLEN.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  November 2001
//:://////////////////////////////////////////////

#include "nw_i0_generic"


void main()
{
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
       if (GetFactionEqual(oTarget, OBJECT_SELF) == TRUE)
       {
           // * Make anyone who is a member of my faction hostile if I am violated
           AssignCommand(oTarget, DetermineCombatRound());
           AdjustReputation(GetLastOpenedBy(),oTarget,-25);
       }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    }

}
