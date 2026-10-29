
//::///////////////////////////////////////////////////
//:: X0_TRAPAVG_MELFS
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_MELFS_ACID_ARROW
//:: Spell caster level: 6
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_MELFS_ACID_ARROW, GetEnteringObject(), 6);
}

