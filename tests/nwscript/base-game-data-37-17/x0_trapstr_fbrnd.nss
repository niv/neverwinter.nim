
//::///////////////////////////////////////////////////
//:: X0_TRAPSTR_FBRND
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_FIREBRAND
//:: Spell caster level: 9
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_FIREBRAND, GetEnteringObject(), 9);
}

