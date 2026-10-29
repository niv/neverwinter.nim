
//::///////////////////////////////////////////////////
//:: X0_TRAPWK_BHAND
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_BURNING_HANDS
//:: Spell caster level: 1
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_BURNING_HANDS, GetEnteringObject(), 1);
}

