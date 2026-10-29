//::///////////////////////////////////////////////////
//:: X0_INF_D1_PLEAD
//:: Send PC to rejoin party leader if in range. 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////

#include "x0_i0_infinite"

void main()
{
    object oPC = GetPCSpeaker();
    INF_TransportToPartyLeader(oPC);
}
