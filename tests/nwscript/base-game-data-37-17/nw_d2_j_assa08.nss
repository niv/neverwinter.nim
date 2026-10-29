//::///////////////////////////////////////////////
//:: NW_D2_J_ASSA08
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if the player has neither item
   and the victim is dead.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "NW_I0_Plot"
#include "NW_J_ASSASSIN"

int StartingConditional()
{
    return ( (CheckIntelligenceNormal() == TRUE) && (VictimDeadButNoItems(GetPCSpeaker()) == TRUE) );

}

