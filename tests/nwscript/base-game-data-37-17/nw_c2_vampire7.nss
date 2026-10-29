//::///////////////////////////////////////////////
//:: NW_C2_VAMPIRE7.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Vampire turns into a vampire shadow
    that looks for the nearest coffin
    with the same tag as the shadow.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void main()
{
    object oGas = CreateObject(OBJECT_TYPE_CREATURE, GetTag(OBJECT_SELF) + "_SHAD",GetLocation(OBJECT_SELF));
    SetLocalString(oGas, "NW_L_MYCREATOR", GetTag(OBJECT_SELF));
    DestroyObject(OBJECT_SELF, 0.5);
}
