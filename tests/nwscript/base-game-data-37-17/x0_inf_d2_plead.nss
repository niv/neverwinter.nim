//::///////////////////////////////////////////////////
//:: X0_INF_D2_PLEAD
//:: Return TRUE if party leader can be rejoined in desert.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////

#include "x0_i0_infinite"

int StartingConditional()
{
    return INF_GetIsPartyLeaderInRange(GetPCSpeaker());
}
