//::///////////////////////////////////////////////////
//:: X0_D1_NPC_RESR1
//:: Use this script to mark the PC speaker as having
//:: raised this NPC from the dead. 
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_npckilled"

void main()
{
    SetNPCResurrected(GetPCSpeaker());
}

