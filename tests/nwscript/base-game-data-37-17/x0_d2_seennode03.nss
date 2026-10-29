//::///////////////////////////////////////////////
//:: Player seen conversation node 3
//:: x0_d2_seennode03
//:: Copyright (c) 2002 Floodgate Corp.
//:://////////////////////////////////////////////
/*
    Checks if the player has been through this
    conversation node before (works in conjunction
    with x0_d1_seennode03 in the Actions tab)
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/11/02 @ 17:00
//:://////////////////////////////////////////////
#include "x0_i0_seennode"

int StartingConditional()
{
    return !GetLocalInt( GetPCSpeaker(), SeenNodeVarName( 3 ) );
}
