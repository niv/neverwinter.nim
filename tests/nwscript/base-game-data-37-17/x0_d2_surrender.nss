//::///////////////////////////////////////////////////
//:: X0_D2_SURRENDER
//:: TRUE if the NPC has surrendered.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/07/2002
//::///////////////////////////////////////////////////

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "X0_HAS_SURRENDERED");
}
