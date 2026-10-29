//::///////////////////////////////////////////////
//:: Electrical Trap
//:: NW_T1_ElecMinoC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 3 other
    targets doing 8d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    TrapDoElectricalDamage(d6(8),19,3);
}

