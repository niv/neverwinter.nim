//::///////////////////////////////////////////////
//:: Post Dismount Script for a Paladin Mount
//:: x3_s2_paldmount
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script is fired by the rider after successfully dismounting
     a summoned paladin mount.  It's primary duty is to send a signal
     to the monitor to stop monitoring.  When not mounted monitoring
     is handled by the mount's own heartbeat script.

     X3_EXTEND_PALDMOUNT = string variable that if set on the module object
     will allow a person to extend this paladin mount script to call other
     scripts in a daisy chain type situation such as saddle bag handling ones.

*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: 2008-01-01
//:: Last Update: March 29th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"

void main()
{
    object oRider=OBJECT_SELF;
    string sScript=GetLocalString(GetModule(),"X3_EXTEND_PALDMOUNT");
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    DeleteLocalObject(OBJECT_SELF,"oX3_PALADIN_MOUNT");
    DeleteLocalInt(oRider,"bX3_HORSE_MODIFIERS");
    DelayCommand(0.1*fX3_MOUNT_MULTIPLE,HORSE_SupportOriginalSpeed(oRider));
    DelayCommand(0.15*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveMountedSkillDecreases(oRider));
    DelayCommand(0.2*fX3_MOUNT_MULTIPLE,HORSE_SupportAdjustMountedArcheryPenalty(oRider));
    DelayCommand(0.41*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveACBonus(oRider));
    DelayCommand(0.42*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveHPBonus(oRider));
    if (GetStringLength(sScript)>0) ExecuteScript(sScript,OBJECT_SELF);
}
