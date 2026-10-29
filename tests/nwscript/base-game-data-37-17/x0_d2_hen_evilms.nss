//:://////////////////////////////////////////////////
//:: X0_D2_HEN_EVILMS
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Returns TRUE if the speaker is the henchman's current
master AND the master is evil.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    return (GetWorkingForPlayer(GetPCSpeaker())
        && (GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_EVIL));
}
