//:://////////////////////////////////////////////////
//:: X0_D2_NPC_DONEQ1
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Returns true if the speaker has completed quest 1 for this NPC.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_plotgiver"

int StartingConditional()
{
    return GetQuestStatus(GetPCSpeaker(), 1) == QUEST_COMPLETE;
}
