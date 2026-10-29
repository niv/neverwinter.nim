
//::///////////////////////////////////////////////////
//:: X0_TRAPDLY_SHURI
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_TRAP_SHURIKEN
//:: Spell caster level: 11
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_TRAP_SHURIKEN, GetEnteringObject(), 11,
                          OBJECT_INVALID, OBJECT_SELF,
                          PROJECTILE_PATH_TYPE_HOMING);
}

