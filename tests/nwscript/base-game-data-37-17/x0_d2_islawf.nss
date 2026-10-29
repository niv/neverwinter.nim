//:://////////////////////////////////////////////////
//:: X0_D2_ISLAWFUL
/*
TRUE if the speaker is lawful. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 10/16/2002
//:://////////////////////////////////////////////////

int StartingConditional()
{
    return (GetAlignmentLawChaos(GetPCSpeaker()) == ALIGNMENT_LAWFUL);
}
