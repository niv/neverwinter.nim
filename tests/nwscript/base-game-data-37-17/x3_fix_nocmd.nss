//::///////////////////////////////////////////////
//:: Horse Mounting Toggle no set commandable
//:: x3_fix_nocmd
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Set Settings for slow PC
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 19th, 2008
//:: Last Update: March 19th, 2008
//::///////////////////////////////////////////////


void main()
{
    object oPC=OBJECT_SELF;
    int bValue=GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE");
    if (bValue) bValue=FALSE;
    else { bValue=TRUE; }
    SendMessageToPC(oPC,"SetCommandable="+IntToString(bValue));
    SetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE",bValue);
}
