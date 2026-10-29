//::///////////////////////////////////////////////
//:: Horse Mounting Speed Multiple Set to 150
//:: x3_fix_speed150
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Mounting Multiple set to 150%
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 29th, 2008
//:: Last Update: March 29th, 2008
//::///////////////////////////////////////////////


void main()
{
    object oPC=OBJECT_SELF;
    SetLocalFloat(oPC,"fX3_MOUNT_MULTIPLE",1.5);
    SendMessageToPC(oPC,"Mounting Multiple set to 150%");
}
