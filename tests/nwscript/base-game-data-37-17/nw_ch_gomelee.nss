//::///////////////////////////////////////////////
//:: Set To Melee Only
//:: nw_ch_gomelee
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the henchmen go to melee combat.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 5th, 2002
//:://////////////////////////////////////////////

#include "nw_i0_generic"
void main()
{
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);
    ClearAllActions();
    EquipAppropriateWeapons(GetMaster());
    //ActionEquipMostDamagingMelee(GetMaster(), FALSE);
 //   SpeakString("melee");
  //  ActionEquipItem(GetItemPossessedBy(OBJECT_SELF, "nw_wspmku009"), INVENTORY_SLOT_RIGHTHAND);
}
