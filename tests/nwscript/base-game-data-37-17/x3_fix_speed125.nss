//::///////////////////////////////////////////////
//:: Horse Mounting Speed Multiple Set to 125
//:: x3_fix_speed125
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Mounting Multiple set to 125%
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 29th, 2008
//:: Last Update: March 29th, 2008
//::///////////////////////////////////////////////


void main()
{
    object oPC=OBJECT_SELF;
    SetLocalFloat(oPC,"fX3_MOUNT_MULTIPLE",1.25);
    SendMessageToPC(oPC,"Mounting Multiple set to 125%");
}
