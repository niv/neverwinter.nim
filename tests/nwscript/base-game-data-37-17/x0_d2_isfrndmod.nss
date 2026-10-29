//:://////////////////////////////////////////////////
//:: X0_D1_ISFRNDMODERATE
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Check if player has been friendly to NPC. Most useful
for ongoing relationships. 
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"

int StartingConditional()
{
    return FriendCheck(DIFFICULTY_MODERATE, GetPCSpeaker());
}
