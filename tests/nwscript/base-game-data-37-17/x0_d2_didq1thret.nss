//:://////////////////////////////////////////////////
//:: X0_D2_DIDTHREAT
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Check if the PC threatened the NPC AND finished q1
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_plotgiver"

int StartingConditional()
{
    return ( GetThreaten(GetPCSpeaker()) ) 
        && ( GetQuestStatus(GetPCSpeaker(), 1) == QUEST_COMPLETE );
}
