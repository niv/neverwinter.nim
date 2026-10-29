#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    object oBackup =  CIGetCurrentModBackup(oPC);
    object oNew;
    int nDC;
    int nCost;

    oNew = CIGetCurrentModItem(oPC);

    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        if (GetIsObjectValid(oNew))
        {
            nDC   =  CIGetArmorModificationDC(oBackup, oNew );
            nCost =  CIGetArmorModificationCost(oBackup, oNew );
        }
    }
    else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
    {
        if (GetIsObjectValid(oNew))
        {
          nCost = CIGetWeaponModificationCost(oBackup,oNew); //CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);;
          nDC= 15 ;
        }
     }
    CIUpdateModItemCostDC(oPC, nDC, nCost);
    CISetDefaultModItemCamera(oPC);
}
