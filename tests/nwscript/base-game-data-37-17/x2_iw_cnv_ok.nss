#include "x2_inc_intweapon"
int StartingConditional()
{
    int iResult;

    iResult = IWGetIsInIntelligentWeaponConversation(GetPCSpeaker());
    return iResult;
}
