
//::///////////////////////////////////////////////////
//:: X0_TRAPSTR_CCOLD
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_CONE_OF_COLD
//:: Spell caster level: 9
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_CONE_OF_COLD, GetEnteringObject(), 9);
}

