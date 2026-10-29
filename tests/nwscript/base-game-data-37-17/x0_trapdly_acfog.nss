
//::///////////////////////////////////////////////////
//:: X0_TRAPDLY_ACFOG
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_ACID_FOG
//:: Spell caster level: 11
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_ACID_FOG, GetEnteringObject(), 11);
}

