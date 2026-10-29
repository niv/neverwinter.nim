#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;
    int nDC;
    int nCost;
    object oPC = GetPCSpeaker();
    object oBackup =  CIGetCurrentModBackup(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        if (GetIsObjectValid(oItem))
        {
            iResult = (CIGetArmorModificationCost(oBackup,oItem) != 0);
        }
        else
        {
            nDC = 0;
            nCost=0;
        }
    } else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
    {
        if (GetIsObjectValid(oItem))
        {
            iResult = (CIGetWeaponModificationCost(oBackup,oItem) != 0);
        }
        else
        {
            nDC = 0;
            nCost=0;
        }

    }

    return iResult;
}
