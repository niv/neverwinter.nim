//::///////////////////////////////////////////////////
//:: X0_O2_PICKUP
//:: This is the OnUsed handler for a placeable that should be
//:: able to be "picked up" by the player. When the player uses
//:: the placeable, the placeable will be destroyed and the item
//:: with the blueprint:
//:: 
//::     <placeable blueprint>_i
//:: 
//:: will be created in the player's inventory, creating the 
//:: impression that the player has picked up the placeable. 
//:: 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/09/2002
//::///////////////////////////////////////////////////

#include "x0_i0_transform"

void main()
{
    TransformObjectToItem(OBJECT_SELF, "", GetLastUsedBy());
}
