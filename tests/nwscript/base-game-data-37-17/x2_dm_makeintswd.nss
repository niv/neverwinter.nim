//::///////////////////////////////////////////////
//:: Make intelligent weapon
//:: x2_dm_makeintswd
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Debug Script. Makes the weapon currently
    equipped in the right hand intelligent

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003
//:://////////////////////////////////////////////

#include "x2_inc_intweapon"
void main()
{
    if (!GetPlotFlag(OBJECT_SELF) && GetIsPC(OBJECT_SELF))
    {
        SpeakString("Must be in god mode to use this script!");
        return;
    }

    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF)  ;
    IWCreateIntelligentWeapon(oWeapon,1);

}
