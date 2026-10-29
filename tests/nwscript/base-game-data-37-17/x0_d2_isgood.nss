//:://////////////////////////////////////////////////
//:: X0_D2_ISGOOD
/*
TRUE if the speaker is good. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 10/16/2002
//:://////////////////////////////////////////////////

int StartingConditional()
{
    return (GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_GOOD);
}
