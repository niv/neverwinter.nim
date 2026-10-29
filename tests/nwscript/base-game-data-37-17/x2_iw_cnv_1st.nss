#include "x2_inc_intweapon"
int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    iResult = IWGetIsInIntelligentWeaponConversation(GetPCSpeaker());
    iResult = iResult && (IWGetTalkedTo(oPC,"x2_iw_enserric") == 0);
    return iResult;
}

