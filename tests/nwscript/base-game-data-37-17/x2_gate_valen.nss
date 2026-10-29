//::///////////////////////////////////////////////
//:: x2_gate_valen
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Brings Valen out of the database and into
    Chapter 3.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_globals"

void main()
{
    CallForthHenchman("x2_hen_valen", "Valen_Called");
    // * Decrement number of henchmen called, so option in dialog
    // * can be hidden (Nov 8 - BK)
    int nNumHench = GetLocalInt(GetModule(), "X2_L_NUM_HENCHES_COME") - 1;
    SetLocalInt(GetModule(), "X2_L_NUM_HENCHES_COME", nNumHench);
}
