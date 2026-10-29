//------------------------------------------------------------------------------
// Starting Condition
//------------------------------------------------------------------------------
/*
    Return TRUE if
        No armor is equipped OR
        The current armor is marked as plot OR
        Craft Armor has been deactivated by a global variable
*/
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oA = GetItemInSlot(INVENTORY_SLOT_CHEST,GetPCSpeaker());
    iResult = (!GetIsObjectValid(oA) ||
                GetPlotFlag(oA) ||
                GetLocalInt(GetModule(),"X2_L_DO_NOT_ALLOW_MODIFY_ARMOR") );

   return iResult;
}
