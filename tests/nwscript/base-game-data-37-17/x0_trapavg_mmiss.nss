
//::///////////////////////////////////////////////////
//:: X0_TRAPAVG_MMISS
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_MAGIC_MISSILE
//:: Spell caster level: 4
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_MAGIC_MISSILE, GetEnteringObject(), 4);
}

