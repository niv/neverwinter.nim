//::///////////////////////////////////////////////
//:: Set To Ranged Only
//:: nw_ch_goranged
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the henchmen go to ranged combat.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 5th, 2002
//:://////////////////////////////////////////////
#include "nw_i0_generic"
void main()
{
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON);
    ClearAllActions();
    EquipAppropriateWeapons(GetMaster());
}
