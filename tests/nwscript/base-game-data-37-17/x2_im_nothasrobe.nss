#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;
    object oItem = CIGetCurrentModItem(GetPCSpeaker());

    iResult = !(GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE) >0 );
    return iResult;
}
