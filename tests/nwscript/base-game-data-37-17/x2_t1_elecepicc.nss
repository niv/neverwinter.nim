//::///////////////////////////////////////////////
//:: Electrical Trap
//:: X2_T1_ElecEpicC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 60d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: andrew Nobbs
//:: Created On: June 09, 2003
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    TrapDoElectricalDamage(d6(60),35,6);
}

