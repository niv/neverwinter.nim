//::///////////////////////////////////////////////
//:: XP2 Ammo Treasure Spawn Script   HIGH
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in general purpose treasure and gold
    usable by all classes.

*/
//:://////////////////////////////////////////////
//:: Created By:   Georg Zoeller
//:: Created On:   2003-06-04
//:://////////////////////////////////////////////
#include "x2_inc_treasure"
#include "nw_o2_coninclude"
#include "x2_inc_compon"

void main()
{
     craft_drop_placeable();
   if (GetLocalInt(OBJECT_SELF,"NW_DO_ONCE") != 0)
    {
       return;
    }
    object oOpener = GetLastOpener();
    DTSGenerateTreasureOnContainer (OBJECT_SELF,oOpener,X2_DTS_CLASS_MEDIUM, X2_DTS_TYPE_AMMO);
    SetLocalInt(OBJECT_SELF,"NW_DO_ONCE",1);
    ShoutDisturbed();
}


