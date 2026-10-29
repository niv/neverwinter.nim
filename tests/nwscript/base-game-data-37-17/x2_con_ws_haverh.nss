//::///////////////////////////////////////////////
//:: x2_con_sw_haverh
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Only returns true if you have a valid
    item in your right hand.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, GetPCSpeaker());
    if (GetIsObjectValid(oItem) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
