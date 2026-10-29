
#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;

    iResult = CIGetInModWeaponOrArmorConv(GetPCSpeaker());
    return iResult;
}
