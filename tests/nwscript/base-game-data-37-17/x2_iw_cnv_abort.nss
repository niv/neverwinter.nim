#include "x2_inc_intweapon"

void main()
{
    object oPC = GetPCSpeaker();
    IWClearConversationConditions(oPC);

    if (IWGetIsInIntelligentWeaponConversation(oPC))
    {
        IWEndIntelligentWeaponConversation(OBJECT_SELF,oPC);
    }
}
