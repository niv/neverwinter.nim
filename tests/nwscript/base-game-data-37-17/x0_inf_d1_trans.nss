//::///////////////////////////////////////////////////
//:: X0_INF_D1_TRANS
//:: Transition into an area. (Used in the starting marker
//:: conversation)
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////

#include "x0_i0_infinite"

void main()
{
    object oPC = GetPCSpeaker();
    object oTrans = INF_GetNearestTransition(oPC);
    INF_DoTransition(oPC, oTrans);
}
