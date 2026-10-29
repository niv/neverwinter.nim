/*
    Intelligent Weapon Interjections
    Hit Orc Quote

    Georg Zoeller, 2003-09-05
*/

#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;

    iResult =  (IWGetConversationCondition(OBJECT_SELF,X2_IW_INTERJECTION_TYPE_ONHIT_CRE) == RACIAL_TYPE_HUMANOID_ORC);
    return iResult;
}
