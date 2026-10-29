//::///////////////////////////////////////////////
//:: x0_closeinven
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Closes an open henchmen inventory
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_henchmen"

void main()
{
//    SpeakString("closing inventory...");
    object oHench = GetLocalObject(OBJECT_SELF, "NW_L_MYHENCH");
    if (GetIsPC(GetLastClosedBy()) == TRUE)
    {
        CopyBack(OBJECT_SELF, oHench);
        DestroyEquipped(oHench);
        DestroyObject(OBJECT_SELF, 0.3);
    }
}
