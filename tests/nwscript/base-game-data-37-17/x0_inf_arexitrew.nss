//::///////////////////////////////////////////////////
//:: X0_INF_AREXIT
//:: OnExit event handler for a reward area.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////

#include "x0_i0_infinite"

// Use this to clean up the PC after a delay, if they
// are no longer in the infinite desert.
void CleanupPC(object oPC);

void main()
{
    object oPC = GetExitingObject();
    if (!GetIsPC(oPC)) {return;}

    // Do a sanity check to make sure we clean up
    // PCs who leave by dying or by going another
    // way from a reward area.
    DelayCommand(INF_MSG_DELAY + 3.0, CleanupPC(oPC));
}

// Use this to clean up the PC after a delay, if they
// are no longer in the infinite desert.
void CleanupPC(object oPC)
{
    if (INF_GetIsInInfiniteSpace(oPC)) return;

    INF_CleanupPC(oPC);
}

