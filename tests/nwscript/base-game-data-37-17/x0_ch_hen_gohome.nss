//::////////////////////////////////////////////////////
//:: X0_CH_HEN_GOHOME
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 9/15/2002
//::////////////////////////////////////////////////////

/*
Sends the henchman home. Must be called from the henchman object.
*/

#include "x0_i0_common"

void main()
{
    location lHome = GetRespawnLocation();
    //DBG_msg("Traveling back to respawn location");
    TravelToLocation(lHome);
}
