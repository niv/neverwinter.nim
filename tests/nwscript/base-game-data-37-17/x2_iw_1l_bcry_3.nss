/*
    Intelligent Weapon Interjections
    Random BattleCry

    Georg Zoeller, 2003-09-05
*/

#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;

    iResult =  (IWGetConversationCondition(OBJECT_SELF,X2_IW_INTERJECTION_TYPE_BATTLECRY) == 3);
    return iResult;
}
