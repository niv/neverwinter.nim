#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oA = GetItemInSlot(INVENTORY_SLOT_CHEST,GetPCSpeaker());
    if (!GetIsObjectValid(oA))
    {
        return FALSE;
    }
    if (GetPlotFlag(oA))
    {
        return FALSE;
    }
    if (!GetHasSkill(SKILL_CRAFT_ARMOR,GetPCSpeaker()))
    {
       return FALSE;
    }

    return TRUE;
}
