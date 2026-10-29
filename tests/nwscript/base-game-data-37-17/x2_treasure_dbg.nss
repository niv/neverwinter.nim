#include "x2_inc_treasure"

void main()
{
    object oPC = OBJECT_SELF;
    SendMessageToPC(oPC, "Disposable Treasure System Debug");
    SendMessageToPC(oPC, "--------------------------------");
    SendMessageToPC(oPC, "Gold2DA: " + DTSGet2DANameByType(X2_DTS_TYPE_GOLD));
    SendMessageToPC(oPC, "Disp2DA: " + DTSGet2DANameByType(X2_DTS_TYPE_DISP));
    SendMessageToPC(oPC, "Ammo2DA: " + DTSGet2DANameByType(X2_DTS_TYPE_AMMO));
    SendMessageToPC(oPC, "Item2DA: " + DTSGet2DANameByType(X2_DTS_TYPE_ITEM));

    SendMessageToPC(oPC, "DTSGetBaseChance: " + IntToString(DTSGetBaseChance(GetArea(oPC))));
    SendMessageToPC(oPC, "DTSGetMaxItems: " + IntToString(DTSGetMaxItems()));
    SendMessageToPC(oPC, "DTSGetStackVariation:" + FloatToString(DTSGetStackVariation()));

    int nFeat = DTSDetermineFeatToUse(oPC);
    SendMessageToPC(oPC, "Feat I would pick:" + IntToString(nFeat));
    SendMessageToPC(oPC, "Random Feat Item:" + DTSGetFeatSpecificItemResRef(nFeat));;

}
