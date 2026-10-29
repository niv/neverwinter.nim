//::///////////////////////////////////////////////
//:: Player seen conversation node 1
//:: x0_d1_seennode01
//:: Copyright (c) 2002 Floodgate Corp.
//:://////////////////////////////////////////////
/*
    Sets that the player has been through this
    conversation node before (works in conjunction
    with x0_d2_seennode01 in the Displayed if tab)
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/11/02 @ 17:00
//:://////////////////////////////////////////////
#include "x0_i0_seennode"

void main()
{
    SetLocalInt( GetPCSpeaker(), SeenNodeVarName( 1 ), TRUE );
}
