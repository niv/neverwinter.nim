//:://////////////////////////////////////////////////
//:: X0_D2_ISNEU2
/*
TRUE if the speaker is neutral on the law/chaos axis. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 10/16/2002
//:://////////////////////////////////////////////////

int StartingConditional()
{
    return (GetAlignmentLawChaos(GetPCSpeaker()) == ALIGNMENT_NEUTRAL);
}
