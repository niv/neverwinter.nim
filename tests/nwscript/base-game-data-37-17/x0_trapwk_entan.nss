
//::///////////////////////////////////////////////////
//:: X0_TRAPWK_ENTAN
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_ENTANGLE
//:: Spell caster level: 1
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_ENTANGLE, GetEnteringObject(), 1);
}

