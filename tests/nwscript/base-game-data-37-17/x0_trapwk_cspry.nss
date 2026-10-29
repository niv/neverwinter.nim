
//::///////////////////////////////////////////////////
//:: X0_TRAPWK_CSPRY
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_COLOR_SPRAY
//:: Spell caster level: 1
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_COLOR_SPRAY, GetEnteringObject(), 1);
}

