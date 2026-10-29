/*
    Intelligent Weapon Interjections
    Equip Quote 2

    Georg Zoeller, 2003-09-05
*/
#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;

    iResult =  (IWGetConversationCondition(OBJECT_SELF,X2_IW_INTERJECTION_TYPE_EQUIP) == 2);
    return iResult;
}
