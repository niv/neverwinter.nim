//::///////////////////////////////////////////////////
//:: X0_INF_TRENTER
//:: Transition OnAreaTransitionClick script for infinite space.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////

#include "x0_i0_infinite"

void main()
{
    object oPC = GetClickingObject();
    if (!GetIsPC(oPC)) return;
    object oTrans = OBJECT_SELF;

    INF_DoTransition(oPC, oTrans);
}
