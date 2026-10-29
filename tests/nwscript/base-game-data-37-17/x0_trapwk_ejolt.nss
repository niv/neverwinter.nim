
//::///////////////////////////////////////////////////
//:: X0_TRAPWK_EJOLT
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_ELECTRIC_JOLT
//:: Spell caster level: 1
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_ELECTRIC_JOLT, GetEnteringObject(), 1);
}

