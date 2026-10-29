//::///////////////////////////////////////////////
//:: Electrical Trap
//:: NW_T1_ElecAvgC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 4 other
    targets doing 15d6 damage.  Can make a Reflex
    save for half damage.
    
    PATCH (Brent/Jon): replaced oTarget with
    o2ndTarget in the while loop
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"


void main()
{
    TrapDoElectricalDamage(d6(15), 22, 4);
}
