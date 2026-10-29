//::///////////////////////////////////////////////
//:: Brazier OnInventoryDisturbed
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Fire if there is anything in the container.
     No fire if nothing in it.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void main()
{
    if (GetIsObjectValid(GetFirstItemInInventory()) == TRUE)
    {
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    }
    // * turn fire off
    else
    {
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    }
}
