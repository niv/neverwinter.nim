//::///////////////////////////////////////////////////
//:: X0_O2_BOOKMED.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Books or scrolls
//:: Treasure level: TREASURE_TYPE_MED
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{

    CTG_CreateSpecificBaseTypeTreasure(TREASURE_TYPE_MED, GetLastOpener(), OBJECT_SELF, BASE_ITEM_BOOK, BASE_ITEM_SPELLSCROLL);

}

