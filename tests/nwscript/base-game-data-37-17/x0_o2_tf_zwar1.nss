//:://////////////////////////////////////////////////
//:: X0_O2_TF_ZWAR1
//::    This is an OnEntered script for a generic trigger. 
//::    When a PC enters the trigger area, it will transform
//::    the nearest object (placeable, creature, item) with
//::    a matching tag into the specified creature, using
//::    the specified effect named below. 
//::
//::    Creature to be created: Zombie Warrior
//::    Challenge Rating: 4
//::    Effect to be used: VFX_IMP_RAISE_DEAD
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/06/2002
//:://////////////////////////////////////////////////

#include "x0_i0_transform"


void main()
{
    TriggerObjectTransform("nw_zombwarr01", VFX_IMP_RAISE_DEAD);
}

