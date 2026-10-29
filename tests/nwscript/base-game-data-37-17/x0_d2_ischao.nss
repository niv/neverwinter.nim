//:://////////////////////////////////////////////////
//:: X0_D2_ISCHAOTIC
/*
TRUE if the speaker is chaotic. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 10/16/2002
//:://////////////////////////////////////////////////

int StartingConditional()
{
    return (GetAlignmentLawChaos(GetPCSpeaker()) == ALIGNMENT_CHAOTIC);
}
