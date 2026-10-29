//::///////////////////////////////////////////////
//:: Horse Mounting Toggle Act vs Not Act
//:: x3_fix_act
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Toggle action vs not action
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 19th, 2008
//:: Last Update: March 19th, 2008
//::///////////////////////////////////////////////


void main()
{
    object oPC=OBJECT_SELF;
    int bValue=GetLocalInt(GetModule(),"X3_HORSE_ACT_VS_DELAY");
    if (bValue) bValue=FALSE;
    else { bValue=TRUE; }
    SendMessageToPC(oPC,"Use Actions For Mounting="+IntToString(bValue));
    SetLocalInt(GetModule(),"X3_HORSE_ACT_VS_DELAY",bValue);
}
