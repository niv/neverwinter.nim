#include "x2_inc_intweapon"
void main()
{
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {

        object oWeapon = IWGetIntelligentWeaponEquipped(oPC);
        if (oWeapon != OBJECT_INVALID)
        {
            int nID = GetLocalInt(OBJECT_SELF,"X2_INTWEAPON_INTERJECT_ID");
            if (nID >0)
            {

                int nOnce = GetLocalInt(OBJECT_SELF,"X2_INTWEAPON_DOONCE");
                if (nOnce == 1)
                {
                    return;
                }
                else
                {
                    SetLocalInt(OBJECT_SELF,"X2_INTWEAPON_DOONCE",1);
                }
                IWPlayTriggerQuote(oPC, oWeapon,nID);
            }
        }
    }



}
