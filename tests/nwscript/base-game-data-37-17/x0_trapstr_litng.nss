
//::///////////////////////////////////////////////////
//:: X0_TRAPSTR_LITNG
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_LIGHTNING_BOLT
//:: Spell caster level: 8
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_LIGHTNING_BOLT, GetEnteringObject(), 8);
}

