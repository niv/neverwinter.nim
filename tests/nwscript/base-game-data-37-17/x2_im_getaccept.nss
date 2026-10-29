#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    object oBackup =  CIGetCurrentModBackup(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    int nCost  ;
    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        if (GetIsObjectValid(oItem))
        {
            nCost = (CIGetArmorModificationCost(oBackup,oItem) );
        }
        else
        {
            return FALSE;
        }
    } else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
    {
        if (GetIsObjectValid(oItem))
        {
            nCost = (CIGetWeaponModificationCost(oBackup,oItem) );
        }
        else
        {
            return FALSE;
        }

    }



    iResult = (GetGold(oPC)>= nCost);
    return iResult;
}
