//:://////////////////////////////////////////////////
//:: X0_D2_NPC_NOTQ3
/*
Checks that the PC is not on quest 3.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 10/16/2002
//:://////////////////////////////////////////////////

#include "x0_i0_plotgiver"

int StartingConditional()
{
    return (GetQuestStatus(GetPCSpeaker(), 3) == QUEST_NOT_TAKEN);
}
