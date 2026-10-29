
//::///////////////////////////////////////////////////
//:: X0_TRAPFTL_ENERV
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_ENERVATION
//:: Spell caster level: 15
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_ENERVATION, GetEnteringObject(), 15);
}

