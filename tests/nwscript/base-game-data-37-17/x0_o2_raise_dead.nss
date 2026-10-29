//::///////////////////////////////////////////////////
//:: X0_O2_RAISE_DEAD
//:: OnEntered handler for a trigger.
//:: Raises the nearest corpse from the dead.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "x0_i0_corpses"

void main()
{
    TriggerRaiseCorpse(VFX_IMP_RAISE_DEAD);
}
