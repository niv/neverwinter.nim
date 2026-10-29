//::///////////////////////////////////////////////////
//:: X0_O2_GOLDHIGH.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Gold only
//:: Treasure level: TREASURE_TYPE_HIGH
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{
    if (CTG_GetIsTreasureGenerated(OBJECT_SELF)) {return;}
    CTG_SetIsTreasureGenerated(OBJECT_SELF);
    CTG_CreateGoldTreasure(TREASURE_TYPE_HIGH, GetLastOpener(), OBJECT_SELF);
}

