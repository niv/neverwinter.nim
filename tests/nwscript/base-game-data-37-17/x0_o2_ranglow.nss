//::///////////////////////////////////////////////////
//:: X0_O2_RANGLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Any ranged weapon (includes throwing weapons but not ammunition)
//:: Treasure level: TREASURE_TYPE_LOW
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{

    CTG_CreateSpecificBaseTypeTreasure(TREASURE_TYPE_LOW, GetLastOpener(), OBJECT_SELF, TREASURE_BASE_TYPE_WEAPON_RANGED);

}

