#include "x2_inc_intweapon"
void main()
{
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {

        object oWeapon = IWGetIntelligentWeaponEquipped(oPC);
        if (oWeapon != OBJECT_INVALID)
        {
            //int nID = GetLocalInt(OBJECT_SELF,"X2_INTWEAPON_INTERJECT_ID");
            AssignCommand(oPC,ClearAllActions(TRUE));
            ExecuteScript("x2_s3_intitemtlk",oPC);
        }
    }



}
