//::///////////////////////////////////////////////////
//:: X0_O2_POTNLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Potions only
//:: Treasure level: TREASURE_TYPE_LOW
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{

    CTG_CreateSpecificBaseTypeTreasure(TREASURE_TYPE_LOW, GetLastOpener(), OBJECT_SELF, BASE_ITEM_POTIONS);

}

